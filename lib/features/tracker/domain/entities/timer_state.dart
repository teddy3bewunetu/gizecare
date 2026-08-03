import 'package:equatable/equatable.dart';

/// Runtime state of the timer engine.
enum TimerPhase { idle, running, paused }

/// Immutable timer UI/state model.
class TimerState extends Equatable {
  const TimerState({
    this.phase = TimerPhase.idle,
    this.entryId,
    this.projectId,
    this.taskId,
    this.projectName,
    this.taskName,
    this.startedAt,
    this.elapsed = Duration.zero,
    this.activityPercentage = 0,
    this.pendingIdlePrompt = false,
    this.idleDuration = Duration.zero,
  });

  final TimerPhase phase;
  final String? entryId;
  final String? projectId;
  final String? taskId;
  final String? projectName;
  final String? taskName;
  final DateTime? startedAt;
  final Duration elapsed;
  final int activityPercentage;
  final bool pendingIdlePrompt;
  final Duration idleDuration;

  bool get isRunning => phase == TimerPhase.running;
  bool get isPaused => phase == TimerPhase.paused;
  bool get hasSession => phase != TimerPhase.idle;

  TimerState copyWith({
    TimerPhase? phase,
    String? entryId,
    String? projectId,
    String? taskId,
    String? projectName,
    String? taskName,
    DateTime? startedAt,
    Duration? elapsed,
    int? activityPercentage,
    bool? pendingIdlePrompt,
    Duration? idleDuration,
    bool clearSession = false,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      entryId: clearSession ? null : entryId ?? this.entryId,
      projectId: clearSession ? null : projectId ?? this.projectId,
      taskId: clearSession ? null : taskId ?? this.taskId,
      projectName: clearSession ? null : projectName ?? this.projectName,
      taskName: clearSession ? null : taskName ?? this.taskName,
      startedAt: clearSession ? null : startedAt ?? this.startedAt,
      elapsed: elapsed ?? this.elapsed,
      activityPercentage: activityPercentage ?? this.activityPercentage,
      pendingIdlePrompt: pendingIdlePrompt ?? this.pendingIdlePrompt,
      idleDuration: idleDuration ?? this.idleDuration,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        entryId,
        projectId,
        taskId,
        projectName,
        taskName,
        startedAt,
        elapsed,
        activityPercentage,
        pendingIdlePrompt,
        idleDuration,
      ];
}
