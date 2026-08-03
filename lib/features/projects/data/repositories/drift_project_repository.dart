import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/database_mappers.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';

/// Drift-backed [ProjectRepository].
class DriftProjectRepository implements ProjectRepository {
  DriftProjectRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Project>> watchProjects({bool includeArchived = false}) {
    final query = _db.select(_db.projects)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    return query.watch().map(
          (rows) => rows.map(DatabaseMappers.project).toList(),
        );
  }

  @override
  Future<Result<List<Project>>> getProjects({
    bool includeArchived = false,
  }) async {
    try {
      final query = _db.select(_db.projects)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
      if (!includeArchived) {
        query.where((t) => t.archived.equals(false));
      }
      final rows = await query.get();
      return Success(rows.map(DatabaseMappers.project).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load projects', cause: e));
    }
  }

  @override
  Future<Result<Project?>> getById(String id) async {
    try {
      final row = await (_db.select(_db.projects)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return Success(row == null ? null : DatabaseMappers.project(row));
    } catch (e) {
      return Err(CacheFailure('Failed to load project', cause: e));
    }
  }

  @override
  Future<Result<Project>> create({
    required String name,
    required Color color,
    String? clientName,
    String? description,
    double? hourlyRate,
    int? weeklyLimitHours,
    String? contractType,
  }) async {
    try {
      final now = DateTime.now();
      final project = Project(
        id: _uuid.v4(),
        name: name.trim(),
        color: color,
        archived: false,
        clientName: clientName?.trim().isEmpty ?? true
            ? null
            : clientName!.trim(),
        description: description?.trim().isEmpty ?? true
            ? null
            : description!.trim(),
        hourlyRate: hourlyRate,
        weeklyLimitHours: weeklyLimitHours ?? 40,
        contractType: contractType ?? 'Hourly',
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.projects).insert(
            ProjectsCompanion.insert(
              id: project.id,
              name: project.name,
              color: project.color.toARGB32(),
              archived: Value(project.archived),
              clientName: Value(project.clientName),
              description: Value(project.description),
              hourlyRate: Value(project.hourlyRate),
              weeklyLimitHours: Value(project.weeklyLimitHours),
              contractType: Value(project.contractType),
              createdAt: project.createdAt,
              updatedAt: project.updatedAt,
            ),
          );
      for (var i = 0; i < BoardDefaults.columnNames.length; i++) {
        await _db.into(_db.boardColumns).insert(
              BoardColumnsCompanion.insert(
                id: _uuid.v4(),
                projectId: project.id,
                name: BoardDefaults.columnNames[i],
                sortOrder: Value(i),
                createdAt: now,
              ),
            );
      }
      return Success(project);
    } catch (e) {
      return Err(CacheFailure('Failed to create project', cause: e));
    }
  }

  @override
  Future<Result<Project>> update(Project project) async {
    try {
      final updated = project.copyWith(updatedAt: DateTime.now());
      await (_db.update(_db.projects)..where((t) => t.id.equals(project.id)))
          .write(
        ProjectsCompanion(
          name: Value(updated.name),
          color: Value(updated.color.toARGB32()),
          archived: Value(updated.archived),
          clientName: Value(updated.clientName),
          description: Value(updated.description),
          hourlyRate: Value(updated.hourlyRate),
          weeklyLimitHours: Value(updated.weeklyLimitHours),
          contractType: Value(updated.contractType),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      return Success(updated);
    } catch (e) {
      return Err(CacheFailure('Failed to update project', cause: e));
    }
  }

  @override
  Future<Result<Unit>> archive(String id) async {
    try {
      await (_db.update(_db.projects)..where((t) => t.id.equals(id))).write(
        ProjectsCompanion(
          archived: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to archive project', cause: e));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await (_db.delete(_db.projects)..where((t) => t.id.equals(id))).go();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to delete project', cause: e));
    }
  }
}
