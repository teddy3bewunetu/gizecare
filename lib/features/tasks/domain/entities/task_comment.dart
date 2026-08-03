import 'package:equatable/equatable.dart';

/// Comment on a Kanban card.
class TaskComment extends Equatable {
  const TaskComment({
    required this.id,
    required this.taskId,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String taskId;
  final String body;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, taskId, body, createdAt];
}
