import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/notebook/domain/entities/note.dart';
import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/notebook/domain/note_document_codec.dart';
import 'package:gizecare/features/notebook/domain/repositories/note_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Drift-backed [NoteRepository].
class DriftNoteRepository implements NoteRepository {
  DriftNoteRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  SimpleSelectStatement<$NotesTable, NoteRow> _baseQuery({
    String? notebookId,
    bool favoritesOnly = false,
  }) {
    final query = _db.select(_db.notes);
    if (notebookId != null) {
      query.where((t) => t.notebookId.equals(notebookId));
    }
    if (favoritesOnly) {
      query.where((t) => t.isFavorite.equals(true));
    }
    query.orderBy([
      (t) => OrderingTerm.desc(t.isPinned),
      (t) => OrderingTerm.desc(t.updatedAt),
    ]);
    return query;
  }

  List<Note> _mapAndFilter(List<NoteRow> rows, String? searchQuery) {
    var notes = rows.map(DatabaseMappers.note).toList();
    final q = searchQuery?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      notes = notes
          .where(
            (n) =>
                n.title.toLowerCase().contains(q) ||
                n.body.toLowerCase().contains(q),
          )
          .toList();
    }
    return notes;
  }

  @override
  Stream<List<Note>> watchNotes({
    String? notebookId,
    bool favoritesOnly = false,
    String? searchQuery,
  }) {
    return _baseQuery(notebookId: notebookId, favoritesOnly: favoritesOnly)
        .watch()
        .map((rows) => _mapAndFilter(rows, searchQuery));
  }

  @override
  Future<Result<List<Note>>> getNotes({
    String? notebookId,
    bool favoritesOnly = false,
    String? searchQuery,
  }) async {
    try {
      final rows = await _baseQuery(
        notebookId: notebookId,
        favoritesOnly: favoritesOnly,
      ).get();
      return Success(_mapAndFilter(rows, searchQuery));
    } catch (e) {
      return Err(CacheFailure('Failed to load notes', cause: e));
    }
  }

  @override
  Future<Result<Note?>> getById(String id) async {
    try {
      final row = await (_db.select(_db.notes)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.note(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load note', cause: e));
    }
  }

  @override
  Future<Result<int>> countInNotebook(String notebookId) async {
    try {
      final count = await (_db.select(_db.notes)
            ..where((t) => t.notebookId.equals(notebookId)))
          .get();
      return Success(count.length);
    } catch (e) {
      return Err(CacheFailure('Failed to count notes', cause: e));
    }
  }

  @override
  Future<Result<Note>> create({
    required String notebookId,
    required NoteType noteType,
    required Color color,
    String title = '',
    String body = '',
    String? projectId,
    String? taskId,
  }) async {
    try {
      final now = DateTime.now();
      final initialBody = body.isNotEmpty
          ? body
          : NoteDocumentCodec.encode(
              noteType == NoteType.todo
                  ? NoteDocumentCodec.checklistSeed()
                  : NoteDocumentCodec.blank(),
            );
      final note = Note(
        id: _uuid.v4(),
        notebookId: notebookId,
        title: title,
        body: initialBody,
        noteType: noteType,
        color: color,
        isPinned: false,
        isFavorite: false,
        isLocked: false,
        projectId: projectId,
        taskId: taskId,
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.notes).insert(
            NotesCompanion.insert(
              id: note.id,
              notebookId: note.notebookId,
              title: Value(note.title),
              body: Value(note.body),
              noteType: Value(note.noteType.storageValue),
              color: note.color.toARGB32(),
              projectId: Value(note.projectId),
              taskId: Value(note.taskId),
              createdAt: note.createdAt,
              updatedAt: note.updatedAt,
            ),
          );
      return Success(note);
    } catch (e) {
      return Err(CacheFailure('Failed to create note', cause: e));
    }
  }

  @override
  Future<Result<Note>> update(Note note) async {
    try {
      final updated = note.copyWith(updatedAt: DateTime.now());
      await (_db.update(_db.notes)..where((t) => t.id.equals(note.id))).write(
        NotesCompanion(
          notebookId: Value(updated.notebookId),
          title: Value(updated.title),
          body: Value(updated.body),
          noteType: Value(updated.noteType.storageValue),
          color: Value(updated.color.toARGB32()),
          isPinned: Value(updated.isPinned),
          isFavorite: Value(updated.isFavorite),
          isLocked: Value(updated.isLocked),
          projectId: Value(updated.projectId),
          taskId: Value(updated.taskId),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update note', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.notes)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete note', cause: e));
    }
  }
}
