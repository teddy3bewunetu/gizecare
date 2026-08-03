import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';

/// Optional project filter for tasks page.
final selectedTaskProjectIdProvider = StateProvider<String?>((ref) => null);

/// Task search query.
final taskSearchProvider = StateProvider<String>((ref) => '');

/// Live tasks, optionally filtered by project.
final tasksProvider = StreamProvider<List<TaskItem>>((ref) {
  final projectId = ref.watch(selectedTaskProjectIdProvider);
  return ref.watch(taskRepositoryProvider).watchTasks(projectId: projectId);
});
