import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/telegram/data/tdjson_client.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/repositories/telegram_repository.dart';
import 'package:gizecare/features/telegram/domain/telegram_config.dart';

class DriftTelegramRepository implements TelegramRepository {
  DriftTelegramRepository({
    required AppDatabase db,
    TdjsonClient? client,
  })  : _db = db,
        _client = client ?? TdjsonClient() {
    _client.updates.listen(_onUpdate);
  }

  final AppDatabase _db;
  final TdjsonClient _client;
  final _uuid = const Uuid();
  final _pendingChats = <int, Completer<Map<String, dynamic>>>{};
  final _pendingHistory = <int, Completer<List<Map<String, dynamic>>>>{};
  final _pendingMe = <Completer<Map<String, dynamic>>>[];

  @override
  Stream<TelegramAccount?> watchAccount() {
    return (_db.select(_db.telegramAccounts)..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _mapAccount(rows.first));
  }

  @override
  Future<Result<TelegramAccount?>> getAccount() async {
    try {
      final rows = await (_db.select(_db.telegramAccounts)..limit(1)).get();
      return Success(rows.isEmpty ? null : _mapAccount(rows.first));
    } catch (e) {
      return Err(CacheFailure('Failed to load Telegram account', cause: e));
    }
  }

  @override
  Stream<TelegramAuthStep> watchAuthStep() async* {
    yield _client.currentAuthStep;
    yield* _client.authStepStream;
  }

  @override
  Stream<TelegramCodeInfo?> watchCodeInfo() async* {
    yield _client.codeInfo;
    yield* _client.codeInfoStream;
  }

