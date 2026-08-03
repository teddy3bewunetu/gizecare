import 'package:equatable/equatable.dart';

/// Checklist group on a task.
class TaskChecklist extends Equatable {
  const TaskChecklist({
    required this.id,
    required this.taskId,
    required this.title,
    required this.sortOrder,
    this.items = const [],
  });

  final String id;
  final String taskId;
  final String title;
  final int sortOrder;
  final List<TaskChecklistItem> items;

  int get doneCount => items.where((i) => i.done).length;
  int get totalCount => items.length;

  TaskChecklist copyWith({
    String? title,
    int? sortOrder,
    List<TaskChecklistItem>? items,
  }) {
    return TaskChecklist(
      id: id,
      taskId: taskId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, taskId, title, sortOrder, items];
}

/// Single checklist row.
class TaskChecklistItem extends Equatable {
  const TaskChecklistItem({
    required this.id,
    required this.checklistId,
    required this.title,
    required this.done,
    required this.sortOrder,
  });

  final String id;
  final String checklistId;
  final String title;
  final bool done;
  final int sortOrder;

  TaskChecklistItem copyWith({
    String? title,
    bool? done,
    int? sortOrder,
  }) {
    return TaskChecklistItem(
      id: id,
      checklistId: checklistId,
      title: title ?? this.title,
      done: done ?? this.done,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [id, checklistId, title, done, sortOrder];
}
