import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/theme_mode_controller.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/settings/presentation/providers/settings_controller.dart';

/// Application settings.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final settings = settingsAsync.value ?? const AppSettingsState();
    final trayReady = ref.watch(trayReadyProvider);
    final desktop = AppPlatform.isDesktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Settings',
          subtitle: 'Tune ጊዜCare for your workflow',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
            children: [
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.brightness_auto),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (value) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(value.first);
                        ref
                            .read(settingsControllerProvider.notifier)
                            .setThemeMode(value.first);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alarm sound',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Default: Digital buzzer — used for alarms and timer finish',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    for (final sound in AlarmSounds.all) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio<String>(
                          value: sound.id,
                          groupValue: settings.alarmSoundId,
                          onChanged: (id) {
                            if (id == null) return;
                            ref
                                .read(settingsControllerProvider.notifier)
                                .setAlarmSoundId(id);
                          },
                        ),
                        title: Text(sound.title),
                        subtitle: sound.id == AlarmSounds.defaultId
                            ? const Text('Recommended')
                            : null,
                        trailing: IconButton(
                          tooltip: 'Preview',
                          onPressed: () => ref
                              .read(alarmAudioServiceProvider)
                              .preview(sound),
                          icon: const Icon(Icons.play_arrow_rounded),
                        ),
                        onTap: () => ref
                            .read(settingsControllerProvider.notifier)
                            .setAlarmSoundId(sound.id),
                      ),
                      if (sound != AlarmSounds.all.last)
                        const Divider(height: 1),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppPanel(
                child: Column(
                  children: [
                    if (desktop) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Launch in compact window'),
                        subtitle: const Text(
                          'Open the Upwork-style tracker on startup',
                        ),
                        value: settings.launchCompact,
                        onChanged: (v) => ref
                            .read(settingsControllerProvider.notifier)
                            .setLaunchCompact(v),
                      ),
                      const Divider(),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Close to tray'),
                        subtitle: Text(
                          trayReady
                              ? 'Closing the window hides to the top bar; '
                                  'minimize keeps it on the taskbar'
                              : 'Tray unavailable — install ayatana + official Flutter SDK',
                        ),
                        value: settings.closeToTray && trayReady,
                        onChanged: trayReady
                            ? (v) => ref
                                .read(settingsControllerProvider.notifier)
                                .setCloseToTray(v)
                            : null,
                      ),
                      const Divider(),
                      _NumberTile(
                        title: 'Idle timeout (minutes)',
                        value: settings.idleTimeoutMinutes,
                        onChanged: (v) => ref
                            .read(settingsControllerProvider.notifier)
                            .setIdleTimeoutMinutes(v),
                      ),
                      const Divider(),
                    ],
                    if (AppPlatform.supportsAutoScreenshots) ...[
                      _NumberTile(
                        title: 'Screenshot interval (minutes)',
                        value: settings.screenshotIntervalMinutes,
                        onChanged: (v) => ref
                            .read(settingsControllerProvider.notifier)
                            .setScreenshotIntervalMinutes(v),
                      ),
                      const Divider(),
                    ],
                    if (desktop) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Launch on startup'),
                        subtitle:
                            const Text('Linux XDG autostart (best effort)'),
                        value: settings.launchOnStartup,
                        onChanged: (v) => ref
                            .read(settingsControllerProvider.notifier)
                            .setLaunchOnStartup(v),
                      ),
                      const Divider(),
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Auto-start timer'),
                      subtitle: const Text(
                        'Reserved for future session restore behavior',
                      ),
                      value: settings.autoStartTimer,
                      onChanged: (v) => ref
                          .read(settingsControllerProvider.notifier)
                          .setAutoStartTimer(v),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Data folder'),
                      subtitle: Text(settings.dataFolderLabel),
                      trailing: const Icon(Icons.folder_outlined),
                      onTap: () async {
                        final dir = await getApplicationSupportDirectory();
                        if (context.mounted) {
                          AppSnackBar.show(context, dir.path);
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Screenshots'),
                      subtitle: Text(
                        AppPlatform.supportsAutoScreenshots
                            ? '~/Pictures/${AppConstants.screenshotsFolderName}/'
                            : 'Desktop capture only — browse saved shots here',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(AppRoutes.screenshots),
                    ),
                    if (desktop) ...[
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Compact tracker'),
                        subtitle:
                            const Text('Switch to the small tracker window'),
                        trailing: const Icon(
                          Icons.picture_in_picture_alt_outlined,
                        ),
                        onTap: () async {
                          await ref
                              .read(windowModeServiceProvider)
                              .enterCompact();
                          if (context.mounted) {
                            context.go(AppRoutes.compact);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
