import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/slack/data/slack_token_store.dart';
import 'package:gizecare/features/slack/domain/slack_config.dart';

/// Linux installed-app OAuth for Slack (user token via `user_scope`).
class SlackAuthService {
  SlackAuthService({
    required this.tokenStore,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final SlackTokenStore tokenStore;
  final http.Client _http;

  bool get canConnectOnThisPlatform =>
      AppPlatform.isLinux && SlackConfig.hasCredentials;

  Future<SlackTokens?> loadStoredTokens() => tokenStore.read();

  Future<void> clearStoredTokens() => tokenStore.clear();

  /// Opens the system browser and completes when the user consents.
  Future<SlackTokens> authorizeInteractive() async {
    if (!AppPlatform.isLinux) {
      throw UnsupportedError('Slack connect is Linux-only in this MVP');
    }
    if (!SlackConfig.hasCredentials) {
      throw StateError(
        'Missing SLACK_CLIENT_ID / SLACK_CLIENT_SECRET. '
        'See docs/slack_setup.md',
      );
    }

    HttpServer? server;
    try {
      server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        SlackConfig.listenPort,
      );
      final state = _randomState();
      final authUri = Uri.https('slack.com', '/oauth/v2/authorize', {
        'client_id': SlackConfig.clientId,
        'user_scope': SlackConfig.userScopes.join(','),
        'redirect_uri': SlackConfig.redirectUri,
        'state': state,
      });

      final opened = await launchUrl(
        authUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        throw StateError('Could not open browser for Slack sign-in');
      }

      final request = await server.first.timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw TimeoutException(
          'Timed out waiting for Slack sign-in. Try Connect again.',
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
          throw StateError('Slack sign-in error: $error');
        }
        final code = uri.queryParameters['code'];
        if (code == null || code.isEmpty) {
          throw StateError('Slack did not return an authorization code');
        }

        final tokens = await _exchangeCode(code);

        request.response
          ..statusCode = 200
          ..headers.set('content-type', 'text/html; charset=UTF-8')
          ..write('''
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>GizeCare</title></head>
<body style="font-family:sans-serif;padding:2rem;background:#141414;color:#eee">
  <h1>Connected to Slack</h1>
  <p>You can close this tab and return to GizeCare.</p>
</body></html>
''');
        await request.response.close();

        await tokenStore.write(tokens);
        return tokens;
      } catch (e) {
        request.response.statusCode = 500;
        await request.response.close().catchError((_) {});
        rethrow;
      }
    } finally {
      await server?.close(force: true);
    }
  }

  Future<SlackTokens> _exchangeCode(String code) async {
    final response = await _http.post(
      Uri.parse('https://slack.com/api/oauth.v2.access'),
      body: {
        'client_id': SlackConfig.clientId,
        'client_secret': SlackConfig.clientSecret,
        'code': code,
        'redirect_uri': SlackConfig.redirectUri,
      },
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['ok'] != true) {
      throw StateError(
        'Slack token exchange failed: ${json['error'] ?? response.body}',
      );
    }
    final authed = json['authed_user'] as Map<String, dynamic>?;
    final team = json['team'] as Map<String, dynamic>?;
    final accessToken = authed?['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError(
        'Slack did not return a user access token. '
        'Ensure User Token Scopes are set on the Slack app.',
      );
    }
    final scopeStr = authed?['scope'] as String? ?? '';
    return SlackTokens(
      accessToken: accessToken,
      userId: authed?['id'] as String? ?? '',
      teamId: team?['id'] as String? ?? '',
      teamName: team?['name'] as String? ?? 'Slack',
      scopes: scopeStr.isEmpty ? const [] : scopeStr.split(','),
    );
  }

  String _randomState() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(24, (_) => rnd.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  void close() {
    _http.close();
  }
}
