import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/services/clock/clock_alert_service.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

enum CountdownPhase { idle, running, paused, finished }

enum TimerMode { classic, pomodoro }

enum PomodoroStage { focus, shortBreak, longBreak }

class CountdownState extends Equatable {
  const CountdownState({
    this.phase = CountdownPhase.idle,
    this.remaining = Duration.zero,
    this.initial = Duration.zero,
    this.mode = TimerMode.classic,
    this.pomodoroStage = PomodoroStage.focus,
    this.completedFocus = 0,
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.focusesPerLongBreak = 4,
  });

  final CountdownPhase phase;
  final Duration remaining;
  final Duration initial;
  final TimerMode mode;
  final PomodoroStage pomodoroStage;
  /// Focus sessions finished in the current cycle (0…focusesPerLongBreak).
  final int completedFocus;
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int focusesPerLongBreak;

  bool get isRunning => phase == CountdownPhase.running;
  bool get isPaused => phase == CountdownPhase.paused;
  bool get isPomodoro => mode == TimerMode.pomodoro;

  String get stageLabel => switch (pomodoroStage) {
        PomodoroStage.focus => 'Focus',
        PomodoroStage.shortBreak => 'Short break',
        PomodoroStage.longBreak => 'Long break',
      };

  CountdownState copyWith({
    CountdownPhase? phase,
    Duration? remaining,
    Duration? initial,
    TimerMode? mode,
    PomodoroStage? pomodoroStage,
    int? completedFocus,
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? focusesPerLongBreak,
  }) {
    return CountdownState(
      phase: phase ?? this.phase,
      remaining: remaining ?? this.remaining,
      initial: initial ?? this.initial,
      mode: mode ?? this.mode,
      pomodoroStage: pomodoroStage ?? this.pomodoroStage,
      completedFocus: completedFocus ?? this.completedFocus,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      focusesPerLongBreak: focusesPerLongBreak ?? this.focusesPerLongBreak,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        remaining,
        initial,
        mode,
        pomodoroStage,
        completedFocus,
        focusMinutes,
        shortBreakMinutes,
        longBreakMinutes,
        focusesPerLongBreak,
      ];
}

class CountdownController extends Notifier<CountdownState> {
  Timer? _ticker;
  DateTime? _deadline;

  @override
  CountdownState build() {
    ref.onDispose(() => _ticker?.cancel());
    Future.microtask(_restore);
    return const CountdownState();
  }

  void setMode(TimerMode mode) {
    if (state.isRunning) return;
    _ticker?.cancel();
    _deadline = null;
    if (mode == TimerMode.pomodoro) {
      state = state.copyWith(
        mode: mode,
        phase: CountdownPhase.idle,
        pomodoroStage: PomodoroStage.focus,
        completedFocus: 0,
      );
      _applyPomodoroDuration(PomodoroStage.focus);
    } else {
      state = state.copyWith(
        mode: TimerMode.classic,
        phase: CountdownPhase.idle,
      );
    }
    unawaited(_persist());
  }

  void setDuration(Duration duration) {
    if (state.isRunning) return;
    _ticker?.cancel();
    _deadline = null;
    state = state.copyWith(
      mode: TimerMode.classic,
      phase: CountdownPhase.idle,
      remaining: duration,
      initial: duration,
    );
    unawaited(_persist());
  }

  void startPomodoroStage(PomodoroStage stage) {
    if (state.isRunning) return;
    selectPomodoroStage(stage);
    start();
  }

  void selectPomodoroStage(PomodoroStage stage) {
    if (state.isRunning) return;
    _ticker?.cancel();
    _deadline = null;
    state = state.copyWith(
      mode: TimerMode.pomodoro,
      pomodoroStage: stage,
      phase: CountdownPhase.idle,
    );
    _applyPomodoroDuration(stage);
    unawaited(_persist());
  }

  void skipToNextPomodoroStage() {
    if (!state.isPomodoro || state.isRunning) return;
    final next = _nextStageAfter(state.pomodoroStage, state.completedFocus);
    state = state.copyWith(
      pomodoroStage: next.stage,
      completedFocus: next.completedFocus,
      phase: CountdownPhase.idle,
    );
    _applyPomodoroDuration(next.stage);
    unawaited(_persist());
  }

