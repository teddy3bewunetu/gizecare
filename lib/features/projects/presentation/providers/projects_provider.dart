import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';

/// Live project list (active only).
final projectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).watchProjects();
});

/// Live project list including archived.
final allProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref
      .watch(projectRepositoryProvider)
      .watchProjects(includeArchived: true);
});

/// Search query for projects page.
final projectSearchProvider = StateProvider<String>((ref) => '');
