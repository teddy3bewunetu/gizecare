import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/features/activity/domain/entities/keystroke_count.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/project_detail_provider.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tracker/domain/entities/live_time_entries.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Task for the detail route.
final taskByIdProvider = StreamProvider.family<TaskItem?, String>((ref, id) {
  return ref.watch(taskRepositoryProvider).watchTasks(includeArchived: true).map(
        (list) => list.where((t) => t.id == id).firstOrNull,
      );
});

/// Project for a task (via task.projectId).
final taskProjectProvider =
    Provider.family<AsyncValue<Project?>, String>((ref, taskId) {
  final taskAsync = ref.watch(taskByIdProvider(taskId));
  return taskAsync.when(
    data: (task) {
      if (task == null) return const AsyncData(null);
      return ref.watch(projectByIdProvider(task.projectId));
    },
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
  );
});

/// Session log for a task (newest first).
final taskEntriesProvider =
    StreamProvider.family<List<TimeEntry>, String>((ref, taskId) {
  return ref.watch(timeEntryRepositoryProvider).watchEntries(taskId: taskId);
});

/// Screenshots captured during this task’s sessions.
final taskScreenshotsProvider =
    StreamProvider.family<List<ScreenshotItem>, String>((ref, taskId) {
  return ref.watch(screenshotRepositoryProvider).watchForTask(taskId);
});

/// Ranked keys across all sessions for a task.
final taskKeystrokesProvider =
    StreamProvider.family<List<KeystrokeCount>, String>((ref, taskId) {
  return ref.watch(keystrokeRepositoryProvider).watchForTask(taskId);
});

/// Total / this-week hours for every task.
final taskHoursMapProvider = StreamProvider<Map<String, Duration>>((ref) {
  return ref.watch(timeEntryRepositoryProvider).watchEntries().map((entries) {
    final map = <String, int>{};
    for (final e in entries) {
      final id = e.taskId;
      if (id == null) continue;
      map[id] = (map[id] ?? 0) + e.durationSeconds;
    }
    return {
      for (final entry in map.entries) entry.key: Duration(seconds: entry.value),
    };
  });
});

/// This-week hours per task.
final taskWeekHoursMapProvider = StreamProvider<Map<String, Duration>>((ref) {
  final weekStart = Formatters.startOfWeek(DateTime.now());
  final weekEnd = weekStart.add(const Duration(days: 7));
  return ref.watch(timeEntryRepositoryProvider).watchEntries().map((entries) {
    final map = <String, int>{};
    for (final e in entries) {
      final id = e.taskId;
      if (id == null) continue;
      if (e.startTime.isBefore(weekStart) || !e.startTime.isBefore(weekEnd)) {
        continue;
      }
      map[id] = (map[id] ?? 0) + e.durationSeconds;
    }
    return {
      for (final entry in map.entries) entry.key: Duration(seconds: entry.value),
    };
  });
});

final taskStatsProvider =
    Provider.family<AsyncValue<ProjectTimeStats>, String>((ref, taskId) {
  final timer = ref.watch(timerControllerProvider);
  return ref.watch(taskEntriesProvider(taskId)).whenData(
        (entries) => computeProjectStats(entriesWithLiveTimer(entries, timer)),
      );
});
