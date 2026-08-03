import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Key/value settings store.
abstract class SettingsRepository {
  Future<Result<String?>> get(String key);

  Future<Result<Unit>> set(String key, String value);

  Stream<String?> watch(String key);
}

/// Well-known settings keys.
abstract final class SettingKeys {
  static const themeMode = 'theme_mode';
  static const idleTimeoutMinutes = 'idle_timeout_minutes';
  static const screenshotIntervalMinutes = 'screenshot_interval_minutes';
  static const launchOnStartup = 'launch_on_startup';
  static const dataFolder = 'data_folder';
  static const autoStartTimer = 'auto_start_timer';
  static const launchCompact = 'launch_compact';
  static const closeToTray = 'close_to_tray';
  static const windowMode = 'window_mode';
  static const compactWindowState = 'compact_window_state';
  static const fullWindowState = 'full_window_state';
  static const lastProjectId = 'last_project_id';
  static const lastTaskId = 'last_task_id';
  static const worldClockCities = 'world_clock_cities';
  static const countdownState = 'countdown_timer_state';
  static const stopwatchActiveSessionId = 'stopwatch_active_session_id';
  static const alarmSoundId = 'alarm_sound_id';
  static const documentBrowsingHistory = 'document_browsing_history';
}
