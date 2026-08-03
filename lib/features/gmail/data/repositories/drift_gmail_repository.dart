import 'dart:io' show HttpDate;

import 'package:drift/drift.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis/oauth2/v2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/calendar/data/google_calendar_auth_service.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';
import 'package:gizecare/features/gmail/domain/entities/gmail_entities.dart';
import 'package:gizecare/features/gmail/domain/gmail_html.dart';
import 'package:gizecare/features/gmail/domain/repositories/gmail_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

class DriftGmailRepository implements GmailRepository {
  DriftGmailRepository({
    required AppDatabase db,
    required GoogleCalendarAuthService auth,
  })  : _db = db,
        _auth = auth;

  final AppDatabase _db;
  final GoogleCalendarAuthService _auth;
  final _uuid = const Uuid();

  static String _apiErrorMessage(Object e, String fallback) {
    final text = e.toString();
    if (text.contains('Gmail API has not been used') ||
        text.contains('accessNotConfigured') ||
        text.contains('has not been used in project')) {
      return 'Gmail API is disabled for this Google Cloud project. '
          'Enable it at console.cloud.google.com → APIs → Gmail API, '
          'wait a minute, then Refresh. See docs/gmail_setup.md';
    }
    if (text.contains('insufficientPermissions') ||
        text.contains('Insufficient Permission') ||
        text.contains('ACCESS_TOKEN_SCOPE_INSUFFICIENT')) {
      return 'Gmail permission missing. Revoke GizeCare at '
          'myaccount.google.com/permissions, then Connect Gmail again.';
    }
    // DetailedApiRequestError / ApiRequestError often look like:
    // DetailedApiRequestError(403, message)
    final detail = RegExp(r'DetailedApiRequestError\(\d+,\s*(.+)\)')
        .firstMatch(text);
    if (detail != null) {
      var msg = detail.group(1)!.trim();
      if (msg.endsWith(')')) msg = msg.substring(0, msg.length - 1);
      if (msg.isNotEmpty) return msg;
    }
    if (e is http.ClientException) return e.message;
    return '$fallback: $e';
  }

  @override
  Stream<GmailAccount?> watchAccount() {
    return (_db.select(_db.gmailAccounts)..limit(1)).watch().map(
          (rows) => rows.isEmpty ? null : _mapAccount(rows.first),
        );
  }

  @override
  Future<Result<GmailAccount?>> getAccount() async {
    try {
      final rows = await (_db.select(_db.gmailAccounts)..limit(1)).get();
      return Success(rows.isEmpty ? null : _mapAccount(rows.first));
    } catch (e) {
      return Err(CacheFailure('Failed to load Gmail account', cause: e));
    }
  }

