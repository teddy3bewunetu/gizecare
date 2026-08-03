import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/slack/data/slack_api_client.dart';
import 'package:gizecare/features/slack/data/slack_auth_service.dart';
import 'package:gizecare/features/slack/domain/entities/slack_entities.dart';
import 'package:gizecare/features/slack/domain/repositories/slack_repository.dart';
import 'package:gizecare/features/slack/domain/slack_config.dart';

class DriftSlackRepository implements SlackRepository {
  DriftSlackRepository({
    required AppDatabase db,
    required SlackAuthService auth,
    SlackApiClient? api,
  })  : _db = db,
        _auth = auth,
        _api = api ?? SlackApiClient(tokenStore: auth.tokenStore);

  final AppDatabase _db;
  final SlackAuthService _auth;
  final SlackApiClient _api;
  final _uuid = const Uuid();
  final _userNameCache = <String, String>{};

  @override
  Stream<SlackAccount?> watchAccount() {
    return (_db.select(_db.slackAccounts)..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _mapAccount(rows.first));
  }

  @override
  Future<Result<SlackAccount?>> getAccount() async {
    try {
      final rows = await (_db.select(_db.slackAccounts)..limit(1)).get();
      return Success(rows.isEmpty ? null : _mapAccount(rows.first));
    } catch (e) {
      return Err(CacheFailure('Failed to load Slack account', cause: e));
    }
  }

