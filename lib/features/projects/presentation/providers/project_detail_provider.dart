import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Selected project for the detail route.
final projectByIdProvider =
    StreamProvider.family<Project?, String>((ref, id) {
  return ref
      .watch(projectRepositoryProvider)
      .watchProjects(includeArchived: true)
      .map((list) => list.where((p) => p.id == id).firstOrNull);
});

/// All time entries for a project (newest first).
final projectEntriesProvider =
    StreamProvider.family<List<TimeEntry>, String>((ref, projectId) {
  return ref.watch(timeEntryRepositoryProvider).watchEntries(
        projectId: projectId,
      );
});

/// Tasks for a project.
final projectTasksProvider =
    StreamProvider.family<List<TaskItem>, String>((ref, projectId) {
  return ref.watch(taskRepositoryProvider).watchTasks(projectId: projectId);
});

/// Aggregated stats for project overview / timesheet.
class ProjectTimeStats {
  const ProjectTimeStats({
    required this.last24h,
    required this.thisWeek,
    required this.lastWeek,
    required this.sinceStart,
    required this.trackedThisWeek,
    required this.manualThisWeek,
    required this.lastWorkedAt,
    required this.weekDaySeconds,
    required this.weekStart,
  });

  final Duration last24h;
  final Duration thisWeek;
  final Duration lastWeek;
  final Duration sinceStart;
  final Duration trackedThisWeek;
  final Duration manualThisWeek;
  final DateTime? lastWorkedAt;
  final List<int> weekDaySeconds; // Mon..Sun
  final DateTime weekStart;

  double earningsThisWeek(double? hourlyRate) {
    if (hourlyRate == null) return 0;
    return (thisWeek.inSeconds / 3600.0) * hourlyRate;
  }
}

ProjectTimeStats computeProjectStats(
  List<TimeEntry> entries, {
  DateTime? now,
  DateTime? weekStartOverride,
}) {
  final clock = now ?? DateTime.now();
  final weekStart = weekStartOverride ?? Formatters.startOfWeek(clock);
  final lastWeekStart = weekStart.subtract(const Duration(days: 7));
  final dayAgo = clock.subtract(const Duration(hours: 24));

  var last24 = 0;
  var thisWeek = 0;
  var lastWeek = 0;
  var sinceStart = 0;
  var trackedWeek = 0;
  var manualWeek = 0;
  DateTime? lastWorked;
  final days = List<int>.filled(7, 0);

  for (final e in entries) {
    final secs = e.durationSeconds;
    sinceStart += secs;
    if (lastWorked == null || e.startTime.isAfter(lastWorked)) {
      lastWorked = e.endTime ?? e.startTime;
    }
    if (e.startTime.isAfter(dayAgo) || e.startTime.isAtSameMomentAs(dayAgo)) {
      last24 += secs;
    }
    if (!e.startTime.isBefore(weekStart) &&
        e.startTime.isBefore(weekStart.add(const Duration(days: 7)))) {
      thisWeek += secs;
      if (e.isManual) {
        manualWeek += secs;
      } else {
        trackedWeek += secs;
      }
      final dayIndex = e.startTime.weekday - 1;
      days[dayIndex] += secs;
    } else if (!e.startTime.isBefore(lastWeekStart) &&
        e.startTime.isBefore(weekStart)) {
      lastWeek += secs;
    }
  }

  return ProjectTimeStats(
    last24h: Duration(seconds: last24),
    thisWeek: Duration(seconds: thisWeek),
    lastWeek: Duration(seconds: lastWeek),
    sinceStart: Duration(seconds: sinceStart),
    trackedThisWeek: Duration(seconds: trackedWeek),
    manualThisWeek: Duration(seconds: manualWeek),
    lastWorkedAt: lastWorked,
    weekDaySeconds: days,
    weekStart: weekStart,
  );
}

final projectStatsProvider =
    Provider.family<AsyncValue<ProjectTimeStats>, String>((ref, projectId) {
  return ref.watch(projectEntriesProvider(projectId)).whenData(computeProjectStats);
});
