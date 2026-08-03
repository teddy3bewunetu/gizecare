import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/src/oauth2_flows/auth_code.dart'
    show
        createAuthenticationUri,
        createCodeVerifier,
        obtainAccessCredentialsViaCodeExchange,
        randomState;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/calendar/data/google_calendar_token_store.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';

/// Linux installed-app OAuth for Google Calendar (offline refresh tokens).
class GoogleCalendarAuthService {
  GoogleCalendarAuthService({
    required GoogleCalendarTokenStore tokenStore,
  }) : _tokenStore = tokenStore;

  final GoogleCalendarTokenStore _tokenStore;

  ClientId get _clientId {
    if (!GoogleCalendarConfig.hasCredentials) {
      throw StateError(
        'Missing GOOGLE_CALENDAR_CLIENT_ID / GOOGLE_CALENDAR_CLIENT_SECRET. '
        'See docs/google_calendar_setup.md',
      );
    }
    return ClientId(
      GoogleCalendarConfig.clientId,
      GoogleCalendarConfig.clientSecret,
    );
  }

  bool get canConnectOnThisPlatform =>
      AppPlatform.isLinux && GoogleCalendarConfig.hasCredentials;

  Future<AccessCredentials?> loadStoredCredentials() => _tokenStore.read();

  Future<void> clearStoredCredentials() => _tokenStore.clear();

  /// Whether stored tokens include Gmail modify (read / send / labels).
  Future<bool> hasGmailScope() async {
    final stored = await _tokenStore.read();
    if (stored == null) return false;
    return stored.scopes.contains(GoogleCalendarConfig.gmailModifyScope);
  }

  /// Opens the system browser and completes when the user consents.
  ///
  /// Uses `access_type=offline` + `prompt=consent` so Google returns a
  /// refresh token (required for lasting connection).
  Future<AccessCredentials> authorizeInteractive() async {
    if (!AppPlatform.isLinux) {
      throw UnsupportedError(
        'Google Calendar connect is Linux-only in this MVP',
      );
    }

    final httpClient = http.Client();
    HttpServer? server;
    try {
      server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        GoogleCalendarConfig.listenPort,
      );
      final port = server.port;
      // Prefer 127.0.0.1 to match the bound address.
      final redirectionUri = 'http://127.0.0.1:$port';
      final state = randomState();
      final codeVerifier = createCodeVerifier();

      final authUri = createAuthenticationUri(
        redirectUri: redirectionUri,
        clientId: _clientId.identifier,
        scopes: GoogleCalendarConfig.scopes,
        codeVerifier: codeVerifier,
        state: state,
        offline: true,
      );
      final consentUri = authUri.replace(
        queryParameters: <String, String>{
          ...authUri.queryParameters,
          'prompt': 'consent',
        },
      );

      final opened = await launchUrl(
        consentUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        throw StateError('Could not open browser for Google sign-in');
      }

      final request = await server.first.timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw TimeoutException(
          'Timed out waiting for Google sign-in. Try Connect again.',
        ),
      );

      try {
        if (request.method != 'GET') {
          throw StateError('Expected GET OAuth callback, got ${request.method}');
        }
        final uri = request.uri;
        if (uri.queryParameters['state'] != state) {
          throw StateError('OAuth state mismatch — try Connect again');
        }
        final error = uri.queryParameters['error'];
        if (error != null) {
          throw StateError('Google sign-in error: $error');
        }
        final code = uri.queryParameters['code'];
        if (code == null || code.isEmpty) {
          throw StateError('Google did not return an authorization code');
        }

        final credentials = await obtainAccessCredentialsViaCodeExchange(
          httpClient,
          _clientId,
          code,
          redirectUrl: redirectionUri,
          codeVerifier: codeVerifier,
        );

        if (credentials.refreshToken == null ||
            credentials.refreshToken!.isEmpty) {
          throw StateError(
            'Google did not return a refresh token. '
            'Revoke GizeCare access at https://myaccount.google.com/permissions '
            'then Connect again.',
          );
        }

        request.response
          ..statusCode = 200
          ..headers.set('content-type', 'text/html; charset=UTF-8')
          ..write('''
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>GizeCare</title></head>
<body style="font-family:sans-serif;padding:2rem;background:#141414;color:#eee">
  <h1>Connected</h1>
  <p>You can close this tab and return to GizeCare.</p>
</body></html>
''');
        await request.response.close();

        await _tokenStore.write(credentials);
        return credentials;
      } catch (e) {
        request.response.statusCode = 500;
        await request.response.close().catchError((_) {});
        rethrow;
      }
    } finally {
      await server?.close(force: true);
      httpClient.close();
    }
  }

  /// Authenticated client that refreshes tokens and persists updates.
  ///
  /// Caller must [AutoRefreshingAuthClient.close] when done.
  Future<AutoRefreshingAuthClient?> createAuthClient() async {
    final stored = await _tokenStore.read();
    if (stored == null || stored.refreshToken == null) return null;
    final base = http.Client();
    final client = autoRefreshingClient(_clientId, stored, base);
    client.credentialUpdates.listen((creds) {
      _tokenStore.write(creds).catchError((Object e, StackTrace st) {
        debugPrint('Failed to persist refreshed Google tokens: $e');
      });
    });
    return client;
  }

  void close() {}
}
