import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/theme/theme_mode_controller.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Persisted settings view-model.
class AppSettingsState {
  const AppSettingsState({
    this.idleTimeoutMinutes = 5,
    this.screenshotIntervalMinutes = 10,
    this.launchOnStartup = false,
    this.autoStartTimer = false,
    this.launchCompact = true,
    this.closeToTray = true,
    this.alarmSoundId = AlarmSounds.defaultId,
    this.dataFolderLabel = 'Application support',
  });

  final int idleTimeoutMinutes;
  final int screenshotIntervalMinutes;
  final bool launchOnStartup;
  final bool autoStartTimer;
  final bool launchCompact;
  final bool closeToTray;
  final String alarmSoundId;
  final String dataFolderLabel;

  AppSettingsState copyWith({
    int? idleTimeoutMinutes,
    int? screenshotIntervalMinutes,
    bool? launchOnStartup,
    bool? autoStartTimer,
    bool? launchCompact,
    bool? closeToTray,
    String? alarmSoundId,
    String? dataFolderLabel,
  }) {
    return AppSettingsState(
      idleTimeoutMinutes: idleTimeoutMinutes ?? this.idleTimeoutMinutes,
      screenshotIntervalMinutes:
          screenshotIntervalMinutes ?? this.screenshotIntervalMinutes,
      launchOnStartup: launchOnStartup ?? this.launchOnStartup,
      autoStartTimer: autoStartTimer ?? this.autoStartTimer,
      launchCompact: launchCompact ?? this.launchCompact,
      closeToTray: closeToTray ?? this.closeToTray,
      alarmSoundId: alarmSoundId ?? this.alarmSoundId,
      dataFolderLabel: dataFolderLabel ?? this.dataFolderLabel,
    );
  }
}

/// Loads and mutates application settings.
class SettingsController extends AsyncNotifier<AppSettingsState> {
  @override
  Future<AppSettingsState> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    final idle = await _readInt(repo, SettingKeys.idleTimeoutMinutes, 5);
    final shots =
        await _readInt(repo, SettingKeys.screenshotIntervalMinutes, 10);
    final launch = await _readBool(repo, SettingKeys.launchOnStartup, false);
    final auto = await _readBool(repo, SettingKeys.autoStartTimer, false);
    final launchCompact =
        await _readBool(repo, SettingKeys.launchCompact, true);
    final closeToTray = await _readBool(repo, SettingKeys.closeToTray, true);
    final alarmSound = await _readString(
      repo,
      SettingKeys.alarmSoundId,
      AlarmSounds.defaultId,
    );
    final theme = await repo.get(SettingKeys.themeMode);
    theme.when(
      onSuccess: (value) {
        if (value == null) return;
        final mode = ThemeMode.values.firstWhere(
          (m) => m.name == value,
          orElse: () => ThemeMode.dark,
        );
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      onFailure: (_) {},
    );

    final support = await getApplicationSupportDirectory();
    return AppSettingsState(
      idleTimeoutMinutes: idle,
      screenshotIntervalMinutes: shots,
      launchOnStartup: launch,
      autoStartTimer: auto,
      launchCompact: launchCompact,
      closeToTray: closeToTray,
      alarmSoundId: alarmSound,
      dataFolderLabel: support.path,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.themeMode, mode.name);
  }

  Future<void> setIdleTimeoutMinutes(int value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.idleTimeoutMinutes, '$value');
    state = AsyncData(
      (state.value ?? const AppSettingsState())
          .copyWith(idleTimeoutMinutes: value),
    );
  }

  Future<void> setScreenshotIntervalMinutes(int value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.screenshotIntervalMinutes, '$value');
    state = AsyncData(
      (state.value ?? const AppSettingsState())
          .copyWith(screenshotIntervalMinutes: value),
    );
  }

  Future<void> setLaunchOnStartup(bool value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.launchOnStartup, '$value');
    if (Platform.isLinux) {
      await _writeLinuxAutostart(value);
    }
    state = AsyncData(
      (state.value ?? const AppSettingsState())
          .copyWith(launchOnStartup: value),
    );
  }

  Future<void> setAutoStartTimer(bool value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.autoStartTimer, '$value');
    state = AsyncData(
      (state.value ?? const AppSettingsState())
          .copyWith(autoStartTimer: value),
    );
  }

  Future<void> setLaunchCompact(bool value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.launchCompact, '$value');
    state = AsyncData(
      (state.value ?? const AppSettingsState())
          .copyWith(launchCompact: value),
    );
  }

  Future<void> setCloseToTray(bool value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.closeToTray, '$value');
    state = AsyncData(
      (state.value ?? const AppSettingsState()).copyWith(closeToTray: value),
    );
  }

  Future<void> setAlarmSoundId(String value) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.alarmSoundId, value);
    state = AsyncData(
      (state.value ?? const AppSettingsState()).copyWith(alarmSoundId: value),
    );
  }

  Future<String> _readString(
    SettingsRepository repo,
    String key,
    String fallback,
  ) async {
    final result = await repo.get(key);
    return result.when(
      onSuccess: (v) => (v == null || v.isEmpty) ? fallback : v,
      onFailure: (_) => fallback,
    );
  }

  Future<int> _readInt(
    SettingsRepository repo,
    String key,
    int fallback,
  ) async {
    final result = await repo.get(key);
    return result.when(
      onSuccess: (v) => int.tryParse(v ?? '') ?? fallback,
      onFailure: (_) => fallback,
    );
  }

  Future<bool> _readBool(
    SettingsRepository repo,
    String key,
    bool fallback,
  ) async {
    final result = await repo.get(key);
    return result.when(
      onSuccess: (v) => v == null ? fallback : v == 'true',
      onFailure: (_) => fallback,
    );
  }

  Future<void> _writeLinuxAutostart(bool enabled) async {
    final home = Platform.environment['HOME'];
    if (home == null) return;
    final file = File(p.join(home, '.config', 'autostart', 'gizecare.desktop'));
    if (!enabled) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    final execPath = Platform.resolvedExecutable;
    await file.writeAsString('''
[Desktop Entry]
Type=Application
Name=${AppConstants.displayName}
Comment=${AppConstants.tagline}
Exec="$execPath"
Icon=com.gizecare.gizecare
X-GNOME-Autostart-enabled=true
StartupWMClass=com.gizecare.gizecare
''');
  }
}

/// Settings controller provider.
final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettingsState>(
  SettingsController.new,
);
