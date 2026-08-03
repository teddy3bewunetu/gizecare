import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists Google OAuth credentials (keyring, with file fallback).
class GoogleCalendarTokenStore {
  GoogleCalendarTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'gizecare.google_calendar.credentials';

  final FlutterSecureStorage _storage;

  Future<File> _fallbackFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'google_calendar_tokens.json'));
  }

  Future<AccessCredentials?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null && raw.isNotEmpty) {
        return AccessCredentials.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Secure storage read failed, trying file fallback: $e');
    }
    try {
      final file = await _fallbackFile();
      if (!await file.exists()) return null;
      final raw = await file.readAsString();
      if (raw.isEmpty) return null;
      return AccessCredentials.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('Token file read failed: $e');
      return null;
    }
  }

  Future<void> write(AccessCredentials credentials) async {
    final map = <String, dynamic>{
      'accessToken': credentials.accessToken.toJson(),
      if (credentials.refreshToken != null)
        'refreshToken': credentials.refreshToken,
      'idToken': credentials.idToken,
      'scopes': credentials.scopes,
    };
    final encoded = jsonEncode(map);

    var secureOk = false;
    try {
      await _storage.write(key: _key, value: encoded);
      secureOk = true;
    } catch (e) {
      debugPrint('Secure storage write failed, using file fallback: $e');
    }

    // Always mirror to file so reconnect survives keyring issues on Linux.
    final file = await _fallbackFile();
    await file.writeAsString(encoded, flush: true);
    if (!secureOk) {
      debugPrint('Stored Google tokens in ${file.path}');
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } catch (_) {}
    try {
      final file = await _fallbackFile();
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
