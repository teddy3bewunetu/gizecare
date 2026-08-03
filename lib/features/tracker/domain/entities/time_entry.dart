import 'package:equatable/equatable.dart';

/// A recorded time tracking session.
class TimeEntry extends Equatable {
  const TimeEntry({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.durationSeconds,
    required this.isManual,
    this.taskId,
    this.endTime,
    this.activityPercentage,
    this.notes,
  });

  final String id;
  final String projectId;
  final String? taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int? activityPercentage;
  final bool isManual;
  final String? notes;

  bool get isOpen => endTime == null;

  TimeEntry copyWith({
    String? taskId,
    DateTime? endTime,
    int? durationSeconds,
    int? activityPercentage,
    String? notes,
  }) {
    return TimeEntry(
      id: id,
      projectId: projectId,
      taskId: taskId ?? this.taskId,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      activityPercentage: activityPercentage ?? this.activityPercentage,
      isManual: isManual,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        taskId,
        startTime,
        endTime,
        durationSeconds,
        activityPercentage,
        isManual,
        notes,
      ];
}
