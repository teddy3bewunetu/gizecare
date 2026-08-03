import 'package:flutter/material.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/features/clock/domain/entities/alarm_item.dart';
import 'package:gizecare/features/clock/domain/entities/stopwatch_lap.dart';
import 'package:gizecare/features/notebook/domain/entities/note.dart';
import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/notebook/domain/entities/notebook.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/tasks/domain/entities/board_column.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_attachment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_checklist.dart';
import 'package:gizecare/features/tasks/domain/entities/task_comment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Maps Drift rows to domain entities.
abstract final class DatabaseMappers {
  static Project project(ProjectRow row) {
    return Project(
      id: row.id,
      name: row.name,
      color: Color(row.color),
      archived: row.archived,
      clientName: row.clientName,
      description: row.description,
      hourlyRate: row.hourlyRate,
      weeklyLimitHours: row.weeklyLimitHours,
      contractType: row.contractType,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static BoardColumn boardColumn(BoardColumnRow row) {
    return BoardColumn(
      id: row.id,
      projectId: row.projectId,
      name: row.name,
      sortOrder: row.sortOrder,
      wipLimit: row.wipLimit,
      createdAt: row.createdAt,
    );
  }

  static TaskItem task(TaskRow row) {
    return TaskItem(
      id: row.id,
      projectId: row.projectId,
      name: row.name,
      description: row.description,
      columnId: row.columnId,
      sortOrder: row.sortOrder,
      priority: TaskPriority.fromStorage(row.priority),
      dueAt: row.dueAt,
      coverColor: row.coverColor == null ? null : Color(row.coverColor!),
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static ProjectLabel projectLabel(ProjectLabelRow row) {
    return ProjectLabel(
      id: row.id,
      projectId: row.projectId,
      name: row.name,
      color: Color(row.color),
    );
  }

  static TaskChecklist checklist(
    TaskChecklistRow row, [
    List<TaskChecklistItem> items = const [],
  ]) {
    return TaskChecklist(
      id: row.id,
      taskId: row.taskId,
      title: row.title,
      sortOrder: row.sortOrder,
      items: items,
    );
  }

  static TaskChecklistItem checklistItem(TaskChecklistItemRow row) {
    return TaskChecklistItem(
      id: row.id,
      checklistId: row.checklistId,
      title: row.title,
      done: row.done,
      sortOrder: row.sortOrder,
    );
  }

  static TaskComment comment(TaskCommentRow row) {
    return TaskComment(
      id: row.id,
      taskId: row.taskId,
      body: row.body,
      createdAt: row.createdAt,
    );
  }

  static TaskAttachment attachment(TaskAttachmentRow row) {
    return TaskAttachment(
      id: row.id,
      taskId: row.taskId,
      fileName: row.fileName,
      filePath: row.filePath,
      mimeType: row.mimeType,
      byteSize: row.byteSize,
      createdAt: row.createdAt,
    );
  }

  static TaskActivityEvent activity(TaskActivityRow row) {
    return TaskActivityEvent(
      id: row.id,
      taskId: row.taskId,
      type: row.type,
      payload: row.payload,
      createdAt: row.createdAt,
    );
  }

  static TimeEntry timeEntry(TimeEntryRow row) {
    return TimeEntry(
      id: row.id,
      projectId: row.projectId,
      taskId: row.taskId,
      startTime: row.startTime,
      endTime: row.endTime,
      durationSeconds: row.durationSeconds,
      activityPercentage: row.activityPercentage,
      isManual: row.isManual,
      notes: row.notes,
    );
  }

  static ScreenshotItem screenshot(ScreenshotRow row) {
    return ScreenshotItem(
      id: row.id,
      timeEntryId: row.timeEntryId,
      filePath: row.filePath,
      takenAt: row.takenAt,
    );
  }

  static AlarmItem alarm(AlarmRow row) {
    return AlarmItem(
      id: row.id,
      label: row.label,
      hour: row.hour,
      minute: row.minute,
      enabled: row.enabled,
      repeatDays: row.repeatDays,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static StopwatchLap stopwatchLap(StopwatchLapRow row) {
    return StopwatchLap(
      id: row.id,
      sessionId: row.sessionId,
      lapIndex: row.lapIndex,
      lapMs: row.lapMs,
      totalMs: row.totalMs,
      createdAt: row.createdAt,
    );
  }

  static Notebook notebook(NotebookRow row) {
    return Notebook(
      id: row.id,
      name: row.name,
      coverColor: Color(row.coverColor),
      coverImagePath: row.coverImagePath,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static Note note(NoteRow row) {
    return Note(
      id: row.id,
      notebookId: row.notebookId,
      title: row.title,
      body: row.body,
      noteType: NoteType.fromStorage(row.noteType),
      color: Color(row.color),
      isPinned: row.isPinned,
      isFavorite: row.isFavorite,
      isLocked: row.isLocked,
      projectId: row.projectId,
      taskId: row.taskId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
