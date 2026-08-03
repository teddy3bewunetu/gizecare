import 'package:equatable/equatable.dart';

/// A persisted clock alarm.
class AlarmItem extends Equatable {
  const AlarmItem({
    required this.id,
    required this.label,
    required this.hour,
    required this.minute,
    required this.enabled,
    required this.repeatDays,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String label;
  final int hour;
  final int minute;
  final bool enabled;
  /// Bitmask: bit0=Mon … bit6=Sun. 0 = one-shot.
  final int repeatDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOneShot => repeatDays == 0;

  bool repeatsOnWeekday(int weekday) {
    // DateTime.weekday: Mon=1 … Sun=7 → bit index 0…6
    final bit = weekday - 1;
    return (repeatDays & (1 << bit)) != 0;
  }

  AlarmItem copyWith({
    String? label,
    int? hour,
    int? minute,
    bool? enabled,
    int? repeatDays,
    DateTime? updatedAt,
  }) {
    return AlarmItem(
      id: id,
      label: label ?? this.label,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
      repeatDays: repeatDays ?? this.repeatDays,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, label, hour, minute, enabled, repeatDays, createdAt, updatedAt];
}
