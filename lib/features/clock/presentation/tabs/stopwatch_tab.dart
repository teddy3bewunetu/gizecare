import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/clock/domain/entities/stopwatch_lap.dart';
import 'package:gizecare/features/clock/presentation/clock_formatters.dart';
import 'package:gizecare/features/clock/presentation/providers/stopwatch_controller.dart';

class StopwatchTab extends StatelessWidget {
  const StopwatchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: const [
        _StopwatchLivePanel(),
        SizedBox(height: 16),
        _StopwatchLapHistoryHeader(),
        SizedBox(height: 12),
        _StopwatchLapHistory(),
      ],
    );
  }
}

/// Timer, controls, and in-progress laps — rebuilds on every tick.
class _StopwatchLivePanel extends ConsumerWidget {
  const _StopwatchLivePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sw = ref.watch(stopwatchControllerProvider);
    final notifier = ref.read(stopwatchControllerProvider.notifier);

    return AppPanel(
      child: Column(
        children: [
          Text(
            ClockFormatters.stopwatch(sw.elapsed),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              if (!sw.isRunning)
                FilledButton.icon(
                  onPressed: notifier.start,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(sw.isPaused ? 'Resume' : 'Start'),
                ),
              if (sw.isRunning)
                FilledButton.tonalIcon(
                  onPressed: notifier.pause,
                  icon: const Icon(Icons.pause_rounded),
                  label: const Text('Pause'),
                ),
              OutlinedButton.icon(
                onPressed: sw.hasStarted || sw.isRunning || sw.isPaused
                    ? () => notifier.lap()
                    : null,
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Lap'),
              ),
              OutlinedButton.icon(
                onPressed: sw.hasStarted || sw.isRunning || sw.isPaused
                    ? notifier.reset
                    : null,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
              ),
            ],
          ),
          if (sw.currentLaps.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Current session laps',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            for (final lap in sw.currentLaps.reversed)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Lap ${lap.lapIndex}'),
                trailing: Text(
                  ClockFormatters.lapDuration(lap.lapMs),
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                subtitle: Text(
                  'Total ${ClockFormatters.lapDuration(lap.totalMs)}',
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Static header above lap history — never tied to the live timer.
class _StopwatchLapHistoryHeader extends StatelessWidget {
  const _StopwatchLapHistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lap history',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Reset clears the live clock; past sessions stay saved until deleted.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

/// Saved sessions — isolated from stopwatch ticks; only updates on data changes.
class _StopwatchLapHistory extends ConsumerWidget {
  const _StopwatchLapHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(stopwatchSessionsProvider);
    final activeSessionId = ref.watch(
      stopwatchControllerProvider.select((s) => s.sessionId),
    );

    return RepaintBoundary(
      child: sessionsAsync.when(
        skipLoadingOnReload: true,
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('$e'),
        data: (sessions) => _StopwatchLapHistoryList(
          sessions: sessions,
          activeSessionId: activeSessionId,
        ),
      ),
    );
  }
}

class _StopwatchLapHistoryList extends ConsumerWidget {
  const _StopwatchLapHistoryList({
    required this.sessions,
    required this.activeSessionId,
  });

  final List<StopwatchSession> sessions;
  final String? activeSessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = sessions
        .where((s) => s.sessionId != activeSessionId)
        .toList();

    if (history.isEmpty) {
      return const AppPanel(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text('No saved sessions yet')),
        ),
      );
    }

    return Column(
      children: [
        for (final session in history) ...[
          _StopwatchHistorySessionCard(session: session),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _StopwatchHistorySessionCard extends ConsumerWidget {
  const _StopwatchHistorySessionCard({required this.session});

  final StopwatchSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.yMMMd().add_jm().format(session.startedAt),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                ClockFormatters.lapDuration(session.totalMs),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              IconButton(
                tooltip: 'Delete session',
                onPressed: () async {
                  await ref
                      .read(stopwatchRepositoryProvider)
                      .deleteSession(session.sessionId);
                  ref.invalidate(stopwatchSessionsProvider);
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          for (final lap in session.laps)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text('Lap ${lap.lapIndex}'),
                  const Spacer(),
                  Text(ClockFormatters.lapDuration(lap.lapMs)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
