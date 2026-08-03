import 'package:flutter/material.dart';

import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/calendar/domain/repositories/calendar_repositories.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/repositories/task_repository.dart';
import 'package:gizecare/features/tracker/domain/repositories/time_entry_repository.dart';

/// Pure merger used by [CalendarFeedRepository] and unit tests.
List<CalendarItem> mergeCalendarFeed({
  required List<CalendarItem> googleEvents,
  required List<CalendarItem> tasks,
  required List<CalendarItem> timeEntries,
  bool includeGoogle = true,
  bool includeTasks = true,
  bool includeTimeEntries = true,
}) {
  final items = <CalendarItem>[
    if (includeGoogle) ...googleEvents,
    if (includeTasks) ...tasks,
    if (includeTimeEntries) ...timeEntries,
  ]..sort((a, b) => a.startAt.compareTo(b.startAt));
  return items;
}

class CalendarFeedRepositoryImpl implements CalendarFeedRepository {
  CalendarFeedRepositoryImpl({
    required GoogleCalendarRepository googleCalendarRepository,
    required TaskRepository taskRepository,
    required TimeEntryRepository timeEntryRepository,
    required ProjectRepository projectRepository,
  })  : _google = googleCalendarRepository,
        _tasks = taskRepository,
        _timeEntries = timeEntryRepository,
        _projects = projectRepository;

  final GoogleCalendarRepository _google;
  final TaskRepository _tasks;
  final TimeEntryRepository _timeEntries;
  final ProjectRepository _projects;

  static const _taskColor = Color(0xFFA855F7);
  static const _timeColor = AppColors.brand;

  @override
  Future<Result<List<CalendarItem>>> getItems({
    required DateTime from,
    required DateTime to,
    bool includeGoogle = true,
    bool includeTasks = true,
    bool includeTimeEntries = true,
  }) async {
    try {
      final google = includeGoogle
          ? await _google.getCachedEvents(from: from, to: to)
          : const Success(<CalendarItem>[]);
      if (google.isFailure) return Err(google.requireFailure);

      final taskItems = <CalendarItem>[];
      if (includeTasks) {
        final tasksResult = await _tasks.getTasks();
        if (tasksResult.isFailure) return Err(tasksResult.requireFailure);
        for (final task in tasksResult.requireValue) {
          final due = task.dueAt;
          if (due == null) continue;
          if (due.isBefore(from) || !due.isBefore(to)) continue;
          taskItems.add(
            CalendarItem(
              id: 'task:${task.id}',
              source: CalendarItemSource.task,
              title: task.name,
              startAt: due,
              endAt: due.add(const Duration(minutes: 30)),
              allDay: due.hour == 0 && due.minute == 0 && due.second == 0,
              description: task.description,
              color: task.coverColor ?? _taskColor,
              projectId: task.projectId,
              taskId: task.id,
            ),
          );
        }
      }

      final timeItems = <CalendarItem>[];
      if (includeTimeEntries) {
        final entriesResult = await _timeEntries.getEntries(from: from, to: to);
        if (entriesResult.isFailure) {
          return Err(entriesResult.requireFailure);
        }
        final projectsResult = await _projects.getProjects();
        final colors = <String, Color>{};
        if (projectsResult.isSuccess) {
          for (final p in projectsResult.requireValue) {
            colors[p.id] = p.color;
          }
        }
        for (final entry in entriesResult.requireValue) {
          final end = entry.endTime ??
              entry.startTime.add(Duration(seconds: entry.durationSeconds));
          if (end.isBefore(from) || entry.startTime.isAfter(to)) continue;
          timeItems.add(
            CalendarItem(
              id: 'time:${entry.id}',
              source: CalendarItemSource.timeEntry,
              title: entry.notes?.trim().isNotEmpty == true
                  ? entry.notes!.trim()
                  : 'Tracked time',
              startAt: entry.startTime,
              endAt: end,
              allDay: false,
              color: colors[entry.projectId] ?? _timeColor,
              projectId: entry.projectId,
              taskId: entry.taskId,
            ),
          );
        }
      }

      return Success(
        mergeCalendarFeed(
          googleEvents: google.requireValue,
          tasks: taskItems,
          timeEntries: timeItems,
          includeGoogle: includeGoogle,
          includeTasks: includeTasks,
          includeTimeEntries: includeTimeEntries,
        ),
      );
    } catch (e) {
      return Err(UnexpectedFailure('Failed to build calendar feed', cause: e));
    }
  }
}
