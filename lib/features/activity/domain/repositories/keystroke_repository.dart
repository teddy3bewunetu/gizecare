import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/activity/domain/entities/keystroke_count.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Persists per-session key-press aggregates.
abstract class KeystrokeRepository {
  Future<Result<Unit>> replaceForEntry({
    required String timeEntryId,
    required Map<String, int> counts,
  });

  Stream<List<KeystrokeCount>> watchForEntry(String timeEntryId);

  Stream<List<KeystrokeCount>> watchForTask(String taskId);

  Future<Result<List<KeystrokeCount>>> getForTask(String taskId);
}