  @override
  Future<Result<SlackAccount>> connect() async {
    if (!AppPlatform.isLinux) {
      return const Err(
        PlatformFailure('Slack connect is available on Linux only'),
      );
    }
    if (!SlackConfig.hasCredentials) {
      return const Err(
        ValidationFailure(
          'Missing SLACK_CLIENT_ID / SLACK_CLIENT_SECRET. See docs/slack_setup.md',
        ),
      );
    }
    try {
      final tokens = await _auth.authorizeInteractive();
      String? displayName;
      try {
        final me = await _api.authTest();
        displayName = me['user'] as String?;
      } catch (_) {}

      final now = DateTime.now();
      final existing = await (_db.select(_db.slackAccounts)..limit(1)).get();
      final id = existing.isEmpty ? _uuid.v4() : existing.first.id;
      await _db.into(_db.slackAccounts).insertOnConflictUpdate(
            SlackAccountsCompanion.insert(
              id: id,
              teamId: tokens.teamId,
              teamName: tokens.teamName,
              userId: tokens.userId,
              displayName: Value(displayName),
              connectedAt: existing.isEmpty ? now : existing.first.connectedAt,
              lastSyncAt: const Value(null),
            ),
          );

      await syncConversations();

      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(CacheFailure('Connected but account row missing'));
      }
      return Success(account);
    } catch (e) {
      return Err(NetworkFailure('Failed to connect Slack', cause: e));
    }
  }

  @override
  Future<Result<Unit>> disconnect() async {
    try {
      await _auth.clearStoredTokens();
      await _db.delete(_db.slackMessages).go();
      await _db.delete(_db.slackConversations).go();
      await _db.delete(_db.slackAccounts).go();
      _userNameCache.clear();
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to disconnect Slack', cause: e));
    }
  }

  @override
  Future<Result<Unit>> syncConversations() async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Slack first'));
      }

      String? cursor;
      final channels = <Map<String, dynamic>>[];
      do {
        final page = await _api.usersConversations(cursor: cursor);
        final list = page['channels'] as List? ?? const [];
        for (final item in list) {
          if (item is Map<String, dynamic>) channels.add(item);
        }
        final meta = page['response_metadata'] as Map<String, dynamic>?;
        cursor = meta?['next_cursor'] as String?;
        if (cursor != null && cursor.isEmpty) cursor = null;
      } while (cursor != null);

      final now = DateTime.now();
      final seen = <String>{};

      for (final ch in channels) {
        final conversationId = ch['id'] as String?;
        if (conversationId == null) continue;
        seen.add(conversationId);

        final type = _typeFromChannel(ch);
        final name = await _displayNameForChannel(ch, type);
        final unread = ch['unread_count_display'] as int? ??
            ch['unread_count'] as int? ??
            0;
        final isMuted = (ch['is_muted'] as bool?) ?? false;
        DateTime? lastAt;
        final latest = ch['latest'] as Map<String, dynamic>?;
        final ts = latest?['ts'] as String?;
        if (ts != null) lastAt = _tsToDateTime(ts);

        final existing = await (_db.select(_db.slackConversations)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.conversationId.equals(conversationId),
              ))
            .getSingleOrNull();

        final rowId = existing?.id ?? _uuid.v4();
        await _db.into(_db.slackConversations).insertOnConflictUpdate(
              SlackConversationsCompanion.insert(
                id: rowId,
                accountId: account.id,
                conversationId: conversationId,
                name: name,
                conversationType: slackConversationTypeToString(type),
                isMuted: Value(isMuted),
                isAllowed: Value(existing?.isAllowed ?? true),
                unreadCount: Value(unread),
                lastMessageAt: Value(lastAt ?? existing?.lastMessageAt),
                updatedAt: now,
              ),
            );
      }

      final all = await (_db.select(_db.slackConversations)
            ..where((t) => t.accountId.equals(account.id)))
          .get();
      for (final row in all) {
        if (!seen.contains(row.conversationId)) {
          await (_db.delete(_db.slackMessages)
                ..where(
                  (t) =>
                      t.accountId.equals(account.id) &
                      t.conversationId.equals(row.conversationId),
                ))
              .go();
          await (_db.delete(_db.slackConversations)
                ..where((t) => t.id.equals(row.id)))
              .go();
        }
      }

      await (_db.update(_db.slackAccounts)
            ..where((t) => t.id.equals(account.id)))
          .write(SlackAccountsCompanion(lastSyncAt: Value(now)));

      return const Success(unit);
    } catch (e) {
      return Err(
        NetworkFailure('Failed to sync Slack conversations', cause: e),
      );
    }
  }

  @override
  Stream<List<SlackConversation>> watchConversations() {
    return (_db.select(_db.slackConversations)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastMessageAt),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapConversation).toList());
  }

  @override
  Stream<List<SlackMessage>> watchMessages(String conversationId) {
    return (_db.select(_db.slackMessages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([(t) => OrderingTerm.asc(t.sentAt)]))
        .watch()
        .map((rows) => rows.map(_mapMessage).toList());
  }

  @override
  Future<Result<Unit>> syncMessages(
    String conversationId, {
    int limit = 50,
    bool soft = false,
  }) async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Slack first'));
      }

      // Soft sync: fetch a recent window and upsert (no wipe) so edits/reactions
      // on recent messages land without resetting scroll/history.
      final history = await _api.conversationsHistory(
        channel: conversationId,
        limit: soft ? 30 : limit,
      );
      final messages = history['messages'] as List? ?? const [];
      final now = DateTime.now();

      if (!soft) {
        await (_db.delete(_db.slackMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.conversationId.equals(conversationId),
              ))
            .go();
      }

      DateTime? latestAt;
      for (final raw in messages.reversed) {
        if (raw is! Map<String, dynamic>) continue;
        final upserted = await _upsertRawMessage(
          account: account,
          conversationId: conversationId,
          raw: raw,
          now: now,
        );
        if (upserted != null &&
            (latestAt == null || upserted.isAfter(latestAt))) {
          latestAt = upserted;
        }
      }

      if (latestAt != null) {
        await (_db.update(_db.slackConversations)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.conversationId.equals(conversationId),
              ))
            .write(
              SlackConversationsCompanion(
                lastMessageAt: Value(latestAt),
                updatedAt: Value(now),
              ),
            );
      }

      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to sync Slack messages', cause: e));
    }
  }

  @override
  Future<Result<Unit>> syncThreadReplies({
    required String conversationId,
    required String threadTs,
  }) async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Slack first'));
      }
      final result = await _api.conversationsReplies(
        channel: conversationId,
        ts: threadTs,
      );
      final messages = result['messages'] as List? ?? const [];
      final now = DateTime.now();
      for (final raw in messages) {
        if (raw is! Map<String, dynamic>) continue;
        await _upsertRawMessage(
          account: account,
          conversationId: conversationId,
          raw: raw,
          now: now,
        );
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to sync thread replies', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sendMessage({
    required String conversationId,
    required String text,
    String? threadTs,
  }) async {
    try {
      final trimmed = text.trim();
      if (trimmed.isEmpty) {
        return const Err(ValidationFailure('Message is empty'));
      }
      await _api.chatPostMessage(
        channel: conversationId,
        text: trimmed,
        threadTs: threadTs,
      );
      if (threadTs != null) {
        return syncThreadReplies(
          conversationId: conversationId,
          threadTs: threadTs,
        );
      }
      return syncMessages(conversationId, soft: true);
    } catch (e) {
      return Err(NetworkFailure('Failed to send Slack message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> editMessage({
    required String conversationId,
    required String messageTs,
    required String text,
  }) async {
    try {
      final trimmed = text.trim();
      if (trimmed.isEmpty) {
        return const Err(ValidationFailure('Message is empty'));
      }
      await _api.chatUpdate(
        channel: conversationId,
        ts: messageTs,
        text: trimmed,
      );
      final account = (await getAccount()).requireValue;
      if (account != null) {
        await (_db.update(_db.slackMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.conversationId.equals(conversationId) &
                    t.messageTs.equals(messageTs),
              ))
            .write(
              SlackMessagesCompanion(
                body: Value(trimmed),
                isEdited: const Value(true),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to edit Slack message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteMessage({
    required String conversationId,
    required String messageTs,
  }) async {
    try {
      await _api.chatDelete(channel: conversationId, ts: messageTs);
      final account = (await getAccount()).requireValue;
      if (account != null) {
        await (_db.delete(_db.slackMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.conversationId.equals(conversationId) &
                    t.messageTs.equals(messageTs),
              ))
            .go();
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to delete Slack message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> addReaction({
    required String conversationId,
    required String messageTs,
    required String emojiName,
  }) async {
    try {
      await _api.reactionsAdd(
        channel: conversationId,
        timestamp: messageTs,
        name: emojiName,
      );
      return syncMessages(conversationId, soft: true, limit: 30);
    } catch (e) {
      return Err(NetworkFailure('Failed to add reaction', cause: e));
    }
  }

  @override
  Future<Result<Unit>> removeReaction({
    required String conversationId,
    required String messageTs,
    required String emojiName,
  }) async {
    try {
      await _api.reactionsRemove(
        channel: conversationId,
        timestamp: messageTs,
        name: emojiName,
      );
      return syncMessages(conversationId, soft: true, limit: 30);
    } catch (e) {
      return Err(NetworkFailure('Failed to remove reaction', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sendFile({
    required String conversationId,
    required String filePath,
    String? caption,
    String? threadTs,
  }) async {
    try {
      await _api.uploadFile(
        channel: conversationId,
        filePath: filePath,
        caption: caption,
        threadTs: threadTs,
      );
      if (threadTs != null) {
        return syncThreadReplies(
          conversationId: conversationId,
          threadTs: threadTs,
        );
      }
      return syncMessages(conversationId, soft: true);
    } catch (e) {
      return Err(NetworkFailure('Failed to upload Slack file', cause: e));
    }
  }

  @override
  Future<Result<String>> downloadFile(SlackFileRef file) async {
    try {
      final url = file.urlPrivate;
      if (url == null || url.isEmpty) {
        return const Err(ValidationFailure('File has no download URL'));
      }
      final bytes = await _api.downloadPrivateUrl(url);
      final dir = await getApplicationSupportDirectory();
      final folder = Directory(p.join(dir.path, 'slack_files'));
      if (!await folder.exists()) await folder.create(recursive: true);
      final safeName = file.name.replaceAll(RegExp(r'[^\w.\-]+'), '_');
      final out = File(p.join(folder.path, '${file.id}_$safeName'));
      await out.writeAsBytes(bytes, flush: true);
      return Success(out.path);
    } catch (e) {
      return Err(NetworkFailure('Failed to download Slack file', cause: e));
    }
  }

  @override
  Future<Result<Unit>> markRead(String conversationId) async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Slack first'));
      }
      final latest = await (_db.select(_db.slackMessages)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.conversationId.equals(conversationId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)])
            ..limit(1))
          .getSingleOrNull();
      if (latest != null) {
        try {
          await _api.conversationsMark(
            channel: conversationId,
            ts: latest.messageTs,
          );
        } catch (_) {}
      }
      await (_db.update(_db.slackConversations)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.conversationId.equals(conversationId),
            ))
          .write(const SlackConversationsCompanion(unreadCount: Value(0)));
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to mark Slack chat read', cause: e));
    }
  }

  @override
  Future<Result<Unit>> refreshConversationUnread(String conversationId) async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Slack first'));
      }
      final info = await _api.conversationsInfo(conversationId);
      final channel = info['channel'] as Map<String, dynamic>?;
      final unread = channel?['unread_count_display'] as int? ??
          channel?['unread_count'] as int? ??
          0;
      await (_db.update(_db.slackConversations)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.conversationId.equals(conversationId),
            ))
          .write(
            SlackConversationsCompanion(
              unreadCount: Value(unread),
              updatedAt: Value(DateTime.now()),
            ),
          );
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to refresh unread', cause: e));
    }
  }

  Future<DateTime?> _upsertRawMessage({
    required SlackAccount account,
    required String conversationId,
    required Map<String, dynamic> raw,
    required DateTime now,
  }) async {
    final ts = raw['ts'] as String?;
    if (ts == null) return null;
    final userId = raw['user'] as String?;
    final text = raw['text'] as String? ?? '';
    final threadTs = raw['thread_ts'] as String?;
    final replyCount = raw['reply_count'] as int? ?? 0;
    final isEdited = raw['edited'] != null;
    final sentAt = _tsToDateTime(ts);
    final reactions = _parseReactions(raw['reactions'] as List?, account.userId);
    final files = _parseFiles(raw['files'] as List?);

    String? senderName;
    if (userId != null) {
      senderName = await _resolveUserName(userId);
    }

    final existing = await (_db.select(_db.slackMessages)
          ..where(
            (t) =>
                t.accountId.equals(account.id) &
                t.conversationId.equals(conversationId) &
                t.messageTs.equals(ts),
          ))
        .getSingleOrNull();

    final companion = SlackMessagesCompanion.insert(
      id: existing?.id ?? _uuid.v4(),
      accountId: account.id,
      conversationId: conversationId,
      messageTs: ts,
      threadTs: Value(threadTs),
      senderName: Value(senderName),
      senderUserId: Value(userId),
      body: text,
      isOutgoing: Value(userId == account.userId),
      replyCount: Value(replyCount),
      reactionsJson: Value(jsonEncode(reactions.map((r) => r.toJson()).toList())),
      filesJson: Value(jsonEncode(files.map((f) => f.toJson()).toList())),
      isEdited: Value(isEdited),
      sentAt: sentAt,
      updatedAt: now,
    );
    await _db.into(_db.slackMessages).insertOnConflictUpdate(companion);
    return sentAt;
  }

  List<SlackReaction> _parseReactions(List<dynamic>? raw, String selfUserId) {
    if (raw == null) return const [];
    final out = <SlackReaction>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final name = item['name'] as String? ?? '';
      final count = item['count'] as int? ?? 0;
      final users = item['users'] as List? ?? const [];
      final isMine = users.any((u) => '$u' == selfUserId);
      if (name.isEmpty) continue;
      out.add(SlackReaction(name: name, count: count, isMine: isMine));
    }
    return out;
  }

  List<SlackFileRef> _parseFiles(List<dynamic>? raw) {
    if (raw == null) return const [];
    final out = <SlackFileRef>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final id = item['id'] as String? ?? '';
      if (id.isEmpty) continue;
      out.add(
        SlackFileRef(
          id: id,
          name: item['name'] as String? ??
              item['title'] as String? ??
              'file',
          mimetype: item['mimetype'] as String?,
          urlPrivate: item['url_private'] as String? ??
              item['url_private_download'] as String?,
          thumbUrl: item['thumb_64'] as String? ??
              item['thumb_80'] as String? ??
              item['thumb_360'] as String?,
        ),
      );
    }
    return out;
  }

  SlackConversationType _typeFromChannel(Map<String, dynamic> ch) {
    if (ch['is_im'] == true) return SlackConversationType.im;
    if (ch['is_mpim'] == true) return SlackConversationType.mpim;
    if (ch['is_private'] == true || ch['is_group'] == true) {
      return SlackConversationType.group;
    }
    if (ch['is_channel'] == true) return SlackConversationType.channel;
    return SlackConversationType.unknown;
  }

  Future<String> _displayNameForChannel(
    Map<String, dynamic> ch,
    SlackConversationType type,
  ) async {
    if (type == SlackConversationType.im) {
      final userId = ch['user'] as String?;
      if (userId != null) {
        final name = await _resolveUserName(userId);
        return name ?? userId;
      }
    }
    final name = ch['name'] as String?;
    if (name != null && name.isNotEmpty) {
      return type == SlackConversationType.channel ||
              type == SlackConversationType.group
          ? '#$name'
          : name;
    }
    return ch['id'] as String? ?? 'conversation';
  }

  Future<String?> _resolveUserName(String userId) async {
    final cached = _userNameCache[userId];
    if (cached != null) return cached;
    try {
      final info = await _api.usersInfo(userId);
      final user = info['user'] as Map<String, dynamic>?;
      final profile = user?['profile'] as Map<String, dynamic>?;
      final name = profile?['display_name'] as String?;
      final real = profile?['real_name'] as String?;
      final resolved = (name != null && name.isNotEmpty)
          ? name
          : (real != null && real.isNotEmpty)
              ? real
              : user?['name'] as String? ?? userId;
      _userNameCache[userId] = resolved;
      return resolved;
    } catch (_) {
      return userId;
    }
  }

  DateTime _tsToDateTime(String ts) {
    final seconds = double.tryParse(ts) ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(
      (seconds * 1000).round(),
      isUtc: true,
    ).toLocal();
  }

  SlackAccount _mapAccount(SlackAccountRow row) {
    return SlackAccount(
      id: row.id,
      teamId: row.teamId,
      teamName: row.teamName,
      userId: row.userId,
      displayName: row.displayName,
      connectedAt: row.connectedAt,
      lastSyncAt: row.lastSyncAt,
    );
  }

  SlackConversation _mapConversation(SlackConversationRow row) {
    return SlackConversation(
      id: row.id,
      conversationId: row.conversationId,
      name: row.name,
      conversationType: slackConversationTypeFromString(row.conversationType),
      isMuted: row.isMuted,
      isAllowed: row.isAllowed,
      unreadCount: row.unreadCount,
      lastMessageAt: row.lastMessageAt,
    );
  }

  SlackMessage _mapMessage(SlackMessageRow row) {
    var reactions = const <SlackReaction>[];
    var files = const <SlackFileRef>[];
    try {
      final raw = row.reactionsJson;
      final r = jsonDecode(raw.isEmpty ? '[]' : raw);
      if (r is List) {
        reactions = r
            .whereType<Map>()
            .map((e) => SlackReaction.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}
    try {
      final raw = row.filesJson;
      final f = jsonDecode(raw.isEmpty ? '[]' : raw);
      if (f is List) {
        files = f
            .whereType<Map>()
            .map((e) => SlackFileRef.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}

    return SlackMessage(
      id: row.id,
      conversationId: row.conversationId,
      messageTs: row.messageTs,
      threadTs: row.threadTs,
      senderName: row.senderName,
      senderUserId: row.senderUserId,
      text: row.body,
      sentAt: row.sentAt,
      isOutgoing: row.isOutgoing,
      replyCount: row.replyCount,
      reactions: reactions,
      files: files,
      isEdited: row.isEdited,
    );
  }
}
