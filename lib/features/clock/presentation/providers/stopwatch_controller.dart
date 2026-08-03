import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/clock/domain/entities/stopwatch_lap.dart';

enum StopwatchPhase { idle, running, paused }

class StopwatchUiState extends Equatable {
  const StopwatchUiState({
    this.phase = StopwatchPhase.idle,
    this.elapsed = Duration.zero,
    this.sessionId,
    this.currentLaps = const [],
  });

  final StopwatchPhase phase;
  final Duration elapsed;
  final String? sessionId;
  final List<StopwatchLap> currentLaps;

  bool get isRunning => phase == StopwatchPhase.running;
  bool get isPaused => phase == StopwatchPhase.paused;
  bool get hasStarted => phase != StopwatchPhase.idle || currentLaps.isNotEmpty;

  StopwatchUiState copyWith({
    StopwatchPhase? phase,
    Duration? elapsed,
    String? sessionId,
    List<StopwatchLap>? currentLaps,
    bool clearSession = false,
  }) {
    return StopwatchUiState(
      phase: phase ?? this.phase,
      elapsed: elapsed ?? this.elapsed,
      sessionId: clearSession ? null : sessionId ?? this.sessionId,
      currentLaps: currentLaps ?? this.currentLaps,
    );
  }

  @override
  List<Object?> get props => [phase, elapsed, sessionId, currentLaps];
}

class StopwatchController extends Notifier<StopwatchUiState> {
  Timer? _ticker;
  DateTime? _segmentStarted;
  Duration _accumulated = Duration.zero;
  Duration _lastLapTotal = Duration.zero;
  final _uuid = const Uuid();

  @override
  StopwatchUiState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const StopwatchUiState();
  }

  void start() {
    if (state.isRunning) return;
    final sessionId = state.sessionId ?? _uuid.v4();
    _segmentStarted = DateTime.now();
    state = state.copyWith(
      phase: StopwatchPhase.running,
      sessionId: sessionId,
    );
    _startTicker();
  }

  void pause() {
    if (!state.isRunning) return;
    _accumulate();
    _ticker?.cancel();
    state = state.copyWith(phase: StopwatchPhase.paused, elapsed: _accumulated);
  }

  void resume() => start();

  Future<void> lap() async {
    if (!state.isRunning && !state.isPaused) return;
    if (state.isRunning) _accumulate();
    final sessionId = state.sessionId ?? _uuid.v4();
    final total = _accumulated;
    final lapMs = total.inMilliseconds - _lastLapTotal.inMilliseconds;
    _lastLapTotal = total;
    final index = state.currentLaps.length + 1;
    final saved = await ref.read(stopwatchRepositoryProvider).addLap(
          sessionId: sessionId,
          lapIndex: index,
          lapMs: lapMs < 0 ? 0 : lapMs,
          totalMs: total.inMilliseconds,
        );
    if (saved.isFailure) return;
    state = state.copyWith(
      sessionId: sessionId,
      currentLaps: [...state.currentLaps, saved.requireValue],
      elapsed: total,
    );
    ref.invalidate(stopwatchSessionsProvider);
    if (state.isRunning) {
      _segmentStarted = DateTime.now();
      _startTicker();
    }
  }

  /// Clears the live stopwatch; lap history remains in the database.
  void reset() {
    _ticker?.cancel();
    _accumulated = Duration.zero;
    _lastLapTotal = Duration.zero;
    _segmentStarted = null;
    state = const StopwatchUiState();
    ref.invalidate(stopwatchSessionsProvider);
  }

  void _accumulate() {
    if (_segmentStarted != null) {
      _accumulated += DateTime.now().difference(_segmentStarted!);
      _segmentStarted = null;
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!state.isRunning || _segmentStarted == null) return;
      final elapsed = _accumulated + DateTime.now().difference(_segmentStarted!);
      state = state.copyWith(elapsed: elapsed);
    });
  }
}

final stopwatchControllerProvider =
    NotifierProvider<StopwatchController, StopwatchUiState>(
  StopwatchController.new,
);

final stopwatchSessionsProvider =
    FutureProvider<List<StopwatchSession>>((ref) async {
  final result = await ref.read(stopwatchRepositoryProvider).getSessions();
  return result.when(onSuccess: (v) => v, onFailure: (_) => const []);
});
