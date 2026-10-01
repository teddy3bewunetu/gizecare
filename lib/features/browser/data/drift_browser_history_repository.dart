import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/browser/domain/browser_history_entry.dart';
import 'package:gizecare/features/browser/domain/browser_history_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

class DriftBrowserHistoryRepository implements BrowserHistoryRepository {
  DriftBrowserHistoryRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();
  static const _maxEntries = 5000;

  @override
  Stream<List<BrowserHistoryEntry>> watchRecent({int limit = 200}) {
    final q = (_db.select(_db.browserHistoryEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.visitedAt)])
          ..limit(limit))
        .watch();
    return q.map((rows) => rows.map(_map).toList());
  }

  @override
  Future<Result<List<BrowserHistoryEntry>>> search(
    String query, {
    int limit = 100,
  }) async {
    try {
      final q = query.trim().toLowerCase();
      if (q.isEmpty) {
        final rows = await (_db.select(_db.browserHistoryEntries)
              ..orderBy([(t) => OrderingTerm.desc(t.visitedAt)])
              ..limit(limit))
            .get();
        return Success(rows.map(_map).toList());
      }
      final rows = await (_db.select(_db.browserHistoryEntries)
            ..where(
              (t) =>
                  t.url.lower().like('%$q%') | t.title.lower().like('%$q%'),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.visitedAt)])
            ..limit(limit))
          .get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to search history', cause: e));
    }
  }

  @override
  Future<Result<Unit>> recordVisit({
    required String url,
    String? title,
  }) async {
    try {
      final normalized = url.trim();
      if (normalized.isEmpty ||
          normalized == 'about:blank' ||
          normalized.startsWith('data:')) {
        return const Success(unit);
      }
      final now = DateTime.now();
      final resolvedTitle = (title?.trim().isNotEmpty == true)
          ? title!.trim()
          : _hostFromUrl(normalized);
      final existing = await (_db.select(_db.browserHistoryEntries)
            ..where((t) => t.url.equals(normalized)))
          .getSingleOrNull();
      if (existing != null) {
        await (_db.update(_db.browserHistoryEntries)
              ..where((t) => t.id.equals(existing.id)))
            .write(
          BrowserHistoryEntriesCompanion(
            title: Value(resolvedTitle),
            visitedAt: Value(now),
            visitCount: Value(existing.visitCount + 1),
          ),
        );
      } else {
        await _db.into(_db.browserHistoryEntries).insert(
              BrowserHistoryEntriesCompanion.insert(
                id: _uuid.v4(),
                title: resolvedTitle,
                url: normalized,
                visitedAt: now,
              ),
            );
        await _trimOldest();
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to record history', cause: e));
    }
  }

  @override
  Future<Result<Unit>> remove(String id) async {
    try {
      await (_db.delete(_db.browserHistoryEntries)..where((t) => t.id.equals(id)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to remove history entry', cause: e));
    }
  }

  @override
  Future<Result<Unit>> clearAll() async {
    try {
      await _db.delete(_db.browserHistoryEntries).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to clear history', cause: e));
    }
  }

  Future<void> _trimOldest() async {
    final count = await _db
        .customSelect('SELECT COUNT(*) AS c FROM browser_history_entries')
        .getSingle();
    final total = count.read<int>('c');
    if (total <= _maxEntries) return;
    final overflow = total - _maxEntries;
    await _db.customStatement(
      'DELETE FROM browser_history_entries WHERE id IN ('
      'SELECT id FROM browser_history_entries '
      'ORDER BY visited_at ASC LIMIT ?)',
      [overflow],
    );
  }

  String _hostFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final host = uri?.host;
    if (host != null && host.isNotEmpty) return host;
    return url.length > 48 ? '${url.substring(0, 45)}…' : url;
  }

  BrowserHistoryEntry _map(BrowserHistoryEntryRow row) {
    return BrowserHistoryEntry(
      id: row.id,
      title: row.title,
      url: row.url,
      visitedAt: row.visitedAt,
      visitCount: row.visitCount,
    );
  }
}
