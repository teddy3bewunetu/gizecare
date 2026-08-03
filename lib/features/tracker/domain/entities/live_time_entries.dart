import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';

/// Replaces the open session's DB duration/activity with live timer values.
///
/// While a session is running, Drift still holds `durationSeconds: 0` until
/// pause/stop (or a periodic persist). Stats UIs must use this so totals and
/// session rows reflect the in-memory timer without double-counting.
List<TimeEntry> entriesWithLiveTimer(
  List<TimeEntry> entries,
  TimerState timer,
) {
  if (!timer.hasSession || timer.entryId == null) return entries;
  return [
    for (final e in entries)
      if (e.id == timer.entryId)
        e.copyWith(
          durationSeconds: timer.elapsed.inSeconds,
          activityPercentage: timer.activityPercentage,
        )
      else
        e,
  ];
}

/// Sum of duration seconds after applying [entriesWithLiveTimer].
int liveDurationSeconds(List<TimeEntry> entries, TimerState timer) {
  return entriesWithLiveTimer(entries, timer)
      .fold<int>(0, (sum, e) => sum + e.durationSeconds);
}
