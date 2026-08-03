import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/clock/presentation/clock_formatters.dart';
import 'package:gizecare/features/clock/presentation/providers/countdown_controller.dart';

class CountdownTab extends ConsumerWidget {
  const CountdownTab({super.key});

  static const _presets = <int>[5, 10, 15, 25, 45, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(countdownControllerProvider);
    final notifier = ref.read(countdownControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        AppPanel(
          child: Column(
            children: [
              SegmentedButton<TimerMode>(
                segments: const [
                  ButtonSegment(
                    value: TimerMode.classic,
                    label: Text('Timer'),
                    icon: Icon(Icons.timer_outlined),
                  ),
                  ButtonSegment(
                    value: TimerMode.pomodoro,
                    label: Text('Pomodoro'),
                    icon: Icon(Icons.local_florist_outlined),
                  ),
                ],
                selected: {state.mode},
                onSelectionChanged: state.isRunning
                    ? null
                    : (value) => notifier.setMode(value.first),
              ),
              const SizedBox(height: 20),
              if (state.isPomodoro) ...[
                Text(
                  state.stageLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < state.focusesPerLongBreak; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < state.completedFocus
                              ? Icons.circle
                              : Icons.circle_outlined,
                          size: 14,
                          color: scheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.completedFocus}/${state.focusesPerLongBreak} focus'
                  ' · ${state.focusMinutes}/'
                  '${state.shortBreakMinutes}/'
                  '${state.longBreakMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                ClockFormatters.countdown(state.remaining),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
              if (state.phase == CountdownPhase.finished)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Time’s up',
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (!state.isPomodoro)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final m in _presets)
                      ActionChip(
                        label: Text('${m}m'),
                        onPressed: state.isRunning
                            ? null
                            : () =>
                                notifier.setDuration(Duration(minutes: m)),
                      ),
                    ActionChip(
                      label: const Text('Custom'),
                      onPressed: state.isRunning
                          ? null
                          : () => _pickCustom(context, notifier),
                    ),
                  ],
                )
              else if (!state.isRunning)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    FilterChip(
                      label: Text('Focus (${state.focusMinutes}m)'),
                      selected: state.pomodoroStage == PomodoroStage.focus,
                      onSelected: (_) =>
                          notifier.selectPomodoroStage(PomodoroStage.focus),
                    ),
                    FilterChip(
                      label: Text('Short (${state.shortBreakMinutes}m)'),
                      selected:
                          state.pomodoroStage == PomodoroStage.shortBreak,
                      onSelected: (_) => notifier
                          .selectPomodoroStage(PomodoroStage.shortBreak),
                    ),
                    FilterChip(
                      label: Text('Long (${state.longBreakMinutes}m)'),
                      selected:
                          state.pomodoroStage == PomodoroStage.longBreak,
                      onSelected: (_) => notifier
                          .selectPomodoroStage(PomodoroStage.longBreak),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  if (!state.isRunning)
                    FilledButton.icon(
                      onPressed: state.remaining > Duration.zero
                          ? notifier.start
                          : null,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(state.isPaused ? 'Resume' : 'Start'),
                    ),
                  if (state.isRunning)
                    FilledButton.tonalIcon(
                      onPressed: notifier.pause,
                      icon: const Icon(Icons.pause_rounded),
                      label: const Text('Pause'),
                    ),
                  if (state.isPomodoro && !state.isRunning)
                    OutlinedButton.icon(
                      onPressed: notifier.skipToNextPomodoroStage,
                      icon: const Icon(Icons.skip_next_rounded),
                      label: const Text('Skip stage'),
                    ),
                  OutlinedButton.icon(
                    onPressed: notifier.addOneMinute,
                    icon: const Icon(Icons.exposure_plus_1_rounded),
                    label: const Text('+1 min'),
                  ),
                  OutlinedButton.icon(
                    onPressed: notifier.reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                  ),
                  if (state.isPomodoro && !state.isRunning)
                    TextButton(
                      onPressed: notifier.resetPomodoroCycle,
                      child: const Text('Reset cycle'),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (state.isPomodoro) ...[
          const SizedBox(height: 12),
          AppPanel(
            child: Text(
              'Classic Pomodoro: ${state.focusMinutes} min focus, '
              '${state.shortBreakMinutes} min short break, then a '
              '${state.longBreakMinutes} min long break after '
              '${state.focusesPerLongBreak} focus sessions. '
              'When a stage ends you’ll get an alert with Start for the next one.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickCustom(
    BuildContext context,
    CountdownController notifier,
  ) async {
    var hours = 0;
    var minutes = 10;
    var seconds = 0;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Custom timer'),
              content: Row(
                children: [
                  Expanded(
                    child: _NumberField(
                      label: 'Hours',
                      value: hours,
                      onChanged: (v) => setLocal(() => hours = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: 'Min',
                      value: minutes,
                      max: 59,
                      onChanged: (v) => setLocal(() => minutes = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: 'Sec',
                      value: seconds,
                      max: 59,
                      onChanged: (v) => setLocal(() => seconds = v),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Set'),
                ),
              ],
            );
          },
        );
      },
    );
    if (ok != true) return;
    final d = Duration(hours: hours, minutes: minutes, seconds: seconds);
    if (d > Duration.zero) notifier.setDuration(d);
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 99,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
            ),
            Text('$value'),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
