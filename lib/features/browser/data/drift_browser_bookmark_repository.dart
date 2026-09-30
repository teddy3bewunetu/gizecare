import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

class DriftBrowserBookmarkRepository implements BrowserBookmarkRepository {
  DriftBrowserBookmarkRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<BrowserBookmark>> watchAll() {
    final q = (_db.select(_db.browserBookmarks)
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
    return q.map((rows) => rows.map(_map).toList());
  }

  @override
  Future<Result<List<BrowserBookmark>>> list() async {
    try {
      final rows = await (_db.select(_db.browserBookmarks)
            ..orderBy([
              (t) => OrderingTerm.asc(t.sortOrder),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to list bookmarks', cause: e));
    }
  }

  @override
  Future<Result<BrowserBookmark?>> findByUrl(String url) async {
    try {
      final normalized = url.trim();
      final row = await (_db.select(_db.browserBookmarks)
            ..where((t) => t.url.equals(normalized)))
          .getSingleOrNull();
      return Success(row == null ? null : _map(row));
    } catch (e) {
      return Err(CacheFailure('Failed to find bookmark', cause: e));
    }
  }

  @override
  Future<Result<BrowserBookmark>> add({
    required String title,
    required String url,
    String? faviconUrl,
  }) async {
    try {
      final normalized = url.trim();
      final existing = await (_db.select(_db.browserBookmarks)
            ..where((t) => t.url.equals(normalized)))
          .getSingleOrNull();
      if (existing != null) {
        return Success(_map(existing));
      }
      final id = _uuid.v4();
      final now = DateTime.now();
      final count = await _db.select(_db.browserBookmarks).get();
      final resolvedTitle = title.trim().isEmpty ? normalized : title.trim();
      await _db.into(_db.browserBookmarks).insert(
            BrowserBookmarksCompanion.insert(
              id: id,
              title: resolvedTitle,
              url: normalized,
              faviconUrl: Value(faviconUrl),
              sortOrder: Value(count.length),
              createdAt: now,
            ),
          );
      return Success(
        BrowserBookmark(
          id: id,
          title: resolvedTitle,
          url: normalized,
          faviconUrl: faviconUrl,
          sortOrder: count.length,
          createdAt: now,
        ),
      );
    } catch (e) {
      return Err(CacheFailure('Failed to add bookmark', cause: e));
    }
  }

  @override
  Future<Result<Unit>> remove(String id) async {
    try {
      await (_db.delete(_db.browserBookmarks)..where((t) => t.id.equals(id)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to remove bookmark', cause: e));
    }
  }

  @override
  Future<Result<Unit>> removeByUrl(String url) async {
    try {
      await (_db.delete(_db.browserBookmarks)
            ..where((t) => t.url.equals(url.trim())))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to remove bookmark', cause: e));
    }
  }

  @override
  Future<Result<Unit>> clearAll() async {
    try {
      await _db.delete(_db.browserBookmarks).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to clear bookmarks', cause: e));
    }
  }

  BrowserBookmark _map(BrowserBookmarkRow row) {
    return BrowserBookmark(
      id: row.id,
      title: row.title,
      url: row.url,
      faviconUrl: row.faviconUrl,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }
}
