import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/projects/presentation/providers/projects_provider.dart';
import 'package:gizecare/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Daily / weekly / monthly reports with charts and CSV export.
class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(reportRangeProvider);
    final entriesAsync = ref.watch(reportEntriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final tasksAsync = ref.watch(tasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Reports',
          subtitle: 'Understand where time goes',
          actions: [
            SegmentedButton<ReportRange>(
              segments: const [
                ButtonSegment(value: ReportRange.daily, label: Text('Daily')),
                ButtonSegment(value: ReportRange.weekly, label: Text('Weekly')),
                ButtonSegment(
                  value: ReportRange.monthly,
                  label: Text('Monthly'),
                ),
              ],
              selected: {range},
              onSelectionChanged: (value) {
                ref.read(reportRangeProvider.notifier).state = value.first;
              },
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final entries = entriesAsync.maybeWhen(
                  data: (e) => e,
                  orElse: () => <TimeEntry>[],
                );
                await _exportCsv(context, entries);
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Export CSV'),
            ),
          ],
        ),
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              final projects = projectsAsync.maybeWhen(
                data: (p) => {for (final x in p) x.id: x},
                orElse: () => <String, Project>{},
              );
              final tasks = tasksAsync.maybeWhen(
                data: (t) => {for (final x in t) x.id: x.name},
                orElse: () => <String, String>{},
              );

              final byProject = <String, int>{};
              final byTask = <String, int>{};
              for (final e in entries) {
                byProject[e.projectId] =
                    (byProject[e.projectId] ?? 0) + e.durationSeconds;
                if (e.taskId != null) {
                  byTask[e.taskId!] =
                      (byTask[e.taskId!] ?? 0) + e.durationSeconds;
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hours by Project',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 220,
                                  child: byProject.isEmpty
                                      ? const Center(child: Text('No data'))
                                      : PieChart(
                                          PieChartData(
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 48,
                                            sections: [
                                              for (final entry
                                                  in byProject.entries)
                                                PieChartSectionData(
                                                  value:
                                                      entry.value.toDouble(),
                                                  title: Formatters.hoursCompact(
                                                    Duration(
                                                      seconds: entry.value,
                                                    ),
                                                  ),
                                                  color: projects[entry.key]
                                                          ?.color ??
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  radius: 60,
                                                ),
                                            ],
                                          ),
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
                                  'Hours by Task',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 220,
                                  child: byTask.isEmpty
                                      ? const Center(child: Text('No data'))
                                      : BarChart(
                                          BarChartData(
                                            titlesData: FlTitlesData(
                                              leftTitles: const AxisTitles(),
                                              topTitles: const AxisTitles(),
                                              rightTitles: const AxisTitles(),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget: (value, _) {
                                                    final keys =
                                                        byTask.keys.toList();
                                                    final i = value.toInt();
                                                    if (i < 0 ||
                                                        i >= keys.length) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    final name =
                                                        tasks[keys[i]] ??
                                                            'Task';
                                                    return Text(
                                                      name.length > 8
                                                          ? '${name.substring(0, 8)}…'
                                                          : name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            barGroups: [
                                              for (var i = 0;
                                                  i < byTask.length;
                                                  i++)
                                                BarChartGroupData(
                                                  x: i,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: (byTask.values
                                                                  .elementAt(
                                                                i,
                                                              ) /
                                                              3600)
                                                          .toDouble(),
                                                      width: 18,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        6,
                                                      ),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _exportCsv(
    BuildContext context,
    List<TimeEntry> entries,
  ) async {
    final buffer = StringBuffer('id,projectId,taskId,start,end,duration,activity,notes\n');
    for (final e in entries) {
      buffer.writeln(
        '${e.id},${e.projectId},${e.taskId ?? ''},${e.startTime.toIso8601String()},'
        '${e.endTime?.toIso8601String() ?? ''},${e.durationSeconds},${e.activityPercentage ?? ''},'
        '"${(e.notes ?? '').replaceAll('"', '""')}"',
      );
    }
    final dir = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final file = File(
      p.join(
        dir.path,
        'gizecare_report_${DateTime.now().millisecondsSinceEpoch}.csv',
      ),
    );
    await file.writeAsString(buffer.toString());
    if (context.mounted) {
      AppSnackBar.show(context, 'Exported to ${file.path}');
    }
  }
}
