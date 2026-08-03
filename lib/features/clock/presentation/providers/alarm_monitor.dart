import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/services/clock/clock_alert_service.dart';
import 'package:gizecare/features/clock/domain/entities/alarm_item.dart';

/// Live list of alarms.
final alarmsProvider = StreamProvider<List<AlarmItem>>((ref) {
  return ref.watch(alarmRepositoryProvider).watchAll();
});

/// Polls once per second and rings due alarms while the app is running.
class AlarmMonitor extends Notifier<void> {
  Timer? _timer;
  final Set<String> _firedKeys = {};
  final Map<String, DateTime> _snoozeUntil = {};

  @override
  void build() {
    ref.onDispose(() => _timer?.cancel());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void snooze(String alarmId, Duration duration) {
    _snoozeUntil[alarmId] = DateTime.now().add(duration);
  }

  Future<void> _tick() async {
    final now = DateTime.now();
    final minuteKey =
        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';
    final result = await ref.read(alarmRepositoryProvider).getAll();
    if (result.isFailure) return;
    for (final alarm in result.requireValue) {
      if (!alarm.enabled) continue;
      final snoozeUntil = _snoozeUntil[alarm.id];
      if (snoozeUntil != null && now.isBefore(snoozeUntil)) continue;

      if (!_isDue(alarm, now, snoozeUntil)) continue;
      final fireKey = '${alarm.id}@$minuteKey';
      if (_firedKeys.contains(fireKey)) continue;
      _firedKeys.add(fireKey);
      if (_firedKeys.length > 200) {
        _firedKeys.remove(_firedKeys.first);
      }
      _snoozeUntil.remove(alarm.id);
      unawaited(
        ref.read(clockAlertServiceProvider).ring(
              title: alarm.label,
              body:
                  'Alarm for ${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}',
              actions: [
                ClockAlertAction(
                  label: 'Snooze 5 min',
                  onPressed: () =>
                      snooze(alarm.id, const Duration(minutes: 5)),
                ),
                ClockAlertAction(
                  label: 'Snooze 10 min',
                  onPressed: () =>
                      snooze(alarm.id, const Duration(minutes: 10)),
                ),
              ],
            ),
      );
      if (alarm.isOneShot) {
        await ref
            .read(alarmRepositoryProvider)
            .update(alarm.copyWith(enabled: false));
      }
    }
  }

  bool _isDue(AlarmItem alarm, DateTime now, DateTime? snoozeUntil) {
    if (snoozeUntil != null &&
        !now.isBefore(snoozeUntil) &&
        now.difference(snoozeUntil).inSeconds < 3) {
      return true;
    }
    if (now.hour != alarm.hour || now.minute != alarm.minute) return false;
    if (now.second > 2) return false;
    if (alarm.isOneShot) return true;
    return alarm.repeatsOnWeekday(now.weekday);
  }
}

final alarmMonitorProvider =
    NotifierProvider<AlarmMonitor, void>(AlarmMonitor.new);
