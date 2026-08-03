import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/calendar/data/google_calendar_auth_service.dart';
import 'package:gizecare/features/calendar/data/google_calendar_token_store.dart';
import 'package:gizecare/features/calendar/data/repositories/calendar_feed_repository_impl.dart';
import 'package:gizecare/features/calendar/data/repositories/drift_google_calendar_repository.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/calendar/domain/repositories/calendar_repositories.dart';

final googleCalendarTokenStoreProvider = Provider<GoogleCalendarTokenStore>((ref) {
  return GoogleCalendarTokenStore();
});

final googleCalendarAuthServiceProvider =
    Provider<GoogleCalendarAuthService>((ref) {
  final service = GoogleCalendarAuthService(
    tokenStore: ref.watch(googleCalendarTokenStoreProvider),
  );
  ref.onDispose(service.close);
  return service;
});

final googleCalendarRepositoryProvider =
    Provider<GoogleCalendarRepository>((ref) {
  return DriftGoogleCalendarRepository(
    db: ref.watch(appDatabaseProvider),
    auth: ref.watch(googleCalendarAuthServiceProvider),
  );
});

final calendarFeedRepositoryProvider = Provider<CalendarFeedRepository>((ref) {
  return CalendarFeedRepositoryImpl(
    googleCalendarRepository: ref.watch(googleCalendarRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    timeEntryRepository: ref.watch(timeEntryRepositoryProvider),
    projectRepository: ref.watch(projectRepositoryProvider),
  );
});

final calendarAccountProvider = StreamProvider<CalendarAccount?>((ref) {
  return ref.watch(googleCalendarRepositoryProvider).watchAccount();
});

enum CalendarViewMode { day, week }

class CalendarUiState {
  const CalendarUiState({
    required this.focusDay,
    this.viewMode = CalendarViewMode.day,
    this.showGoogle = true,
    this.showTasks = true,
    this.showTimeEntries = true,
  });

  final DateTime focusDay;
  final CalendarViewMode viewMode;
  final bool showGoogle;
  final bool showTasks;
  final bool showTimeEntries;

  DateTime get rangeStart {
    final day = DateTime(focusDay.year, focusDay.month, focusDay.day);
    if (viewMode == CalendarViewMode.day) return day;
    final weekday = day.weekday; // Mon=1
    return day.subtract(Duration(days: weekday - 1));
  }

  DateTime get rangeEnd {
    if (viewMode == CalendarViewMode.day) {
      return rangeStart.add(const Duration(days: 1));
    }
    return rangeStart.add(const Duration(days: 7));
  }

  CalendarUiState copyWith({
    DateTime? focusDay,
    CalendarViewMode? viewMode,
    bool? showGoogle,
    bool? showTasks,
    bool? showTimeEntries,
  }) {
    return CalendarUiState(
      focusDay: focusDay ?? this.focusDay,
      viewMode: viewMode ?? this.viewMode,
      showGoogle: showGoogle ?? this.showGoogle,
      showTasks: showTasks ?? this.showTasks,
      showTimeEntries: showTimeEntries ?? this.showTimeEntries,
    );
  }
}

class CalendarUiController extends Notifier<CalendarUiState> {
  @override
  CalendarUiState build() {
    final now = DateTime.now();
    return CalendarUiState(
      focusDay: DateTime(now.year, now.month, now.day),
    );
  }

  void setFocusDay(DateTime day) {
    state = state.copyWith(
      focusDay: DateTime(day.year, day.month, day.day),
    );
  }

  void goToday() => setFocusDay(DateTime.now());

  void shift(int days) {
    setFocusDay(state.focusDay.add(Duration(days: days)));
  }

  void setViewMode(CalendarViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void toggleGoogle() =>
      state = state.copyWith(showGoogle: !state.showGoogle);

  void toggleTasks() => state = state.copyWith(showTasks: !state.showTasks);

  void toggleTimeEntries() =>
      state = state.copyWith(showTimeEntries: !state.showTimeEntries);
}

final calendarUiProvider =
    NotifierProvider<CalendarUiController, CalendarUiState>(
  CalendarUiController.new,
);

final calendarFeedProvider =
    FutureProvider.autoDispose<List<CalendarItem>>((ref) async {
  final ui = ref.watch(calendarUiProvider);
  final result = await ref.watch(calendarFeedRepositoryProvider).getItems(
        from: ui.rangeStart,
        to: ui.rangeEnd,
        includeGoogle: ui.showGoogle,
        includeTasks: ui.showTasks,
        includeTimeEntries: ui.showTimeEntries,
      );
  if (result.isFailure) {
    throw result.requireFailure;
  }
  return result.requireValue;
});
