import 'package:flutter/material.dart';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/notebook/domain/entities/note.dart';
import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Contract for note persistence.
abstract class NoteRepository {
  Stream<List<Note>> watchNotes({
    String? notebookId,
    bool favoritesOnly = false,
    String? searchQuery,
  });

  Future<Result<List<Note>>> getNotes({
    String? notebookId,
    bool favoritesOnly = false,
    String? searchQuery,
  });

  Future<Result<Note?>> getById(String id);

  Future<Result<int>> countInNotebook(String notebookId);

  Future<Result<Note>> create({
    required String notebookId,
    required NoteType noteType,
    required Color color,
    String title = '',
    String body = '',
    String? projectId,
    String? taskId,
  });

  Future<Result<Note>> update(Note note);

  Future<Result<Unit>> delete(String id);
}
