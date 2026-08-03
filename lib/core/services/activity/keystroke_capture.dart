import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/core_providers.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/services/activity/keystroke_label.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Live keystroke tallies for the current tracking session (UI).
final liveKeystrokeStatsProvider =
    NotifierProvider<LiveKeystrokeStats, LiveKeystrokeStatsState>(
  LiveKeystrokeStats.new,
);

class LiveKeystrokeStatsState {
  const LiveKeystrokeStatsState({
    this.total = 0,
    this.ranked = const [],
  });

  final int total;
  final List<MapEntry<String, int>> ranked;
}

class LiveKeystrokeStats extends Notifier<LiveKeystrokeStatsState> {
  @override
  LiveKeystrokeStatsState build() => const LiveKeystrokeStatsState();

  void refreshFromActivity() {
    final activity = ref.read(activityServiceProvider);
    state = LiveKeystrokeStatsState(
      total: activity.totalKeyPresses,
      ranked: activity.rankedKeys(limit: 12),
    );
  }

  void clear() => state = const LiveKeystrokeStatsState();
}

/// Registers a global keyboard handler and periodically flushes counts to DB.
final keystrokeCaptureProvider = Provider<KeystrokeCaptureController>((ref) {
  final controller = KeystrokeCaptureController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

class KeystrokeCaptureController {
  KeystrokeCaptureController(this._ref) {
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
    _flushTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => unawaited(flushToDb(clear: false)),
    );
  }

  final Ref _ref;
  Timer? _flushTimer;
  bool _disposed = false;
  int _sinceLastLog = 0;

  bool _onKeyEvent(KeyEvent event) {
    if (_disposed) return false;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    final timer = _ref.read(timerControllerProvider);
    if (!timer.isRunning || timer.entryId == null) return false;

    final label = keystrokeLabel(event);
    if (label == null) return false;

    _ref.read(timerControllerProvider.notifier).recordKey(label);
    _ref.read(liveKeystrokeStatsProvider.notifier).refreshFromActivity();

    _sinceLastLog++;
    if (_sinceLastLog == 1 || _sinceLastLog % 50 == 0) {
      _ref.read(appLoggerProvider).verbose(
            'Keystroke captured: $label '
            '(session total ${_ref.read(activityServiceProvider).totalKeyPresses})',
          );
    }
    return false;
  }

  /// Writes current tallies for the active entry. [clear] empties memory (stop).
  Future<void> flushToDb({required bool clear}) async {
    if (_disposed) return;
    final timer = _ref.read(timerControllerProvider);
    final entryId = timer.entryId;
    if (entryId == null) return;

    final activity = _ref.read(activityServiceProvider);
    final counts = clear
        ? activity.takeKeyCounts()
        : Map<String, int>.from(activity.keyCounts);
    if (counts.isEmpty) {
      if (clear) {
        _ref.read(liveKeystrokeStatsProvider.notifier).clear();
      }
      return;
    }

    final result = await _ref.read(keystrokeRepositoryProvider).replaceForEntry(
          timeEntryId: entryId,
          counts: counts,
        );
    result.when(
      onSuccess: (_) {
        _ref.read(appLoggerProvider).verbose(
              'Saved ${counts.length} key labels '
              '(${counts.values.fold<int>(0, (a, b) => a + b)} presses) '
              'for entry $entryId',
            );
      },
      onFailure: (f) {
        _ref.read(appLoggerProvider).warning('Failed to persist keystrokes: $f');
      },
    );

    if (clear) {
      _ref.read(liveKeystrokeStatsProvider.notifier).clear();
    } else {
      _ref.read(liveKeystrokeStatsProvider.notifier).refreshFromActivity();
    }
  }

  void dispose() {
    _disposed = true;
    _flushTimer?.cancel();
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
  }
}
