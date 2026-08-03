import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/clock/domain/entities/stopwatch_lap.dart';
import 'package:gizecare/features/clock/domain/repositories/stopwatch_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Drift-backed [StopwatchRepository].
class DriftStopwatchRepository implements StopwatchRepository {
  DriftStopwatchRepository(this._db, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<StopwatchLap>> watchLaps({String? sessionId}) {
    final query = _db.select(_db.stopwatchLaps)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.asc(t.lapIndex),
      ]);
    if (sessionId != null) {
      query.where((t) => t.sessionId.equals(sessionId));
    }
    return query
        .watch()
        .map((rows) => rows.map(DatabaseMappers.stopwatchLap).toList());
  }

  @override
  Future<Result<List<StopwatchSession>>> getSessions() async {
    try {
      final rows = await (_db.select(_db.stopwatchLaps)
            ..orderBy([
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.asc(t.lapIndex),
            ]))
          .get();
      final bySession = <String, List<StopwatchLap>>{};
      for (final row in rows) {
        final lap = DatabaseMappers.stopwatchLap(row);
        bySession.putIfAbsent(lap.sessionId, () => []).add(lap);
      }
      final sessions = bySession.entries.map((e) {
        final laps = e.value..sort((a, b) => a.lapIndex.compareTo(b.lapIndex));
        return StopwatchSession(
          sessionId: e.key,
          laps: laps,
          startedAt: laps.first.createdAt,
        );
      }).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
      return Success(sessions);
    } catch (e) {
      return Err(CacheFailure('Failed to load stopwatch sessions', cause: e));
    }
  }

  @override
  Future<Result<List<StopwatchLap>>> getLaps(String sessionId) async {
    try {
      final rows = await (_db.select(_db.stopwatchLaps)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.lapIndex)]))
          .get();
      return Success(rows.map(DatabaseMappers.stopwatchLap).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load laps', cause: e));
    }
  }

  @override
  Future<Result<StopwatchLap>> addLap({
    required String sessionId,
    required int lapIndex,
    required int lapMs,
    required int totalMs,
  }) async {
    try {
      final lap = StopwatchLap(
        id: _uuid.v4(),
        sessionId: sessionId,
        lapIndex: lapIndex,
        lapMs: lapMs,
        totalMs: totalMs,
        createdAt: DateTime.now(),
      );
      await _db.into(_db.stopwatchLaps).insert(
            StopwatchLapsCompanion.insert(
              id: lap.id,
              sessionId: lap.sessionId,
              lapIndex: lap.lapIndex,
              lapMs: lap.lapMs,
              totalMs: lap.totalMs,
              createdAt: lap.createdAt,
            ),
          );
      return Success(lap);
    } catch (e) {
      return Err(CacheFailure('Failed to save lap', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteSession(String sessionId) async {
    try {
      await (_db.delete(_db.stopwatchLaps)
            ..where((t) => t.sessionId.equals(sessionId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete session', cause: e));
    }
  }
}
