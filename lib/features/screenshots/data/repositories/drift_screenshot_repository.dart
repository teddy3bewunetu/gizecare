import 'package:drift/drift.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/screenshots/domain/repositories/screenshot_repository.dart';

/// Drift-backed [ScreenshotRepository].
class DriftScreenshotRepository implements ScreenshotRepository {
  DriftScreenshotRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<ScreenshotItem>> watchAll() {
    final query = _db.select(_db.screenshots)
      ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]);
    return query.watch().map(
          (rows) => rows.map(DatabaseMappers.screenshot).toList(),
        );
  }

  @override
  Stream<List<ScreenshotItem>> watchForTask(String taskId) {
    final query = _db.select(_db.screenshots).join([
      innerJoin(
        _db.timeEntries,
        _db.timeEntries.id.equalsExp(_db.screenshots.timeEntryId),
      ),
    ])
      ..where(_db.timeEntries.taskId.equals(taskId))
      ..orderBy([OrderingTerm.desc(_db.screenshots.takenAt)]);

    return query.watch().map(
          (rows) => rows
              .map((r) => DatabaseMappers.screenshot(r.readTable(_db.screenshots)))
              .toList(),
        );
  }

  @override
  Future<Result<List<ScreenshotItem>>> getAll() async {
    try {
      final rows = await (_db.select(_db.screenshots)
            ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
          .get();
      return Success(rows.map(DatabaseMappers.screenshot).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load screenshots', cause: e));
    }
  }

  @override
  Future<Result<ScreenshotItem>> create(ScreenshotItem item) async {
    try {
      await _db.into(_db.screenshots).insert(
            ScreenshotsCompanion.insert(
              id: item.id,
              timeEntryId: item.timeEntryId,
              filePath: item.filePath,
              takenAt: item.takenAt,
            ),
          );
      return Success(item);
    } catch (e) {
      return Err(CacheFailure('Failed to save screenshot', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.screenshots)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete screenshot', cause: e));
    }
  }
}
