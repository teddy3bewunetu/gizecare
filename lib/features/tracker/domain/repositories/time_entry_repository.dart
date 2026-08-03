import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Contract for time entry persistence.
abstract class TimeEntryRepository {
  Stream<List<TimeEntry>> watchEntries({
    DateTime? from,
    DateTime? to,
    String? projectId,
    String? taskId,
  });

  Future<Result<List<TimeEntry>>> getEntries({
    DateTime? from,
    DateTime? to,
    String? projectId,
    String? taskId,
  });

  Future<Result<TimeEntry?>> getById(String id);

  Future<Result<TimeEntry?>> getOpenEntry();

  Future<Result<TimeEntry>> create(TimeEntry entry);

  Future<Result<TimeEntry>> update(TimeEntry entry);

  Future<Result<Unit>> delete(String id);

  Future<Result<int>> sumDurationSeconds({
    required DateTime from,
    required DateTime to,
    String? projectId,
    String? taskId,
  });

  /// Total duration seconds per task id (skips entries without a task).
  Future<Result<Map<String, int>>> sumDurationSecondsByTask({
    String? projectId,
  });
}
