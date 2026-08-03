import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/services/activity/keystroke_capture.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/core/widgets/brand_mark.dart';
import 'package:gizecare/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/screenshots/presentation/screenshot_viewer.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tracker/domain/entities/live_time_entries.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';
import 'package:gizecare/features/tracker/presentation/widgets/idle_return_dialog.dart';

/// Upwork-style compact tracker window.
class CompactTrackerPage extends ConsumerStatefulWidget {
  const CompactTrackerPage({super.key});

  @override
  ConsumerState<CompactTrackerPage> createState() => _CompactTrackerPageState();
}

class _CompactTrackerPageState extends ConsumerState<CompactTrackerPage> {
  Project? _selectedProject;
  TaskItem? _selectedTask;
  List<TaskItem> _projectTasks = const [];
  bool _hydratedSelection = false;

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerControllerProvider);
    final keyStats = ref.watch(liveKeystrokeStatsProvider);
    final todayAsync = ref.watch(todayEntriesProvider);
    final weekAsync = ref.watch(weekEntriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final screenshots = ref.watch(screenshotRepositoryProvider).watchAll();

    ref.listen(timerControllerProvider, (prev, next) {
      if (next.pendingIdlePrompt && !(prev?.pendingIdlePrompt ?? false)) {
        showIdleReturnDialog(context, ref);
      }
    });

    projectsAsync.whenData((projects) {
      if (!_hydratedSelection && projects.isNotEmpty) {
        _hydratedSelection = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_hydrateSelection(projects));
        });
      }
    });

    final todaySeconds = todayAsync.maybeWhen(
      data: (entries) => liveDurationSeconds(entries, timer),
      orElse: () => 0,
    );
    final weekSeconds = weekAsync.maybeWhen(
      data: (entries) => liveDurationSeconds(entries, timer),
      orElse: () => 0,
    );
    final liveToday = Duration(seconds: todaySeconds);
    final liveWeek = Duration(seconds: weekSeconds);

    final canStart = !timer.hasSession &&
        _selectedProject != null &&
        _selectedTask != null;

    return Listener(
      onPointerDown: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
      onPointerMove: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const Expanded(child: BrandMark(logoSize: 28)),
                    IconButton(
                      tooltip: 'Open full app',
                      onPressed: () => _openFullApp(),
                      icon: const Icon(Icons.open_in_full_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current session',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          if (!timer.hasSession) ...[
                            projectsAsync.when(
                              data: (projects) {
                                if (projects.isEmpty) {
                                  return Text(
                                    'Create a project (contract) and a task '
                                    '(activity) in the full app before tracking.',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  );
                                }
                                return Column(
                                  children: [
                                    DropdownButtonFormField<Project>(
                                      isExpanded: true,
                                      value: _resolveProject(projects),
                                      decoration: const InputDecoration(
                                        labelText: 'Project / contract',
                                      ),
                                      items: [
                                        for (final p in projects)
                                          DropdownMenuItem(
                                            value: p,
                                            child: Text(
                                              p.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                      onChanged: (value) async {
                                        setState(() {
                                          _selectedProject = value;
                                          _selectedTask = null;
                                          _projectTasks = const [];
                                        });
                                        if (value != null) {
                                          await _loadTasksFor(value.id);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<TaskItem>(
                                      isExpanded: true,
                                      value: _resolveTask(),
                                      decoration: const InputDecoration(
                                        labelText: 'Activity / task',
                                      ),
                                      items: [
                                        for (final t in _projectTasks)
                                          DropdownMenuItem(
                                            value: t,
                                            child: Text(
                                              t.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                      onChanged: _selectedProject == null
                                          ? null
                                          : (value) {
                                              setState(
                                                () => _selectedTask = value,
                                              );
                                            },
                                    ),
                                    if (_selectedProject != null &&
                                        _projectTasks.isEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        'No activities for this project. '
                                        'Add a task in the full app.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('$e'),
                            ),
                            const SizedBox(height: 16),
                          ] else ...[
                            Text(
                              timer.projectName ?? 'Project',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (timer.taskName != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                timer.taskName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Formatters.duration(timer.elapsed),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontFeatures: const [
                                              FontFeature.tabularFigures(),
                                            ],
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _statusLabel(timer),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    if (timer.hasSession) ...[
                                      if (timer.isRunning ||
                                          keyStats.total > 0) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          keyStats.total == 0
                                              ? 'Keys: type while this window is focused'
                                              : 'Keys: ${keyStats.total} · top '
                                                  '${keyStats.ranked.take(5).map((e) => '${e.key}(${e.value})').join(' ')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                              _PrimaryTimerButton(
                                timer: timer,
                                canStart: canStart,
                                onStart: _startTracking,
                                onPause: () => ref
                                    .read(timerControllerProvider.notifier)
                                    .pause(),
                                onResume: () => ref
                                    .read(timerControllerProvider.notifier)
                                    .resume(),
                              ),
                            ],
                          ),
                          if (timer.hasSession) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => ref
                                    .read(timerControllerProvider.notifier)
                                    .stop(),
                                icon: const Icon(Icons.stop_rounded),
                                label: const Text('Stop'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total hours tracked',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () => _openFullApp(
                              path: AppRoutes.reports,
                            ),
                            child: const Text("View this week's timesheet"),
                          ),
                          const Divider(height: 24),
                          _HoursRow(
                            label:
                                'Today (${DateFormat.E().format(DateTime.now())})',
                            value: Formatters.hoursCompact(liveToday),
                          ),
                          const Divider(height: 24),
                          _HoursRow(
                            label: 'This week',
                            value: Formatters.hoursCompact(liveWeek),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppPanel(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Latest screenshot',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => _openFullApp(
                                  path: AppRoutes.screenshots,
                                ),
                                child: const Text('Gallery'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timer.isRunning
                                ? 'Automatic while tracking (settings interval)'
                                : 'Starts automatically when you track time',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<List<ScreenshotItem>>(
                            stream: screenshots,
                            builder: (context, snapshot) {
                              final items =
                                  snapshot.data ?? const <ScreenshotItem>[];
                              if (items.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No screenshots yet — they appear when '
                                      'tracking starts',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                );
                              }
                              final latest = items.first;
                              final file = File(latest.filePath);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    _relativeTime(latest.takenAt),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: file.existsSync()
                                          ? () => openScreenshotViewer(
                                                context,
                                                filePath: latest.filePath,
                                                takenAt: latest.takenAt,
                                              )
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 10,
                                          child: file.existsSync()
                                              ? Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                )
                                              : ColoredBox(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to open',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _addManualTime,
                            child: const Text('Add manual time'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () => _openFullApp(),
                            child: const Text('Open full app'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _hydrateSelection(List<Project> projects) async {
    final settings = ref.read(settingsRepositoryProvider);
    final projectRaw = await settings.get(SettingKeys.lastProjectId);
    final taskRaw = await settings.get(SettingKeys.lastTaskId);
    final lastProjectId =
        projectRaw.when(onSuccess: (v) => v, onFailure: (_) => null);
    final lastTaskId =
        taskRaw.when(onSuccess: (v) => v, onFailure: (_) => null);

    if (!mounted) return;
    Project? project;
    for (final p in projects) {
      if (p.id == lastProjectId) {
        project = p;
        break;
      }
    }
    if (project == null) return;
    setState(() => _selectedProject = project);
    await _loadTasksFor(project.id);
    if (!mounted || lastTaskId == null) return;
    TaskItem? task;
    for (final t in _projectTasks) {
      if (t.id == lastTaskId) {
        task = t;
        break;
      }
    }
    if (task != null) {
      setState(() => _selectedTask = task);
    }
  }

  Project? _resolveProject(List<Project> projects) {
    final selected = _selectedProject;
    if (selected == null) return null;
    for (final p in projects) {
      if (p.id == selected.id) return p;
    }
    return null;
  }

  TaskItem? _resolveTask() {
    final selected = _selectedTask;
    if (selected == null) return null;
    for (final t in _projectTasks) {
      if (t.id == selected.id) return t;
    }
    return null;
  }

  Future<void> _loadTasksFor(String projectId) async {
    final result =
        await ref.read(taskRepositoryProvider).getTasks(projectId: projectId);
    if (!mounted) return;
    setState(() {
      _projectTasks = result.when(
        onSuccess: (tasks) => tasks,
        onFailure: (_) => const <TaskItem>[],
      );
    });
  }

  Future<void> _startTracking() async {
    final project = _selectedProject;
    final task = _selectedTask;
    if (project == null || task == null) {
      AppSnackBar.show(context, 'Select a project and an activity before starting');
      return;
    }
    await ref.read(timerControllerProvider.notifier).start(
          project: project,
          task: task,
        );
  }

  String _statusLabel(TimerState timer) {
    return switch (timer.phase) {
      TimerPhase.idle => 'Select project & activity, then Start',
      TimerPhase.running => 'Tracking…',
      TimerPhase.paused => 'Paused',
    };
  }

  String _relativeTime(DateTime takenAt) {
    final diff = DateTime.now().difference(takenAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return DateFormat.MMMd().add_jm().format(takenAt);
  }

  Future<void> _openFullApp({String path = AppRoutes.dashboard}) async {
    await ref.read(windowModeServiceProvider).enterFull();
    if (mounted) {
      context.go(path);
    }
  }

  Future<void> _addManualTime() async {
    final project = _selectedProject;
    final task = _selectedTask;
    if (project == null || task == null) {
      AppSnackBar.show(context, 'Select a project and activity first');
      return;
    }
    var minutes = 30;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Add manual time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${project.name} · ${task.name}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Minutes'),
                      const Spacer(),
                      IconButton(
                        onPressed: minutes > 5
                            ? () => setLocal(() => minutes -= 5)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$minutes'),
                      IconButton(
                        onPressed: () => setLocal(() => minutes += 5),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    if (confirmed != true) return;

    final end = DateTime.now();
    final start = end.subtract(Duration(minutes: minutes));
    final entry = TimeEntry(
      id: const Uuid().v4(),
      projectId: project.id,
      taskId: task.id,
      startTime: start,
      endTime: end,
      durationSeconds: minutes * 60,
      isManual: true,
    );
    await ref.read(timeEntryRepositoryProvider).create(entry);
    if (mounted) {
      AppSnackBar.show(context, 'Added $minutes minutes');
    }
  }
}

class _PrimaryTimerButton extends StatelessWidget {
  const _PrimaryTimerButton({
    required this.timer,
    required this.canStart,
    required this.onStart,
    required this.onPause,
    required this.onResume,
  });

  final TimerState timer;
  final bool canStart;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    if (timer.isRunning) {
      return FilledButton.tonalIcon(
        onPressed: onPause,
        icon: const Icon(Icons.pause_rounded),
        label: const Text('Pause'),
      );
    }
    if (timer.isPaused) {
      return FilledButton.icon(
        onPressed: onResume,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Resume'),
      );
    }
    return FilledButton.icon(
      onPressed: canStart ? onStart : null,
      icon: const Icon(Icons.play_arrow_rounded),
      label: const Text('Start'),
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
