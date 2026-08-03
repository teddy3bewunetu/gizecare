import 'package:equatable/equatable.dart';

/// Activity event types written for a task card.
abstract final class TaskActivityType {
  static const created = 'created';
  static const moved = 'moved';
  static const commented = 'commented';
  static const checklist = 'checklist';
  static const attachment = 'attachment';
  static const dueChanged = 'due_changed';
  static const updated = 'updated';
  static const archived = 'archived';
}

/// Activity / audit event for a task.
class TaskActivityEvent extends Equatable {
  const TaskActivityEvent({
    required this.id,
    required this.taskId,
    required this.type,
    required this.createdAt,
    this.payload,
  });

  final String id;
  final String taskId;
  final String type;
  final String? payload;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, taskId, type, payload, createdAt];
}
