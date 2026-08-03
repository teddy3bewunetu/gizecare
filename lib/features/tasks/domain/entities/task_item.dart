import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';

/// A task / Kanban card belonging to a project.
class TaskItem extends Equatable {
  const TaskItem({
    required this.id,
    required this.projectId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    this.description,
    this.columnId,
    this.priority = TaskPriority.none,
    this.dueAt,
    this.coverColor,
    this.archived = false,
  });

  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String? columnId;
  final int sortOrder;
  final TaskPriority priority;
  final DateTime? dueAt;
  final Color? coverColor;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskItem copyWith({
    String? name,
    String? description,
    String? columnId,
    int? sortOrder,
    TaskPriority? priority,
    DateTime? dueAt,
    Color? coverColor,
    bool? archived,
    DateTime? updatedAt,
    bool clearDueAt = false,
    bool clearCoverColor = false,
    bool clearColumnId = false,
  }) {
    return TaskItem(
      id: id,
      projectId: projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      columnId: clearColumnId ? null : columnId ?? this.columnId,
      sortOrder: sortOrder ?? this.sortOrder,
      priority: priority ?? this.priority,
      dueAt: clearDueAt ? null : dueAt ?? this.dueAt,
      coverColor: clearCoverColor ? null : coverColor ?? this.coverColor,
      archived: archived ?? this.archived,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        name,
        description,
        columnId,
        sortOrder,
        priority,
        dueAt,
        coverColor,
        archived,
        createdAt,
        updatedAt,
      ];
}
