import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';
import 'package:gizecare/features/tracker/domain/entities/live_time_entries.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_provider.dart';
import 'package:gizecare/features/tracker/presentation/widgets/idle_return_dialog.dart';

/// Home: workday hub overview — time spine plus workspace tools.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerControllerProvider);
    final todayAsync = ref.watch(todayEntriesProvider);
    final weekAsync = ref.watch(weekEntriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final scheme = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 960;

    ref.listen(timerControllerProvider, (prev, next) {
      if (next.pendingIdlePrompt && !(prev?.pendingIdlePrompt ?? false)) {
        showIdleReturnDialog(context, ref);
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

    return Listener(
      onPointerDown: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
      onPointerMove: (_) =>
          ref.read(timerControllerProvider.notifier).recordPointer(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppConstants.tagline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppConstants.taglineSupporting,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TimerHero(
                    elapsed: timer.elapsed,
                    isRunning: timer.isRunning,
                    hasSession: timer.hasSession,
                    projectName: timer.projectName,
                    taskName: timer.taskName,
                    onOpenTracker: () => context.go(AppRoutes.tracker),
                    onStart: () async {
                      final started = await startFromLastSelection(ref);
                      if (!context.mounted) return;
                      if (started) {
                        context.go(AppRoutes.tracker);
                      } else {
                        context.go(AppRoutes.tracker);
                        AppSnackBar.show(
                          context,
                          'Choose a project to start tracking',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (wide)
                    Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: 'Today',
                            value: Formatters.hoursCompact(
                              Duration(seconds: todaySeconds),
                            ),
                            caption: 'Hours logged today',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricTile(
                            label: 'This week',
                            value: Formatters.hoursCompact(
                              Duration(seconds: weekSeconds),
                            ),
                            caption: 'Hours since Monday',
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _MetricTile(
                      label: 'Today',
                      value: Formatters.hoursCompact(
                        Duration(seconds: todaySeconds),
                      ),
                      caption: 'Hours logged today',
                    ),
                    const SizedBox(height: 12),
                    _MetricTile(
                      label: 'This week',
                      value: Formatters.hoursCompact(
                        Duration(seconds: weekSeconds),
                      ),
                      caption: 'Hours since Monday',
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _ProjectsSection(
                            projectsAsync: projectsAsync,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _WorkspaceShortcuts(),
                        ),
                      ],
                    )
                  else ...[
                    _ProjectsSection(projectsAsync: projectsAsync),
                    const SizedBox(height: 16),
                    const _WorkspaceShortcuts(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerHero extends StatelessWidget {
  const _TimerHero({
    required this.elapsed,
    required this.isRunning,
    required this.hasSession,
    required this.onOpenTracker,
    required this.onStart,
    this.projectName,
    this.taskName,
  });

  final Duration elapsed;
  final bool isRunning;
  final bool hasSession;
  final String? projectName;
  final String? taskName;
  final VoidCallback onOpenTracker;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusLabel = !hasSession
        ? 'Ready to track'
        : (isRunning ? 'Tracking now' : 'Paused');
    final detail = !hasSession
        ? 'Start a session on a project to capture billable or focused time.'
        : '${projectName ?? 'Project'}'
            '${taskName != null ? ' · $taskName' : ''}';

    return AppPanel(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRunning
                      ? AppColors.brand
                      : scheme.onSurfaceVariant.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                statusLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.duration(elapsed),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: hasSession ? onOpenTracker : onStart,
                icon: Icon(
                  hasSession
                      ? (isRunning
                          ? Icons.timer_rounded
                          : Icons.play_arrow_rounded)
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  hasSession
                      ? (isRunning ? 'Open Tracker' : 'Resume in Tracker')
                      : 'Start tracking',
                ),
              ),
              if (hasSession)
                OutlinedButton(
                  onPressed: onOpenTracker,
                  child: const Text('View session'),
                )
              else
                OutlinedButton(
                  onPressed: () => context.go(AppRoutes.projects),
                  child: const Text('Set up a project'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({required this.projectsAsync});

  final AsyncValue<List<Project>> projectsAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Continue working',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.projects),
                  child: const Text('All projects'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jump into a project and open the tracker.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No projects yet. Create one to start measuring your work.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.tonalIcon(
                        onPressed: () => context.go(AppRoutes.projects),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Create project'),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  for (final project in projects.take(5))
                    ListTile(
                      contentPadding: const EdgeInsets.only(right: 4),
                      leading: CircleAvatar(
                        backgroundColor: project.color,
                        radius: 11,
                      ),
                      title: Text(
                        project.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: project.clientName == null ||
                              project.clientName!.trim().isEmpty
                          ? null
                          : Text(project.clientName!),
                      trailing: IconButton.filledTonal(
                        tooltip: 'Track this project',
                        onPressed: () => context.go(AppRoutes.tracker),
                        icon: const Icon(Icons.play_arrow_rounded),
                      ),
                      onTap: () =>
                          context.go(AppRoutes.projectDetailPath(project.id)),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Could not load projects: $e'),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceShortcuts extends StatelessWidget {
  const _WorkspaceShortcuts();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workspace',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything around your time — notes, tasks, and reports.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          _ShortcutTile(
            icon: Icons.sticky_note_2_outlined,
            title: 'Notes',
            subtitle: 'Capture context while you work',
            onTap: () => context.go(AppRoutes.notebook),
          ),
          _ShortcutTile(
            icon: Icons.checklist_outlined,
            title: 'Tasks',
            subtitle: 'Plan work on your boards',
            onTap: () => context.go(AppRoutes.tasks),
          ),
          _ShortcutTile(
            icon: Icons.bar_chart_outlined,
            title: 'Reports',
            subtitle: 'Review hours by project',
            onTap: () => context.go(AppRoutes.reports),
          ),
          _ShortcutTile(
            icon: Icons.timer_outlined,
            title: 'Tracker',
            subtitle: 'Full session controls',
            onTap: () => context.go(AppRoutes.tracker),
          ),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
