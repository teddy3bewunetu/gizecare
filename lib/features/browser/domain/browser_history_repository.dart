import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/browser/domain/browser_history_entry.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Persistence for in-app browser visit history.
abstract class BrowserHistoryRepository {
  Stream<List<BrowserHistoryEntry>> watchRecent({int limit = 200});

  Future<Result<List<BrowserHistoryEntry>>> search(
    String query, {
    int limit = 100,
  });

  Future<Result<Unit>> recordVisit({
    required String url,
    String? title,
  });

  Future<Result<Unit>> remove(String id);

  Future<Result<Unit>> clearAll();
}
