import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';

/// Projects CRUD with search and color picker.
class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(allProjectsProvider);
    final query = ref.watch(projectSearchProvider).trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Projects',
          subtitle: 'Contracts and work you track',
          actions: [
            FilledButton.icon(
              onPressed: () => _openEditor(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Project'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search projects…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) =>
                ref.read(projectSearchProvider.notifier).state = value,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: projectsAsync.when(
            data: (projects) {
              final filtered = projects
                  .where(
                    (p) =>
                        p.name.toLowerCase().contains(query) ||
                        (p.clientName?.toLowerCase().contains(query) ?? false),
                  )
                  .toList();
              if (filtered.isEmpty) {
                return const Center(child: Text('No projects found'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final project = filtered[index];
                  return AppPanel(
                    onTap: () => context.go(
                      AppRoutes.projectDetailPath(project.id),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: project.color),
                      title: Text(project.name),
                      subtitle: Text(
                        [
                          if (project.clientName != null) project.clientName!,
                          project.archived ? 'Archived' : 'Active',
                          if (project.hourlyRate != null)
                            '\$${project.hourlyRate!.toStringAsFixed(2)}/hr',
                        ].join(' · '),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () =>
                                _openEditor(context, ref, project: project),
                          ),
                          IconButton(
                            tooltip: project.archived ? 'Delete' : 'Archive',
                            icon: Icon(
                              project.archived
                                  ? Icons.delete_outline
                                  : Icons.archive_outlined,
                            ),
                            onPressed: () async {
                              final repo = ref.read(projectRepositoryProvider);
                              if (project.archived) {
                                await repo.delete(project.id);
                              } else {
                                await repo.archive(project.id);
                              }
                            },
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
    Project? project,
  }) async {
    final nameController = TextEditingController(text: project?.name ?? '');
    final clientController =
        TextEditingController(text: project?.clientName ?? '');
    final rateController = TextEditingController(
      text: project?.hourlyRate?.toStringAsFixed(2) ?? '',
    );
    final limitController = TextEditingController(
      text: '${project?.weeklyLimitHours ?? 40}',
    );
    var color = project?.color ?? AppColors.projectPalette.first;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: Text(project == null ? 'New Project' : 'Edit Project'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Contract title',
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: clientController,
                        decoration: const InputDecoration(
                          labelText: 'Client name',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: rateController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Hourly rate',
                          prefixText: '\$ ',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: limitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weekly limit (hours)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Color',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final c in AppColors.projectPalette)
                            InkWell(
                              onTap: () => setLocal(() => color = c),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: color == c
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
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
            );
          },
        );
      },
    );

    if (saved != true) return;
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    final client = clientController.text.trim();
    final rate = double.tryParse(rateController.text.trim());
    final limit = int.tryParse(limitController.text.trim()) ?? 40;
    final repo = ref.read(projectRepositoryProvider);
    if (project == null) {
      await repo.create(
        name: name,
        color: color,
        clientName: client.isEmpty ? null : client,
        hourlyRate: rate,
        weeklyLimitHours: limit,
      );
    } else {
      await repo.update(
        project.copyWith(
          name: name,
          color: color,
          clientName: client.isEmpty ? null : client,
          hourlyRate: rate,
          weeklyLimitHours: limit,
          clearClientName: client.isEmpty,
          clearHourlyRate: rateController.text.trim().isEmpty,
        ),
      );
    }
  }
}