  void start() {
    if (state.remaining <= Duration.zero) return;
    _deadline = DateTime.now().add(state.remaining);
    state = state.copyWith(phase: CountdownPhase.running);
    _startTicker();
    unawaited(_persist());
  }

  void pause() {
    if (!state.isRunning || _deadline == null) return;
    final left = _deadline!.difference(DateTime.now());
    _ticker?.cancel();
    _deadline = null;
    state = state.copyWith(
      phase: CountdownPhase.paused,
      remaining: left.isNegative ? Duration.zero : left,
    );
    unawaited(_persist());
  }

  void resume() => start();

  void addOneMinute() {
    if (state.phase == CountdownPhase.idle && state.initial == Duration.zero) {
      setDuration(const Duration(minutes: 1));
      return;
    }
    final next = state.remaining + const Duration(minutes: 1);
    if (state.isRunning && _deadline != null) {
      _deadline = _deadline!.add(const Duration(minutes: 1));
    }
    state = state.copyWith(
      remaining: next,
      initial: state.initial == Duration.zero
          ? next
          : state.initial + const Duration(minutes: 1),
      phase: state.phase == CountdownPhase.finished
          ? CountdownPhase.paused
          : state.phase,
    );
    unawaited(_persist());
  }

  void reset() {
    _ticker?.cancel();
    _deadline = null;
    if (state.isPomodoro) {
      state = state.copyWith(phase: CountdownPhase.idle);
      _applyPomodoroDuration(state.pomodoroStage);
    } else {
      state = state.copyWith(
        phase: CountdownPhase.idle,
        remaining: state.initial,
      );
    }
    unawaited(_persist());
  }

  void resetPomodoroCycle() {
    if (state.isRunning) return;
    _ticker?.cancel();
    _deadline = null;
    state = state.copyWith(
      mode: TimerMode.pomodoro,
      pomodoroStage: PomodoroStage.focus,
      completedFocus: 0,
      phase: CountdownPhase.idle,
    );
    _applyPomodoroDuration(PomodoroStage.focus);
    unawaited(_persist());
  }

  void _applyPomodoroDuration(PomodoroStage stage) {
    final minutes = switch (stage) {
      PomodoroStage.focus => state.focusMinutes,
      PomodoroStage.shortBreak => state.shortBreakMinutes,
      PomodoroStage.longBreak => state.longBreakMinutes,
    };
    final d = Duration(minutes: minutes);
    state = state.copyWith(remaining: d, initial: d);
  }