  @override
  Future<Result<GmailAccount>> connect() async {
    if (!AppPlatform.isLinux) {
      return const Err(
        PlatformFailure('Gmail connect is available on Linux only'),
      );
    }
    if (!GoogleCalendarConfig.hasCredentials) {
      return const Err(
        ValidationFailure(
          'Missing Google OAuth credentials. See docs/gmail_setup.md',
        ),
      );
    }
    try {
      final hasScope = await _auth.hasGmailScope();
      final stored = await _auth.loadStoredCredentials();
      if (stored == null || !hasScope) {
        await _auth.authorizeInteractive();
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(NetworkFailure('Authorization did not produce tokens'));
      }
      try {
        if (!await _auth.hasGmailScope()) {
          return const Err(
            ValidationFailure(
              'Gmail permission missing. Revoke GizeCare at '
              'https://myaccount.google.com/permissions then Connect again.',
            ),
          );
        }
        final oauthApi = oauth2.Oauth2Api(client);
        final userInfo = await oauthApi.userinfo.get();
        final email = userInfo.email ?? 'Google account';
        final now = DateTime.now();
        final existing = await (_db.select(_db.gmailAccounts)..limit(1)).get();
        late final String accountId;
        if (existing.isEmpty) {
          accountId = _uuid.v4();
          await _db.into(_db.gmailAccounts).insert(
                GmailAccountsCompanion.insert(
                  id: accountId,
                  email: email,
                  connectedAt: now,
                ),
              );
        } else {
          accountId = existing.first.id;
          await (_db.update(_db.gmailAccounts)
                ..where((t) => t.id.equals(accountId)))
              .write(
            GmailAccountsCompanion(
              email: Value(email),
              connectedAt: Value(existing.first.connectedAt),
            ),
          );
        }
        final sync = await syncInbox();
        final account = (await getAccount()).requireValue;
        if (sync.isFailure) {
          return Err(
            NetworkFailure(
              'Connected as ${account!.email}, but inbox sync failed. '
              '${sync.requireFailure.message}',
              cause: sync.requireFailure.cause,
            ),
          );
        }
        return Success(account!);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(
        NetworkFailure(_apiErrorMessage(e, 'Failed to connect Gmail'), cause: e),
      );
    }
  }

  @override
  Future<Result<Unit>> disconnect() async {
    try {
      await _db.delete(_db.gmailMessages).go();
      await _db.delete(_db.gmailThreads).go();
      await _db.delete(_db.gmailAccounts).go();
      // Keep Google tokens (Calendar may still use them).
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to disconnect Gmail', cause: e));
    }
  }

  @override
  Future<Result<Unit>> syncInbox({int maxThreads = 40}) async {
    try {
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(ValidationFailure('Connect Google / Gmail first'));
      }
      if (!await _auth.hasGmailScope()) {
        return const Err(
          ValidationFailure('Reconnect Gmail to grant mailbox access'),
        );
      }
      final accountRows =
          await (_db.select(_db.gmailAccounts)..limit(1)).get();
      if (accountRows.isEmpty) {
        client.close();
        return const Err(ValidationFailure('Connect Gmail first'));
      }
      final account = accountRows.first;
      try {
        final api = gmail.GmailApi(client);
        final listed = await api.users.threads.list(
          'me',
          labelIds: ['INBOX'],
          maxResults: maxThreads,
        );
        final now = DateTime.now();
        final remoteIds = <String>{};

        for (final summary in listed.threads ?? const <gmail.Thread>[]) {
          final threadId = summary.id;
          if (threadId == null || threadId.isEmpty) continue;
          remoteIds.add(threadId);

          gmail.Thread full;
          try {
            full = await api.users.threads.get(
              'me',
              threadId,
              format: 'metadata',
              metadataHeaders: ['From', 'Subject', 'Date'],
            );
          } catch (_) {
            continue;
          }

          final messages = full.messages ?? const <gmail.Message>[];
          if (messages.isEmpty) continue;
          final latest = messages.last;
          final headers = latest.payload?.headers ?? const <gmail.MessagePartHeader>[];
          final from = _parseAddress(_header(headers, 'From'));
          final subject = _header(headers, 'Subject') ?? '(no subject)';
          final date = _parseDate(_header(headers, 'Date')) ??
              DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(latest.internalDate ?? '') ??
                    now.millisecondsSinceEpoch,
              );
          final unread = (latest.labelIds ?? const <String>[]).contains('UNREAD') ||
              messages.any(
                (m) => (m.labelIds ?? const <String>[]).contains('UNREAD'),
              );

          final existing = await (_db.select(_db.gmailThreads)
                ..where(
                  (t) =>
                      t.accountId.equals(account.id) &
                      t.gmailThreadId.equals(threadId),
                ))
              .getSingleOrNull();
          final rowId = existing?.id ?? _uuid.v4();
          final companion = GmailThreadsCompanion(
            id: Value(rowId),
            accountId: Value(account.id),
            gmailThreadId: Value(threadId),
            subject: Value(subject),
            snippet: Value(summary.snippet ?? full.snippet ?? ''),
            fromName: Value(from.$1),
            fromEmail: Value(from.$2),
            date: Value(date),
            isUnread: Value(unread),
            updatedAt: Value(now),
          );
          if (existing == null) {
            await _db.into(_db.gmailThreads).insert(companion);
          } else {
            await (_db.update(_db.gmailThreads)
                  ..where((t) => t.id.equals(rowId)))
                .write(companion);
          }
        }

        // Drop threads no longer in the fetched inbox window.
        final local = await (_db.select(_db.gmailThreads)
              ..where((t) => t.accountId.equals(account.id)))
            .get();
        for (final row in local) {
          if (!remoteIds.contains(row.gmailThreadId)) {
            await (_db.delete(_db.gmailMessages)
                  ..where(
                    (t) =>
                        t.accountId.equals(account.id) &
                        t.gmailThreadId.equals(row.gmailThreadId),
                  ))
                .go();
            await (_db.delete(_db.gmailThreads)
                  ..where((t) => t.id.equals(row.id)))
                .go();
          }
        }

        await (_db.update(_db.gmailAccounts)
              ..where((t) => t.id.equals(account.id)))
            .write(GmailAccountsCompanion(lastSyncAt: Value(now)));
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(
        NetworkFailure(
          _apiErrorMessage(e, 'Failed to sync Gmail inbox'),
          cause: e,
        ),
      );
    }
  }

