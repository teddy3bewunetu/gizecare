import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Google Calendar connect / sync / create.
abstract class GoogleCalendarRepository {
  Stream<CalendarAccount?> watchAccount();

  Future<Result<CalendarAccount?>> getAccount();

  Future<Result<CalendarAccount>> connect();

  Future<Result<Unit>> disconnect();

  Future<Result<Unit>> sync({DateTime? from, DateTime? to});

  Future<Result<CalendarItem>> createEvent({
    required String title,
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? description,
  });

  Future<Result<CalendarItem>> updateEvent({
    required String localEventId,
    required String title,
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? description,
  });

  Future<Result<Unit>> deleteEvent({required String localEventId});

  Future<Result<List<CalendarItem>>> getCachedEvents({
    required DateTime from,
    required DateTime to,
  });

  Stream<List<CalendarItem>> watchCachedEvents({
    required DateTime from,
    required DateTime to,
  });
}

/// Merges Google cache + local tasks + time entries for a visible range.
abstract class CalendarFeedRepository {
  Future<Result<List<CalendarItem>>> getItems({
    required DateTime from,
    required DateTime to,
    bool includeGoogle = true,
    bool includeTasks = true,
    bool includeTimeEntries = true,
  });
}
