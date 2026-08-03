import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:googleapis/oauth2/v2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/calendar/data/google_calendar_auth_service.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';
import 'package:gizecare/features/calendar/domain/repositories/calendar_repositories.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:drift/drift.dart';

class DriftGoogleCalendarRepository implements GoogleCalendarRepository {
  DriftGoogleCalendarRepository({
    required AppDatabase db,
    required GoogleCalendarAuthService auth,
  })  : _db = db,
        _auth = auth;

  final AppDatabase _db;
  final GoogleCalendarAuthService _auth;
  final _uuid = const Uuid();

  static const _googleColor = Color(0xFF34A853);

  @override
  Stream<CalendarAccount?> watchAccount() {
    return (_db.select(_db.calendarAccounts)
          ..where((t) => t.provider.equals('google'))
          ..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _mapAccount(rows.first));
  }

  @override
  Future<Result<CalendarAccount?>> getAccount() async {
    try {
      final rows = await (_db.select(_db.calendarAccounts)
            ..where((t) => t.provider.equals('google'))
            ..limit(1))
          .get();
      return Success(rows.isEmpty ? null : _mapAccount(rows.first));
    } catch (e) {
      return Err(CacheFailure('Failed to load calendar account', cause: e));
    }
  }

  @override
  Future<Result<CalendarAccount>> connect() async {
    if (!AppPlatform.isLinux) {
      return const Err(
        PlatformFailure('Google Calendar connect is available on Linux only'),
      );
    }
    if (!GoogleCalendarConfig.hasCredentials) {
      return const Err(
        ValidationFailure(
          'Missing Google OAuth credentials. See docs/google_calendar_setup.md',
        ),
      );
    }
    try {
      await _auth.authorizeInteractive();
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Authorization did not produce tokens'));
      }
      try {
        final calendarApi = gcal.CalendarApi(client);
        final oauthApi = oauth2.Oauth2Api(client);
        final userInfo = await oauthApi.userinfo.get();
        final email = userInfo.email ?? 'Google account';

        String calendarId = 'primary';
        final list = await calendarApi.calendarList.list();
        final primary = list.items?.where((c) => c.primary == true);
        if (primary != null && primary.isNotEmpty) {
          calendarId = primary.first.id ?? 'primary';
        }

        final now = DateTime.now();
        final existing = await (_db.select(_db.calendarAccounts)
              ..where((t) => t.provider.equals('google')))
            .get();
        late final String accountId;
        if (existing.isEmpty) {
          accountId = _uuid.v4();
          await _db.into(_db.calendarAccounts).insert(
                CalendarAccountsCompanion.insert(
                  id: accountId,
                  provider: 'google',
                  email: email,
                  calendarId: calendarId,
                  connectedAt: now,
                ),
              );
        } else {
          accountId = existing.first.id;
          await (_db.update(_db.calendarAccounts)
                ..where((t) => t.id.equals(accountId)))
              .write(
            CalendarAccountsCompanion(
              email: Value(email),
              calendarId: Value(calendarId),
              connectedAt: Value(now),
            ),
          );
        }

        final from = DateTime.now().subtract(const Duration(days: 7));
        final to = DateTime.now().add(const Duration(days: 60));
        await _syncWithClient(
          client: client,
          accountId: accountId,
          calendarId: calendarId,
          from: from,
          to: to,
        );

        final account = CalendarAccount(
          id: accountId,
          provider: 'google',
          email: email,
          calendarId: calendarId,
          connectedAt: now,
          lastSyncAt: DateTime.now(),
        );
        return Success(account);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(
        NetworkFailure(
          'Google connect failed: $e',
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<Unit>> disconnect() async {
    try {
      await _auth.clearStoredCredentials();
      final accounts = await (_db.select(_db.calendarAccounts)
            ..where((t) => t.provider.equals('google')))
          .get();
      for (final account in accounts) {
        await (_db.delete(_db.cachedCalendarEvents)
              ..where((e) => e.accountId.equals(account.id)))
            .go();
        await (_db.delete(_db.calendarAccounts)
              ..where((a) => a.id.equals(account.id)))
            .go();
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to disconnect Google Calendar', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sync({DateTime? from, DateTime? to}) async {
    try {
      final accountResult = await getAccount();
      if (accountResult.isFailure) {
        return Err(accountResult.requireFailure);
      }
      final account = accountResult.requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Google Calendar first'));
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Not signed in to Google'));
      }
      try {
        final rangeFrom =
            from ?? DateTime.now().subtract(const Duration(days: 7));
        final rangeTo = to ?? DateTime.now().add(const Duration(days: 60));
        await _syncWithClient(
          client: client,
          accountId: account.id,
          calendarId: account.calendarId,
          from: rangeFrom,
          to: rangeTo,
        );
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(NetworkFailure('Google Calendar sync failed', cause: e));
    }
  }

  Future<void> _syncWithClient({
    required http.Client client,
    required String accountId,
    required String calendarId,
    required DateTime from,
    required DateTime to,
  }) async {
    final api = gcal.CalendarApi(client);
    String? pageToken;
    final fetched = <gcal.Event>[];
    do {
      final page = await api.events.list(
        calendarId,
        timeMin: from.toUtc(),
        timeMax: to.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
        maxResults: 250,
        pageToken: pageToken,
      );
      fetched.addAll(page.items ?? const []);
      pageToken = page.nextPageToken;
    } while (pageToken != null && pageToken.isNotEmpty);

    await (_db.delete(_db.cachedCalendarEvents)
          ..where(
            (e) =>
                e.accountId.equals(accountId) &
                e.startAt.isBiggerOrEqualValue(from) &
                e.startAt.isSmallerThanValue(to),
          ))
        .go();

    final now = DateTime.now();
    for (final event in fetched) {
      final mapped = _mapGoogleEvent(event);
      if (mapped == null) continue;
      await _db.into(_db.cachedCalendarEvents).insert(
            CachedCalendarEventsCompanion.insert(
              id: _uuid.v4(),
              accountId: accountId,
              googleEventId: mapped.googleEventId,
              title: mapped.title,
              description: Value(mapped.description),
              startAt: mapped.startAt,
              endAt: mapped.endAt,
              allDay: Value(mapped.allDay),
              htmlLink: Value(mapped.htmlLink),
              etag: Value(mapped.etag),
              updatedAt: now,
            ),
          );
    }

    await (_db.update(_db.calendarAccounts)
          ..where((a) => a.id.equals(accountId)))
        .write(CalendarAccountsCompanion(lastSyncAt: Value(now)));
  }

  @override
  Future<Result<CalendarItem>> createEvent({
    required String title,
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? description,
  }) async {
    try {
      final accountResult = await getAccount();
      if (accountResult.isFailure) {
        return Err(accountResult.requireFailure);
      }
      final account = accountResult.requireValue;
      if (account == null) {
        return const Err(
          ValidationFailure('Connect Google Calendar to create events'),
        );
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Not signed in to Google'));
      }
      try {
        final api = gcal.CalendarApi(client);
        final event = gcal.Event(
          summary: title,
          description: description,
          start: allDay
              ? gcal.EventDateTime(date: _dateOnly(startAt))
              : gcal.EventDateTime(dateTime: startAt.toUtc()),
          end: allDay
              ? gcal.EventDateTime(date: _dateOnly(endAt))
              : gcal.EventDateTime(dateTime: endAt.toUtc()),
        );
        final created = await api.events.insert(event, account.calendarId);
        final mapped = _mapGoogleEvent(created);
        if (mapped == null) {
          return const Err(NetworkFailure('Google returned an empty event'));
        }
        final now = DateTime.now();
        final localId = _uuid.v4();
        await _db.into(_db.cachedCalendarEvents).insert(
              CachedCalendarEventsCompanion.insert(
                id: localId,
                accountId: account.id,
                googleEventId: mapped.googleEventId,
                title: mapped.title,
                description: Value(mapped.description),
                startAt: mapped.startAt,
                endAt: mapped.endAt,
                allDay: Value(mapped.allDay),
                htmlLink: Value(mapped.htmlLink),
                etag: Value(mapped.etag),
                updatedAt: now,
              ),
            );
        return Success(
          CalendarItem(
            id: localId,
            source: CalendarItemSource.google,
            title: mapped.title,
            startAt: mapped.startAt,
            endAt: mapped.endAt,
            allDay: mapped.allDay,
            description: mapped.description,
            htmlLink: mapped.htmlLink,
            color: _googleColor,
          ),
        );
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(NetworkFailure('Failed to create Google event', cause: e));
    }
  }

  @override
  Future<Result<CalendarItem>> updateEvent({
    required String localEventId,
    required String title,
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? description,
  }) async {
    try {
      final accountResult = await getAccount();
      if (accountResult.isFailure) {
        return Err(accountResult.requireFailure);
      }
      final account = accountResult.requireValue;
      if (account == null) {
        return const Err(
          ValidationFailure('Connect Google Calendar to edit events'),
        );
      }
      final cached = await (_db.select(_db.cachedCalendarEvents)
            ..where((e) => e.id.equals(localEventId)))
          .getSingleOrNull();
      if (cached == null) {
        return const Err(ValidationFailure('Event not found in local cache'));
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Not signed in to Google'));
      }
      try {
        final api = gcal.CalendarApi(client);
        final patch = gcal.Event(
          summary: title,
          description: description,
          start: allDay
              ? gcal.EventDateTime(date: _dateOnly(startAt))
              : gcal.EventDateTime(dateTime: startAt.toUtc()),
          end: allDay
              ? gcal.EventDateTime(date: _dateOnly(endAt))
              : gcal.EventDateTime(dateTime: endAt.toUtc()),
        );
        final updated = await api.events.patch(
          patch,
          account.calendarId,
          cached.googleEventId,
        );
        final mapped = _mapGoogleEvent(updated);
        if (mapped == null) {
          return const Err(NetworkFailure('Google returned an empty event'));
        }
        final now = DateTime.now();
        await (_db.update(_db.cachedCalendarEvents)
              ..where((e) => e.id.equals(localEventId)))
            .write(
          CachedCalendarEventsCompanion(
            title: Value(mapped.title),
            description: Value(mapped.description),
            startAt: Value(mapped.startAt),
            endAt: Value(mapped.endAt),
            allDay: Value(mapped.allDay),
            htmlLink: Value(mapped.htmlLink),
            etag: Value(mapped.etag),
            updatedAt: Value(now),
          ),
        );
        return Success(
          CalendarItem(
            id: localEventId,
            source: CalendarItemSource.google,
            title: mapped.title,
            startAt: mapped.startAt,
            endAt: mapped.endAt,
            allDay: mapped.allDay,
            description: mapped.description,
            htmlLink: mapped.htmlLink,
            color: _googleColor,
          ),
        );
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(NetworkFailure('Failed to update Google event', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteEvent({required String localEventId}) async {
    try {
      final accountResult = await getAccount();
      if (accountResult.isFailure) {
        return Err(accountResult.requireFailure);
      }
      final account = accountResult.requireValue;
      if (account == null) {
        return const Err(
          ValidationFailure('Connect Google Calendar to delete events'),
        );
      }
      final cached = await (_db.select(_db.cachedCalendarEvents)
            ..where((e) => e.id.equals(localEventId)))
          .getSingleOrNull();
      if (cached == null) {
        return const Err(ValidationFailure('Event not found in local cache'));
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Not signed in to Google'));
      }
      try {
        final api = gcal.CalendarApi(client);
        await api.events.delete(account.calendarId, cached.googleEventId);
        await (_db.delete(_db.cachedCalendarEvents)
              ..where((e) => e.id.equals(localEventId)))
            .go();
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(NetworkFailure('Failed to delete Google event', cause: e));
    }
  }

  @override
  Future<Result<List<CalendarItem>>> getCachedEvents({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await (_db.select(_db.cachedCalendarEvents)
            ..where((e) => e.startAt.isBiggerOrEqualValue(from))
            ..where((e) => e.startAt.isSmallerThanValue(to))
            ..orderBy([(e) => OrderingTerm.asc(e.startAt)]))
          .get();
      return Success(rows.map(_mapCached).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load cached events', cause: e));
    }
  }

  @override
  Stream<List<CalendarItem>> watchCachedEvents({
    required DateTime from,
    required DateTime to,
  }) {
    return (_db.select(_db.cachedCalendarEvents)
          ..where((e) => e.startAt.isBiggerOrEqualValue(from))
          ..where((e) => e.startAt.isSmallerThanValue(to))
          ..orderBy([(e) => OrderingTerm.asc(e.startAt)]))
        .watch()
        .map((rows) => rows.map(_mapCached).toList());
  }

  CalendarItem _mapCached(CachedCalendarEventRow row) {
    return CalendarItem(
      id: row.id,
      source: CalendarItemSource.google,
      title: row.title,
      startAt: row.startAt,
      endAt: row.endAt,
      allDay: row.allDay,
      description: row.description,
      htmlLink: row.htmlLink,
      color: _googleColor,
    );
  }

  CalendarAccount _mapAccount(CalendarAccountRow row) {
    return CalendarAccount(
      id: row.id,
      provider: row.provider,
      email: row.email,
      calendarId: row.calendarId,
      connectedAt: row.connectedAt,
      lastSyncAt: row.lastSyncAt,
    );
  }

  _MappedGoogleEvent? _mapGoogleEvent(gcal.Event event) {
    final id = event.id;
    if (id == null) return null;
    final start = event.start;
    final end = event.end;
    if (start == null || end == null) return null;

    final allDay = start.date != null;
    late final DateTime startAt;
    late final DateTime endAt;
    if (allDay) {
      startAt = DateTime(start.date!.year, start.date!.month, start.date!.day);
      final endDate = end.date ?? start.date!.add(const Duration(days: 1));
      endAt = DateTime(endDate.year, endDate.month, endDate.day);
    } else {
      startAt = (start.dateTime ?? DateTime.now()).toLocal();
      endAt = (end.dateTime ?? startAt.add(const Duration(hours: 1))).toLocal();
    }

    return _MappedGoogleEvent(
      googleEventId: id,
      title: (event.summary == null || event.summary!.trim().isEmpty)
          ? '(No title)'
          : event.summary!,
      description: event.description,
      startAt: startAt,
      endAt: endAt,
      allDay: allDay,
      htmlLink: event.htmlLink,
      etag: event.etag,
    );
  }

  DateTime _dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);
}

class _MappedGoogleEvent {
  const _MappedGoogleEvent({
    required this.googleEventId,
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.allDay,
    this.description,
    this.htmlLink,
    this.etag,
  });

  final String googleEventId;
  final String title;
  final String? description;
  final DateTime startAt;
  final DateTime endAt;
  final bool allDay;
  final String? htmlLink;
  final String? etag;
}
