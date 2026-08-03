import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/tasks/domain/entities/board_column.dart';
import 'package:gizecare/features/tasks/domain/entities/board_snapshot.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tasks/presentation/providers/board_provider.dart';
import 'package:gizecare/features/tasks/presentation/providers/task_detail_provider.dart';
import 'package:gizecare/features/tasks/presentation/widgets/task_card_modal.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Drag payload for Kanban cards.
class _CardDragData {
  const _CardDragData({
    required this.taskId,
    required this.fromColumnId,
  });

  final String taskId;
  final String fromColumnId;
}

/// Per-project Kanban board (and optional list) tab content.
class ProjectBoardTab extends ConsumerWidget {
  const ProjectBoardTab({
    required this.project,
    super.key,
  });

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(boardProvider(project.id));
    final viewMode = ref.watch(projectTasksViewModeProvider(project.id));
    final search = ref.watch(boardSearchProvider(project.id));
    final labelFilter = ref.watch(boardLabelFilterProvider(project.id));
    final weekHours =
        ref.watch(taskWeekHoursMapProvider).valueOrNull ?? const {};

    return boardAsync.when(
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (board) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
              child: _BoardToolbar(
                project: project,
                board: board,
                viewMode: viewMode,
                search: search,
                labelFilter: labelFilter,
              ),
            ),
            Expanded(
              child: viewMode == ProjectTasksViewMode.list
                  ? _BoardListView(
                      project: project,
                      board: board,
                      search: search,
                      labelFilter: labelFilter,
                      weekHours: weekHours,
                    )
                  : _BoardCanvas(
                      project: project,
                      board: board,
                      search: search,
                      labelFilter: labelFilter,
                      weekHours: weekHours,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _BoardToolbar extends ConsumerWidget {
  const _BoardToolbar({
    required this.project,
    required this.board,
    required this.viewMode,
    required this.search,
    required this.labelFilter,
  });

  final Project project;
  final BoardSnapshot board;
  final ProjectTasksViewMode viewMode;
  final String search;
  final Set<String> labelFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search cards…',
                  prefixIcon: Icon(Icons.search_rounded),
                  isDense: true,
                ),
                onChanged: (v) =>
                    ref.read(boardSearchProvider(project.id).notifier).state =
                        v,
              ),
            ),
            const SizedBox(width: 12),
            SegmentedButton<ProjectTasksViewMode>(
              segments: const [
                ButtonSegment(
                  value: ProjectTasksViewMode.board,
                  icon: Icon(Icons.view_kanban_outlined),
                  label: Text('Board'),
                ),
                ButtonSegment(
                  value: ProjectTasksViewMode.list,
                  icon: Icon(Icons.view_list_rounded),
                  label: Text('List'),
                ),
              ],
              selected: {viewMode},
              onSelectionChanged: (s) {
                ref
                    .read(projectTasksViewModeProvider(project.id).notifier)
                    .state = s.first;
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Manage labels',
              onPressed: () => _manageLabels(context, ref),
              icon: const Icon(Icons.label_outline_rounded),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _addColumn(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Column'),
            ),
          ],
        ),
        if (board.labels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final label in board.labels)
                FilterChip(
                  selected: labelFilter.contains(label.id),
                  label: Text(label.name),
                  avatar: CircleAvatar(
                    backgroundColor: label.color,
                    radius: 6,
                  ),
                  onSelected: (selected) {
                    final next = {...labelFilter};
                    if (selected) {
                      next.add(label.id);
                    } else {
                      next.remove(label.id);
                    }
                    ref
                        .read(boardLabelFilterProvider(project.id).notifier)
                        .state = next;
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _addColumn(BuildContext context, WidgetRef ref) async {
    final name = await _promptText(
      context,
      title: 'New column',
      label: 'Column name',
    );
    if (name == null || name.trim().isEmpty) return;
    await ref.read(boardRepositoryProvider).createColumn(
          projectId: project.id,
          name: name.trim(),
        );
  }

  Future<void> _manageLabels(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _LabelsDialog(project: project, labels: board.labels),
    );
  }
}

class _BoardCanvas extends ConsumerWidget {
  const _BoardCanvas({
    required this.project,
    required this.board,
    required this.search,
    required this.labelFilter,
    required this.weekHours,
  });

  final Project project;
  final BoardSnapshot board;
  final String search;
  final Set<String> labelFilter;
  final Map<String, Duration> weekHours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 720;

