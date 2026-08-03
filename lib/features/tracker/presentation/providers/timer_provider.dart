import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

export 'timer_controller.dart';

/// Starts the timer using the last selected project + activity.
///
/// Returns `false` when no valid last selection exists (user must pick both).
Future<bool> startFromLastSelection(WidgetRef ref) async {
  final settings = ref.read(settingsRepositoryProvider);
  final projectRaw = await settings.get(SettingKeys.lastProjectId);
  final taskRaw = await settings.get(SettingKeys.lastTaskId);
  final projectId =
      projectRaw.when(onSuccess: (v) => v, onFailure: (_) => null);
  final taskId = taskRaw.when(onSuccess: (v) => v, onFailure: (_) => null);
  if (projectId == null || taskId == null) return false;

  final projects = await ref.read(projectRepositoryProvider).getProjects();
  if (projects.isFailure) return false;
  final project = projects.requireValue
      .where((p) => p.id == projectId)
      .firstOrNull;
  if (project == null) return false;

  final tasks =
      await ref.read(taskRepositoryProvider).getTasks(projectId: projectId);
  if (tasks.isFailure) return false;
  final task = tasks.requireValue.where((t) => t.id == taskId).firstOrNull;
  if (task == null) return false;

  await ref.read(timerControllerProvider.notifier).start(
        project: project,
        task: task,
      );
  return true;
}
