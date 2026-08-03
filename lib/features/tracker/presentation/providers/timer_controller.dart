import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/services/activity/keystroke_capture.dart';
import 'package:gizecare/core/services/idle/idle_detection_service.dart';
import 'package:gizecare/core/services/idle/linux_idle_detection_service.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';

/// Controls the tracking timer engine.
class TimerController extends Notifier<TimerState> {
  Timer? _ticker;
  DateTime? _segmentStartedAt;
  Duration _accumulated = Duration.zero;
  int _ticksSincePersist = 0;
  final _uuid = const Uuid();

  static const _persistEverySeconds = 30;

  @override
  TimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return const TimerState();
  }

  Future<void> start({
    required Project project,
    required TaskItem task,
  }) async {
    if (state.hasSession) {
      await stop();
    }

    final now = DateTime.now();
    final entry = TimeEntry(
      id: _uuid.v4(),
      projectId: project.id,
      taskId: task.id,
      startTime: now,
      durationSeconds: 0,
      isManual: false,
      activityPercentage: 0,
    );

    final created = await ref.read(timeEntryRepositoryProvider).create(entry);
    if (created.isFailure) return;

    // Remember selection for tray / next session.
    final settings = ref.read(settingsRepositoryProvider);
    unawaited(settings.set(SettingKeys.lastProjectId, project.id));
    unawaited(settings.set(SettingKeys.lastTaskId, task.id));

    _accumulated = Duration.zero;
    _segmentStartedAt = now;

    ref.read(activityServiceProvider).resetSession();
    ref.read(liveKeystrokeStatsProvider.notifier).clear();

    state = TimerState(
      phase: TimerPhase.running,
      entryId: entry.id,
      projectId: project.id,
      taskId: task.id,
      projectName: project.name,
      taskName: task.name,
      startedAt: now,
      elapsed: Duration.zero,
    );

    _startTicker();
    await _startAuxServices(entry.id);
  }

  void pause() {
    if (!state.isRunning) return;
    _accumulateSegment();
    _ticker?.cancel();
    ref.read(idleDetectionServiceProvider).stopMonitoring();
    ref.read(screenshotServiceProvider).stop();
    state = state.copyWith(phase: TimerPhase.paused, elapsed: _accumulated);
    unawaited(_persistPartial());
    unawaited(
      ref.read(keystrokeCaptureProvider).flushToDb(clear: false),
    );
  }

  void resume() {
    if (!state.isPaused || state.entryId == null) return;
    _segmentStartedAt = DateTime.now();
    state = state.copyWith(
      phase: TimerPhase.running,
      pendingIdlePrompt: false,
      idleDuration: Duration.zero,
    );
    _startTicker();
    unawaited(_startAuxServices(state.entryId!));
  }

  Future<void> stop() async {
    if (!state.hasSession) return;
    if (state.isRunning) {
      _accumulateSegment();
    }
    _ticker?.cancel();
    ref.read(idleDetectionServiceProvider).stopMonitoring();
    ref.read(screenshotServiceProvider).stop();

    final entryId = state.entryId!;
    final activity = ref.read(activityServiceProvider);
    final activityPct = activity.currentPercentage;

    // Flush keys before clearing session state / activity.
    await ref.read(keystrokeCaptureProvider).flushToDb(clear: true);
    activity.stop();

    final repo = ref.read(timeEntryRepositoryProvider);
    final existing = await repo.getById(entryId);
    if (existing.isSuccess && existing.requireValue != null) {
      await repo.update(
        existing.requireValue!.copyWith(
          endTime: DateTime.now(),
          durationSeconds: _accumulated.inSeconds,
          activityPercentage: activityPct,
        ),
      );
    }

    state = const TimerState();
    _accumulated = Duration.zero;
    _segmentStartedAt = null;
  }

  void recordPointer() {
    ref.read(activityServiceProvider).recordPointerEvent();
    final idle = ref.read(idleDetectionServiceProvider);
    if (idle is LinuxIdleDetectionService) {
      idle.bumpActivity();
    }
    _refreshActivity();
  }

  void recordKey([String? keyLabel]) {
    ref.read(activityServiceProvider).recordKeyEvent(keyLabel);
    final idle = ref.read(idleDetectionServiceProvider);
    if (idle is LinuxIdleDetectionService) {
      idle.bumpActivity();
    }
    _refreshActivity();
  }

  Future<void> handleIdleReturn({required IdleReturnAction action}) async {
    final idle = state.idleDuration;
    switch (action) {
      case IdleReturnAction.resume:
      case IdleReturnAction.discardIdle:
        resume();
      case IdleReturnAction.keepIdle:
        _accumulated += idle;
        state = state.copyWith(elapsed: _accumulated);
        resume();
    }
  }

  void _onIdle(IdleInfo info) {
    if (!state.isRunning) return;
    _accumulateSegment();
    _ticker?.cancel();
    ref.read(screenshotServiceProvider).stop();
    ref.read(idleDetectionServiceProvider).stopMonitoring();
    state = state.copyWith(
      phase: TimerPhase.paused,
      elapsed: _accumulated,
      pendingIdlePrompt: true,
      idleDuration: info.idleDuration,
    );
    unawaited(_persistPartial());
    unawaited(ref.read(keystrokeCaptureProvider).flushToDb(clear: false));
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticksSincePersist = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isRunning || _segmentStartedAt == null) return;
      final elapsed =
          _accumulated + DateTime.now().difference(_segmentStartedAt!);
      state = state.copyWith(elapsed: elapsed);
      _refreshActivity();
      _ticksSincePersist++;
      if (_ticksSincePersist >= _persistEverySeconds) {
        _ticksSincePersist = 0;
        unawaited(_persistPartial());
      }
    });
  }

  void _accumulateSegment() {
    if (_segmentStartedAt != null) {
      _accumulated += DateTime.now().difference(_segmentStartedAt!);
      _segmentStartedAt = null;
    }
  }

  /// Duration that should be written to the open entry right now.
  Duration get _persistableElapsed {
    if (state.isRunning && _segmentStartedAt != null) {
      return _accumulated + DateTime.now().difference(_segmentStartedAt!);
    }
    return _accumulated;
  }

  void _refreshActivity() {
    final pct = ref.read(activityServiceProvider).currentPercentage;
    if (pct != state.activityPercentage) {
      state = state.copyWith(activityPercentage: pct);
    }
  }

  Future<void> _persistPartial() async {
    final entryId = state.entryId;
    if (entryId == null) return;
    final repo = ref.read(timeEntryRepositoryProvider);
    final existing = await repo.getById(entryId);
    if (existing.isSuccess && existing.requireValue != null) {
      await repo.update(
        existing.requireValue!.copyWith(
          durationSeconds: _persistableElapsed.inSeconds,
          activityPercentage:
              ref.read(activityServiceProvider).currentPercentage,
        ),
      );
    }
  }

  Future<void> _startAuxServices(String entryId) async {
    final settings = ref.read(settingsRepositoryProvider);
    final idleRaw = await settings.get(SettingKeys.idleTimeoutMinutes);
    final shotRaw = await settings.get(SettingKeys.screenshotIntervalMinutes);
    final idleMinutes = int.tryParse(
          idleRaw.when(onSuccess: (v) => v, onFailure: (_) => null) ?? '',
        ) ??
        AppConstants.defaultIdleTimeout.inMinutes;
    final shotMinutes = int.tryParse(
          shotRaw.when(onSuccess: (v) => v, onFailure: (_) => null) ?? '',
        ) ??
        AppConstants.defaultScreenshotInterval.inMinutes;

    ref.read(activityServiceProvider).start();
    ref.read(idleDetectionServiceProvider).startMonitoring(
          timeout: Duration(minutes: idleMinutes),
          onIdle: _onIdle,
        );
    ref.read(screenshotServiceProvider).start(
          timeEntryId: entryId,
          interval: Duration(minutes: shotMinutes),
        );
  }
}

/// Idle dialog actions when the user returns.
enum IdleReturnAction { resume, discardIdle, keepIdle }

/// Timer controller provider.
final timerControllerProvider =
    NotifierProvider<TimerController, TimerState>(TimerController.new);
