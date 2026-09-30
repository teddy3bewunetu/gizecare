import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Persistence for in-app browser bookmarks.
abstract class BrowserBookmarkRepository {
  Stream<List<BrowserBookmark>> watchAll();

  Future<Result<List<BrowserBookmark>>> list();

  Future<Result<BrowserBookmark?>> findByUrl(String url);

  Future<Result<BrowserBookmark>> add({
    required String title,
    required String url,
    String? faviconUrl,
  });

  Future<Result<Unit>> remove(String id);

  Future<Result<Unit>> removeByUrl(String url);

  Future<Result<Unit>> clearAll();
}
