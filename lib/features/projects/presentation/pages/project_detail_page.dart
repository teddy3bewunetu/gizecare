import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/project_detail_provider.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/presentation/widgets/project_board_tab.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Upwork-style contract / project detail with Overview, Timesheet, Tasks, Details.
class ProjectDetailPage extends ConsumerStatefulWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  DateTime _weekStart = Formatters.startOfWeek(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectByIdProvider(widget.projectId));
    final entriesAsync = ref.watch(projectEntriesProvider(widget.projectId));
    final tasksAsync = ref.watch(projectTasksProvider(widget.projectId));
    final scheme = Theme.of(context).colorScheme;

    return projectAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (project) {
        if (project == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Project not found'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(AppRoutes.projects),
                  child: const Text('Back to projects'),
                ),
              ],
            ),
          );
        }

        final entries = entriesAsync.maybeWhen(
          data: (e) => e,
          orElse: () => const <TimeEntry>[],
        );
        final tasks = tasksAsync.maybeWhen(
          data: (t) => t,
          orElse: () => const <TaskItem>[],
        );
        final stats = computeProjectStats(
          entries,
          weekStartOverride: _weekStart,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => context.go(AppRoutes.projects),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Contract',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'New note',
                    onPressed: () => context.go(
                      AppRoutes.notebookCreatePath(projectId: project.id),
                    ),
                    icon: const Icon(Icons.note_add_outlined),
                  ),
                  IconButton(
                    tooltip: 'Edit contract',
                    onPressed: () => _editContract(project),
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: AppPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: project.color,
                          child: Text(
                            _initial(project.clientName ?? project.name),
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.clientName ?? 'No client set',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                DateFormat('EEE h:mm a').format(DateTime.now()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        if (project.archived)
                          Chip(
                            label: const Text('Archived'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor:
                                scheme.errorContainer.withValues(alpha: 0.4),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: TabBar(
                controller: _tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: scheme.primary,
                unselectedLabelColor: scheme.onSurfaceVariant,
                indicatorColor: scheme.primary,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Timesheet'),
                  Tab(text: 'Board'),
                  Tab(text: 'Contract details'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _OverviewTab(
                    project: project,
                    stats: stats,
                    tasks: tasks,
                    entries: entries,
                    onOpenTracker: () => _openTracker(project),
                    onAddManual: () => _addManualTime(project),
                    onViewTimesheet: () => _tabs.animateTo(1),
                    onNewTask: () => _addTask(project),
                  ),
                  _TimesheetTab(
                    project: project,
                    stats: stats,
                    weekStart: _weekStart,
                    onWeekChanged: (w) => setState(() => _weekStart = w),
                    onAddManual: () => _addManualTime(project),
                  ),
                  ProjectBoardTab(project: project),
                  _DetailsTab(
                    project: project,
                    onEdit: () => _editContract(project),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openTracker(Project project) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.lastProjectId, project.id);
    final mode = ref.read(windowModeServiceProvider);
    await mode.enterCompact();
    if (mounted) context.go(AppRoutes.compact);
  }

  Future<void> _addTask(Project project) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Activity / task name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (ok != true || controller.text.trim().isEmpty) return;
    await ref.read(taskRepositoryProvider).create(
          projectId: project.id,
          name: controller.text.trim(),
        );
  }

  Future<void> _addManualTime(Project project) async {
    final hoursController = TextEditingController(text: '1');
    final notesController = TextEditingController();
    DateTime day = Formatters.startOfDay(DateTime.now());
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Add time manually'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(DateFormat.yMMMd().format(day)),
                      trailing: const Icon(Icons.calendar_today_rounded),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: day,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (picked != null) {
                          setLocal(() => day = Formatters.startOfDay(picked));
                        }
                      },
                    ),
                    TextField(
                      controller: hoursController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        hintText: 'e.g. 1.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                  ],
                ),
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
    if (ok != true) return;
    final hours = double.tryParse(hoursController.text.trim()) ?? 0;
    if (hours <= 0) return;
    final seconds = (hours * 3600).round();
    final start = day.add(const Duration(hours: 9));
    final entry = TimeEntry(
      id: const Uuid().v4(),
      projectId: project.id,
      startTime: start,
      endTime: start.add(Duration(seconds: seconds)),
      durationSeconds: seconds,
      isManual: true,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );
    await ref.read(timeEntryRepositoryProvider).create(entry);
  }

  Future<void> _editContract(Project project) async {
    final name = TextEditingController(text: project.name);
    final client = TextEditingController(text: project.clientName ?? '');
    final description =
        TextEditingController(text: project.description ?? '');
    final rate = TextEditingController(
      text: project.hourlyRate?.toStringAsFixed(2) ?? '',
    );
    final limit = TextEditingController(
      text: '${project.weeklyLimitHours ?? 40}',
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit contract'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: client,
                  decoration: const InputDecoration(labelText: 'Client'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: rate,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Hourly rate',
                    prefixText: '\$ ',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: limit,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weekly limit (hours)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: description,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
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
      ),
    );
    if (ok != true || name.text.trim().isEmpty) return;
    final updated = project.copyWith(
      name: name.text.trim(),
      clientName: client.text.trim().isEmpty ? null : client.text.trim(),
      description:
          description.text.trim().isEmpty ? null : description.text.trim(),
      hourlyRate: double.tryParse(rate.text.trim()),
      weeklyLimitHours: int.tryParse(limit.text.trim()) ?? 40,
      clearClientName: client.text.trim().isEmpty,
      clearDescription: description.text.trim().isEmpty,
      clearHourlyRate: rate.text.trim().isEmpty,
    );
    await ref.read(projectRepositoryProvider).update(updated);
  }
}

String _initial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed[0].toUpperCase();
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.project,
    required this.stats,
    required this.tasks,
    required this.entries,
    required this.onOpenTracker,
    required this.onAddManual,
    required this.onViewTimesheet,
    required this.onNewTask,
  });

  final Project project;
  final ProjectTimeStats stats;
  final List<TaskItem> tasks;
  final List<TimeEntry> entries;
  final VoidCallback onOpenTracker;
  final VoidCallback onAddManual;
  final VoidCallback onViewTimesheet;
  final VoidCallback onNewTask;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final earnings = stats.earningsThisWeek(project.hourlyRate);
    final limit = project.weeklyLimitHours ?? 40;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        AppPanel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 28,
                  runSpacing: 20,
                  children: [
                    _MetricBlock(
                      label: 'Earnings this week',
                      value: Formatters.money(earnings),
                      subtitle: project.hourlyRate == null
                          ? 'Set an hourly rate to estimate'
                          : 'Estimated from tracked time',
                    ),
                    _MetricBlock(
                      label: "Contract's rate",
                      value: project.hourlyRate == null
                          ? '—'
                          : '${Formatters.money(project.hourlyRate!)} /hr',
                    ),
                    _MetricBlock(
                      label: "This week's tracked",
                      value: Formatters.hoursHm(stats.thisWeek),
                      subtitle: 'of $limit hrs weekly limit',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: onOpenTracker,
                      child: const Text('Open time tracker'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: onAddManual,
                      child: const Text('Add time manually'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onViewTimesheet,
                      child: const Text('View timesheet'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'To-dos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: onNewTask,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('New'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (tasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            'No tasks yet — add activities to track against',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...tasks.take(8).map(
                            (t) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.check_box_outline_blank_rounded,
                                color: scheme.primary,
                              ),
                              title: Text(t.name),
                              subtitle: t.description == null
                                  ? null
                                  : Text(t.description!),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent sessions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    if (entries.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            'No time recorded yet',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      )
                    else
                      ...entries.take(6).map((e) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            Formatters.dateTime(e.startTime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            e.isManual ? 'Manual' : 'Tracked'
                            '${e.notes == null ? '' : ' · ${e.notes}'}',
                          ),
                          trailing: Text(
                            Formatters.hoursHm(
                              Duration(seconds: e.durationSeconds),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimesheetTab extends StatelessWidget {
  const _TimesheetTab({
    required this.project,
    required this.stats,
    required this.weekStart,
    required this.onWeekChanged,
    required this.onAddManual,
  });

  final Project project;
  final ProjectTimeStats stats;
  final DateTime weekStart;
  final ValueChanged<DateTime> onWeekChanged;
  final VoidCallback onAddManual;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final weekEnd = weekStart.add(const Duration(days: 6));
    final maxDay = stats.weekDaySeconds.fold<int>(0, (a, b) => a > b ? a : b);
    final limit = project.weeklyLimitHours ?? 40;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        Row(
          children: [
            _StatCard(
              label: 'Last 24 hours',
              value: Formatters.hoursHm(stats.last24h),
              subtitle: stats.lastWorkedAt == null
                  ? null
                  : 'Last worked ${_relative(stats.lastWorkedAt!)}',
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'This week',
              value: Formatters.hoursHm(stats.thisWeek),
              subtitle: 'of $limit hrs weekly limit',
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Last week',
              value: Formatters.hoursHm(stats.lastWeek),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Since start',
              value: Formatters.hoursHm(stats.sinceStart),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Work diary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: onAddManual,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add time'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => onWeekChanged(
                      weekStart.subtract(const Duration(days: 7)),
                    ),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    '${DateFormat.MMMd().format(weekStart)} – '
                    '${DateFormat.MMMd().format(weekEnd)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                    onPressed: () => onWeekChanged(
                      weekStart.add(const Duration(days: 7)),
                    ),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        onWeekChanged(Formatters.startOfWeek(DateTime.now())),
                    child: const Text('This week'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: _MiniCalendar(
                      focusedMonth: weekStart,
                      selectedStart: weekStart,
                      selectedEnd: weekEnd,
                      dayHasTracked: {
                        for (var i = 0; i < 7; i++)
                          if (stats.weekDaySeconds[i] > 0)
                            weekStart.add(Duration(days: i)).day: true,
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 0; i < 7; i++) ...[
                          _DayBarRow(
                            date: weekStart.add(Duration(days: i)),
                            seconds: stats.weekDaySeconds[i],
                            maxSeconds: maxDay == 0 ? 1 : maxDay,
                          ),
                          if (i < 6) const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _LegendStat(
                    color: scheme.primary,
                    icon: Icons.circle,
                    label: 'Tracked',
                    value: Formatters.hoursHm(stats.trackedThisWeek),
                  ),
                  _LegendStat(
                    color: scheme.tertiary,
                    icon: Icons.change_history_rounded,
                    label: 'Manual',
                    value: Formatters.hoursHm(stats.manualThisWeek),
                  ),
                  _LegendStat(
                    color: scheme.error,
                    icon: Icons.square_rounded,
                    label: 'Overtime',
                    value: Formatters.hoursHm(
                      stats.thisWeek.inHours > limit
                          ? stats.thisWeek - Duration(hours: limit)
                          : Duration.zero,
                    ),
                  ),
                  if (project.hourlyRate != null)
                    Text(
                      'Total amount  '
                      '${Formatters.money(stats.earningsThisWeek(project.hourlyRate))}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _relative(DateTime at) {
    final d = DateTime.now().difference(at);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes} minutes ago';
    if (d.inHours < 24) return '${d.inHours} hours ago';
    return DateFormat.MMMd().add_jm().format(at);
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.project, required this.onEdit});

  final Project project;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      project.description?.trim().isNotEmpty == true
                          ? project.description!
                          : 'No description yet. Edit the contract to add one.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Contract type',
                      value: project.contractType ?? 'Hourly',
                    ),
                    _SummaryRow(
                      label: 'Rate',
                      value: project.hourlyRate == null
                          ? '—'
                          : '${Formatters.money(project.hourlyRate!)} /hr',
                    ),
                    _SummaryRow(
                      label: 'Weekly limit',
                      value: '${project.weeklyLimitHours ?? 40} hrs/week',
                    ),
                    _SummaryRow(
                      label: 'Manual time',
                      value: 'Manual time allowed',
                    ),
                    _SummaryRow(
                      label: 'Start date',
                      value: DateFormat.yMMMd().format(project.createdAt),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: onEdit,
                      child: const Text('Edit details'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Track with clarity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Screenshots are captured automatically '
                      'while the timer runs for this contract.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPanel(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayBarRow extends StatelessWidget {
  const _DayBarRow({
    required this.date,
    required this.seconds,
    required this.maxSeconds,
  });

  final DateTime date;
  final int seconds;
  final int maxSeconds;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fraction = (seconds / maxSeconds).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            '${date.day} ${DateFormat.EEEE().format(date)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 14,
              child: Stack(
                children: [
                  Container(color: scheme.surfaceContainerHighest),
                  FractionallySizedBox(
                    widthFactor: fraction == 0 ? 0 : fraction.clamp(0.04, 1),
                    child: Container(color: scheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 72,
          child: Text(
            Formatters.hoursHm(Duration(seconds: seconds)),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _LegendStat extends StatelessWidget {
  const _LegendStat({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text('$label  $value'),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
        ),
      ],
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({
    required this.focusedMonth,
    required this.selectedStart,
    required this.selectedEnd,
    required this.dayHasTracked,
  });

  final DateTime focusedMonth;
  final DateTime selectedStart;
  final DateTime selectedEnd;
  final Map<int, bool> dayHasTracked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(focusedMonth.year, focusedMonth.month);
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMM().format(first),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
              Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lead + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            if (index < lead) return const SizedBox.shrink();
            final day = index - lead + 1;
            final date = DateTime(first.year, first.month, day);
            final inWeek = !date.isBefore(selectedStart) &&
                !date.isAfter(selectedEnd);
            final tracked = dayHasTracked[day] == true;
            return Container(
              decoration: BoxDecoration(
                color: inWeek
                    ? scheme.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$day', style: Theme.of(context).textTheme.bodySmall),
                  if (tracked)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.circle, size: 10, color: scheme.primary),
            const SizedBox(width: 4),
            Text('Tracked', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
