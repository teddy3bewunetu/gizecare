import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/activity/domain/entities/keystroke_count.dart';
import 'package:gizecare/features/projects/presentation/providers/project_detail_provider.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/screenshots/presentation/screenshot_viewer.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/presentation/providers/task_detail_provider.dart';
import 'package:gizecare/features/tasks/presentation/widgets/task_card_panel.dart';
import 'package:gizecare/features/tracker/domain/entities/live_time_entries.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Task detail: overview, session log, screenshots, key usage.
class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskByIdProvider(widget.taskId));
    final projectAsync = ref.watch(taskProjectProvider(widget.taskId));
    final statsAsync = ref.watch(taskStatsProvider(widget.taskId));
    final entriesAsync = ref.watch(taskEntriesProvider(widget.taskId));
    final shotsAsync = ref.watch(taskScreenshotsProvider(widget.taskId));
    final keysAsync = ref.watch(taskKeystrokesProvider(widget.taskId));

    return taskAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (task) {
        if (task == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Task not found'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.tasks),
                  child: const Text('Back to tasks'),
                ),
              ],
            ),
          );
        }

        final timer = ref.watch(timerControllerProvider);
        final project = projectAsync.valueOrNull;
        final stats = statsAsync.valueOrNull;
        final entries = entriesWithLiveTimer(
          entriesAsync.valueOrNull ?? const <TimeEntry>[],
          timer,
        );
        final shots = shotsAsync.valueOrNull ?? const <ScreenshotItem>[];
        final keys = keysAsync.valueOrNull ?? const <KeystrokeCount>[];
        final trackingThisTask =
            timer.hasSession && timer.taskId == task.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: task.name,
              subtitle: [
                if (project != null) project.name,
                if (task.description?.trim().isNotEmpty == true)
                  task.description!.trim(),
              ].join(' · '),
              actions: [
                IconButton(
                  tooltip: 'New note',
                  onPressed: () => context.go(
                    AppRoutes.notebookCreatePath(
                      projectId: task.projectId,
                      taskId: task.id,
                    ),
                  ),
                  icon: const Icon(Icons.note_add_outlined),
                ),
                if (project != null)
                  FilledButton.tonalIcon(
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
                      await controller.start(project: project, task: task);
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
                          ? (timer.isPaused ? 'Resume timer' : 'Stop timer')
                          : 'Start timer',
                    ),
                  ),
                IconButton(
                  tooltip: 'Back',
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.tasks);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: TabBar(
                controller: _tabs,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Card'),
                  Tab(text: 'Overview'),
                  Tab(text: 'Sessions'),
                  Tab(text: 'Screenshots'),
                  Tab(text: 'Keys'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  TaskCardPanel(task: task, project: project),
                  _OverviewTab(
                    task: task,
                    projectName: project?.name ?? 'Project',
                    stats: stats,
                    recent: entries.take(8).toList(),
                    topKeys: keys.take(8).toList(),
                    screenshotCount: shots.length,
                    activeEntryId: trackingThisTask ? timer.entryId : null,
                    onOpenSessions: () => _tabs.animateTo(2),
                    onOpenScreenshots: () => _tabs.animateTo(3),
                    onOpenKeys: () => _tabs.animateTo(4),
                  ),
                  _SessionsTab(
                    entries: entries,
                    activeEntryId: trackingThisTask ? timer.entryId : null,
                  ),
                  _ScreenshotsTab(shots: shots),
                  _KeysTab(keys: keys),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.task,
    required this.projectName,
    required this.stats,
    required this.recent,
    required this.topKeys,
    required this.screenshotCount,
    required this.onOpenSessions,
    required this.onOpenScreenshots,
    required this.onOpenKeys,
    this.activeEntryId,
  });

  final TaskItem task;
  final String projectName;
  final ProjectTimeStats? stats;
  final List<TimeEntry> recent;
  final List<KeystrokeCount> topKeys;
  final int screenshotCount;
  final String? activeEntryId;
  final VoidCallback onOpenSessions;
  final VoidCallback onOpenScreenshots;
  final VoidCallback onOpenKeys;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(projectName, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                task.description?.trim().isNotEmpty == true
                    ? task.description!
                    : 'No description',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              if (stats != null) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    _Metric(
                      label: 'Total',
                      value: Formatters.hoursHm(stats!.sinceStart),
                    ),
                    _Metric(
                      label: 'This week',
                      value: Formatters.hoursHm(stats!.thisWeek),
                    ),
                    _Metric(
                      label: 'Last 24h',
                      value: Formatters.hoursHm(stats!.last24h),
                    ),
                    _Metric(
                      label: 'Screenshots',
                      value: '$screenshotCount',
                    ),
                  ],
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
              Row(
                children: [
                  Text(
                    'Recent sessions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton(onPressed: onOpenSessions, child: const Text('All')),
                ],
              ),
              const SizedBox(height: 8),
              if (recent.isEmpty)
                Text(
                  'No tracked time yet. Start the timer with this task selected.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              else
                ...recent.map(
                  (e) {
                    final isLive = e.id == activeEntryId;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(Formatters.dateTime(e.startTime)),
                      subtitle: Text(
                        [
                          if (isLive) 'In progress',
                          if (e.isManual) 'Manual',
                          if (e.notes?.isNotEmpty == true) e.notes!,
                        ].where((s) => s.isNotEmpty).join(' · '),
                      ),
                      trailing: Text(
                        Formatters.hoursHm(
                          Duration(seconds: e.durationSeconds),
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Most used keys',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton(onPressed: onOpenKeys, child: const Text('All')),
                ],
              ),
              const SizedBox(height: 8),
              if (topKeys.isEmpty)
                Text(
                  'Key presses are logged while the timer runs and this app '
                  'has focus.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final k in topKeys)
                      Chip(
                        label: Text('${k.keyLabel} · ${k.count}'),
                      ),
                  ],
                ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onOpenScreenshots,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text('Screenshots ($screenshotCount)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionsTab extends StatelessWidget {
  const _SessionsTab({required this.entries, this.activeEntryId});

  final List<TimeEntry> entries;
  final String? activeEntryId;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('No session history yet'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final e = entries[index];
        final isLive = e.id == activeEntryId;
        return AppPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(Formatters.dateTime(e.startTime)),
            subtitle: Text(
              [
                if (isLive)
                  'In progress'
                else if (e.endTime != null)
                  'Ended ${DateFormat.jm().format(e.endTime!.toLocal())}',
                if (e.isManual) 'Manual entry',
                if (e.notes?.isNotEmpty == true) e.notes!,
              ].join(' · '),
            ),
            trailing: Text(
              Formatters.hoursHm(Duration(seconds: e.durationSeconds)),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }
}

class _ScreenshotsTab extends StatelessWidget {
  const _ScreenshotsTab({required this.shots});

  final List<ScreenshotItem> shots;

  @override
  Widget build(BuildContext context) {
    if (shots.isEmpty) {
      return const Center(
        child: Text('No screenshots for this task yet'),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: shots.length,
      itemBuilder: (context, index) {
        final shot = shots[index];
        final file = File(shot.filePath);
        return AppPanel(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () => openScreenshotViewer(
              context,
              filePath: shot.filePath,
              takenAt: shot.takenAt,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: file.existsSync()
                      ? Image.file(file, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.broken_image_outlined)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    Formatters.dateTime(shot.takenAt),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KeysTab extends StatelessWidget {
  const _KeysTab({required this.keys});

  final List<KeystrokeCount> keys;

  @override
  Widget build(BuildContext context) {
    if (keys.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No keystroke data yet.\n'
            'Start tracking and type while ጊዜCare is focused — '
            'keys are ranked by frequency when you stop.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final max = keys.first.count.toDouble().clamp(1, double.infinity);
    final total = keys.fold<int>(0, (sum, k) => sum + k.count);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Key usage',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    '$total presses · ${keys.length} keys',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (var index = 0; index < keys.length; index++) ...[
                if (index > 0) const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${index + 1}. ${keys[index].keyLabel}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      '${keys[index].count}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: keys[index].count / max,
                    minHeight: 8,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
