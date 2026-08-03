import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/sqlite_setup.dart';
import 'package:gizecare/features/projects/data/repositories/drift_project_repository.dart';
import 'package:gizecare/features/tasks/data/repositories/drift_board_repository.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository projects;
  late DriftBoardRepository board;

  setUpAll(ensureSqliteLoaded);

  setUp(() {
    db = AppDatabase.memory();
    projects = DriftProjectRepository(db);
    board = DriftBoardRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('project create seeds default board columns', () async {
    final created = await projects.create(
      name: 'Board Proj',
      color: const Color(0xFF009DFE),
    );
    expect(created.isSuccess, isTrue);

    final snap = await board.getBoard(created.requireValue.id);
    expect(snap.isSuccess, isTrue);
    expect(snap.requireValue.columns, hasLength(3));
    expect(
      snap.requireValue.columns.map((c) => c.name).toList(),
      BoardDefaults.columnNames,
    );
  });

  test('create card, move between columns, reorder', () async {
    final project = (await projects.create(
      name: 'Move Me',
      color: Colors.teal,
    ))
        .requireValue;
    final snap0 = (await board.getBoard(project.id)).requireValue;
    final todo = snap0.columns.firstWhere((c) => c.name == BoardDefaults.todo);
    final doing =
        snap0.columns.firstWhere((c) => c.name == BoardDefaults.inProgress);

    final a = (await board.createCard(
      projectId: project.id,
      columnId: todo.id,
      name: 'Card A',
    ))
        .requireValue;
    final b = (await board.createCard(
      projectId: project.id,
      columnId: todo.id,
      name: 'Card B',
    ))
        .requireValue;

    var boardSnap = (await board.getBoard(project.id)).requireValue;
    expect(boardSnap.tasksIn(todo.id).map((t) => t.id), [a.id, b.id]);

    await board.moveTask(taskId: a.id, toColumnId: doing.id, toIndex: 0);
    boardSnap = (await board.getBoard(project.id)).requireValue;
    expect(boardSnap.tasksIn(doing.id).single.id, a.id);
    expect(boardSnap.tasksIn(todo.id).single.id, b.id);

    await board.moveTask(taskId: b.id, toColumnId: doing.id, toIndex: 0);
    boardSnap = (await board.getBoard(project.id)).requireValue;
    expect(boardSnap.tasksIn(doing.id).map((t) => t.name), ['Card B', 'Card A']);
  });

  test('labels, checklist, comment, meta, attachment records', () async {
    final project = (await projects.create(
      name: 'Rich',
      color: Colors.orange,
    ))
        .requireValue;
    final snap = (await board.getBoard(project.id)).requireValue;
    final todo = snap.columns.first;

    final card = (await board.createCard(
      projectId: project.id,
      columnId: todo.id,
      name: 'Rich card',
    ))
        .requireValue;

    final label = (await board.createLabel(
      projectId: project.id,
      name: 'Bug',
      color: Colors.red,
    ))
        .requireValue;
    await board.setTaskLabels(card.id, [label.id]);
    expect((await board.getTaskLabelIds(card.id)).requireValue, [label.id]);

    await board.setCardMeta(
      taskId: card.id,
      priority: TaskPriority.high,
      dueAt: DateTime(2030, 1, 15),
      coverColor: Colors.blue,
    );

    final checklist = (await board.createChecklist(
      taskId: card.id,
      title: 'Steps',
    ))
        .requireValue;
    await board.addChecklistItem(checklistId: checklist.id, title: 'One');
    await board.addComment(taskId: card.id, body: 'Hello');
    await board.addAttachment(
      taskId: card.id,
      fileName: 'note.txt',
      filePath: '/tmp/note.txt',
      byteSize: 4,
    );

    final refreshed = (await board.getBoard(project.id)).requireValue;
    expect(refreshed.labelIdsByTask[card.id], [label.id]);
    expect(refreshed.checklistProgressByTask[card.id]?.total, 1);
    expect(refreshed.commentCountByTask[card.id], 1);

    final taskRow = refreshed.tasksIn(todo.id).single;
    expect(taskRow.priority, TaskPriority.high);
    expect(taskRow.dueAt, DateTime(2030, 1, 15));
  });

  test('migration backfill path: seed columns for empty project via getBoard',
      () async {
    // Insert project without columns (simulates pre-v5 row before seed).
    await db.into(db.projects).insert(
          ProjectsCompanion.insert(
            id: 'legacy-proj',
            name: 'Legacy',
            color: Colors.grey.toARGB32(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
    final snap = (await board.getBoard('legacy-proj')).requireValue;
    expect(snap.columns, hasLength(3));
  });

  test('idempotent v5 migration recovers when user_version stuck at 4', () async {
    final dir = await Directory.systemTemp.createTemp('gizecare_mig_');
    final file = File('${dir.path}/test.sqlite');

    final first = AppDatabase(NativeDatabase(file));
    final projects = DriftProjectRepository(first);
    final project = (await projects.create(
      name: 'Stuck',
      color: Colors.brown,
    ))
        .requireValue;
    await first.into(first.tasks).insert(
          TasksCompanion.insert(
            id: 'task-1',
            projectId: project.id,
            name: 'Orphan card',
            createdAt: DateTime.now(),
          ),
        );
    // Simulate failed upgrade: wipe seeds, keep tables, freeze version.
    await first.customStatement('DELETE FROM board_columns');
    await first.customStatement('UPDATE tasks SET column_id = NULL');
    await first.customStatement('PRAGMA user_version = 4');
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    // Opening triggers onUpgrade(4→5) which must not throw.
    final board2 = DriftBoardRepository(second);
    final snap = (await board2.getBoard(project.id)).requireValue;
    expect(snap.columns, hasLength(3));
    expect(snap.tasksIn(snap.columns.first.id), isNotEmpty);

    final versionRows =
        await second.customSelect('PRAGMA user_version').get();
    expect(versionRows.first.data.values.first, 5);
    await second.close();
    await dir.delete(recursive: true);
  });
}

