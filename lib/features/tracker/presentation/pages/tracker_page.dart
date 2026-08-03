import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_provider.dart';
import 'package:gizecare/features/tracker/presentation/widgets/idle_return_dialog.dart';

/// Large timer with start / pause / resume / stop controls.
class TrackerPage extends ConsumerStatefulWidget {
  const TrackerPage({super.key});

  @override
  ConsumerState<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends ConsumerState<TrackerPage> {
  Project? _selectedProject;
  TaskItem? _selectedTask;

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerControllerProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final tasksAsync = ref.watch(tasksProvider);

    ref.listen(timerControllerProvider, (prev, next) {
      if (next.pendingIdlePrompt && !(prev?.pendingIdlePrompt ?? false)) {
        showIdleReturnDialog(context, ref);
      }
    });

    return Listener(
      onPointerDown: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
      onPointerMove: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
        child: Column(
          children: [
            const PageHeader(
              title: 'Tracker',
              subtitle: 'Focus on the work in front of you',
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: AppPanel(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Formatters.duration(timer.elapsed),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                  letterSpacing: 1.5,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _phaseLabel(timer.phase),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 28),
                          if (!timer.hasSession) ...[
                            projectsAsync.when(
                              data: (projects) {
                                return DropdownButtonFormField<Project>(
                                  value: _selectedProject == null
                                      ? null
                                      : projects
                                          .where(
                                            (p) => p.id == _selectedProject!.id,
                                          )
                                          .firstOrNull,
                                  decoration: const InputDecoration(
                                    labelText: 'Project / contract',
                                  ),
                                  items: [
                                    for (final p in projects)
                                      DropdownMenuItem(
                                        value: p,
                                        child: Text(p.name),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProject = value;
                                      _selectedTask = null;
                                      ref
                                          .read(
                                            selectedTaskProjectIdProvider
                                                .notifier,
                                          )
                                          .state = value?.id;
                                    });
                                  },
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('$e'),
                            ),
                            const SizedBox(height: 12),
                            tasksAsync.when(
                              data: (tasks) {
                                final filtered = tasks
                                    .where(
                                      (t) =>
                                          t.projectId == _selectedProject?.id,
                                    )
                                    .toList();
                                return DropdownButtonFormField<TaskItem>(
                                  value: _selectedTask != null &&
                                          filtered.any(
                                            (t) => t.id == _selectedTask!.id,
                                          )
                                      ? filtered.firstWhere(
                                          (t) => t.id == _selectedTask!.id,
                                        )
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Activity / task',
                                  ),
                                  items: [
                                    for (final t in filtered)
                                      DropdownMenuItem(
                                        value: t,
                                        child: Text(t.name),
                                      ),
                                  ],
                                  onChanged: _selectedProject == null
                                      ? null
                                      : (value) => setState(
                                            () => _selectedTask = value,
                                          ),
                                );
                              },
                              loading: () => const SizedBox.shrink(),
                              error: (e, _) => Text('$e'),
                            ),
                          ] else ...[
                            _InfoRow(
                              label: 'Project',
                              value: timer.projectName ?? '—',
                            ),
                            _InfoRow(
                              label: 'Task',
                              value: timer.taskName ?? '—',
                            ),
                          ],
                          const SizedBox(height: 28),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              if (!timer.hasSession)
                                FilledButton.icon(
                                  onPressed: _selectedProject == null ||
                                          _selectedTask == null
                                      ? null
                                      : () => ref
                                          .read(timerControllerProvider.notifier)
                                          .start(
                                            project: _selectedProject!,
                                            task: _selectedTask!,
                                          ),
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text('Start'),
                                ),
                              if (timer.isRunning)
                                FilledButton.tonalIcon(
                                  onPressed: () => ref
                                      .read(timerControllerProvider.notifier)
                                      .pause(),
                                  icon: const Icon(Icons.pause_rounded),
                                  label: const Text('Pause'),
                                ),
                              if (timer.isPaused)
                                FilledButton.icon(
                                  onPressed: () => ref
                                      .read(timerControllerProvider.notifier)
                                      .resume(),
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text('Resume'),
                                ),
                              if (timer.hasSession)
                                OutlinedButton.icon(
                                  onPressed: () => ref
                                      .read(timerControllerProvider.notifier)
                                      .stop(),
                                  icon: const Icon(Icons.stop_rounded),
                                  label: const Text('Stop'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  String _phaseLabel(TimerPhase phase) {
    return switch (phase) {
      TimerPhase.idle => 'Ready',
      TimerPhase.running => 'Running',
      TimerPhase.paused => 'Paused',
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
