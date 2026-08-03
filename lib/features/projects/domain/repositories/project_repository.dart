import 'package:flutter/material.dart';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';

/// Contract for project persistence.
abstract class ProjectRepository {
  Stream<List<Project>> watchProjects({bool includeArchived = false});

  Future<Result<List<Project>>> getProjects({bool includeArchived = false});

  Future<Result<Project?>> getById(String id);

  Future<Result<Project>> create({
    required String name,
    required Color color,
    String? clientName,
    String? description,
    double? hourlyRate,
    int? weeklyLimitHours,
    String? contractType,
  });

  Future<Result<Project>> update(Project project);

  Future<Result<Unit>> archive(String id);

  Future<Result<Unit>> delete(String id);
}

/// Void success marker for [Result].
class Unit {
  const Unit();
}

const unit = Unit();
