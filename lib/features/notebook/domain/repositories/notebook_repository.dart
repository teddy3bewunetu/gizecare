import 'package:flutter/material.dart';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/notebook/domain/entities/notebook.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Contract for notebook collection persistence.
abstract class NotebookRepository {
  Stream<List<Notebook>> watchNotebooks();

  Future<Result<List<Notebook>>> getNotebooks();

  Future<Result<Notebook?>> getById(String id);

  Future<Result<Notebook>> create({
    required String name,
    required Color coverColor,
  });

  Future<Result<Notebook>> update(Notebook notebook);

  Future<Result<Unit>> delete(String id);

  /// Returns the first notebook, creating the default if the table is empty.
  Future<Result<Notebook>> ensureDefault();
}
