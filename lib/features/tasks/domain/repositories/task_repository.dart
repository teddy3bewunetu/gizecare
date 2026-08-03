import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';

/// Contract for task persistence (list + CRUD used by tracker / global tasks).
abstract class TaskRepository {
  Stream<List<TaskItem>> watchTasks({
    String? projectId,
    bool includeArchived = false,
  });

  Future<Result<List<TaskItem>>> getTasks({
    String? projectId,
    bool includeArchived = false,
  });

  Future<Result<TaskItem?>> getById(String id);

  Future<Result<TaskItem>> create({
    required String projectId,
    required String name,
    String? description,
    String? columnId,
  });

  Future<Result<TaskItem>> update(TaskItem task);

  Future<Result<Unit>> delete(String id);
}
