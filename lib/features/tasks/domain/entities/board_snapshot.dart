import 'package:equatable/equatable.dart';

import 'package:gizecare/features/tasks/domain/entities/board_column.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';

/// Snapshot of a project's Kanban board.
class BoardSnapshot extends Equatable {
  const BoardSnapshot({
    required this.projectId,
    required this.columns,
    required this.tasksByColumn,
    this.labels = const [],
    this.labelIdsByTask = const {},
    this.checklistProgressByTask = const {},
    this.commentCountByTask = const {},
  });

  final String projectId;
  final List<BoardColumn> columns;
  final Map<String, List<TaskItem>> tasksByColumn;
  final List<ProjectLabel> labels;
  final Map<String, List<String>> labelIdsByTask;
  final Map<String, ({int done, int total})> checklistProgressByTask;
  final Map<String, int> commentCountByTask;

  List<TaskItem> tasksIn(String columnId) =>
      tasksByColumn[columnId] ?? const [];

  @override
  List<Object?> get props => [
        projectId,
        columns,
        tasksByColumn,
        labels,
        labelIdsByTask,
        checklistProgressByTask,
        commentCountByTask,
      ];
}
