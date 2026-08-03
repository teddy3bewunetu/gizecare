import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/features/activity/data/repositories/drift_keystroke_repository.dart';
import 'package:gizecare/features/activity/domain/repositories/keystroke_repository.dart';
import 'package:gizecare/features/clock/data/repositories/drift_alarm_repository.dart';
import 'package:gizecare/features/clock/data/repositories/drift_stopwatch_repository.dart';
import 'package:gizecare/features/clock/domain/repositories/alarm_repository.dart';
import 'package:gizecare/features/clock/domain/repositories/stopwatch_repository.dart';
import 'package:gizecare/features/notebook/data/repositories/drift_note_repository.dart';
import 'package:gizecare/features/notebook/data/repositories/drift_notebook_repository.dart';
import 'package:gizecare/features/notebook/domain/repositories/note_repository.dart';
import 'package:gizecare/features/notebook/domain/repositories/notebook_repository.dart';
import 'package:gizecare/features/projects/data/repositories/drift_project_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/screenshots/data/repositories/drift_screenshot_repository.dart';
import 'package:gizecare/features/screenshots/domain/repositories/screenshot_repository.dart';
import 'package:gizecare/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tasks/data/repositories/drift_board_repository.dart';
import 'package:gizecare/features/tasks/data/repositories/drift_task_repository.dart';
import 'package:gizecare/features/tasks/domain/repositories/board_repository.dart';
import 'package:gizecare/features/tasks/domain/repositories/task_repository.dart';
import 'package:gizecare/features/tracker/data/repositories/drift_time_entry_repository.dart';
import 'package:gizecare/features/tracker/domain/repositories/time_entry_repository.dart';

/// Project repository DI.
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return DriftProjectRepository(ref.watch(appDatabaseProvider));
});

/// Task repository DI.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return DriftTaskRepository(ref.watch(appDatabaseProvider));
});

/// Kanban board repository DI.
final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  return DriftBoardRepository(ref.watch(appDatabaseProvider));
});
/// Time entry repository DI.
final timeEntryRepositoryProvider = Provider<TimeEntryRepository>((ref) {
  return DriftTimeEntryRepository(ref.watch(appDatabaseProvider));
});

/// Screenshot repository DI.
final screenshotRepositoryProvider = Provider<ScreenshotRepository>((ref) {
  return DriftScreenshotRepository(ref.watch(appDatabaseProvider));
});

/// Keystroke aggregate repository DI.
final keystrokeRepositoryProvider = Provider<KeystrokeRepository>((ref) {
  return DriftKeystrokeRepository(ref.watch(appDatabaseProvider));
});

/// Settings repository DI.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return DriftSettingsRepository(ref.watch(appDatabaseProvider));
});

/// Alarm repository DI.
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return DriftAlarmRepository(ref.watch(appDatabaseProvider));
});

/// Stopwatch lap repository DI.
final stopwatchRepositoryProvider = Provider<StopwatchRepository>((ref) {
  return DriftStopwatchRepository(ref.watch(appDatabaseProvider));
});

/// Notebook collection repository DI.
final notebookRepositoryProvider = Provider<NotebookRepository>((ref) {
  return DriftNotebookRepository(ref.watch(appDatabaseProvider));
});

/// Note repository DI.
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return DriftNoteRepository(ref.watch(appDatabaseProvider));
});
