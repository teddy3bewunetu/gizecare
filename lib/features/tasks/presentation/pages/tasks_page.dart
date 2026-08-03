import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tasks/presentation/providers/task_detail_provider.dart';
import 'package:gizecare/features/tasks/presentation/providers/tasks_provider.dart';

/// Tasks CRUD with project filter, search, and summarized hours.
class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final hoursAsync = ref.watch(taskHoursMapProvider);
    final weekHoursAsync = ref.watch(taskWeekHoursMapProvider);
    final selectedProjectId = ref.watch(selectedTaskProjectIdProvider);
    final query = ref.watch(taskSearchProvider).trim().toLowerCase();
    final hours = hoursAsync.valueOrNull ?? const <String, Duration>{};
    final weekHours = weekHoursAsync.valueOrNull ?? const <String, Duration>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Tasks',
          subtitle: 'Trackable work across projects — open a project for the board',
          actions: [
            FilledButton.icon(
              onPressed: () => _openEditor(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Task'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search tasks…',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (value) =>
                      ref.read(taskSearchProvider.notifier).state = value,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 240,
                child: projectsAsync.when(
                  data: (projects) => DropdownButtonFormField<String?>(
                    value: selectedProjectId,
                    decoration: const InputDecoration(labelText: 'Project'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All projects'),
                      ),
                      for (final p in projects)
                        DropdownMenuItem(value: p.id, child: Text(p.name)),
                    ],
                    onChanged: (value) => ref
                        .read(selectedTaskProjectIdProvider.notifier)
                        .state = value,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              final filtered = tasks
                  .where((t) => t.name.toLowerCase().contains(query))
                  .toList();
              if (filtered.isEmpty) {
                return const Center(child: Text('No tasks found'));
              }
              final projects = projectsAsync.maybeWhen(
                data: (p) => {for (final x in p) x.id: x.name},
                orElse: () => <String, String>{},
              );
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final task = filtered[index];
                  final total = hours[task.id] ?? Duration.zero;
                  final week = weekHours[task.id] ?? Duration.zero;
                  return AppPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      onTap: () =>
                          context.go(AppRoutes.taskDetailPath(task.id)),
                      title: Text(task.name),
                      subtitle: Text(
                        [
                          projects[task.projectId] ?? 'Project',
                          if (task.priority != TaskPriority.none)
                            task.priority.label,
                          if (task.dueAt != null)
                            'Due ${task.dueAt!.month}/${task.dueAt!.day}',
                          if (task.description?.isNotEmpty == true)
                            task.description!,
                          'Week ${Formatters.hoursCompact(week)}',
                        ].join(' · '),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.hoursHm(total),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'total',
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
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () =>
                                _openEditor(context, ref, task: task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(taskRepositoryProvider)
                                .delete(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    TaskItem? task,
  }) async {
    final projects =
        await ref.read(projectRepositoryProvider).getProjects();
    if (projects.isFailure || projects.requireValue.isEmpty) {
      if (context.mounted) {
        AppSnackBar.show(context, 'Create a project first');
      }
      return;
    }
    final list = projects.requireValue;
    var projectId = task?.projectId ?? list.first.id;
    final nameController = TextEditingController(text: task?.name ?? '');
    final descController =
        TextEditingController(text: task?.description ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: Text(task == null ? 'New Task' : 'Edit Task'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: projectId,
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: [
                        for (final p in list)
                          DropdownMenuItem(value: p.id, child: Text(p.name)),
                      ],
                      onChanged: task == null
                          ? (value) => setLocal(() => projectId = value!)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
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

    if (saved != true) return;
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(taskRepositoryProvider);
    if (task == null) {
      await repo.create(
        projectId: projectId,
        name: name,
        description: descController.text.trim(),
      );
    } else {
      await repo.update(
        task.copyWith(
          name: name,
          description: descController.text.trim(),
        ),
      );
    }
  }
}
