import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/clock/presentation/providers/world_clock_controller.dart';

class WorldClockTab extends ConsumerWidget {
  const WorldClockTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(worldClockControllerProvider);
    final timeFormat = DateFormat.jm();
    final dateFormat = DateFormat.MMMd();

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _addCity(context, ref, state.cityIds),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add city'),
          ),
        ),
        const SizedBox(height: 16),
        if (state.entries.isEmpty)
          const AppPanel(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('Loading world clocks…')),
            ),
          )
        else
          for (final entry in state.entries) ...[
            AppPanel(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.city.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          [
                            if (entry.city.region.isNotEmpty) entry.city.region,
                            entry.offsetLabel,
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeFormat.format(entry.localTime),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        dateFormat.format(entry.localTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Remove',
                    onPressed: () => ref
                        .read(worldClockControllerProvider.notifier)
                        .removeCity(entry.city.id),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  Future<void> _addCity(
    BuildContext context,
    WidgetRef ref,
    List<String> existing,
  ) async {
    final available =
        curatedWorldCities.where((c) => !existing.contains(c.id)).toList();
    if (available.isEmpty) {
      AppSnackBar.show(context, 'All curated cities are already added');
      return;
    }
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Add city'),
          children: [
            for (final city in available)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, city.id),
                child: Text('${city.name} · ${city.region}'),
              ),
          ],
        );
      },
    );
    if (selected != null) {
      await ref.read(worldClockControllerProvider.notifier).addCity(selected);
    }
  }
}
