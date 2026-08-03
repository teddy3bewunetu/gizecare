import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:gizecare/app/router/root_navigator.dart';
import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/di/core_providers.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/services/activity/activity_service.dart';
import 'package:gizecare/core/services/clock/alarm_audio_service.dart';
import 'package:gizecare/core/services/clock/clock_alert_service.dart';
import 'package:gizecare/core/services/idle/idle_detection_service.dart';
import 'package:gizecare/core/services/idle/linux_idle_detection_service.dart';
import 'package:gizecare/core/services/screenshot/screenshot_service.dart';
import 'package:gizecare/core/services/tray/tray_service.dart';
import 'package:gizecare/core/services/window/window_mode_service.dart';
import 'package:gizecare/core/services/window/window_state_service.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Activity tracking service.
final activityServiceProvider = Provider<ActivityService>((ref) {
  final service = ActivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Platform idle detection.
final idleDetectionServiceProvider = Provider<IdleDetectionService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final IdleDetectionService service = LinuxIdleDetectionService(
    logger: logger,
    isWindowFocused: () async {
      try {
        if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) {
          return true;
        }
        return await windowManager.isFocused();
      } catch (_) {
        return true;
      }
    },
  );
  ref.onDispose(service.dispose);
  return service;
});

/// Screenshot capture service.
final screenshotServiceProvider = Provider<ScreenshotService>((ref) {
  final service = ScreenshotService(
    repository: ref.watch(screenshotRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

/// System tray integration (best-effort; may no-op on snap Flutter).
final trayServiceProvider = Provider<TrayService>((ref) {
  final service = TrayService(logger: ref.watch(appLoggerProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// Window size/position persistence (legacy full-window helper).
final windowStateServiceProvider = Provider<WindowStateService>((ref) {
  return WindowStateService(
    settings: ref.watch(settingsRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Compact vs full window mode controller.
final windowModeServiceProvider = Provider<WindowModeService>((ref) {
  return WindowModeService(
    settings: ref.watch(settingsRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Whether the system tray initialized successfully.
final trayReadyProvider = StateProvider<bool>((ref) => false);

/// Alarm ringtone playback.
final alarmAudioServiceProvider = Provider<AlarmAudioService>((ref) {
  final service = AlarmAudioService(logger: ref.watch(appLoggerProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// Clock alarm / countdown desktop alerts.
final clockAlertServiceProvider = Provider<ClockAlertService>((ref) {
  return ClockAlertService(
    logger: ref.watch(appLoggerProvider),
    audio: ref.watch(alarmAudioServiceProvider),
    navigatorKey: rootNavigatorKey,
    resolveSound: () async {
      final raw = await ref
          .read(settingsRepositoryProvider)
          .get(SettingKeys.alarmSoundId);
      final id = raw.when(
        onSuccess: (v) => v,
        onFailure: (_) => null,
      );
      return AlarmSounds.byId(id);
    },
  );
});
