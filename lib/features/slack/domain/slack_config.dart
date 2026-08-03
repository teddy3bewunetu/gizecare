import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Slack OAuth credentials for user-token connect (Linux desktop).
///
/// Resolution order: `--dart-define` → `.env` → process environment.
/// See [docs/slack_setup.md].
abstract final class SlackConfig {
  static const _defineClientId = String.fromEnvironment(
    'SLACK_CLIENT_ID',
    defaultValue: '',
  );

  static const _defineClientSecret = String.fromEnvironment(
    'SLACK_CLIENT_SECRET',
    defaultValue: '',
  );

  static String get clientId => _resolve(
        defineValue: _defineClientId,
        key: 'SLACK_CLIENT_ID',
      );

  static String get clientSecret => _resolve(
        defineValue: _defineClientSecret,
        key: 'SLACK_CLIENT_SECRET',
      );

  /// Loopback port for Slack OAuth (Google Calendar uses 8765).
  static const listenPort = 8766;

  static const redirectUri = 'http://127.0.0.1:$listenPort/callback';

  /// User token scopes (passed as `user_scope` in OAuth v2).
  static const userScopes = <String>[
    'channels:read',
    'channels:history',
    'groups:read',
    'groups:history',
    'im:read',
    'im:history',
    'mpim:read',
    'mpim:history',
    'chat:write',
    'users:read',
    'reactions:read',
    'reactions:write',
    'files:read',
    'files:write',
  ];

  static bool get hasCredentials =>
      clientId.isNotEmpty && clientSecret.isNotEmpty;

  static String _resolve({
    required String defineValue,
    required String key,
  }) {
    if (defineValue.isNotEmpty) return defineValue.trim();
    if (dotenv.isInitialized) {
      final fromFile = dotenv.maybeGet(key)?.trim();
      if (fromFile != null && fromFile.isNotEmpty) return fromFile;
    }
    return Platform.environment[key]?.trim() ?? '';
  }
}