  @override
  Stream<List<GmailThread>> watchThreads() {
    return (_db.select(_db.gmailThreads)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(_mapThread).toList());
  }

  @override
  Stream<List<GmailMessage>> watchThreadMessages(String gmailThreadId) {
    return (_db.select(_db.gmailMessages)
          ..where((t) => t.gmailThreadId.equals(gmailThreadId))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch()
        .map((rows) => rows.map(_mapMessage).toList());
  }

  @override
  Future<Result<Unit>> openThread(String gmailThreadId) async {
    try {
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(ValidationFailure('Connect Gmail first'));
      }
      final accountRows =
          await (_db.select(_db.gmailAccounts)..limit(1)).get();
      if (accountRows.isEmpty) {
        client.close();
        return const Err(ValidationFailure('Connect Gmail first'));
      }
      final account = accountRows.first;
      try {
        final api = gmail.GmailApi(client);
        final full = await api.users.threads.get(
          'me',
          gmailThreadId,
          format: 'full',
        );
        final now = DateTime.now();
        final messages = full.messages ?? const <gmail.Message>[];

        await (_db.delete(_db.gmailMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.gmailThreadId.equals(gmailThreadId),
              ))
            .go();

        for (final msg in messages) {
          final mid = msg.id;
          if (mid == null) continue;
          final headers = msg.payload?.headers ?? const <gmail.MessagePartHeader>[];
          final from = _parseAddress(_header(headers, 'From'));
          final to = _header(headers, 'To') ?? '';
          final subject = _header(headers, 'Subject') ?? '(no subject)';
          final date = _parseDate(_header(headers, 'Date')) ??
              DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(msg.internalDate ?? '') ??
                    now.millisecondsSinceEpoch,
              );
          final unread =
              (msg.labelIds ?? const <String>[]).contains('UNREAD');
          final bodies = GmailHtml.bodiesFromPayload(msg.payload);
          final bodyText = bodies.plain.isNotEmpty
              ? bodies.plain
              : (msg.snippet ?? '');

          await _db.into(_db.gmailMessages).insert(
                GmailMessagesCompanion.insert(
                  id: _uuid.v4(),
                  accountId: account.id,
                  gmailThreadId: gmailThreadId,
                  gmailMessageId: mid,
                  fromName: Value(from.$1),
                  fromEmail: Value(from.$2),
                  toEmails: Value(to),
                  subject: subject,
                  bodyText: bodyText,
                  bodyHtml: Value(bodies.html),
                  date: date,
                  isUnread: Value(unread),
                  updatedAt: now,
                ),
              );
        }

        await markThreadRead(gmailThreadId);
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(
        NetworkFailure(_apiErrorMessage(e, 'Failed to open thread'), cause: e),
      );
    }
  }

