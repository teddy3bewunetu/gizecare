import 'package:equatable/equatable.dart';

/// One lap within a stopwatch session.
class StopwatchLap extends Equatable {
  const StopwatchLap({
    required this.id,
    required this.sessionId,
    required this.lapIndex,
    required this.lapMs,
    required this.totalMs,
    required this.createdAt,
  });

  final String id;
  final String sessionId;
  final int lapIndex;
  final int lapMs;
  final int totalMs;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, sessionId, lapIndex, lapMs, totalMs, createdAt];
}

/// A stopwatch session with its laps.
class StopwatchSession extends Equatable {
  const StopwatchSession({
    required this.sessionId,
    required this.laps,
    required this.startedAt,
  });

  final String sessionId;
  final List<StopwatchLap> laps;
  final DateTime startedAt;

  int get totalMs => laps.isEmpty ? 0 : laps.last.totalMs;

  @override
  List<Object?> get props => [sessionId, laps, startedAt];
}
