import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A project-scoped label for Kanban cards.
class ProjectLabel extends Equatable {
  const ProjectLabel({
    required this.id,
    required this.projectId,
    required this.name,
    required this.color,
  });

  final String id;
  final String projectId;
  final String name;
  final Color color;

  ProjectLabel copyWith({String? name, Color? color}) {
    return ProjectLabel(
      id: id,
      projectId: projectId,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, projectId, name, color];
}