  ({PomodoroStage stage, int completedFocus}) _nextStageAfter(
    PomodoroStage finished,
    int completedFocus,
  ) {
    if (finished == PomodoroStage.focus) {
      final nextCount = completedFocus + 1;
      if (nextCount >= state.focusesPerLongBreak) {
        return (stage: PomodoroStage.longBreak, completedFocus: 0);
      }
      return (stage: PomodoroStage.shortBreak, completedFocus: nextCount);
    }
    // Breaks → back to focus; keep completedFocus as-is (already updated).
    return (stage: PomodoroStage.focus, completedFocus: completedFocus);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (_deadline == null) return;
      final left = _deadline!.difference(DateTime.now());
      if (left <= Duration.zero) {
        _ticker?.cancel();
        _deadline = null;
        unawaited(_onFinished());
      } else {
        state = state.copyWith(remaining: left);
      }
    });
  }

  Future<void> _onFinished() async {
    if (state.isPomodoro) {
      final finishedStage = state.pomodoroStage;
      final next = _nextStageAfter(finishedStage, state.completedFocus);
      final title = switch (finishedStage) {
        PomodoroStage.focus => 'Focus complete',
        PomodoroStage.shortBreak => 'Break over',
        PomodoroStage.longBreak => 'Long break over',
      };
      final body = switch (next.stage) {
        PomodoroStage.focus => 'Ready for the next focus session?',
        PomodoroStage.shortBreak =>
          'Nice work — take a ${state.shortBreakMinutes}-minute break.',
        PomodoroStage.longBreak =>
          'Cycle done — enjoy a ${state.longBreakMinutes}-minute long break.',
      };

      state = state.copyWith(
        phase: CountdownPhase.idle,
        pomodoroStage: next.stage,
        completedFocus: next.completedFocus,
      );
      _applyPomodoroDuration(next.stage);
      await _persist();

      await ref.read(clockAlertServiceProvider).ring(
            title: title,
            body: body,
            actions: [
              ClockAlertAction(
                label: 'Start ${switch (next.stage) {
                  PomodoroStage.focus => 'focus',
                  PomodoroStage.shortBreak => 'short break',
                  PomodoroStage.longBreak => 'long break',
                }}',
                onPressed: start,
              ),
            ],
          );
    } else {
      state = state.copyWith(
        phase: CountdownPhase.finished,
        remaining: Duration.zero,
      );
      await _persist();
      await ref.read(clockAlertServiceProvider).ring(
            title: 'Timer finished',
            body: 'Your countdown has reached zero.',
          );
    }
  }

  Future<void> _persist() async {
    final payload = jsonEncode({
      'phase': state.phase.name,
      'remainingMs': state.remaining.inMilliseconds,
      'initialMs': state.initial.inMilliseconds,
      'deadlineMs': _deadline?.millisecondsSinceEpoch,
      'mode': state.mode.name,
      'pomodoroStage': state.pomodoroStage.name,
      'completedFocus': state.completedFocus,
      'focusMinutes': state.focusMinutes,
      'shortBreakMinutes': state.shortBreakMinutes,
      'longBreakMinutes': state.longBreakMinutes,
      'focusesPerLongBreak': state.focusesPerLongBreak,
    });
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.countdownState, payload);
  }

  Future<void> _restore() async {
    final raw =
        await ref.read(settingsRepositoryProvider).get(SettingKeys.countdownState);
    final value = raw.when(onSuccess: (v) => v, onFailure: (_) => null);
    if (value == null) return;
    try {
      final map = jsonDecode(value) as Map<String, dynamic>;
      final remainingMs = (map['remainingMs'] as num?)?.toInt() ?? 0;
      final initialMs = (map['initialMs'] as num?)?.toInt() ?? 0;
      final phaseName = map['phase'] as String? ?? 'idle';
      final deadlineMs = (map['deadlineMs'] as num?)?.toInt();
      final mode = TimerMode.values.firstWhere(
        (m) => m.name == (map['mode'] as String? ?? 'classic'),
        orElse: () => TimerMode.classic,
      );
      final stage = PomodoroStage.values.firstWhere(
        (s) => s.name == (map['pomodoroStage'] as String? ?? 'focus'),
        orElse: () => PomodoroStage.focus,
      );
      final completedFocus = (map['completedFocus'] as num?)?.toInt() ?? 0;
      final phase = CountdownPhase.values.firstWhere(
        (p) => p.name == phaseName,
        orElse: () => CountdownPhase.idle,
      );
      var remaining = Duration(milliseconds: remainingMs);
      final base = CountdownState(
        mode: mode,
        pomodoroStage: stage,
        completedFocus: completedFocus,
        focusMinutes: (map['focusMinutes'] as num?)?.toInt() ?? 25,
        shortBreakMinutes: (map['shortBreakMinutes'] as num?)?.toInt() ?? 5,
        longBreakMinutes: (map['longBreakMinutes'] as num?)?.toInt() ?? 15,
        focusesPerLongBreak:
            (map['focusesPerLongBreak'] as num?)?.toInt() ?? 4,
        phase: phase,
        remaining: remaining,
        initial: Duration(milliseconds: initialMs),
      );

      if (phase == CountdownPhase.running && deadlineMs != null) {
        final deadline = DateTime.fromMillisecondsSinceEpoch(deadlineMs);
        remaining = deadline.difference(DateTime.now());
        if (remaining <= Duration.zero) {
          state = base.copyWith(
            phase: CountdownPhase.idle,
            remaining: Duration.zero,
          );
          return;
        }
        _deadline = deadline;
        state = base.copyWith(phase: phase, remaining: remaining);
        _startTicker();
        return;
      }
      state = base.copyWith(
        phase: phase == CountdownPhase.running
            ? CountdownPhase.paused
            : phase,
        remaining: remaining,
      );
    } catch (_) {}
  }
}

final countdownControllerProvider =
    NotifierProvider<CountdownController, CountdownState>(
  CountdownController.new,
);
