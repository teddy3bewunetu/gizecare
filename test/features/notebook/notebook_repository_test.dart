import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/sqlite_setup.dart';
import 'package:gizecare/features/notebook/data/repositories/drift_note_repository.dart';
import 'package:gizecare/features/notebook/data/repositories/drift_notebook_repository.dart';
import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/notebook/domain/note_colors.dart';
import 'package:gizecare/features/projects/data/repositories/drift_project_repository.dart';
import 'package:gizecare/features/tasks/data/repositories/drift_board_repository.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';

void main() {
  late AppDatabase db;
  late DriftNotebookRepository notebooks;
  late DriftNoteRepository notes;
  late DriftProjectRepository projects;
  late DriftBoardRepository board;

  setUpAll(ensureSqliteLoaded);

  setUp(() async {
    db = AppDatabase.memory();
    await db.seedDefaultNotebookIfEmpty();
    notebooks = DriftNotebookRepository(db);
    notes = DriftNoteRepository(db);
    projects = DriftProjectRepository(db);
    board = DriftBoardRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('ensureDefault seeds My Notebook when empty', () async {
    final result = await notebooks.ensureDefault();
    expect(result.isSuccess, isTrue);
    expect(result.requireValue.name, 'My Notebook');

    final list = await notebooks.getNotebooks();
    expect(list.requireValue, isNotEmpty);
  });

  test('create notebook and notes, filter by notebook', () async {
    final nb = (await notebooks.create(
      name: 'Work',
      coverColor: Colors.teal,
    ))
        .requireValue;

    final a = (await notes.create(
      notebookId: nb.id,
      noteType: NoteType.text,
      color: NoteColors.palette.first,
      title: 'Alpha',
      body: 'hello world',
    ))
        .requireValue;
    await notes.create(
      notebookId: nb.id,
      noteType: NoteType.todo,
      color: NoteColors.palette[1],
      title: 'Todos',
    );

    final defaultNb = (await notebooks.ensureDefault()).requireValue;
    await notes.create(
      notebookId: defaultNb.id,
      noteType: NoteType.text,
      color: NoteColors.palette[2],
      title: 'Other',
    );

    final inWork = (await notes.getNotes(notebookId: nb.id)).requireValue;
    expect(inWork, hasLength(2));
    expect(inWork.map((n) => n.id), contains(a.id));

    final all = (await notes.getNotes()).requireValue;
    expect(all.length, greaterThanOrEqualTo(3));
  });

  test('pin and favorite update note flags', () async {
    final nb = (await notebooks.ensureDefault()).requireValue;
    final note = (await notes.create(
      notebookId: nb.id,
      noteType: NoteType.text,
      color: NoteColors.random(1),
      title: 'Pin me',
    ))
        .requireValue;

    final pinned =
        (await notes.update(note.copyWith(isPinned: true, isFavorite: true)))
            .requireValue;
    expect(pinned.isPinned, isTrue);
    expect(pinned.isFavorite, isTrue);

    final favorites =
        (await notes.getNotes(favoritesOnly: true)).requireValue;
    expect(favorites.single.id, note.id);
  });

  test('create note with optional project and task links', () async {
    final project = (await projects.create(
      name: 'Linked Proj',
      color: const Color(0xFF009DFE),
    ))
        .requireValue;
    final snap = (await board.getBoard(project.id)).requireValue;
    final todo =
        snap.columns.firstWhere((c) => c.name == BoardDefaults.todo);
    final task = (await board.createCard(
      projectId: project.id,
      columnId: todo.id,
      name: 'Linked Task',
    ))
        .requireValue;

    final nb = (await notebooks.ensureDefault()).requireValue;
    final note = (await notes.create(
      notebookId: nb.id,
      noteType: NoteType.text,
      color: NoteColors.palette.first,
      title: 'From task',
      projectId: project.id,
      taskId: task.id,
    ))
        .requireValue;

    expect(note.projectId, project.id);
    expect(note.taskId, task.id);

    final cleared = (await notes.update(
      note.copyWith(clearProjectId: true, clearTaskId: true),
    ))
        .requireValue;
    expect(cleared.projectId, isNull);
    expect(cleared.taskId, isNull);
  });

  test('delete notebook removes its notes and reseeds default', () async {
    final only = (await notebooks.getNotebooks()).requireValue;
    expect(only, isNotEmpty);

    final extra = (await notebooks.create(
      name: 'Temp',
      coverColor: Colors.orange,
    ))
        .requireValue;
    await notes.create(
      notebookId: extra.id,
      noteType: NoteType.text,
      color: NoteColors.palette.first,
      title: 'Gone',
    );

    await notebooks.delete(extra.id);
    final remainingNotes =
        (await notes.getNotes(notebookId: extra.id)).requireValue;
    expect(remainingNotes, isEmpty);

    // Deleting the last remaining notebooks still leaves a default.
    for (final nb in (await notebooks.getNotebooks()).requireValue) {
      await notebooks.delete(nb.id);
    }
    final after = (await notebooks.getNotebooks()).requireValue;
    expect(after, isNotEmpty);
    expect(after.first.name, 'My Notebook');
  });
}
