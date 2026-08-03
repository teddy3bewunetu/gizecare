import 'package:equatable/equatable.dart';

/// A column on a project's Kanban board.
class BoardColumn extends Equatable {
  const BoardColumn({
    required this.id,
    required this.projectId,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    this.wipLimit,
  });

  final String id;
  final String projectId;
  final String name;
  final int sortOrder;
  final int? wipLimit;
  final DateTime createdAt;

  BoardColumn copyWith({
    String? name,
    int? sortOrder,
    int? wipLimit,
    bool clearWipLimit = false,
  }) {
    return BoardColumn(
      id: id,
      projectId: projectId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      wipLimit: clearWipLimit ? null : wipLimit ?? this.wipLimit,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, projectId, name, sortOrder, wipLimit, createdAt];
}
