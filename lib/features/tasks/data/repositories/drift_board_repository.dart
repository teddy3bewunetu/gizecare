import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';
import 'package:gizecare/features/tasks/domain/entities/board_column.dart';
import 'package:gizecare/features/tasks/domain/entities/board_snapshot.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_attachment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_checklist.dart';
import 'package:gizecare/features/tasks/domain/entities/task_comment.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tasks/domain/repositories/board_repository.dart';

/// Drift-backed [BoardRepository].
class DriftBoardRepository implements BoardRepository {
  DriftBoardRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  Future<void> _log(
    String taskId,
    String type, {
    String? payload,
  }) async {
    await _db.into(_db.taskActivity).insert(
          TaskActivityCompanion.insert(
            id: _uuid.v4(),
            taskId: taskId,
            type: type,
            payload: Value(payload),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<BoardSnapshot> _buildSnapshot(String projectId) async {
    final columnRows = await (_db.select(_db.boardColumns)
          ..where((c) => c.projectId.equals(projectId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
    final columns = columnRows.map(DatabaseMappers.boardColumn).toList();

    final taskRows = await (_db.select(_db.tasks)
          ..where(
            (t) =>
                t.projectId.equals(projectId) & t.archived.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final tasks = taskRows.map(DatabaseMappers.task).toList();

    final tasksByColumn = <String, List<TaskItem>>{
      for (final c in columns) c.id: <TaskItem>[],
    };
    for (final task in tasks) {
      final colId = task.columnId;
      if (colId != null && tasksByColumn.containsKey(colId)) {
        tasksByColumn[colId]!.add(task);
      } else if (columns.isNotEmpty) {
        tasksByColumn[columns.first.id]!.add(task);
      }
    }

    final labelRows = await (_db.select(_db.projectLabels)
          ..where((l) => l.projectId.equals(projectId)))
        .get();
    final labels = labelRows.map(DatabaseMappers.projectLabel).toList();

    final taskIds = tasks.map((t) => t.id).toList();
    final labelIdsByTask = <String, List<String>>{};
    final checklistProgress = <String, ({int done, int total})>{};
    final commentCounts = <String, int>{};

    if (taskIds.isNotEmpty) {
      final links = await (_db.select(_db.taskLabelLinks)
            ..where((l) => l.taskId.isIn(taskIds)))
          .get();
      for (final link in links) {
        labelIdsByTask
            .putIfAbsent(link.taskId, () => <String>[])
            .add(link.labelId);
      }

      final checklists = await (_db.select(_db.taskChecklists)
            ..where((c) => c.taskId.isIn(taskIds)))
          .get();
      final checklistIds = checklists.map((c) => c.id).toList();
      final items = checklistIds.isEmpty
          ? <TaskChecklistItemRow>[]
          : await (_db.select(_db.taskChecklistItems)
                ..where((i) => i.checklistId.isIn(checklistIds)))
              .get();
      final itemsByChecklist = <String, List<TaskChecklistItemRow>>{};
      for (final item in items) {
        itemsByChecklist
            .putIfAbsent(item.checklistId, () => [])
            .add(item);
      }
      final progressByTask = <String, List<TaskChecklistItemRow>>{};
      for (final c in checklists) {
        progressByTask
            .putIfAbsent(c.taskId, () => [])
            .addAll(itemsByChecklist[c.id] ?? const []);
      }
      for (final entry in progressByTask.entries) {
        final total = entry.value.length;
        final done = entry.value.where((i) => i.done).length;
        checklistProgress[entry.key] = (done: done, total: total);
      }

      final comments = await (_db.select(_db.taskComments)
            ..where((c) => c.taskId.isIn(taskIds)))
          .get();
      for (final c in comments) {
        commentCounts[c.taskId] = (commentCounts[c.taskId] ?? 0) + 1;
      }
    }

    return BoardSnapshot(
      projectId: projectId,
      columns: columns,
      tasksByColumn: tasksByColumn,
      labels: labels,
      labelIdsByTask: labelIdsByTask,
      checklistProgressByTask: checklistProgress,
      commentCountByTask: commentCounts,
    );
  }

  @override
  Stream<BoardSnapshot> watchBoard(String projectId) {
    return Stream.multi((listener) async {
      await seedDefaultColumns(projectId);

      Future<void> push() async {
        if (listener.isClosed) return;
        try {
          listener.add(await _buildSnapshot(projectId));
        } catch (e, st) {
          listener.addError(e, st);
        }
      }

      await push();

      // tasks.watch() is the reliable trigger for card moves/creates.
      final taskSub = (_db.select(_db.tasks)
            ..where((t) => t.projectId.equals(projectId)))
          .watch()
          .listen((_) => push());
      final colSub = (_db.select(_db.boardColumns)
            ..where((c) => c.projectId.equals(projectId)))
          .watch()
          .listen((_) => push());
      final labelSub = (_db.select(_db.projectLabels)
            ..where((l) => l.projectId.equals(projectId)))
          .watch()
          .listen((_) => push());
      final linkSub = _db.select(_db.taskLabelLinks).watch().listen((_) => push());
      final checklistSub =
          _db.select(_db.taskChecklists).watch().listen((_) => push());
      final itemSub =
          _db.select(_db.taskChecklistItems).watch().listen((_) => push());
      final commentSub =
          _db.select(_db.taskComments).watch().listen((_) => push());

      listener.onCancel = () async {
        await taskSub.cancel();
        await colSub.cancel();
        await labelSub.cancel();
        await linkSub.cancel();
        await checklistSub.cancel();
        await itemSub.cancel();
        await commentSub.cancel();
      };
    });
  }

  @override
  Future<Result<BoardSnapshot>> getBoard(String projectId) async {
    try {
      await seedDefaultColumns(projectId);
      return Success(await _buildSnapshot(projectId));
    } catch (e) {
      return Err(CacheFailure('Failed to load board', cause: e));
    }
  }

  @override
  Future<Result<Unit>> seedDefaultColumns(String projectId) async {
    try {
      final existing = await (_db.select(_db.boardColumns)
            ..where((c) => c.projectId.equals(projectId)))
          .get();
      if (existing.isNotEmpty) return const Success(unit);

      final now = DateTime.now();
      for (var i = 0; i < BoardDefaults.columnNames.length; i++) {
        await _db.into(_db.boardColumns).insert(
              BoardColumnsCompanion.insert(
                id: _uuid.v4(),
                projectId: projectId,
                name: BoardDefaults.columnNames[i],
                sortOrder: Value(i),
                createdAt: now,
              ),
            );
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to seed columns', cause: e));
    }
  }

  @override
  Future<Result<BoardColumn>> createColumn({
    required String projectId,
    required String name,
    int? wipLimit,
  }) async {
    try {
      final existing = await (_db.select(_db.boardColumns)
            ..where((c) => c.projectId.equals(projectId)))
          .get();
      final order = existing.isEmpty
          ? 0
          : existing.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;
      final column = BoardColumn(
        id: _uuid.v4(),
        projectId: projectId,
        name: name.trim(),
        sortOrder: order,
        wipLimit: wipLimit,
        createdAt: DateTime.now(),
      );
      await _db.into(_db.boardColumns).insert(
            BoardColumnsCompanion.insert(
              id: column.id,
              projectId: column.projectId,
              name: column.name,
              sortOrder: Value(column.sortOrder),
              wipLimit: Value(column.wipLimit),
              createdAt: column.createdAt,
            ),
          );
      return Success(column);
    } catch (e) {
      return Err(CacheFailure('Failed to create column', cause: e));
    }
  }

  @override
  Future<Result<BoardColumn>> updateColumn(BoardColumn column) async {
    try {
      await (_db.update(_db.boardColumns)
            ..where((c) => c.id.equals(column.id)))
          .write(
        BoardColumnsCompanion(
          name: Value(column.name),
          sortOrder: Value(column.sortOrder),
          wipLimit: Value(column.wipLimit),
        ),
      );
      return Success(column);
    } catch (e) {
      return Err(CacheFailure('Failed to update column', cause: e));
    }
  }

  @override
  Future<Result<Unit>> reorderColumns(
    String projectId,
    List<String> orderedIds,
  ) async {
    try {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.boardColumns)
              ..where((c) => c.id.equals(orderedIds[i])))
            .write(BoardColumnsCompanion(sortOrder: Value(i)));
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to reorder columns', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteColumn(
    String columnId, {
    String? moveTasksToColumnId,
  }) async {
    try {
      final tasks = await (_db.select(_db.tasks)
            ..where((t) => t.columnId.equals(columnId)))
          .get();
      if (moveTasksToColumnId != null) {
        final dest = await (_db.select(_db.tasks)
              ..where((t) => t.columnId.equals(moveTasksToColumnId)))
            .get();
        var order = dest.isEmpty
            ? 0
            : dest.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
        for (final t in tasks) {
          await (_db.update(_db.tasks)..where((x) => x.id.equals(t.id))).write(
            TasksCompanion(
              columnId: Value(moveTasksToColumnId),
              sortOrder: Value(order++),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      } else if (tasks.isNotEmpty) {
        return Err(
          CacheFailure('Column has cards; move them before deleting'),
        );
      }
      await (_db.delete(_db.boardColumns)..where((c) => c.id.equals(columnId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete column', cause: e));
    }
  }

  @override
  Future<Result<TaskItem>> createCard({
    required String projectId,
    required String columnId,
    required String name,
    String? description,
  }) async {
    try {
      final existing = await (_db.select(_db.tasks)
            ..where((t) => t.columnId.equals(columnId)))
          .get();
      final sort = existing.isEmpty
          ? 0
          : existing.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;
      final now = DateTime.now();
      final task = TaskItem(
        id: _uuid.v4(),
        projectId: projectId,
        name: name.trim(),
        description: description?.trim(),
        columnId: columnId,
        sortOrder: sort,
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
              createdAt: task.createdAt,
              updatedAt: Value(task.updatedAt),
            ),
          );
      await _log(task.id, TaskActivityType.created);
      return Success(task);
    } catch (e) {
      return Err(CacheFailure('Failed to create card', cause: e));
    }
  }

  @override
  Future<Result<TaskItem>> updateCard(TaskItem task) async {
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
      await _log(task.id, TaskActivityType.updated);
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update card', cause: e));
    }
  }

  @override
  Future<Result<Unit>> moveTask({
    required String taskId,
    required String toColumnId,
    required int toIndex,
  }) async {
    try {
      final task = await (_db.select(_db.tasks)
            ..where((t) => t.id.equals(taskId)))
          .getSingleOrNull();
      if (task == null) {
        return Err(CacheFailure('Task not found'));
      }
      final fromColumnId = task.columnId;

      final destRows = await (_db.select(_db.tasks)
            ..where(
              (t) =>
                  t.columnId.equals(toColumnId) &
                  t.id.equals(taskId).not() &
                  t.archived.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

      final ordered = [...destRows.map(DatabaseMappers.task)];
      final clamped = toIndex.clamp(0, ordered.length);
      ordered.insert(clamped, DatabaseMappers.task(task));

      for (var i = 0; i < ordered.length; i++) {
        await (_db.update(_db.tasks)..where((t) => t.id.equals(ordered[i].id)))
            .write(
          TasksCompanion(
            columnId: Value(toColumnId),
            sortOrder: Value(i),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      if (fromColumnId != null && fromColumnId != toColumnId) {
        final remaining = await (_db.select(_db.tasks)
              ..where(
                (t) =>
                    t.columnId.equals(fromColumnId) & t.archived.equals(false),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();
        for (var i = 0; i < remaining.length; i++) {
          await (_db.update(_db.tasks)
                ..where((t) => t.id.equals(remaining[i].id)))
              .write(TasksCompanion(sortOrder: Value(i)));
        }
        await _log(
          taskId,
          TaskActivityType.moved,
          payload: '$fromColumnId->$toColumnId',
        );
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to move task', cause: e));
    }
  }

  @override
  Future<Result<Unit>> archiveTask(String taskId, {bool archived = true}) async {
    try {
      await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        TasksCompanion(
          archived: Value(archived),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _log(taskId, TaskActivityType.archived, payload: '$archived');
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to archive task', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteTask(String taskId) async {
    try {
      await (_db.update(_db.timeEntries)
            ..where((t) => t.taskId.equals(taskId)))
          .write(const TimeEntriesCompanion(taskId: Value(null)));
      await (_db.delete(_db.taskLabelLinks)
            ..where((t) => t.taskId.equals(taskId)))
          .go();
      final checklists = await (_db.select(_db.taskChecklists)
            ..where((c) => c.taskId.equals(taskId)))
          .get();
      for (final c in checklists) {
        await (_db.delete(_db.taskChecklistItems)
              ..where((i) => i.checklistId.equals(c.id)))
            .go();
      }
      await (_db.delete(_db.taskChecklists)
            ..where((c) => c.taskId.equals(taskId)))
          .go();
      await (_db.delete(_db.taskComments)
            ..where((c) => c.taskId.equals(taskId)))
          .go();
      await (_db.delete(_db.taskAttachments)
            ..where((a) => a.taskId.equals(taskId)))
          .go();
      await (_db.delete(_db.taskActivity)
            ..where((a) => a.taskId.equals(taskId)))
          .go();
      await (_db.delete(_db.tasks)..where((t) => t.id.equals(taskId))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete task', cause: e));
    }
  }

  @override
  Stream<List<ProjectLabel>> watchLabels(String projectId) {
    return (_db.select(_db.projectLabels)
          ..where((l) => l.projectId.equals(projectId)))
        .watch()
        .map((rows) => rows.map(DatabaseMappers.projectLabel).toList());
  }

  @override
  Future<Result<ProjectLabel>> createLabel({
    required String projectId,
    required String name,
    required Color color,
  }) async {
    try {
      final label = ProjectLabel(
        id: _uuid.v4(),
        projectId: projectId,
        name: name.trim(),
        color: color,
      );
      await _db.into(_db.projectLabels).insert(
            ProjectLabelsCompanion.insert(
              id: label.id,
              projectId: label.projectId,
              name: label.name,
              color: label.color.toARGB32(),
            ),
          );
      return Success(label);
    } catch (e) {
      return Err(CacheFailure('Failed to create label', cause: e));
    }
  }

  @override
  Future<Result<ProjectLabel>> updateLabel(ProjectLabel label) async {
    try {
      await (_db.update(_db.projectLabels)
            ..where((l) => l.id.equals(label.id)))
          .write(
        ProjectLabelsCompanion(
          name: Value(label.name),
          color: Value(label.color.toARGB32()),
        ),
      );
      return Success(label);
    } catch (e) {
      return Err(CacheFailure('Failed to update label', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteLabel(String labelId) async {
    try {
      await (_db.delete(_db.taskLabelLinks)
            ..where((l) => l.labelId.equals(labelId)))
          .go();
      await (_db.delete(_db.projectLabels)..where((l) => l.id.equals(labelId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete label', cause: e));
    }
  }

  @override
  Future<Result<Unit>> setTaskLabels(
    String taskId,
    List<String> labelIds,
  ) async {
    try {
      await (_db.delete(_db.taskLabelLinks)
            ..where((l) => l.taskId.equals(taskId)))
          .go();
      for (final id in labelIds) {
        await _db.into(_db.taskLabelLinks).insert(
              TaskLabelLinksCompanion.insert(taskId: taskId, labelId: id),
            );
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to set labels', cause: e));
    }
  }

  @override
  Future<Result<List<String>>> getTaskLabelIds(String taskId) async {
    try {
      final rows = await (_db.select(_db.taskLabelLinks)
            ..where((l) => l.taskId.equals(taskId)))
          .get();
      return Success(rows.map((r) => r.labelId).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load labels', cause: e));
    }
  }

  @override
  Stream<List<TaskChecklist>> watchChecklists(String taskId) {
    return (_db.select(_db.taskChecklists)
          ..where((c) => c.taskId.equals(taskId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch()
        .asyncMap((rows) async {
      final result = <TaskChecklist>[];
      for (final row in rows) {
        final items = await (_db.select(_db.taskChecklistItems)
              ..where((i) => i.checklistId.equals(row.id))
              ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
            .get();
        result.add(
          DatabaseMappers.checklist(
            row,
            items.map(DatabaseMappers.checklistItem).toList(),
          ),
        );
      }
      return result;
    });
  }

  @override
  Future<Result<TaskChecklist>> createChecklist({
    required String taskId,
    required String title,
  }) async {
    try {
      final existing = await (_db.select(_db.taskChecklists)
            ..where((c) => c.taskId.equals(taskId)))
          .get();
      final order = existing.length;
      final checklist = TaskChecklist(
        id: _uuid.v4(),
        taskId: taskId,
        title: title.trim(),
        sortOrder: order,
      );
      await _db.into(_db.taskChecklists).insert(
            TaskChecklistsCompanion.insert(
              id: checklist.id,
              taskId: checklist.taskId,
              title: checklist.title,
              sortOrder: Value(checklist.sortOrder),
            ),
          );
      await _log(taskId, TaskActivityType.checklist, payload: 'created');
      return Success(checklist);
    } catch (e) {
      return Err(CacheFailure('Failed to create checklist', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteChecklist(String checklistId) async {
    try {
      await (_db.delete(_db.taskChecklistItems)
            ..where((i) => i.checklistId.equals(checklistId)))
          .go();
      await (_db.delete(_db.taskChecklists)
            ..where((c) => c.id.equals(checklistId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete checklist', cause: e));
    }
  }

  @override
  Future<Result<TaskChecklistItem>> addChecklistItem({
    required String checklistId,
    required String title,
  }) async {
    try {
      final existing = await (_db.select(_db.taskChecklistItems)
            ..where((i) => i.checklistId.equals(checklistId)))
          .get();
      final item = TaskChecklistItem(
        id: _uuid.v4(),
        checklistId: checklistId,
        title: title.trim(),
        done: false,
        sortOrder: existing.length,
      );
      await _db.into(_db.taskChecklistItems).insert(
            TaskChecklistItemsCompanion.insert(
              id: item.id,
              checklistId: item.checklistId,
              title: item.title,
              done: Value(item.done),
              sortOrder: Value(item.sortOrder),
            ),
          );
      return Success(item);
    } catch (e) {
      return Err(CacheFailure('Failed to add checklist item', cause: e));
    }
  }

  @override
  Future<Result<TaskChecklistItem>> updateChecklistItem(
    TaskChecklistItem item,
  ) async {
    try {
      await (_db.update(_db.taskChecklistItems)
            ..where((i) => i.id.equals(item.id)))
          .write(
        TaskChecklistItemsCompanion(
          title: Value(item.title),
          done: Value(item.done),
          sortOrder: Value(item.sortOrder),
        ),
      );
      return Success(item);
    } catch (e) {
      return Err(CacheFailure('Failed to update checklist item', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteChecklistItem(String itemId) async {
    try {
      await (_db.delete(_db.taskChecklistItems)
            ..where((i) => i.id.equals(itemId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete checklist item', cause: e));
    }
  }

  @override
  Stream<List<TaskComment>> watchComments(String taskId) {
    return (_db.select(_db.taskComments)
          ..where((c) => c.taskId.equals(taskId))
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .watch()
        .map((rows) => rows.map(DatabaseMappers.comment).toList());
  }

  @override
  Future<Result<TaskComment>> addComment({
    required String taskId,
    required String body,
  }) async {
    try {
      final comment = TaskComment(
        id: _uuid.v4(),
        taskId: taskId,
        body: body.trim(),
        createdAt: DateTime.now(),
      );
      await _db.into(_db.taskComments).insert(
            TaskCommentsCompanion.insert(
              id: comment.id,
              taskId: comment.taskId,
              body: comment.body,
              createdAt: comment.createdAt,
            ),
          );
      await _log(taskId, TaskActivityType.commented);
      return Success(comment);
    } catch (e) {
      return Err(CacheFailure('Failed to add comment', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteComment(String commentId) async {
    try {
      await (_db.delete(_db.taskComments)..where((c) => c.id.equals(commentId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete comment', cause: e));
    }
  }

  @override
  Stream<List<TaskAttachment>> watchAttachments(String taskId) {
    return (_db.select(_db.taskAttachments)
          ..where((a) => a.taskId.equals(taskId))
          ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
        .watch()
        .map((rows) => rows.map(DatabaseMappers.attachment).toList());
  }

  @override
  Future<Result<TaskAttachment>> addAttachment({
    required String taskId,
    required String fileName,
    required String filePath,
    String? mimeType,
    required int byteSize,
  }) async {
    try {
      final attachment = TaskAttachment(
        id: _uuid.v4(),
        taskId: taskId,
        fileName: fileName,
        filePath: filePath,
        mimeType: mimeType,
        byteSize: byteSize,
        createdAt: DateTime.now(),
      );
      await _db.into(_db.taskAttachments).insert(
            TaskAttachmentsCompanion.insert(
              id: attachment.id,
              taskId: attachment.taskId,
              fileName: attachment.fileName,
              filePath: attachment.filePath,
              mimeType: Value(attachment.mimeType),
              byteSize: Value(attachment.byteSize),
              createdAt: attachment.createdAt,
            ),
          );
      await _log(
        taskId,
        TaskActivityType.attachment,
        payload: fileName,
      );
      return Success(attachment);
    } catch (e) {
      return Err(CacheFailure('Failed to add attachment', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteAttachment(String attachmentId) async {
    try {
      await (_db.delete(_db.taskAttachments)
            ..where((a) => a.id.equals(attachmentId)))
          .go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete attachment', cause: e));
    }
  }

  @override
  Stream<List<TaskActivityEvent>> watchActivity(String taskId) {
    return (_db.select(_db.taskActivity)
          ..where((a) => a.taskId.equals(taskId))
          ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
        .watch()
        .map((rows) => rows.map(DatabaseMappers.activity).toList());
  }

  @override
  Future<Result<Unit>> logActivity({
    required String taskId,
    required String type,
    String? payload,
  }) async {
    try {
      await _log(taskId, type, payload: payload);
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to log activity', cause: e));
    }
  }

  @override
  Future<Result<TaskItem>> setCardMeta({
    required String taskId,
    TaskPriority? priority,
    DateTime? dueAt,
    bool clearDueAt = false,
    Color? coverColor,
    bool clearCoverColor = false,
  }) async {
    try {
      final row = await (_db.select(_db.tasks)..where((t) => t.id.equals(taskId)))
          .getSingleOrNull();
      if (row == null) return Err(CacheFailure('Task not found'));
      final current = DatabaseMappers.task(row);
      final updated = current.copyWith(
        priority: priority,
        dueAt: dueAt,
        clearDueAt: clearDueAt,
        coverColor: coverColor,
        clearCoverColor: clearCoverColor,
        updatedAt: DateTime.now(),
      );
      await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        TasksCompanion(
          priority: Value(updated.priority.storage),
          dueAt: Value(updated.dueAt),
          coverColor: Value(updated.coverColor?.toARGB32()),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      if (clearDueAt || dueAt != null) {
        await _log(taskId, TaskActivityType.dueChanged);
      }
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update card meta', cause: e));
    }
  }
}