    if (isNarrow) {
      return PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: board.columns.length,
        itemBuilder: (context, index) {
          final column = board.columns[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 4, 16),
            child: _BoardColumnPane(
              project: project,
              board: board,
              column: column,
              search: search,
              labelFilter: labelFilter,
              weekHours: weekHours,
            ),
          );
        },
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      itemCount: board.columns.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final column = board.columns[index];
        return SizedBox(
          width: 300,
          child: _BoardColumnPane(
            project: project,
            board: board,
            column: column,
            search: search,
            labelFilter: labelFilter,
            weekHours: weekHours,
          ),
        );
      },
    );
  }
}

class _BoardListView extends ConsumerWidget {
  const _BoardListView({
    required this.project,
    required this.board,
    required this.search,
    required this.labelFilter,
    required this.weekHours,
  });

  final Project project;
  final BoardSnapshot board;
  final String search;
  final Set<String> labelFilter;
  final Map<String, Duration> weekHours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnById = {for (final c in board.columns) c.id: c};
    final cards = board.columns
        .expand((c) => board.tasksIn(c.id))
        .where((t) => _matchesFilters(t, board, search, labelFilter))
        .toList();

    if (cards.isEmpty) {
      return const Center(child: Text('No cards match'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = cards[index];
        final col = columnById[task.columnId];
        return AppPanel(
          onTap: () => showTaskCardModal(
            context,
            taskId: task.id,
            project: project,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.name,
                        style: Theme.of(context).textTheme.titleSmall),
                    if (col != null)
                      Text(
                        col.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
              Text(
                Formatters.hoursCompact(weekHours[task.id] ?? Duration.zero),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BoardColumnPane extends ConsumerWidget {
  const _BoardColumnPane({
    required this.project,
    required this.board,
    required this.column,
    required this.search,
    required this.labelFilter,
    required this.weekHours,
  });

  final Project project;
  final BoardSnapshot board;
  final BoardColumn column;
  final String search;
  final Set<String> labelFilter;
  final Map<String, Duration> weekHours;

  Future<void> _move(
    WidgetRef ref,
    _CardDragData data,
    int toIndex,
  ) async {
    await ref.read(boardRepositoryProvider).moveTask(
          taskId: data.taskId,
          toColumnId: column.id,
          toIndex: toIndex,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final cards = board
        .tasksIn(column.id)
        .where((t) => _matchesFilters(t, board, search, labelFilter))
        .toList();
    final overWip =
        column.wipLimit != null && cards.length > column.wipLimit!;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  column.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                '${cards.length}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: overWip
                          ? AppColors.danger
                          : scheme.onSurfaceVariant,
                    ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Column actions',
                onSelected: (value) => _onColumnAction(context, ref, value),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'wip', child: Text('WIP limit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                icon: const Icon(Icons.more_horiz_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DragTarget<_CardDragData>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (details) =>
                  _move(ref, details.data, cards.length),
              builder: (context, candidate, _) {
                final hovering = candidate.isNotEmpty;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: hovering
                        ? scheme.primaryContainer.withValues(alpha: 0.35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: hovering
                        ? Border.all(
                            color: scheme.primary.withValues(alpha: 0.45),
                          )
                        : null,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 8),
                    children: [
                      for (var i = 0; i < cards.length; i++)
                        _KanbanCard(
                          project: project,
                          board: board,
                          task: cards[i],
                          columnId: column.id,
                          index: i,
                          weekHours: weekHours[cards[i].id] ?? Duration.zero,
                          onDropAt: (drag, atIndex) =>
                              _move(ref, drag, atIndex),
                        ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () => _addCard(context, ref),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add card'),
                      ),
                      // Extra drop room at the bottom of the column.
                      const SizedBox(height: 48),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCard(BuildContext context, WidgetRef ref) async {
    final name = await _promptText(
      context,
      title: 'New card',
      label: 'Card title',
    );
    if (name == null || name.trim().isEmpty) return;
    await ref.read(boardRepositoryProvider).createCard(
          projectId: project.id,
          columnId: column.id,
          name: name.trim(),
        );
  }

  Future<void> _onColumnAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final repo = ref.read(boardRepositoryProvider);
    switch (action) {
      case 'rename':
        final name = await _promptText(
          context,
          title: 'Rename column',
          label: 'Name',
          initial: column.name,
        );
        if (name == null || name.trim().isEmpty) return;
        await repo.updateColumn(column.copyWith(name: name.trim()));
      case 'wip':
        final raw = await _promptText(
          context,
          title: 'WIP limit',
          label: 'Max cards (empty to clear)',
          initial: column.wipLimit?.toString() ?? '',
        );
        if (raw == null) return;
        final trimmed = raw.trim();
        if (trimmed.isEmpty) {
          await repo.updateColumn(column.copyWith(clearWipLimit: true));
        } else {
          final n = int.tryParse(trimmed);
          if (n != null && n > 0) {
            await repo.updateColumn(column.copyWith(wipLimit: n));
          }
        }
      case 'delete':
        final others =
            board.columns.where((c) => c.id != column.id).toList();
        if (others.isEmpty) {
          if (context.mounted) {
            AppSnackBar.show(context, 'Keep at least one column');
          }
          return;
        }
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete column?'),
            content: Text(
              'Cards will move to “${others.first.name}”.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (ok == true) {
          await repo.deleteColumn(
            column.id,
            moveTasksToColumnId: others.first.id,
          );
        }
    }
  }
}

class _KanbanCard extends ConsumerWidget {
  const _KanbanCard({
    required this.project,
    required this.board,
    required this.task,
    required this.columnId,
    required this.index,
    required this.weekHours,
    required this.onDropAt,
  });

  final Project project;
  final BoardSnapshot board;
  final TaskItem task;
  final String columnId;
  final int index;
  final Duration weekHours;
  final Future<void> Function(_CardDragData data, int atIndex) onDropAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final labels = (board.labelIdsByTask[task.id] ?? const <String>[])
        .map((id) => board.labels.where((l) => l.id == id))
        .expand((x) => x)
        .toList();
    final progress = board.checklistProgressByTask[task.id];
    final comments = board.commentCountByTask[task.id] ?? 0;
    final dragData = _CardDragData(taskId: task.id, fromColumnId: columnId);
    final cardWidth = MediaQuery.sizeOf(context).width < 720 ? 260.0 : 276.0;

    final face = _CardFace(
      task: task,
      labels: labels,
      progress: progress,
      comments: comments,
      weekHours: weekHours,
      borderColor: scheme.outline.withValues(alpha: 0.25),
    );

    return DragTarget<_CardDragData>(
      onWillAcceptWithDetails: (d) => d.data.taskId != task.id,
      onAcceptWithDetails: (d) => onDropAt(d.data, index),
      builder: (context, candidate, _) {
        return Column(
          children: [
            if (candidate.isNotEmpty)
              Container(
                height: 4,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Draggable<_CardDragData>(
                data: dragData,
                rootOverlay: true,
                feedback: Material(
                  elevation: 8,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: cardWidth,
                    child: Opacity(
                      opacity: 0.95,
                      child: _CardFace(
                        task: task,
                        labels: labels,
                        progress: progress,
                        comments: comments,
                        weekHours: weekHours,
                        highlight: true,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(opacity: 0.3, child: face),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => showTaskCardModal(
                      context,
                      taskId: task.id,
                      project: project,
                    ),
                    onSecondaryTapDown: (details) => _showCardMenu(
                      context,
                      ref,
                      details.globalPosition,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: face,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCardMenu(
    BuildContext context,
    WidgetRef ref,
    Offset position,
  ) async {
    final moveItems = <PopupMenuEntry<String>>[
      for (final col in board.columns)
        if (col.id != columnId)
          PopupMenuItem(
            value: 'move:${col.id}',
            child: Text('Move to ${col.name}'),
          ),
    ];
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        const PopupMenuItem(value: 'open', child: Text('Open')),
        const PopupMenuItem(value: 'timer', child: Text('Start timer')),
        if (moveItems.isNotEmpty) ...[
          const PopupMenuDivider(),
          ...moveItems,
          const PopupMenuDivider(),
        ],
        const PopupMenuItem(value: 'archive', child: Text('Archive')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
    if (selected == null || !context.mounted) return;
    if (selected.startsWith('move:')) {
      final toColumnId = selected.substring(5);
      await ref.read(boardRepositoryProvider).moveTask(
            taskId: task.id,
            toColumnId: toColumnId,
            toIndex: 0,
          );
      return;
    }
    switch (selected) {
      case 'open':
        await showTaskCardModal(
          context,
          taskId: task.id,
          project: project,
        );
      case 'timer':
        await ref.read(timerControllerProvider.notifier).start(
              project: project,
              task: task,
            );
        if (context.mounted) {
          AppSnackBar.show(context, 'Timer started on ${task.name}');
        }
      case 'archive':
        await ref.read(boardRepositoryProvider).archiveTask(task.id);
      case 'delete':
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete card?'),
            content: const Text(
              'Time entries stay; the task link is cleared.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (ok == true) {
          await ref.read(boardRepositoryProvider).deleteTask(task.id);
        }
    }
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.task,
    required this.labels,
    required this.progress,
    required this.comments,
    required this.weekHours,
    this.highlight = false,
    this.borderColor,
  });

  final TaskItem task;
  final List<ProjectLabel> labels;
  final ({int done, int total})? progress;
  final int comments;
  final Duration weekHours;
  final bool highlight;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? scheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (task.coverColor != null)
            Container(height: 6, color: task.coverColor),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labels.isNotEmpty) ...[
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final l in labels)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: l.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: l.color),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  task.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (task.priority != TaskPriority.none)
                      _MetaChip(
                        icon: Icons.flag_rounded,
                        label: task.priority.label,
                        color: _priorityColor(task.priority),
                      ),
                    if (task.dueAt != null)
                      _MetaChip(
                        icon: Icons.event_rounded,
                        label: DateFormat.MMMd().format(task.dueAt!),
                        color: task.dueAt!.isBefore(DateTime.now())
                            ? AppColors.danger
                            : scheme.onSurfaceVariant,
                      ),
                    if (progress != null && progress!.total > 0)
                      _MetaChip(
                        icon: Icons.checklist_rounded,
                        label: '${progress!.done}/${progress!.total}',
                      ),
                    if (comments > 0)
                      _MetaChip(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '$comments',
                      ),
                    _MetaChip(
                      icon: Icons.schedule_rounded,
                      label: Formatters.hoursCompact(weekHours),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.urgent => AppColors.danger,
        TaskPriority.high => AppColors.warning,
        TaskPriority.medium => schemePrimaryFallback,
        TaskPriority.low => AppColors.success,
        TaskPriority.none => Colors.grey,
      };

  // Avoid Theme lookup in pure helper; medium uses cyan brand.
  static const schemePrimaryFallback = Color(0xFF009DFE);
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c),
        ),
      ],
    );
  }
}

class _LabelsDialog extends ConsumerStatefulWidget {
  const _LabelsDialog({required this.project, required this.labels});

  final Project project;
  final List<ProjectLabel> labels;

  @override
  ConsumerState<_LabelsDialog> createState() => _LabelsDialogState();
}

class _LabelsDialogState extends ConsumerState<_LabelsDialog> {
  static const _palette = [
    Color(0xFF009DFE),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF0EA5E9),
    Color(0xFF64748B),
  ];

  @override
  Widget build(BuildContext context) {
    final labelsAsync = ref.watch(taskLabelsProvider(widget.project.id));
    final labels = labelsAsync.valueOrNull ?? widget.labels;

    return AlertDialog(
      title: const Text('Labels'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final label in labels)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: label.color, radius: 10),
                title: Text(label.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref
                      .read(boardRepositoryProvider)
                      .deleteLabel(label.id),
                ),
              ),
            const Divider(),
            FilledButton.tonalIcon(
              onPressed: () async {
                final name = await _promptText(
                  context,
                  title: 'New label',
                  label: 'Name',
                );
                if (name == null || name.trim().isEmpty) return;
                final color = _palette[labels.length % _palette.length];
                await ref.read(boardRepositoryProvider).createLabel(
                      projectId: widget.project.id,
                      name: name.trim(),
                      color: color,
                    );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add label'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

bool _matchesFilters(
  TaskItem task,
  BoardSnapshot board,
  String search,
  Set<String> labelFilter,
) {
  final q = search.trim().toLowerCase();
  if (q.isNotEmpty && !task.name.toLowerCase().contains(q)) {
    return false;
  }
  if (labelFilter.isEmpty) return true;
  final ids = board.labelIdsByTask[task.id] ?? const <String>[];
  return ids.any(labelFilter.contains);
}

Future<String?> _promptText(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _TextPromptDialog(
      title: title,
      label: label,
      initial: initial,
    ),
  );
}

class _TextPromptDialog extends StatefulWidget {
  const _TextPromptDialog({
    required this.title,
    required this.label,
    this.initial = '',
  });

  final String title;
  final String label;
  final String initial;

  @override
  State<_TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<_TextPromptDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.label),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
