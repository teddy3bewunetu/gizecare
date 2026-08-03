import 'dart:convert';
import 'dart:io';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/documents/domain/entities/document_history_entry.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

const _maxEntries = 20;

/// Persists recently opened document files and folders.
class DocumentHistoryStore {
  DocumentHistoryStore(this._settings);

  final SettingsRepository _settings;

  Future<List<DocumentHistoryEntry>> load() async {
    final result = await _settings.get(SettingKeys.documentBrowsingHistory);
    if (result case Err()) return const [];

    final raw = (result as Success<String?>).value;
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final entries = decoded
          .map((item) => DocumentHistoryEntry.fromJson(item as Map<String, dynamic>))
          .where(_entryExists)
          .toList();
      return entries;
    } catch (_) {
      return const [];
    }
  }

  Future<void> recordFile(String path) async {
    await _upsert(
      DocumentHistoryEntry(
        path: path,
        kind: DocumentHistoryKind.file,
        accessedAt: DateTime.now(),
      ),
    );
  }

  Future<void> recordFolder(String folderPath, {String? lastFilePath}) async {
    await _upsert(
      DocumentHistoryEntry(
        path: folderPath,
        kind: DocumentHistoryKind.folder,
        accessedAt: DateTime.now(),
        lastFilePath: lastFilePath,
      ),
    );
  }

  Future<void> remove(String path) async {
    final entries = await load();
    final next = entries.where((entry) => entry.path != path).toList();
    await _save(next);
  }

  Future<void> clear() async {
    await _save(const []);
  }

  Future<void> _upsert(DocumentHistoryEntry entry) async {
    final entries = await load();
    final next = <DocumentHistoryEntry>[
      entry,
      ...entries.where((existing) => existing.path != entry.path),
    ];
    if (next.length > _maxEntries) {
      next.removeRange(_maxEntries, next.length);
    }
    await _save(next);
  }

  Future<void> _save(List<DocumentHistoryEntry> entries) async {
    final payload = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await _settings.set(SettingKeys.documentBrowsingHistory, payload);
  }

  bool _entryExists(DocumentHistoryEntry entry) {
    if (entry.kind == DocumentHistoryKind.folder) {
      return Directory(entry.path).existsSync();
    }
    return File(entry.path).existsSync();
  }
}
