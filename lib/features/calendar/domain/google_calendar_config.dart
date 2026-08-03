import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Google OAuth credentials for Calendar + Gmail (Linux desktop).
///
/// Resolution order:
/// 1. `--dart-define=GOOGLE_CALENDAR_CLIENT_ID=...` (and SECRET)
/// 2. Project-root `.env` (loaded by `loadAppEnv` in bootstrap)
/// 3. Process environment variables
///
/// These identify the **app** (same for all users). Each user still Connects
/// their own Google account; tokens are stored per machine in secure storage.
///
/// See [docs/google_calendar_setup.md] and [docs/gmail_setup.md].
abstract final class GoogleCalendarConfig {
  static const _defineClientId = String.fromEnvironment(
    'GOOGLE_CALENDAR_CLIENT_ID',
    defaultValue: '',
  );

  static const _defineClientSecret = String.fromEnvironment(
    'GOOGLE_CALENDAR_CLIENT_SECRET',
    defaultValue: '',
  );

  static String get clientId => _resolve(
        defineValue: _defineClientId,
        key: 'GOOGLE_CALENDAR_CLIENT_ID',
      );

  static String get clientSecret => _resolve(
        defineValue: _defineClientSecret,
        key: 'GOOGLE_CALENDAR_CLIENT_SECRET',
      );

  /// Fixed loopback port for the installed-app OAuth redirect.
  static const listenPort = 8765;

  static const redirectUri = 'http://127.0.0.1:$listenPort';

  static const scopes = <String>[
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/userinfo.email',
  ];

  static const gmailModifyScope =
      'https://www.googleapis.com/auth/gmail.modify';

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
