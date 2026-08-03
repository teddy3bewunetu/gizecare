import 'package:flutter/material.dart';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/entities/board_column.dart';
import 'package:gizecare/features/tasks/domain/entities/board_snapshot.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_attachment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_checklist.dart';
import 'package:gizecare/features/tasks/domain/entities/task_comment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';

/// Contract for Kanban board + rich task card persistence.
abstract class BoardRepository {
  Stream<BoardSnapshot> watchBoard(String projectId);

  Future<Result<BoardSnapshot>> getBoard(String projectId);

  Future<Result<Unit>> seedDefaultColumns(String projectId);

  Future<Result<BoardColumn>> createColumn({
    required String projectId,
    required String name,
    int? wipLimit,
  });

  Future<Result<BoardColumn>> updateColumn(BoardColumn column);

  Future<Result<Unit>> reorderColumns(String projectId, List<String> orderedIds);

  Future<Result<Unit>> deleteColumn(String columnId, {String? moveTasksToColumnId});

  Future<Result<TaskItem>> createCard({
    required String projectId,
    required String columnId,
    required String name,
    String? description,
  });

  Future<Result<TaskItem>> updateCard(TaskItem task);

  Future<Result<Unit>> moveTask({
    required String taskId,
    required String toColumnId,
    required int toIndex,
  });

  Future<Result<Unit>> archiveTask(String taskId, {bool archived = true});

  Future<Result<Unit>> deleteTask(String taskId);

  // Labels
  Stream<List<ProjectLabel>> watchLabels(String projectId);

  Future<Result<ProjectLabel>> createLabel({
    required String projectId,
    required String name,
    required Color color,
  });

  Future<Result<ProjectLabel>> updateLabel(ProjectLabel label);

  Future<Result<Unit>> deleteLabel(String labelId);

  Future<Result<Unit>> setTaskLabels(String taskId, List<String> labelIds);

  Future<Result<List<String>>> getTaskLabelIds(String taskId);

  // Checklists
  Stream<List<TaskChecklist>> watchChecklists(String taskId);

  Future<Result<TaskChecklist>> createChecklist({
    required String taskId,
    required String title,
  });

  Future<Result<Unit>> deleteChecklist(String checklistId);

  Future<Result<TaskChecklistItem>> addChecklistItem({
    required String checklistId,
    required String title,
  });

  Future<Result<TaskChecklistItem>> updateChecklistItem(TaskChecklistItem item);

  Future<Result<Unit>> deleteChecklistItem(String itemId);

  // Comments
  Stream<List<TaskComment>> watchComments(String taskId);

  Future<Result<TaskComment>> addComment({
    required String taskId,
    required String body,
  });

  Future<Result<Unit>> deleteComment(String commentId);

  // Attachments
  Stream<List<TaskAttachment>> watchAttachments(String taskId);

  Future<Result<TaskAttachment>> addAttachment({
    required String taskId,
    required String fileName,
    required String filePath,
    String? mimeType,
    required int byteSize,
  });

  Future<Result<Unit>> deleteAttachment(String attachmentId);

  // Activity
  Stream<List<TaskActivityEvent>> watchActivity(String taskId);

  Future<Result<Unit>> logActivity({
    required String taskId,
    required String type,
    String? payload,
  });

  Future<Result<TaskItem>> setCardMeta({
    required String taskId,
    TaskPriority? priority,
    DateTime? dueAt,
    bool clearDueAt = false,
    Color? coverColor,
    bool clearCoverColor = false,
  });
}
