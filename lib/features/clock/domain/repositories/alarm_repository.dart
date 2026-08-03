import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/clock/domain/entities/alarm_item.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Persistence for clock alarms.
abstract class AlarmRepository {
  Stream<List<AlarmItem>> watchAll();

  Future<Result<List<AlarmItem>>> getAll();

  Future<Result<AlarmItem>> create({
    required String label,
    required int hour,
    required int minute,
    int repeatDays = 0,
    bool enabled = true,
  });

  Future<Result<AlarmItem>> update(AlarmItem alarm);

  Future<Result<Unit>> delete(String id);
}
