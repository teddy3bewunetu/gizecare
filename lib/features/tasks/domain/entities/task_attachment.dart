import 'package:equatable/equatable.dart';

/// Local file attached to a Kanban card.
class TaskAttachment extends Equatable {
  const TaskAttachment({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.filePath,
    required this.byteSize,
    required this.createdAt,
    this.mimeType,
  });

  final String id;
  final String taskId;
  final String fileName;
  final String filePath;
  final String? mimeType;
  final int byteSize;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, taskId, fileName, filePath, mimeType, byteSize, createdAt];
}