  @override
  Future<Result<Unit>> startClient() async {
    if (!AppPlatform.isLinux) {
      return const Err(
        PlatformFailure('Telegram connect is available on Linux only'),
      );
    }
    if (!TelegramConfig.hasCredentials) {
      return const Err(
        ValidationFailure(
          'Missing TELEGRAM_API_ID / TELEGRAM_API_HASH. See docs/telegram_setup.md',
        ),
      );
    }
    try {
      await _client.ensureStarted();
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('$e', cause: e));
    }
  }

  @override
  Future<Result<Unit>> resumeSession() async {
    if (!AppPlatform.isLinux) {
      return const Err(
        PlatformFailure('Telegram connect is available on Linux only'),
      );
    }
    if (!TelegramConfig.hasCredentials) {
      return const Err(
        ValidationFailure(
          'Missing TELEGRAM_API_ID / TELEGRAM_API_HASH. See docs/telegram_setup.md',
        ),
      );
    }
    try {
      if (_client.isReady) return const Success(unit);
      await _client.ensureReady();
      return const Success(unit);
    } catch (e) {
      final msg = e is StateError ? e.message : '$e';
      return Err(ValidationFailure(msg, cause: e));
    }
  }

  /// Ensures the live TDLib client is authorized before network ops.
  Future<Result<Unit>?> _ensureLiveSession() async {
    if (_client.isReady) return null;
    final resumed = await resumeSession();
    if (resumed.isSuccess) return null;
    return Err(resumed.requireFailure);
  }

  @override
  Future<Result<Unit>> submitPhone(String phoneNumber) async {
    try {
      await _client.ensureStarted();
      await _client.setPhoneNumber(phoneNumber.trim());
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to submit phone', cause: e));
    }
  }

  @override
  Future<Result<Unit>> submitCode(String code) async {
    try {
      await _client.checkCode(code.trim());
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to submit code', cause: e));
    }
  }

  @override
  Future<Result<Unit>> submitPassword(String password) async {
    try {
      await _client.checkPassword(password);
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to submit password', cause: e));
    }
  }

  @override
  Future<Result<Unit>> resendCode() async {
    try {
      await _client.resendAuthenticationCode();
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to resend code', cause: e));
    }
  }

  @override
  Future<Result<Unit>> disconnect() async {
    try {
      try {
        _client.send({'@type': 'logOut'});
      } catch (_) {}
      await _client.close();

      final accounts = await _db.select(_db.telegramAccounts).get();
      for (final account in accounts) {
        await (_db.delete(_db.telegramMessages)
              ..where((t) => t.accountId.equals(account.id)))
            .go();
        await (_db.delete(_db.telegramChats)
              ..where((t) => t.accountId.equals(account.id)))
            .go();
        await (_db.delete(_db.telegramAccounts)
              ..where((t) => t.id.equals(account.id)))
            .go();
      }

      final support = await getApplicationSupportDirectory();
      for (final entity in support.listSync()) {
        if (entity is! Directory) continue;
        final name = p.basename(entity.path);
        if (name == 'telegram_tdlib' ||
            name.startsWith('telegram_tdlib_') ||
            name.startsWith('telegram_tdlib.retired_')) {
          try {
            await entity.delete(recursive: true);
          } catch (_) {}
        }
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to disconnect Telegram', cause: e));
    }
  }

  @override
  Future<Result<Unit>> syncChats() async {
    try {
      final live = await _ensureLiveSession();
      if (live != null) return live;
      await _ensureAccountRow();
      _client.loadChats(limit: 200);
      // Give TDLib time to emit chats, then refresh known chat ids.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('No Telegram account row'));
      }

      // Ask TDLib for chat list via getChats is deprecated; rely on updateNewChat
      // already persisted in _onUpdate. Mark sync time.
      await (_db.update(_db.telegramAccounts)
            ..where((t) => t.id.equals(account.id)))
          .write(TelegramAccountsCompanion(lastSyncAt: Value(DateTime.now())));
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to sync chats', cause: e));
    }
  }

  @override
  Stream<List<TelegramChat>> watchChats({bool allowedOnly = false}) {
    final query = _db.select(_db.telegramChats)
      ..orderBy([
        (t) => OrderingTerm.desc(t.lastMessageAt),
        (t) => OrderingTerm.asc(t.title),
      ]);
    if (allowedOnly) {
      query.where((t) => t.isAllowed.equals(true));
    }
    return query.watch().map((rows) => rows.map(_mapChat).toList());
  }

  @override
  Future<Result<List<TelegramChat>>> getChats({bool allowedOnly = false}) async {
    try {
      final query = _db.select(_db.telegramChats)
        ..orderBy([(t) => OrderingTerm.asc(t.title)]);
      if (allowedOnly) {
        query.where((t) => t.isAllowed.equals(true));
      }
      final rows = await query.get();
      return Success(rows.map(_mapChat).toList());
    } catch (e) {
      return Err(CacheFailure('Failed to load chats', cause: e));
    }
  }

  @override
  Future<Result<Unit>> setAllowedChats(Set<String> telegramChatIds) async {
    try {
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Telegram first'));
      }
      final all = await (_db.select(_db.telegramChats)
            ..where((t) => t.accountId.equals(account.id)))
          .get();
      for (final chat in all) {
        final allowed = telegramChatIds.contains(chat.telegramChatId);
        await (_db.update(_db.telegramChats)
              ..where((t) => t.id.equals(chat.id)))
            .write(TelegramChatsCompanion(isAllowed: Value(allowed)));
        if (!allowed) {
          await (_db.delete(_db.telegramMessages)
                ..where(
                  (t) =>
                      t.accountId.equals(account.id) &
                      t.telegramChatId.equals(chat.telegramChatId),
                ))
              .go();
        }
      }
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to update allowlist', cause: e));
    }
  }

  @override
  Future<Result<Unit>> syncMessages(
    String telegramChatId, {
    int limit = 50,
  }) async {
    try {
      final live = await _ensureLiveSession();
      if (live != null) return live;
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(
          ValidationFailure(
            'Telegram session expired. Tap Connect to sign in again.',
          ),
        );
      }
      final chat = await (_db.select(_db.telegramChats)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(telegramChatId),
            ))
          .getSingleOrNull();
      if (chat == null || !chat.isAllowed) {
        return const Err(
          ValidationFailure('Chat is not allowed in GizeCare'),
        );
      }

      final chatId = int.parse(telegramChatId);
      final completer = Completer<List<Map<String, dynamic>>>();
      _pendingHistory[chatId] = completer;
      _client.getChatHistory(chatId: chatId, limit: limit);
      final messages = await completer.future.timeout(
        const Duration(seconds: 12),
        onTimeout: () => <Map<String, dynamic>>[],
      );

      final now = DateTime.now();
      for (final msg in messages) {
        await _upsertMessage(account.id, msg, now);
      }
      await _dedupeMessages(account.id, telegramChatId);
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to sync messages', cause: e));
    }
  }

  @override
  Stream<List<TelegramMessage>> watchMessages(String telegramChatId) {
    return (_db.select(_db.telegramMessages)
          ..where((t) => t.telegramChatId.equals(telegramChatId))
          ..orderBy([(t) => OrderingTerm.asc(t.sentAt)]))
        .watch()
        .map((rows) => rows.map(_mapMessage).toList());
  }

  @override
  Future<Result<Unit>> sendMessage({
    required String telegramChatId,
    required String text,
    String? replyToMessageId,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final trimmed = text.trim();
      if (trimmed.isEmpty) {
        return const Err(ValidationFailure('Message is empty'));
      }
      await _client.sendTextMessage(
        chatId: int.parse(telegramChatId),
        text: trimmed,
        replyToMessageId: replyToMessageId == null
            ? null
            : int.tryParse(replyToMessageId),
      );
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to send message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> editMessage({
    required String telegramChatId,
    required String telegramMessageId,
    required String text,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final trimmed = text.trim();
      if (trimmed.isEmpty) {
        return const Err(ValidationFailure('Message is empty'));
      }
      await _client.editTextMessage(
        chatId: int.parse(telegramChatId),
        messageId: int.parse(telegramMessageId),
        text: trimmed,
      );
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to edit message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteMessage({
    required String telegramChatId,
    required String telegramMessageId,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      await _client.deleteMessages(
        chatId: int.parse(telegramChatId),
        messageIds: [int.parse(telegramMessageId)],
      );
      final account = (await getAccount()).requireValue;
      if (account != null) {
        await (_db.delete(_db.telegramMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.telegramChatId.equals(telegramChatId) &
                    t.telegramMessageId.equals(telegramMessageId),
              ))
            .go();
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to delete message', cause: e));
    }
  }

  @override
  Future<Result<Unit>> markChatRead(String telegramChatId) async {
    try {
      final live = await _ensureLiveSession();
      if (live != null) return live;
      final account = (await getAccount()).requireValue;
      if (account == null) {
        return const Err(ValidationFailure('Connect Telegram first'));
      }
      final rows = await (_db.select(_db.telegramMessages)
            ..where((t) => t.telegramChatId.equals(telegramChatId))
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)])
            ..limit(40))
          .get();
      final ids = rows
          .map((r) => int.tryParse(r.telegramMessageId))
          .whereType<int>()
          .toList();
      final chatId = int.parse(telegramChatId);
      _client.openChat(chatId);
      if (ids.isNotEmpty) {
        await _client.viewMessages(chatId: chatId, messageIds: ids);
      }
      await (_db.update(_db.telegramChats)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(telegramChatId),
            ))
          .write(const TelegramChatsCompanion(unreadCount: Value(0)));
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to mark chat read', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sendDocument({
    required String telegramChatId,
    required String filePath,
    String? caption,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      await _client.sendDocumentMessage(
        chatId: int.parse(telegramChatId),
        filePath: filePath,
        caption: caption,
      );
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to send file', cause: e));
    }
  }

  @override
  Future<Result<Unit>> sendVoiceNote({
    required String telegramChatId,
    required String filePath,
    required int durationSeconds,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      await _client.sendVoiceNoteMessage(
        chatId: int.parse(telegramChatId),
        filePath: filePath,
        durationSeconds: durationSeconds,
      );
      return const Success(unit);
    } catch (e) {
      final detail = e.toString().replaceFirst('StateError: ', '');
      return Err(
        NetworkFailure(
          detail.startsWith('Failed') ? detail : 'Failed to send voice: $detail',
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<TelegramProfile>> getChatProfile(String telegramChatId) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) {
        return Err(guard.requireFailure);
      }
      final chatId = int.parse(telegramChatId);
      final chat = await _client.getChatResult(chatId);
      if (chat['@type'] == 'error') {
        return Err(
          NetworkFailure(chat['message'] as String? ?? 'Failed to load chat'),
        );
      }

      final title = chat['title'] as String? ?? 'Chat';
      final typeMap = chat['type'] as Map<String, dynamic>?;
      final chatType = _chatTypeFromTd(typeMap);
      final cached = await (_db.select(_db.telegramChats)
            ..where((t) => t.telegramChatId.equals(telegramChatId)))
          .getSingleOrNull();

      String? photoPath = cached?.photoPath;
      final photo = chat['photo'] as Map<String, dynamic>?;
      final small = photo?['small'] as Map<String, dynamic>?;
      final fileId = small?['id'] as int?;
      if (fileId != null) {
        final local = small?['local'] as Map<String, dynamic>?;
        if (local?['is_downloading_completed'] == true) {
          photoPath = local?['path'] as String? ?? photoPath;
        } else {
          photoPath = await _client.downloadFilePath(fileId) ?? photoPath;
        }
      }

      String? userId;
      String? username = cached?.username;
      String? phone;
      String? firstName;
      String? lastName;
      String? bio;
      String? statusText;
      var isMuted = false;
      var isContact = false;
      var isBlocked = false;

      final notification = chat['notification_settings'] as Map<String, dynamic>?;
      final muteFor = notification?['mute_for'] as int? ?? 0;
      isMuted = muteFor > 0;

      if (typeMap?['@type'] == 'chatTypePrivate') {
        final uid = typeMap?['user_id'] as int?;
        if (uid != null) {
          userId = '$uid';
          final user = await _client.getUserResult(uid);
          if (user['@type'] != 'error') {
            firstName = user['first_name'] as String?;
            lastName = user['last_name'] as String?;
            final uname = user['usernames'] as Map<String, dynamic>?;
            final active = uname?['active_usernames'] as List?;
            if (active != null && active.isNotEmpty) {
              username = '${active.first}';
            } else {
              username = user['username'] as String? ?? username;
            }
            phone = user['phone_number'] as String?;
            isContact = user['is_contact'] as bool? ?? false;
            statusText = _formatUserStatus(user['status'] as Map<String, dynamic>?);
          }
          final full = await _client.getUserFullInfoResult(uid);
          if (full['@type'] != 'error') {
            final bioObj = full['bio'] as Map<String, dynamic>?;
            bio = bioObj?['text'] as String? ?? full['bio'] as String?;
            isBlocked = full['is_blocked'] as bool? ??
                (full['block_list'] != null);
          }
        }
      } else if (typeMap?['@type'] == 'chatTypeSupergroup') {
        final sid = typeMap?['supergroup_id'] as int?;
        if (sid != null) {
          final full = await _client.getSupergroupFullInfoResult(sid);
          if (full['@type'] != 'error') {
            bio = full['description'] as String?;
          }
          statusText = (typeMap?['is_channel'] as bool? ?? false)
              ? 'channel'
              : 'group';
        }
      } else if (typeMap?['@type'] == 'chatTypeBasicGroup') {
        final gid = typeMap?['basic_group_id'] as int?;
        if (gid != null) {
          final full = await _client.getBasicGroupFullInfoResult(gid);
          if (full['@type'] != 'error') {
            bio = full['description'] as String?;
          }
        }
        statusText = 'group';
      }

      // Shared media counts (best-effort; may be 0 if search is restricted).
      Future<int> count(String filter) => _client.countChatMessages(
            chatId: chatId,
            filterType: filter,
          );
      final counts = await Future.wait([
        count('searchMessagesFilterPhoto'),
        count('searchMessagesFilterVideo'),
        count('searchMessagesFilterDocument'),
        count('searchMessagesFilterUrl'),
        count('searchMessagesFilterVoiceNote'),
        count('searchMessagesFilterAnimation'),
      ]);

      return Success(
        TelegramProfile(
          chatId: telegramChatId,
          title: title,
          chatType: chatType,
          userId: userId,
          username: username?.isEmpty == true ? null : username,
          phoneNumber: phone?.isEmpty == true ? null : phone,
          firstName: firstName?.isEmpty == true ? null : firstName,
          lastName: lastName?.isEmpty == true ? null : lastName,
          bio: bio?.trim().isEmpty == true ? null : bio?.trim(),
          statusText: statusText,
          photoPath: photoPath,
          isMuted: isMuted,
          isContact: isContact,
          isBlocked: isBlocked,
          photoCount: counts[0],
          videoCount: counts[1],
          fileCount: counts[2],
          linkCount: counts[3],
          voiceCount: counts[4],
          gifCount: counts[5],
        ),
      );
    } catch (e) {
      return Err(NetworkFailure('Failed to load profile', cause: e));
    }
  }

  @override
  Future<Result<Unit>> startCall(String telegramChatId) async {
    try {
      final profileResult = await getChatProfile(telegramChatId);
      if (profileResult.isFailure) {
        return Err(profileResult.requireFailure);
      }
      final profile = profileResult.requireValue;
      if (!profile.isPrivate) {
        return const Err(
          ValidationFailure('Calls are only available in personal chats'),
        );
      }

      // Full in-app Telegram VoIP needs a native stack; open phone or Telegram.
      final phone = profile.phoneNumber?.replaceAll(RegExp(r'[^\d+]'), '');
      if (phone != null && phone.length >= 8) {
        final tel = Uri(scheme: 'tel', path: phone);
        if (await canLaunchUrl(tel)) {
          final ok = await launchUrl(tel);
          if (ok) return const Success(unit);
        }
      }

      final username = profile.username;
      if (username != null && username.isNotEmpty) {
        final tg = Uri.parse('tg://resolve?domain=$username');
        if (await canLaunchUrl(tg)) {
          final ok = await launchUrl(tg, mode: LaunchMode.externalApplication);
          if (ok) return const Success(unit);
        }
        final https = Uri.parse('https://t.me/$username');
        final ok = await launchUrl(https, mode: LaunchMode.externalApplication);
        if (ok) return const Success(unit);
      }

      if (profile.userId != null) {
        final tgUser = Uri.parse('tg://user?id=${profile.userId}');
        if (await canLaunchUrl(tgUser)) {
          final ok =
              await launchUrl(tgUser, mode: LaunchMode.externalApplication);
          if (ok) return const Success(unit);
        }
      }

      return const Err(
        ValidationFailure(
          'Could not start a call. Add a phone number in Telegram or install Telegram Desktop.',
        ),
      );
    } catch (e) {
      return Err(NetworkFailure('Failed to start call', cause: e));
    }
  }

  @override
  Future<Result<Unit>> setChatMuted({
    required String telegramChatId,
    required bool muted,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final chatId = int.parse(telegramChatId);
      final chat = await _client.getChatResult(chatId);
      if (chat['@type'] == 'error') {
        return Err(
          NetworkFailure(chat['message'] as String? ?? 'Failed to load chat'),
        );
      }
      final existing =
          chat['notification_settings'] as Map<String, dynamic>?;
      // > 366 days ⇒ muted forever in TDLib.
      final muteFor = muted ? (367 * 24 * 60 * 60) : 0;
      final result = await _client.setChatMuteFor(
        chatId: chatId,
        muteForSeconds: muteFor,
        existingSettings: existing,
      );
      if (result['@type'] == 'error') {
        return Err(
          NetworkFailure(result['message'] as String? ?? 'Failed to update mute'),
        );
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to update mute', cause: e));
    }
  }

  @override
  Future<Result<Unit>> editContact({
    required String telegramChatId,
    required String firstName,
    String lastName = '',
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final first = firstName.trim();
      if (first.isEmpty) {
        return const Err(ValidationFailure('First name is required'));
      }
      final profileResult = await getChatProfile(telegramChatId);
      if (profileResult.isFailure) {
        return Err(profileResult.requireFailure);
      }
      final profile = profileResult.requireValue;
      if (!profile.isPrivate || profile.userId == null) {
        return const Err(
          ValidationFailure('Only personal chats can be edited as contacts'),
        );
      }
      final result = await _client.addOrEditContact(
        userId: int.parse(profile.userId!),
        phoneNumber: profile.phoneNumber ?? '',
        firstName: first,
        lastName: lastName.trim(),
      );
      if (result['@type'] == 'error') {
        return Err(
          NetworkFailure(
            result['message'] as String? ?? 'Failed to save contact',
          ),
        );
      }
      // Refresh local chat title.
      final account = (await getAccount()).requireValue;
      if (account != null) {
        final title = [first, lastName.trim()]
            .where((s) => s.isNotEmpty)
            .join(' ');
        await (_db.update(_db.telegramChats)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.telegramChatId.equals(telegramChatId),
              ))
            .write(TelegramChatsCompanion(title: Value(title)));
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to edit contact', cause: e));
    }
  }

  @override
  Future<Result<Unit>> deleteContact(String telegramChatId) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final profileResult = await getChatProfile(telegramChatId);
      if (profileResult.isFailure) {
        return Err(profileResult.requireFailure);
      }
      final profile = profileResult.requireValue;
      if (!profile.isPrivate || profile.userId == null) {
        return const Err(
          ValidationFailure('Only personal contacts can be deleted'),
        );
      }
      final result =
          await _client.removeContacts([int.parse(profile.userId!)]);
      if (result['@type'] == 'error') {
        return Err(
          NetworkFailure(
            result['message'] as String? ?? 'Failed to delete contact',
          ),
        );
      }
      return const Success(unit);
    } catch (e) {
      return Err(NetworkFailure('Failed to delete contact', cause: e));
    }
  }

  @override
  Future<Result<Unit>> setUserBlocked({
    required String telegramChatId,
    required bool blocked,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) return guard;
      final profileResult = await getChatProfile(telegramChatId);
      if (profileResult.isFailure) {
        return Err(profileResult.requireFailure);
      }
      final profile = profileResult.requireValue;
      if (!profile.isPrivate || profile.userId == null) {
        return const Err(
          ValidationFailure('Only personal chats can be blocked'),
        );
      }
      final result = await _client.setUserBlocked(
        userId: int.parse(profile.userId!),
        blocked: blocked,
      );
      if (result['@type'] == 'error') {
        return Err(
          NetworkFailure(
            result['message'] as String? ??
                (blocked ? 'Failed to block user' : 'Failed to unblock user'),
          ),
        );
      }
      return const Success(unit);
    } catch (e) {
      return Err(
        NetworkFailure(
          blocked ? 'Failed to block user' : 'Failed to unblock user',
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<Unit>> openInTelegram(String telegramChatId) async {
    try {
      final profileResult = await getChatProfile(telegramChatId);
      if (profileResult.isFailure) {
        return Err(profileResult.requireFailure);
      }
      final profile = profileResult.requireValue;
      final username = profile.username;
      if (username != null && username.isNotEmpty) {
        final tg = Uri.parse('tg://resolve?domain=$username');
        if (await canLaunchUrl(tg)) {
          final ok = await launchUrl(tg, mode: LaunchMode.externalApplication);
          if (ok) return const Success(unit);
        }
        final https = Uri.parse('https://t.me/$username');
        final ok = await launchUrl(https, mode: LaunchMode.externalApplication);
        if (ok) return const Success(unit);
      }
      if (profile.userId != null) {
        final tgUser = Uri.parse('tg://user?id=${profile.userId}');
        if (await canLaunchUrl(tgUser)) {
          final ok =
              await launchUrl(tgUser, mode: LaunchMode.externalApplication);
          if (ok) return const Success(unit);
        }
      }
      // Private chats without username: open by chat id when possible.
      final openChat = Uri.parse('tg://openmessage?chat_id=$telegramChatId');
      if (await canLaunchUrl(openChat)) {
        final ok =
            await launchUrl(openChat, mode: LaunchMode.externalApplication);
        if (ok) return const Success(unit);
      }
      return const Err(
        ValidationFailure(
          'Could not open Telegram. Install Telegram Desktop or set a username.',
        ),
      );
    } catch (e) {
      return Err(NetworkFailure('Failed to open Telegram', cause: e));
    }
  }

  @override
  Future<Result<List<TelegramMessage>>> searchMessages({
    required String telegramChatId,
    required String query,
  }) async {
    try {
      final guard = await _guardAllowedChat(telegramChatId);
      if (guard != null) {
        return Err(guard.requireFailure);
      }
      final q = query.trim();
      if (q.isEmpty) return const Success([]);
      final rows = await (_db.select(_db.telegramMessages)
            ..where(
              (t) =>
                  t.telegramChatId.equals(telegramChatId) &
                  t.body.like('%$q%'),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)])
            ..limit(80))
          .get();
      // SQLite LIKE is ASCII-case-insensitive; still filter for unicode safety.
      final lower = q.toLowerCase();
      final filtered = rows
          .where((r) => r.body.toLowerCase().contains(lower))
          .map(_mapMessage)
          .toList();
      return Success(filtered);
    } catch (e) {
      return Err(CacheFailure('Failed to search messages', cause: e));
    }
  }

  String _formatUserStatus(Map<String, dynamic>? status) {
    if (status == null) return 'last seen recently';
    final type = status['@type'] as String?;
    switch (type) {
      case 'userStatusOnline':
        return 'online';
      case 'userStatusRecently':
        return 'last seen recently';
      case 'userStatusLastWeek':
        return 'last seen within a week';
      case 'userStatusLastMonth':
        return 'last seen within a month';
      case 'userStatusEmpty':
        return 'last seen a long time ago';
      case 'userStatusOffline':
        final sec = status['was_online'] as int?;
        if (sec == null) return 'last seen recently';
        final when = DateTime.fromMillisecondsSinceEpoch(sec * 1000).toLocal();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final day = DateTime(when.year, when.month, when.day);
        final time =
            '${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}';
        if (day == today) return 'last seen today at $time';
        if (today.difference(day).inDays == 1) {
          return 'last seen yesterday at $time';
        }
        return 'last seen ${when.month}/${when.day}/${when.year} at $time';
      default:
        return 'last seen recently';
    }
  }

  Future<Result<Unit>?> _guardAllowedChat(String telegramChatId) async {
    final live = await _ensureLiveSession();
    if (live != null) return live;
    final account = (await getAccount()).requireValue;
    if (account == null) {
      return const Err(
        ValidationFailure(
          'Telegram session expired. Tap Connect to sign in again.',
        ),
      );
    }
    final chat = await (_db.select(_db.telegramChats)
          ..where(
            (t) =>
                t.accountId.equals(account.id) &
                t.telegramChatId.equals(telegramChatId),
          ))
        .getSingleOrNull();
    if (chat == null || !chat.isAllowed) {
      return const Err(
        ValidationFailure('Chat is not allowed in GizeCare'),
      );
    }
    return null;
  }

  Future<void> _ensureAccountRow({
    String? phone,
    String? userId,
    String? username,
    String? displayName,
  }) async {
    final existing = await (_db.select(_db.telegramAccounts)..limit(1)).get();
    final now = DateTime.now();
    if (existing.isEmpty) {
      await _db.into(_db.telegramAccounts).insert(
            TelegramAccountsCompanion.insert(
              id: _uuid.v4(),
              phoneNumber: phone ?? '',
              telegramUserId: Value(userId),
              username: Value(username),
              displayName: Value(displayName),
              connectedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.telegramAccounts)
            ..where((t) => t.id.equals(existing.first.id)))
          .write(
        TelegramAccountsCompanion(
          phoneNumber: phone != null ? Value(phone) : const Value.absent(),
          telegramUserId:
              userId != null ? Value(userId) : const Value.absent(),
          username: username != null ? Value(username) : const Value.absent(),
          displayName:
              displayName != null ? Value(displayName) : const Value.absent(),
        ),
      );
    }
  }

  Future<void> _onUpdate(Map<String, dynamic> update) async {
    final type = update['@type'] as String?;
    if (type == 'updateAuthorizationState') {
      final state = update['authorization_state'] as Map<String, dynamic>?;
      if (state?['@type'] == 'authorizationStateReady') {
        _client.getMe();
        await _ensureAccountRow();
        _client.loadChats(limit: 200);
      }
      return;
    }

    if (type == 'user') {
      if (_pendingMe.isNotEmpty) {
        final completer = _pendingMe.removeAt(0);
        if (!completer.isCompleted) completer.complete(update);
      }
      final first = update['first_name'] as String? ?? '';
      final last = update['last_name'] as String? ?? '';
      final name = '$first $last'.trim();
      await _ensureAccountRow(
        userId: '${update['id']}',
        username: update['usernames'] != null
            ? ((update['usernames'] as Map<String, dynamic>)['editable_username']
                as String?)
            : update['username'] as String?,
        displayName: name.isEmpty ? null : name,
      );
      return;
    }

    if (type == 'updateNewChat' || type == 'chat') {
      final chat = type == 'chat'
          ? update
          : update['chat'] as Map<String, dynamic>?;
      if (chat != null) {
        await _upsertChat(chat);
        final id = chat['id'];
        if (id is int && _pendingChats.containsKey(id)) {
          _pendingChats.remove(id)?.complete(chat);
        }
      }
      return;
    }

    if (type == 'messages') {
      final chatId = update['chat_id'];
      final list = (update['messages'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      if (chatId is int && _pendingHistory.containsKey(chatId)) {
        _pendingHistory.remove(chatId)?.complete(list);
      }
      final account = (await getAccount()).requireValue;
      if (account != null) {
        final now = DateTime.now();
        for (final msg in list) {
          await _upsertMessage(account.id, msg, now);
        }
      }
      return;
    }

    if (type == 'updateNewMessage') {
      final message = update['message'] as Map<String, dynamic>?;
      if (message == null) return;
      final chatId = '${message['chat_id']}';
      final account = (await getAccount()).requireValue;
      if (account == null) return;
      final allowed = await (_db.select(_db.telegramChats)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(chatId) &
                  t.isAllowed.equals(true),
            ))
          .getSingleOrNull();
      if (allowed == null) return;
      await _upsertMessage(account.id, message, DateTime.now());
      return;
    }

    if (type == 'updateFile') {
      final file = update['file'] as Map<String, dynamic>?;
      if (file == null) return;
      await _onFileDownloaded(file);
      return;
    }

    if (type == 'updateMessageSendSucceeded') {
      final message = update['message'] as Map<String, dynamic>?;
      if (message == null) return;
      final account = (await getAccount()).requireValue;
      if (account == null) return;
      final chatId = '${message['chat_id']}';
      final oldId = update['old_message_id'];
      if (oldId != null) {
        await (_db.delete(_db.telegramMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.telegramChatId.equals(chatId) &
                    t.telegramMessageId.equals('$oldId'),
              ))
            .go();
      }
      await _upsertMessage(account.id, message, DateTime.now());
      await _dedupeMessages(account.id, chatId);
      return;
    }

    if (type == 'updateMessageSendFailed') {
      final oldId = update['old_message_id'];
      final message = update['message'] as Map<String, dynamic>?;
      final account = (await getAccount()).requireValue;
      if (account == null || oldId == null) return;
      final chatId = '${message?['chat_id'] ?? ''}';
      if (chatId.isEmpty) return;
      await (_db.delete(_db.telegramMessages)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(chatId) &
                  t.telegramMessageId.equals('$oldId'),
            ))
          .go();
      return;
    }

    if (type == 'updateChatReadInbox') {
      final chatId = '${update['chat_id']}';
      final unread = update['unread_count'] as int? ?? 0;
      final account = (await getAccount()).requireValue;
      if (account == null) return;
      await (_db.update(_db.telegramChats)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(chatId),
            ))
          .write(TelegramChatsCompanion(unreadCount: Value(unread)));
      return;
    }

    if (type == 'updateDeleteMessages') {
      final chatId = '${update['chat_id']}';
      final ids = (update['message_ids'] as List<dynamic>? ?? const [])
          .map((e) => '$e')
          .toList();
      if (ids.isEmpty) return;
      final account = (await getAccount()).requireValue;
      if (account == null) return;
      await (_db.delete(_db.telegramMessages)
            ..where(
              (t) =>
                  t.accountId.equals(account.id) &
                  t.telegramChatId.equals(chatId) &
                  t.telegramMessageId.isIn(ids),
            ))
          .go();
      return;
    }

    if (type == 'updateMessageEdited' || type == 'updateMessageContent') {
      final chatId = update['chat_id'];
      final messageId = update['message_id'];
      if (chatId == null || messageId == null) return;
      // Refresh content by re-fetching is heavy; for content update, message
      // may be embedded.
      final message = update['message'] as Map<String, dynamic>?;
      final account = (await getAccount()).requireValue;
      if (account == null) return;
      if (message != null) {
        await _upsertMessage(account.id, message, DateTime.now());
      } else if (type == 'updateMessageEdited') {
        await (_db.update(_db.telegramMessages)
              ..where(
                (t) =>
                    t.accountId.equals(account.id) &
                    t.telegramChatId.equals('$chatId') &
                    t.telegramMessageId.equals('$messageId'),
              ))
            .write(const TelegramMessagesCompanion(isEdited: Value(true)));
      }
    }
  }

  /// Removes pending-send leftovers that share body/time with the real message.
  Future<void> _dedupeMessages(String accountId, String telegramChatId) async {
    final rows = await (_db.select(_db.telegramMessages)
          ..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.telegramChatId.equals(telegramChatId),
          ))
        .get();
    if (rows.length < 2) return;

    final bestByKey = <String, TelegramMessageRow>{};
    final dropIds = <String>{};

    for (final row in rows) {
      final key =
          '${row.body}|${row.sentAt.millisecondsSinceEpoch}|${row.isOutgoing}|${row.contentType}';
      final existing = bestByKey[key];
      if (existing == null) {
        bestByKey[key] = row;
        continue;
      }
      final keep = _preferMessageRow(existing, row);
      final drop = keep.id == existing.id ? row : existing;
      bestByKey[key] = keep;
      dropIds.add(drop.id);
    }

    for (final id in dropIds) {
      await (_db.delete(_db.telegramMessages)..where((t) => t.id.equals(id)))
          .go();
    }
  }

  TelegramMessageRow _preferMessageRow(
    TelegramMessageRow a,
    TelegramMessageRow b,
  ) {
    final aId = int.tryParse(a.telegramMessageId) ?? 0;
    final bId = int.tryParse(b.telegramMessageId) ?? 0;
    // Client pending ids are typically huge; prefer the server id.
    const pendingThreshold = 1000000000000;
    if (aId > pendingThreshold && bId <= pendingThreshold) return b;
    if (bId > pendingThreshold && aId <= pendingThreshold) return a;
    final aMedia = a.mediaPath?.startsWith('/') ?? false;
    final bMedia = b.mediaPath?.startsWith('/') ?? false;
    if (aMedia && !bMedia) return a;
    if (bMedia && !aMedia) return b;
    return a.updatedAt.isAfter(b.updatedAt) ? a : b;
  }

  Future<void> _onFileDownloaded(Map<String, dynamic> file) async {
    final local = file['local'] as Map<String, dynamic>?;
    final completed = local?['is_downloading_completed'] as bool? ?? false;
    final path = local?['path'] as String?;
    final fileId = file['id'] as int?;
    if (!completed || path == null || path.isEmpty || fileId == null) return;

    await (_db.update(_db.telegramMessages)
          ..where((t) => t.mediaFileId.equals(fileId)))
        .write(TelegramMessagesCompanion(mediaPath: Value(path)));

    await (_db.update(_db.telegramChats)
          ..where((t) => t.photoPath.equals('pending:$fileId')))
        .write(TelegramChatsCompanion(photoPath: Value(path)));

    // Also match chats that stored the pending marker differently — scan.
    final pendingChats = await (_db.select(_db.telegramChats)
          ..where((t) => t.photoPath.like('pending:%')))
        .get();
    for (final chat in pendingChats) {
      final marker = chat.photoPath;
      if (marker == 'pending:$fileId') {
        await (_db.update(_db.telegramChats)
              ..where((t) => t.id.equals(chat.id)))
            .write(TelegramChatsCompanion(photoPath: Value(path)));
      }
    }
  }

  Future<void> _upsertChat(Map<String, dynamic> chat) async {
    final account = (await getAccount()).requireValue;
    if (account == null) {
      await _ensureAccountRow();
    }
    final acc = (await getAccount()).requireValue;
    if (acc == null) return;

    final telegramChatId = '${chat['id']}';
    final title = (chat['title'] as String?)?.trim().isNotEmpty == true
        ? chat['title'] as String
        : 'Chat $telegramChatId';
    final type = _chatTypeFromTd(chat['type'] as Map<String, dynamic>?);
    final existing = await (_db.select(_db.telegramChats)
          ..where(
            (t) =>
                t.accountId.equals(acc.id) &
                t.telegramChatId.equals(telegramChatId),
          ))
        .getSingleOrNull();
    final now = DateTime.now();
    final unread = chat['unread_count'] as int? ?? existing?.unreadCount ?? 0;
    final photoFileId = _chatPhotoFileId(chat);
    String? photoPath = existing?.photoPath;
    if (photoFileId != null) {
      final local = _localPathFromFileId(chat, photoFileId);
      if (local != null) {
        photoPath = local;
      } else if (photoPath == null || !photoPath.startsWith('/')) {
        photoPath = 'pending:$photoFileId';
        _client.downloadFile(photoFileId);
      }
    }

    if (existing == null) {
      await _db.into(_db.telegramChats).insert(
            TelegramChatsCompanion.insert(
              id: _uuid.v4(),
              accountId: acc.id,
              telegramChatId: telegramChatId,
              title: title,
              chatType: telegramChatTypeToString(type),
              photoPath: Value(photoPath),
              unreadCount: Value(unread),
              updatedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.telegramChats)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        TelegramChatsCompanion(
          title: Value(title),
          chatType: Value(telegramChatTypeToString(type)),
          photoPath: photoPath != null
              ? Value(photoPath)
              : const Value.absent(),
          unreadCount: Value(unread),
          updatedAt: Value(now),
        ),
      );
    }
  }

  int? _chatPhotoFileId(Map<String, dynamic> chat) {
    final photo = chat['photo'] as Map<String, dynamic>?;
    if (photo == null) return null;
    final small = photo['small'] as Map<String, dynamic>?;
    final big = photo['big'] as Map<String, dynamic>?;
    return (small?['id'] as int?) ?? (big?['id'] as int?);
  }

  String? _localPathFromFileId(Map<String, dynamic> chat, int fileId) {
    final photo = chat['photo'] as Map<String, dynamic>?;
    for (final key in ['small', 'big']) {
      final f = photo?[key] as Map<String, dynamic>?;
      if (f?['id'] != fileId) continue;
      final local = f?['local'] as Map<String, dynamic>?;
      if (local?['is_downloading_completed'] == true) {
        final path = local?['path'] as String?;
        if (path != null && path.isNotEmpty) return path;
      }
    }
    return null;
  }

  Future<void> _upsertMessage(
    String accountId,
    Map<String, dynamic> msg,
    DateTime now,
  ) async {
    final chatId = '${msg['chat_id']}';
    final messageId = '${msg['id']}';
    final parsed = _parseContent(msg);
    if (parsed == null) return;

    final allowed = await (_db.select(_db.telegramChats)
          ..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.telegramChatId.equals(chatId) &
                t.isAllowed.equals(true),
          ))
        .getSingleOrNull();
    if (allowed == null) return;

    final dateSec = msg['date'] as int? ?? 0;
    final sentAt = DateTime.fromMillisecondsSinceEpoch(dateSec * 1000);
    final isOutgoing = msg['is_outgoing'] as bool? ?? false;
    final existing = await (_db.select(_db.telegramMessages)
          ..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.telegramChatId.equals(chatId) &
                t.telegramMessageId.equals(messageId),
          ))
        .getSingleOrNull();

    var mediaPath = parsed.localPath ?? existing?.mediaPath;
    if (parsed.fileId != null &&
        (mediaPath == null || !mediaPath.startsWith('/'))) {
      _client.downloadFile(parsed.fileId!);
    }

    final reply = _parseReply(msg);
    final editDate = msg['edit_date'] as int? ?? 0;
    final isEdited = editDate > 0 || (existing?.isEdited ?? false);

    if (existing == null) {
      await _db.into(_db.telegramMessages).insert(
            TelegramMessagesCompanion.insert(
              id: _uuid.v4(),
              accountId: accountId,
              telegramChatId: chatId,
              telegramMessageId: messageId,
              body: parsed.text,
              contentType: Value(parsed.contentType),
              mediaPath: Value(mediaPath),
              mediaFileId: Value(parsed.fileId),
              replyToMessageId: Value(reply?.messageId),
              replyPreview: Value(reply?.preview),
              sentAt: sentAt,
              isOutgoing: Value(isOutgoing),
              isEdited: Value(isEdited),
              updatedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.telegramMessages)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        TelegramMessagesCompanion(
          body: Value(parsed.text),
          contentType: Value(parsed.contentType),
          mediaPath: mediaPath != null
              ? Value(mediaPath)
              : const Value.absent(),
          mediaFileId: parsed.fileId != null
              ? Value(parsed.fileId)
              : const Value.absent(),
          replyToMessageId: reply?.messageId != null
              ? Value(reply!.messageId)
              : const Value.absent(),
          replyPreview: reply?.preview != null
              ? Value(reply!.preview)
              : const Value.absent(),
          isEdited: Value(isEdited),
          updatedAt: Value(now),
        ),
      );
    }

    await (_db.update(_db.telegramChats)
          ..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.telegramChatId.equals(chatId),
          ))
        .write(TelegramChatsCompanion(lastMessageAt: Value(sentAt)));
  }

  ({String messageId, String preview})? _parseReply(Map<String, dynamic> msg) {
    final replyTo = msg['reply_to'] as Map<String, dynamic>?;
    if (replyTo == null) return null;
    final type = replyTo['@type'] as String?;
    if (type != 'messageReplyToMessage') return null;
    final id = replyTo['message_id'];
    if (id == null) return null;
    final quote = replyTo['quote'] as Map<String, dynamic>?;
    final quoteText = quote?['text'] as String?;
    return (
      messageId: '$id',
      preview: (quoteText != null && quoteText.isNotEmpty)
          ? quoteText
          : 'Reply',
    );
  }

  _ParsedContent? _parseContent(Map<String, dynamic> msg) {
    final content = msg['content'] as Map<String, dynamic>?;
    if (content == null) return null;
    final type = content['@type'] as String?;

    String captionOf() {
      final cap = content['caption'] as Map<String, dynamic>?;
      return (cap?['text'] as String?)?.trim() ?? '';
    }

    String? localFrom(Map<String, dynamic>? file) {
      final local = file?['local'] as Map<String, dynamic>?;
      if (local?['is_downloading_completed'] == true) {
        final path = local?['path'] as String?;
        if (path != null && path.isNotEmpty) return path;
      }
      return null;
    }

    if (type == 'messageText') {
      final text = content['text'] as Map<String, dynamic>?;
      return _ParsedContent(
        text: text?['text'] as String? ?? '',
        contentType: 'text',
      );
    }

    if (type == 'messagePhoto') {
      final photo = content['photo'] as Map<String, dynamic>?;
      final sizes = (photo?['sizes'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      Map<String, dynamic>? best;
      var bestArea = -1;
      for (final s in sizes) {
        final w = s['width'] as int? ?? 0;
        final h = s['height'] as int? ?? 0;
        final area = w * h;
        if (area >= bestArea) {
          bestArea = area;
          best = s;
        }
      }
      // Prefer a mid size for chat bubbles when available.
      if (sizes.length >= 2) {
        sizes.sort((a, b) {
          final aa = (a['width'] as int? ?? 0) * (a['height'] as int? ?? 0);
          final bb = (b['width'] as int? ?? 0) * (b['height'] as int? ?? 0);
          return aa.compareTo(bb);
        });
        best = sizes[sizes.length - 2];
      }
      final file = best?['photo'] as Map<String, dynamic>?;
      final fileId = file?['id'] as int?;
      final caption = captionOf();
      return _ParsedContent(
        text: caption.isEmpty ? 'Photo' : caption,
        contentType: 'photo',
        fileId: fileId,
        localPath: localFrom(file),
      );
    }

    if (type == 'messageDocument') {
      final doc = content['document'] as Map<String, dynamic>?;
      final name = doc?['file_name'] as String? ?? 'Document';
      final file = doc?['document'] as Map<String, dynamic>?;
      final caption = captionOf();
      return _ParsedContent(
        text: caption.isEmpty ? name : caption,
        contentType: 'document',
        fileId: file?['id'] as int?,
        localPath: localFrom(file),
      );
    }

    if (type == 'messageVoiceNote' || type == 'messageAudio') {
      final key = type == 'messageVoiceNote' ? 'voice_note' : 'audio';
      final note = content[key] as Map<String, dynamic>?;
      final file = note?[key == 'voice_note' ? 'voice' : 'audio']
          as Map<String, dynamic>?;
      final duration = note?['duration'] as int? ?? 0;
      final label = type == 'messageVoiceNote' ? 'Voice message' : 'Audio';
      return _ParsedContent(
        text: duration > 0 ? '$label|$duration' : label,
        contentType: 'voice',
        fileId: file?['id'] as int?,
        localPath: localFrom(file),
      );
    }

    if (type == 'messageVideo') {
      final video = content['video'] as Map<String, dynamic>?;
      final file = video?['video'] as Map<String, dynamic>?;
      final caption = captionOf();
      return _ParsedContent(
        text: caption.isEmpty ? 'Video' : caption,
        contentType: 'video',
        fileId: file?['id'] as int?,
        localPath: localFrom(file),
      );
    }

    if (type == 'messageSticker') {
      return const _ParsedContent(text: 'Sticker', contentType: 'sticker');
    }

    if (type == 'messageAnimatedEmoji') {
      final emoji = content['emoji'] as String?;
      return _ParsedContent(
        text: emoji?.isNotEmpty == true ? emoji! : '✨',
        contentType: 'text',
      );
    }

    return _ParsedContent(text: '[$type]', contentType: 'other');
  }

  TelegramChatType _chatTypeFromTd(Map<String, dynamic>? type) {
    final t = type?['@type'] as String?;
    return switch (t) {
      'chatTypePrivate' => TelegramChatType.private,
      'chatTypeBasicGroup' => TelegramChatType.group,
      'chatTypeSupergroup' =>
        (type?['is_channel'] as bool? ?? false)
            ? TelegramChatType.channel
            : TelegramChatType.group,
      'chatTypeSecret' => TelegramChatType.secret,
      _ => TelegramChatType.unknown,
    };
  }

  TelegramAccount _mapAccount(TelegramAccountRow row) {
    return TelegramAccount(
      id: row.id,
      phoneNumber: row.phoneNumber,
      telegramUserId: row.telegramUserId,
      username: row.username,
      displayName: row.displayName,
      connectedAt: row.connectedAt,
      lastSyncAt: row.lastSyncAt,
    );
  }

  TelegramChat _mapChat(TelegramChatRow row) {
    final path = row.photoPath;
    return TelegramChat(
      id: row.id,
      telegramChatId: row.telegramChatId,
      title: row.title,
      chatType: telegramChatTypeFromString(row.chatType),
      isAllowed: row.isAllowed,
      username: row.username,
      lastMessageAt: row.lastMessageAt,
      unreadCount: row.unreadCount,
      photoPath: path != null && path.startsWith('/') ? path : null,
    );
  }

  TelegramMessage _mapMessage(TelegramMessageRow row) {
    return TelegramMessage(
      id: row.id,
      telegramChatId: row.telegramChatId,
      telegramMessageId: row.telegramMessageId,
      text: row.body,
      sentAt: row.sentAt,
      isOutgoing: row.isOutgoing,
      senderName: row.senderName,
      contentType: row.contentType,
      mediaPath: row.mediaPath,
      replyToMessageId: row.replyToMessageId,
      replyPreview: row.replyPreview,
      isEdited: row.isEdited,
    );
  }
}

class _ParsedContent {
  const _ParsedContent({
    required this.text,
    required this.contentType,
    this.fileId,
    this.localPath,
  });

  final String text;
  final String contentType;
  final int? fileId;
  final String? localPath;
}
