import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Telegram Client API credentials (api_id / api_hash from my.telegram.org).
///
/// Resolution: dart-define → `.env` → process environment.
abstract final class TelegramConfig {
  static const _defineApiId = String.fromEnvironment(
    'TELEGRAM_API_ID',
    defaultValue: '',
  );
  static const _defineApiHash = String.fromEnvironment(
    'TELEGRAM_API_HASH',
    defaultValue: '',
  );
  static const _defineTdlibPath = String.fromEnvironment(
    'TELEGRAM_TDLIB_PATH',
    defaultValue: '',
  );

  static String get apiId => _resolve(
        defineValue: _defineApiId,
        key: 'TELEGRAM_API_ID',
      );

  static String get apiHash => _resolve(
        defineValue: _defineApiHash,
        key: 'TELEGRAM_API_HASH',
      );

  /// Optional absolute path to `libtdjson.so` on Linux.
  static String get tdlibPath {
    final raw = _resolve(
      defineValue: _defineTdlibPath,
      key: 'TELEGRAM_TDLIB_PATH',
    );
    return _normalizeFsPath(raw);
  }

  static bool get hasCredentials =>
      apiId.isNotEmpty && apiHash.isNotEmpty && int.tryParse(apiId) != null;

  /// Strip quotes / shell-style `\ ` escapes from dotenv paths.
  static String _normalizeFsPath(String raw) {
    var path = raw.trim();
    if (path.length >= 2) {
      final q = path[0];
      if ((q == '"' || q == "'") && path.endsWith(q)) {
        path = path.substring(1, path.length - 1);
      }
    }
    // .env sometimes uses `my\ projects` — keep a real space.
    path = path.replaceAll(r'\ ', ' ');
    return path.trim();
  }

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
