import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/reports/domain/entities/feature_usage.dart';
import 'package:gizecare/features/reports/domain/entities/system_metric_sample.dart';
import 'package:gizecare/features/reports/presentation/providers/system_metrics_providers.dart';

/// Host RAM / CPU / disk plus in-app feature usage for the selected range.
class SystemReportsTab extends ConsumerWidget {
  const SystemReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep background capture warm while this tab (or Reports) is open.
    ref.watch(systemMetricsCaptureControllerProvider);
    final liveAsync = ref.watch(liveSystemMetricsProvider);
    final historyAsync = ref.watch(systemMetricsHistoryProvider);
    final featureAsync = ref.watch(featureUsageSummariesProvider);
    final range = ref.watch(systemHistoryRangeProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
          child: Row(
            children: [
              Text(
                'Host & app usage',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              SegmentedButton<SystemHistoryRange>(
                segments: const [
                  ButtonSegment(
                    value: SystemHistoryRange.hours6,
                    label: Text('6h'),
                  ),
                  ButtonSegment(
                    value: SystemHistoryRange.hours24,
                    label: Text('24h'),
                  ),
                  ButtonSegment(
                    value: SystemHistoryRange.days7,
                    label: Text('7d'),
                  ),
                ],
                selected: {range},
                onSelectionChanged: (value) {
                  ref.read(systemHistoryRangeProvider.notifier).state =
                      value.first;
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: liveAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Could not read host metrics: $e')),
            data: (live) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (live.hostname != null || live.platformLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          [
                            if (live.hostname != null) live.hostname!,
                            if (live.platformLabel != null) live.platformLabel!,
                          ].join(' · '),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricGauge(
                            label: 'Memory',
                            valueLabel:
                                '${_fmtMb(live.ramUsedMb)} / ${_fmtMb(live.ramTotalMb)}',
                            percent: live.ramPercent,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricGauge(
                            label: 'CPU',
                            valueLabel:
                                '${live.cpuPercent.toStringAsFixed(0)}%',
                            percent: live.cpuPercent,
                            color: scheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricGauge(
                            label: 'Storage (/)',
                            valueLabel:
                                '${_fmtMb(live.diskUsedMb)} / ${_fmtMb(live.diskTotalMb)}',
                            percent: live.diskPercent,
                            color: scheme.secondary,
                          ),
                        ),
                        if (live.loadAvg1 != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Load avg',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    live.loadAvg1!.toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  Text(
                                    '1 minute',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    featureAsync.when(
                      loading: () => const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('Feature usage error: $e'),
                      data: (summaries) => _FeatureUsagePanel(
                        summaries: summaries,
                      ),
                    ),
                    const SizedBox(height: 16),
                    historyAsync.when(
                      loading: () => const SizedBox(
                        height: 220,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('History error: $e'),
                      data: (history) => AppPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Host metrics over time',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'RAM, CPU, and storage samples while ጊዜCare runs.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 240,
                              child: history.length < 2
                                  ? const Center(
                                      child: Text(
                                        'Collecting samples… keep this tab open briefly.',
                                      ),
                                    )
                                  : _HistoryChart(samples: history),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static String _fmtMb(int mb) {
    if (mb >= 1024 * 1024) {
      return '${(mb / (1024 * 1024)).toStringAsFixed(1)} TB';
    }
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(1)} GB';
    }
    return '$mb MB';
  }
}

class _FeatureUsagePanel extends StatelessWidget {
  const _FeatureUsagePanel({required this.summaries});

  final List<FeatureUsageSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxMs = summaries.isEmpty
        ? 1
        : summaries
            .map((s) => s.totalDurationMs)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1, 1 << 62);

    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature & page usage',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Time spent in each ጊዜCare area, with average host RAM/CPU while '
            'that page was open. A visit is recorded when you leave a page.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          if (summaries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No feature visits yet — switch between pages and come back.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            )
          else
            ...summaries.take(12).map((s) {
              final fraction = (s.totalDurationMs / maxMs).clamp(0.0, 1.0);
              final metrics = <String>[
                if (s.avgRamPercent != null)
                  'RAM ${s.avgRamPercent!.round()}%',
                if (s.avgCpuPercent != null)
                  'CPU ${s.avgCpuPercent!.round()}%',
              ].join(' · ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.featureLabel,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Text(
                          _fmtDuration(s.totalDuration),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${s.visitCount} visit${s.visitCount == 1 ? '' : 's'}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                    if (metrics.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Avg $metrics',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 8,
                        color: scheme.primary,
                        backgroundColor: scheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  static String _fmtDuration(Duration d) {
    if (d.inHours >= 1) {
      final m = d.inMinutes.remainder(60);
      return m > 0 ? '${d.inHours}h ${m}m' : '${d.inHours}h';
    }
    if (d.inMinutes >= 1) {
      final s = d.inSeconds.remainder(60);
      return s >= 10 ? '${d.inMinutes}m ${s}s' : '${d.inMinutes}m';
    }
    return '${d.inSeconds}s';
  }
}

class _MetricGauge extends StatelessWidget {
  const _MetricGauge({
    required this.label,
    required this.valueLabel,
    required this.percent,
    required this.color,
  });

  final String label;
  final String valueLabel;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0, 100) / 100.0;
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          Text(
            valueLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 10,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${percent.clamp(0, 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _HistoryChart extends StatelessWidget {
  const _HistoryChart({required this.samples});

  final List<SystemMetricSample> samples;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ramSpots = <FlSpot>[];
    final cpuSpots = <FlSpot>[];
    final diskSpots = <FlSpot>[];
    for (var i = 0; i < samples.length; i++) {
      final s = samples[i];
      final x = i.toDouble();
      ramSpots.add(FlSpot(x, s.ramPercent.clamp(0, 100)));
      cpuSpots.add(FlSpot(x, s.cpuPercent.clamp(0, 100)));
      diskSpots.add(FlSpot(x, s.diskPercent.clamp(0, 100)));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => scheme.surfaceContainerHighest,
            getTooltipItems: (touchedSpots) {
              const labels = ['RAM', 'CPU', 'Disk'];
              return [
                for (final spot in touchedSpots)
                  LineTooltipItem(
                    '${labels[spot.barIndex.clamp(0, 2)]} '
                    '${spot.y.round()}%',
                    TextStyle(
                      color: spot.bar.color ?? scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
              ];
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 25,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}%',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: (samples.length / 4).clamp(1, 999).toDouble(),
              getTitlesWidget: (v, _) {
                final i = v.round();
                if (i < 0 || i >= samples.length) {
                  return const SizedBox.shrink();
                }
                final t = samples[i].capturedAt;
                final label =
                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                return Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall,
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (v) => FlLine(
            color: scheme.outline.withValues(alpha: 0.2),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: ramSpots,
            isCurved: true,
            color: scheme.primary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: cpuSpots,
            isCurved: true,
            color: scheme.tertiary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: diskSpots,
            isCurved: true,
            color: scheme.secondary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
