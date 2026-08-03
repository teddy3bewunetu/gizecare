import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/clock/domain/entities/alarm_item.dart';
import 'package:gizecare/features/clock/domain/repositories/alarm_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Drift-backed [AlarmRepository].
class DriftAlarmRepository implements AlarmRepository {
  DriftAlarmRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<AlarmItem>> watchAll() {
    final query = _db.select(_db.alarms)
      ..orderBy([
        (t) => OrderingTerm.asc(t.hour),
        (t) => OrderingTerm.asc(t.minute),
      ]);
    return query.watch().map((rows) => rows.map(DatabaseMappers.alarm).toList());
  }

  @override
  Future<Result<List<AlarmItem>>> getAll() async {
    try {
      final rows = await (_db.select(_db.alarms)
            ..orderBy([
              (t) => OrderingTerm.asc(t.hour),
              (t) => OrderingTerm.asc(t.minute),
            ]))
          .get();
      return Success(rows.map(DatabaseMappers.alarm).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load alarms', cause: e));
    }
  }

  @override
  Future<Result<AlarmItem>> create({
    required String label,
    required int hour,
    required int minute,
    int repeatDays = 0,
    bool enabled = true,
  }) async {
    try {
      final now = DateTime.now();
      final item = AlarmItem(
        id: _uuid.v4(),
        label: label.trim().isEmpty ? 'Alarm' : label.trim(),
        hour: hour,
        minute: minute,
        enabled: enabled,
        repeatDays: repeatDays,
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.alarms).insert(
            AlarmsCompanion.insert(
              id: item.id,
              label: Value(item.label),
              hour: item.hour,
              minute: item.minute,
              enabled: Value(item.enabled),
              repeatDays: Value(item.repeatDays),
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            ),
          );
      return Success(item);
    } catch (e) {
      return Err(CacheFailure('Failed to create alarm', cause: e));
    }
  }

  @override
  Future<Result<AlarmItem>> update(AlarmItem alarm) async {
    try {
      final updated = alarm.copyWith(updatedAt: DateTime.now());
      await (_db.update(_db.alarms)..where((t) => t.id.equals(alarm.id))).write(
        AlarmsCompanion(
          label: Value(updated.label),
          hour: Value(updated.hour),
          minute: Value(updated.minute),
          enabled: Value(updated.enabled),
          repeatDays: Value(updated.repeatDays),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update alarm', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.alarms)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete alarm', cause: e));
    }
  }
}
