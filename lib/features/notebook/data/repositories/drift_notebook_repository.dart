import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/notebook/domain/entities/notebook.dart';
import 'package:gizecare/features/notebook/domain/repositories/notebook_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Drift-backed [NotebookRepository].
class DriftNotebookRepository implements NotebookRepository {
  DriftNotebookRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Notebook>> watchNotebooks() {
    final query = _db.select(_db.notebooks)
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);
    return query.watch().map(
          (rows) => rows.map(DatabaseMappers.notebook).toList(),
        );
  }

  @override
  Future<Result<List<Notebook>>> getNotebooks() async {
    try {
      final query = _db.select(_db.notebooks)
        ..orderBy([
          (t) => OrderingTerm.asc(t.sortOrder),
          (t) => OrderingTerm.desc(t.updatedAt),
        ]);
      final rows = await query.get();
      return Success(rows.map(DatabaseMappers.notebook).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load notebooks', cause: e));
    }
  }

  @override
  Future<Result<Notebook?>> getById(String id) async {
    try {
      final row =
          await (_db.select(_db.notebooks)..where((t) => t.id.equals(id)))
              .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.notebook(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load notebook', cause: e));
    }
  }

  @override
  Future<Result<Notebook>> create({
    required String name,
    required Color coverColor,
  }) async {
    try {
      final now = DateTime.now();
      final count = await _db.select(_db.notebooks).get();
      final notebook = Notebook(
        id: _uuid.v4(),
        name: name.trim(),
        coverColor: coverColor,
        sortOrder: count.length,
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.notebooks).insert(
            NotebooksCompanion.insert(
              id: notebook.id,
              name: notebook.name,
              coverColor: notebook.coverColor.toARGB32(),
              sortOrder: Value(notebook.sortOrder),
              createdAt: notebook.createdAt,
              updatedAt: notebook.updatedAt,
            ),
          );
      return Success(notebook);
    } catch (e) {
      return Err(CacheFailure('Failed to create notebook', cause: e));
    }
  }

  @override
  Future<Result<Notebook>> update(Notebook notebook) async {
    try {
      final updated = notebook.copyWith(updatedAt: DateTime.now());
      await (_db.update(_db.notebooks)..where((t) => t.id.equals(notebook.id)))
          .write(
        NotebooksCompanion(
          name: Value(updated.name),
          coverColor: Value(updated.coverColor.toARGB32()),
          coverImagePath: Value(updated.coverImagePath),
          sortOrder: Value(updated.sortOrder),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update notebook', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.notes)..where((t) => t.notebookId.equals(id))).go();
      await (_db.delete(_db.notebooks)..where((t) => t.id.equals(id))).go();
      await _db.seedDefaultNotebookIfEmpty();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete notebook', cause: e));
    }
  }

  @override
  Future<Result<Notebook>> ensureDefault() async {
    try {
      await _db.seedDefaultNotebookIfEmpty();
      final rows = await (_db.select(_db.notebooks)
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
      if (rows.isEmpty) {
        return const Err(CacheFailure('Failed to ensure default notebook'));
      }
      return Success(DatabaseMappers.notebook(rows.first));
    } catch (e) {
      return Err(CacheFailure('Failed to ensure default notebook', cause: e));
    }
  }
}
