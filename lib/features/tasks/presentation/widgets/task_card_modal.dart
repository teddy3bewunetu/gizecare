import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/tasks/presentation/providers/task_detail_provider.dart';
import 'package:gizecare/features/tasks/presentation/widgets/task_card_panel.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Opens card edit/management without leaving the board.
Future<void> showTaskCardModal(
  BuildContext context, {
  required String taskId,
  Project? project,
}) {
  final size = MediaQuery.sizeOf(context);
  final wide = size.width >= 720;

  if (wide) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 680,
          height: size.height * 0.88,
          child: _TaskCardModalScaffold(
            taskId: taskId,
            project: project,
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => SizedBox(
      height: size.height * 0.92,
      child: _TaskCardModalScaffold(
        taskId: taskId,
        project: project,
      ),
    ),
  );
}

class _TaskCardModalScaffold extends ConsumerWidget {
  const _TaskCardModalScaffold({
    required this.taskId,
    this.project,
  });

  final String taskId;
  final Project? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskByIdProvider(taskId));
    final projectAsync = ref.watch(taskProjectProvider(taskId));
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      child: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (task) {
          if (task == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Card not found'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          }

          final resolvedProject = project ?? projectAsync.valueOrNull;
          final timer = ref.watch(timerControllerProvider);
          final trackingThisTask =
              timer.hasSession && timer.taskId == task.id;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: InlineTaskTitleField(task: task),
                      ),
                    ),
                    if (resolvedProject != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: FilledButton.tonalIcon(
                          onPressed: () async {
                            final controller =
                                ref.read(timerControllerProvider.notifier);
                            if (trackingThisTask) {
                              if (timer.isPaused) {
                                controller.resume();
                                if (context.mounted) {
                                  AppSnackBar.show(
                                    context,
                                    'Timer resumed on ${task.name}',
                                  );
                                }
                              } else {
                                await controller.stop();
                                if (context.mounted) {
                                  AppSnackBar.show(
                                    context,
                                    'Timer stopped on ${task.name}',
                                  );
                                }
                              }
                              return;
                            }
                            await controller.start(
                              project: resolvedProject,
                              task: task,
                            );
                            if (context.mounted) {
                              AppSnackBar.show(
                                context,
                                'Timer started on ${task.name}',
                              );
                            }
                          },
                          icon: Icon(
                            trackingThisTask
                                ? (timer.isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.stop_rounded)
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            trackingThisTask
                                ? (timer.isPaused ? 'Resume' : 'Stop')
                                : 'Start',
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go(AppRoutes.taskDetailPath(task.id));
                        },
                        child: const Text('Time log'),
                      ),
                    ),
                  ],
                ),
              ),
              if (resolvedProject != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 0, 20, 8),
                  child: Text(
                    resolvedProject.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ),
              const Divider(height: 1),
              Expanded(
                child: TaskCardPanel(
                  task: task,
                  project: resolvedProject,
                  compact: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
