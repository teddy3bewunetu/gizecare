import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/clock/domain/entities/alarm_item.dart';
import 'package:gizecare/features/clock/presentation/clock_formatters.dart';
import 'package:gizecare/features/clock/presentation/providers/alarm_monitor.dart';
import 'package:gizecare/features/settings/presentation/providers/settings_controller.dart';

const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class AlarmTab extends ConsumerWidget {
  const AlarmTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmsProvider);
    final settings = ref.watch(settingsControllerProvider).value;
    final selectedSound =
        AlarmSounds.byId(settings?.alarmSoundId ?? AlarmSounds.defaultId);

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      children: [
        AppPanel(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.music_note_rounded),
            title: const Text('Ringtone'),
            subtitle: Text(selectedSound.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Preview',
                  onPressed: () => ref
                      .read(alarmAudioServiceProvider)
                      .preview(selectedSound),
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
                TextButton(
                  onPressed: () => _pickSound(context, ref, selectedSound.id),
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _editAlarm(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add alarm'),
          ),
        ),
        const SizedBox(height: 16),
        alarmsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e'),
          data: (alarms) {
            if (alarms.isEmpty) {
              return const AppPanel(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text('No alarms yet — add one to get started'),
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final alarm in alarms) ...[
                  AppPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        ClockFormatters.alarmTime(alarm.hour, alarm.minute),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alarm.label),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            children: [
                              for (var i = 0; i < 7; i++)
                                _DayChip(
                                  label: _dayLabels[i],
                                  selected: (alarm.repeatDays & (1 << i)) != 0,
                                ),
                              if (alarm.isOneShot)
                                Text(
                                  'Once',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                            ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: alarm.enabled,
                            onChanged: (v) async {
                              await ref
                                  .read(alarmRepositoryProvider)
                                  .update(alarm.copyWith(enabled: v));
                            },
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () =>
                                _editAlarm(context, ref, alarm: alarm),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () async {
                              await ref
                                  .read(alarmRepositoryProvider)
                                  .delete(alarm.id);
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _editAlarm(
    BuildContext context,
    WidgetRef ref, {
    AlarmItem? alarm,
  }) async {
    var hour = alarm?.hour ?? TimeOfDay.now().hour;
    var minute = alarm?.minute ?? ((TimeOfDay.now().minute + 1) % 60);
    var repeatDays = alarm?.repeatDays ?? 0;
    final label = TextEditingController(text: alarm?.label ?? 'Alarm');

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: Text(alarm == null ? 'Add alarm' : 'Edit alarm'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: label,
                      decoration: const InputDecoration(labelText: 'Label'),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(ClockFormatters.alarmTime(hour, minute)),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: hour, minute: minute),
                        );
                        if (picked != null) {
                          setLocal(() {
                            hour = picked.hour;
                            minute = picked.minute;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Repeat',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (var i = 0; i < 7; i++)
                          FilterChip(
                            label: Text(_dayLabels[i]),
                            selected: (repeatDays & (1 << i)) != 0,
                            onSelected: (selected) {
                              setLocal(() {
                                if (selected) {
                                  repeatDays |= 1 << i;
                                } else {
                                  repeatDays &= ~(1 << i);
                                }
                              });
                            },
                          ),
                      ],
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
    final repo = ref.read(alarmRepositoryProvider);
    if (alarm == null) {
      await repo.create(
        label: label.text,
        hour: hour,
        minute: minute,
        repeatDays: repeatDays,
      );
    } else {
      await repo.update(
        alarm.copyWith(
          label: label.text.trim().isEmpty ? 'Alarm' : label.text.trim(),
          hour: hour,
          minute: minute,
          repeatDays: repeatDays,
        ),
      );
    }
  }

  Future<void> _pickSound(
    BuildContext context,
    WidgetRef ref,
    String currentId,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Choose alarm sound',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final sound in AlarmSounds.all)
                ListTile(
                  leading: Icon(
                    sound.id == currentId
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(sound.title),
                  subtitle: sound.id == AlarmSounds.defaultId
                      ? const Text('Recommended')
                      : null,
                  trailing: IconButton(
                    onPressed: () =>
                        ref.read(alarmAudioServiceProvider).preview(sound),
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                  onTap: () => Navigator.pop(context, sound.id),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      await ref
          .read(settingsControllerProvider.notifier)
          .setAlarmSoundId(selected);
    }
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? scheme.primary : scheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
