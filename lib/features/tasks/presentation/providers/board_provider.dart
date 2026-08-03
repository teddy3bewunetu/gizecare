import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/tasks/domain/entities/board_snapshot.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_attachment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_checklist.dart';
import 'package:gizecare/features/tasks/domain/entities/task_comment.dart';

/// Live Kanban board for a project.
final boardProvider =
    StreamProvider.family<BoardSnapshot, String>((ref, projectId) {
  return ref.watch(boardRepositoryProvider).watchBoard(projectId);
});

/// Board filter: selected label ids (empty = all).
final boardLabelFilterProvider =
    StateProvider.family<Set<String>, String>((ref, projectId) => {});

/// Board search query.
final boardSearchProvider =
    StateProvider.family<String, String>((ref, projectId) => '');

/// List vs board toggle on project detail.
final projectTasksViewModeProvider =
    StateProvider.family<ProjectTasksViewMode, String>(
  (ref, projectId) => ProjectTasksViewMode.board,
);

enum ProjectTasksViewMode { board, list }

final taskLabelsProvider =
    StreamProvider.family<List<ProjectLabel>, String>((ref, projectId) {
  return ref.watch(boardRepositoryProvider).watchLabels(projectId);
});

final taskChecklistsProvider =
    StreamProvider.family<List<TaskChecklist>, String>((ref, taskId) {
  return ref.watch(boardRepositoryProvider).watchChecklists(taskId);
});

final taskCommentsProvider =
    StreamProvider.family<List<TaskComment>, String>((ref, taskId) {
  return ref.watch(boardRepositoryProvider).watchComments(taskId);
});

final taskAttachmentsProvider =
    StreamProvider.family<List<TaskAttachment>, String>((ref, taskId) {
  return ref.watch(boardRepositoryProvider).watchAttachments(taskId);
});

final taskActivityProvider =
    StreamProvider.family<List<TaskActivityEvent>, String>((ref, taskId) {
  return ref.watch(boardRepositoryProvider).watchActivity(taskId);
});

final taskLabelIdsProvider =
    FutureProvider.family<List<String>, String>((ref, taskId) async {
  final result =
      await ref.watch(boardRepositoryProvider).getTaskLabelIds(taskId);
  return result.when(onSuccess: (v) => v, onFailure: (_) => const []);
});
