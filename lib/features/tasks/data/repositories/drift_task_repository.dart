import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tasks/domain/repositories/task_repository.dart';

/// Drift-backed [TaskRepository].
class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<TaskItem>> watchTasks({
    String? projectId,
    bool includeArchived = false,
  }) {
    final query = _db.select(_db.tasks)
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    return query.watch().map((rows) => rows.map(DatabaseMappers.task).toList());
  }

  @override
  Future<Result<List<TaskItem>>> getTasks({
    String? projectId,
    bool includeArchived = false,
  }) async {
    try {
      final query = _db.select(_db.tasks)
        ..orderBy([
          (t) => OrderingTerm.asc(t.sortOrder),
          (t) => OrderingTerm.desc(t.createdAt),
        ]);
      if (projectId != null) {
        query.where((t) => t.projectId.equals(projectId));
      }
      if (!includeArchived) {
        query.where((t) => t.archived.equals(false));
      }
      final rows = await query.get();
      return Success(rows.map(DatabaseMappers.task).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load tasks', cause: e));
    }
  }

  @override
  Future<Result<TaskItem?>> getById(String id) async {
    try {
      final row = await (_db.select(_db.tasks)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.task(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load task', cause: e));
    }
  }

  Future<String?> _resolveColumnId(String projectId, String? columnId) async {
    if (columnId != null) return columnId;
    final cols = await (_db.select(_db.boardColumns)
          ..where((c) => c.projectId.equals(projectId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
    if (cols.isEmpty) return null;
    final todo = cols.where((c) => c.name == BoardDefaults.todo);
    return todo.isNotEmpty ? todo.first.id : cols.first.id;
  }

  Future<int> _nextSortOrder(String columnId) async {
    final rows = await (_db.select(_db.tasks)
          ..where((t) => t.columnId.equals(columnId)))
        .get();
    if (rows.isEmpty) return 0;
    return rows.map((r) => r.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  Future<Result<TaskItem>> create({
    required String projectId,
    required String name,
    String? description,
    String? columnId,
  }) async {
    try {
      final resolvedColumn = await _resolveColumnId(projectId, columnId);
      final now = DateTime.now();
      final sort = resolvedColumn == null
          ? 0
          : await _nextSortOrder(resolvedColumn);
      final task = TaskItem(
        id: _uuid.v4(),
        projectId: projectId,
        name: name.trim(),
        description: description?.trim(),
        columnId: resolvedColumn,
        sortOrder: sort,
        priority: TaskPriority.none,
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.tasks).insert(
            TasksCompanion.insert(
              id: task.id,
              projectId: task.projectId,
              name: task.name,
              description: Value(task.description),
              columnId: Value(task.columnId),
              sortOrder: Value(task.sortOrder),
              priority: Value(task.priority.storage),
              createdAt: task.createdAt,
              updatedAt: Value(task.updatedAt),
            ),
          );
      await _db.into(_db.taskActivity).insert(
            TaskActivityCompanion.insert(
              id: _uuid.v4(),
              taskId: task.id,
              type: TaskActivityType.created,
              createdAt: now,
            ),
          );
      return Success(task);
    } catch (e) {
      return Err(CacheFailure('Failed to create task', cause: e));
    }
  }

  @override
  Future<Result<TaskItem>> update(TaskItem task) async {
    try {
      final updated = task.copyWith(updatedAt: DateTime.now());
      await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id))).write(
        TasksCompanion(
          name: Value(updated.name),
          description: Value(updated.description),
          columnId: Value(updated.columnId),
          sortOrder: Value(updated.sortOrder),
          priority: Value(updated.priority.storage),
          dueAt: Value(updated.dueAt),
          coverColor: Value(updated.coverColor?.toARGB32()),
          archived: Value(updated.archived),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update task', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.update(_db.timeEntries)..where((t) => t.taskId.equals(id)))
          .write(const TimeEntriesCompanion(taskId: Value(null)));
      await (_db.delete(_db.taskLabelLinks)..where((t) => t.taskId.equals(id)))
          .go();
      final checklists = await (_db.select(_db.taskChecklists)
            ..where((c) => c.taskId.equals(id)))
          .get();
      for (final c in checklists) {
        await (_db.delete(_db.taskChecklistItems)
              ..where((i) => i.checklistId.equals(c.id)))
            .go();
      }
      await (_db.delete(_db.taskChecklists)..where((c) => c.taskId.equals(id)))
          .go();
      await (_db.delete(_db.taskComments)..where((c) => c.taskId.equals(id)))
          .go();
      await (_db.delete(_db.taskAttachments)..where((a) => a.taskId.equals(id)))
          .go();
      await (_db.delete(_db.taskActivity)..where((a) => a.taskId.equals(id)))
          .go();
      await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete task', cause: e));
    }
  }
}
