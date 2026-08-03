import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/clock/domain/entities/stopwatch_lap.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Persistence for stopwatch lap history.
abstract class StopwatchRepository {
  Stream<List<StopwatchLap>> watchLaps({String? sessionId});

  Future<Result<List<StopwatchSession>>> getSessions();

  Future<Result<List<StopwatchLap>>> getLaps(String sessionId);

  Future<Result<StopwatchLap>> addLap({
    required String sessionId,
    required int lapIndex,
    required int lapMs,
    required int totalMs,
  });

  Future<Result<Unit>> deleteSession(String sessionId);
}
