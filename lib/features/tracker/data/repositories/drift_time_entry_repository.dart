import 'package:drift/drift.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/domain/repositories/time_entry_repository.dart';

/// Drift-backed [TimeEntryRepository].
class DriftTimeEntryRepository implements TimeEntryRepository {
  DriftTimeEntryRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TimeEntry>> watchEntries({
    DateTime? from,
    DateTime? to,
    String? projectId,
    String? taskId,
  }) {
    final query = _db.select(_db.timeEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);
    _applyFilters(
      query,
      from: from,
      to: to,
      projectId: projectId,
      taskId: taskId,
    );
    return query.watch().map(
          (rows) => rows.map(DatabaseMappers.timeEntry).toList(),
        );
  }

  @override
  Future<Result<List<TimeEntry>>> getEntries({
    DateTime? from,
    DateTime? to,
    String? projectId,
    String? taskId,
  }) async {
    try {
      final query = _db.select(_db.timeEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);
      _applyFilters(
        query,
        from: from,
        to: to,
        projectId: projectId,
        taskId: taskId,
      );
      final rows = await query.get();
      return Success(rows.map(DatabaseMappers.timeEntry).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load time entries', cause: e));
    }
  }

  @override
  Future<Result<TimeEntry?>> getById(String id) async {
    try {
      final row =
          await (_db.select(_db.timeEntries)..where((t) => t.id.equals(id)))
              .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.timeEntry(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load time entry', cause: e));
    }
  }

  @override
  Future<Result<TimeEntry?>> getOpenEntry() async {
    try {
      final row = await (_db.select(_db.timeEntries)
            ..where((t) => t.endTime.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
            ..limit(1))
          .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.timeEntry(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load open time entry', cause: e));
    }
  }

  @override
  Future<Result<TimeEntry>> create(TimeEntry entry) async {
    try {
      await _db.into(_db.timeEntries).insert(
            TimeEntriesCompanion.insert(
              id: entry.id,
              projectId: entry.projectId,
              taskId: Value(entry.taskId),
              startTime: entry.startTime,
              endTime: Value(entry.endTime),
              durationSeconds: Value(entry.durationSeconds),
              activityPercentage: Value(entry.activityPercentage),
              isManual: Value(entry.isManual),
              notes: Value(entry.notes),
            ),
          );
      return Success(entry);
    } catch (e) {
      return Err(CacheFailure('Failed to create time entry', cause: e));
    }
  }

  @override
  Future<Result<TimeEntry>> update(TimeEntry entry) async {
    try {
      await (_db.update(_db.timeEntries)..where((t) => t.id.equals(entry.id)))
          .write(
        TimeEntriesCompanion(
          taskId: Value(entry.taskId),
          endTime: Value(entry.endTime),
          durationSeconds: Value(entry.durationSeconds),
          activityPercentage: Value(entry.activityPercentage),
          notes: Value(entry.notes),
        ),
      );
      return Success(entry);
    } catch (e) {
      return Err(CacheFailure('Failed to update time entry', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.keystrokeCounts)
            ..where((t) => t.timeEntryId.equals(id)))
          .go();
      await (_db.delete(_db.screenshots)..where((t) => t.timeEntryId.equals(id)))
          .go();
      await (_db.delete(_db.timeEntries)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete time entry', cause: e));
    }
  }

  @override
  Future<Result<int>> sumDurationSeconds({
    required DateTime from,
    required DateTime to,
    String? projectId,
    String? taskId,
  }) async {
    try {
      final query = _db.selectOnly(_db.timeEntries)
        ..addColumns([_db.timeEntries.durationSeconds.sum()])
        ..where(
          _db.timeEntries.startTime.isBiggerOrEqualValue(from) &
              _db.timeEntries.startTime.isSmallerThanValue(to),
        );
      if (projectId != null) {
        query.where(_db.timeEntries.projectId.equals(projectId));
      }
      if (taskId != null) {
        query.where(_db.timeEntries.taskId.equals(taskId));
      }
      final row = await query.getSingle();
      final sum = row.read(_db.timeEntries.durationSeconds.sum()) ?? 0;
      return Success(sum);
    } catch (e) {
      return Err(CacheFailure('Failed to sum durations', cause: e));
    }
  }

  @override
  Future<Result<Map<String, int>>> sumDurationSecondsByTask({
    String? projectId,
  }) async {
    try {
      final query = _db.selectOnly(_db.timeEntries)
        ..addColumns([
          _db.timeEntries.taskId,
          _db.timeEntries.durationSeconds.sum(),
        ])
        ..where(_db.timeEntries.taskId.isNotNull())
        ..groupBy([_db.timeEntries.taskId]);
      if (projectId != null) {
        query.where(_db.timeEntries.projectId.equals(projectId));
      }
      final rows = await query.get();
      final map = <String, int>{};
      for (final row in rows) {
        final id = row.read(_db.timeEntries.taskId);
        if (id == null) continue;
        map[id] = row.read(_db.timeEntries.durationSeconds.sum()) ?? 0;
      }
      return Success(map);
    } catch (e) {
      return Err(CacheFailure('Failed to sum durations by task', cause: e));
    }
  }

  void _applyFilters(
    SimpleSelectStatement<$TimeEntriesTable, TimeEntryRow> query, {
    DateTime? from,
    DateTime? to,
    String? projectId,
    String? taskId,
  }) {
    if (from != null) {
      query.where((t) => t.startTime.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((t) => t.startTime.isSmallerThanValue(to));
    }
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    if (taskId != null) {
      query.where((t) => t.taskId.equals(taskId));
    }
  }
}
