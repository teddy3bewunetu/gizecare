import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persisted Slack user OAuth tokens.
class SlackTokens {
  const SlackTokens({
    required this.accessToken,
    required this.userId,
    required this.teamId,
    required this.teamName,
    this.scopes = const [],
  });

  final String accessToken;
  final String userId;
  final String teamId;
  final String teamName;
  final List<String> scopes;

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'userId': userId,
        'teamId': teamId,
        'teamName': teamName,
        'scopes': scopes,
      };

  factory SlackTokens.fromJson(Map<String, dynamic> json) {
    final scopesRaw = json['scopes'];
    return SlackTokens(
      accessToken: json['accessToken'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      teamId: json['teamId'] as String? ?? '',
      teamName: json['teamName'] as String? ?? '',
      scopes: scopesRaw is List
          ? scopesRaw.map((e) => '$e').toList()
          : const [],
    );
  }
}

/// Persists Slack OAuth credentials (keyring, with file fallback).
class SlackTokenStore {
  SlackTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'gizecare.slack.credentials';

  final FlutterSecureStorage _storage;

  Future<File> _fallbackFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'slack_tokens.json'));
  }

  Future<SlackTokens?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null && raw.isNotEmpty) {
        return SlackTokens.fromJson(
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
      return SlackTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Slack token file read failed: $e');
      return null;
    }
  }

  Future<void> write(SlackTokens tokens) async {
    final encoded = jsonEncode(tokens.toJson());
    var secureOk = false;
    try {
      await _storage.write(key: _key, value: encoded);
      secureOk = true;
    } catch (e) {
      debugPrint('Secure storage write failed, using file fallback: $e');
    }
    final file = await _fallbackFile();
    await file.writeAsString(encoded, flush: true);
    if (!secureOk) {
      debugPrint('Stored Slack tokens in ${file.path}');
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