  @override
  Future<Result<Unit>> markThreadRead(String gmailThreadId) async {
    try {
      final client = await _auth.createAuthClient();
      if (client == null) return const Success(unit);
      try {
        final api = gmail.GmailApi(client);
        await api.users.threads.modify(
          gmail.ModifyThreadRequest(removeLabelIds: ['UNREAD']),
          'me',
          gmailThreadId,
        );
        await (_db.update(_db.gmailThreads)
              ..where((t) => t.gmailThreadId.equals(gmailThreadId)))
            .write(const GmailThreadsCompanion(isUnread: Value(false)));
        await (_db.update(_db.gmailMessages)
              ..where((t) => t.gmailThreadId.equals(gmailThreadId)))
            .write(const GmailMessagesCompanion(isUnread: Value(false)));
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(NetworkFailure('Failed to mark read', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sendMessage({
    required String to,
    required String subject,
    required String body,
    String? bodyHtml,
    String? replyToThreadId,
    String? inReplyToMessageId,
  }) async {
    try {
      final trimmedTo = to.trim();
      final trimmedBody = body.trim();
      if (trimmedTo.isEmpty) {
        return const Err(ValidationFailure('Recipient is required'));
      }
      if (trimmedBody.isEmpty &&
          (bodyHtml == null || GmailHtml.stripHtmlToText(bodyHtml).isEmpty)) {
        return const Err(ValidationFailure('Message is empty'));
      }
      final client = await _auth.createAuthClient();
      if (client == null) {
        return const Err(ValidationFailure('Connect Gmail first'));
      }
      try {
        final api = gmail.GmailApi(client);
        final html = (bodyHtml != null && bodyHtml.trim().isNotEmpty)
            ? bodyHtml
            : '<p>${trimmedBody.replaceAll('\n', '<br/>')}</p>';
        final raw = GmailHtml.encodeRaw(
          GmailHtml.buildMultipartRfc822(
            to: trimmedTo,
            subject: subject.trim().isEmpty ? '(no subject)' : subject.trim(),
            plainBody: trimmedBody.isEmpty
                ? GmailHtml.stripHtmlToText(html)
                : trimmedBody,
            htmlBody: html,
            inReplyTo: inReplyToMessageId,
          ),
        );
        await api.users.messages.send(
          gmail.Message(
            raw: raw,
            threadId: replyToThreadId,
          ),
          'me',
        );
        await syncInbox();
        if (replyToThreadId != null) {
          await openThread(replyToThreadId);
        }
        return const Success(unit);
      } finally {
        client.close();
      }
    } catch (e) {
      return Err(
        NetworkFailure(_apiErrorMessage(e, 'Failed to send email'), cause: e),
      );
    }
  }

  GmailAccount _mapAccount(GmailAccountRow row) => GmailAccount(
        id: row.id,
        email: row.email,
        connectedAt: row.connectedAt,
        lastSyncAt: row.lastSyncAt,
      );

  GmailThread _mapThread(GmailThreadRow row) => GmailThread(
        id: row.id,
        gmailThreadId: row.gmailThreadId,
        subject: row.subject,
        snippet: row.snippet,
        date: row.date,
        isUnread: row.isUnread,
        fromName: row.fromName,
        fromEmail: row.fromEmail,
      );

  GmailMessage _mapMessage(GmailMessageRow row) => GmailMessage(
        id: row.id,
        gmailThreadId: row.gmailThreadId,
        gmailMessageId: row.gmailMessageId,
        subject: row.subject,
        bodyText: row.bodyText,
        bodyHtml: row.bodyHtml,
        date: row.date,
        isUnread: row.isUnread,
        toEmails: row.toEmails,
        fromName: row.fromName,
        fromEmail: row.fromEmail,
      );

  static String? _header(List<gmail.MessagePartHeader> headers, String name) {
    for (final h in headers) {
      if (h.name != null && h.name!.toLowerCase() == name.toLowerCase()) {
        return h.value;
      }
    }
    return null;
  }

  /// Returns (displayName, email).
  static (String?, String?) _parseAddress(String? raw) {
    if (raw == null || raw.trim().isEmpty) return (null, null);
    final s = raw.trim();
    final angle = RegExp(r'^(.*?)\s*<([^>]+)>\s*$').firstMatch(s);
    if (angle != null) {
      final name = angle.group(1)?.replaceAll('"', '').trim();
      final email = angle.group(2)?.trim();
      return (
        name == null || name.isEmpty ? null : name,
        email,
      );
    }
    if (s.contains('@')) return (null, s);
    return (s, null);
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {}
    try {
      return HttpDate.parse(raw);
    } catch (_) {
      return null;
    }
  }
}
