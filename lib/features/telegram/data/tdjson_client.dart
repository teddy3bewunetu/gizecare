import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/telegram_config.dart';

typedef _TdCreateClientIdC = Int32 Function();
typedef _TdCreateClientIdDart = int Function();

typedef _TdSendC = Void Function(Int32, Pointer<Utf8>);
typedef _TdSendDart = void Function(int, Pointer<Utf8>);

typedef _TdReceiveC = Pointer<Utf8> Function(Double);
typedef _TdReceiveDart = Pointer<Utf8> Function(double);

typedef _TdExecuteC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef _TdExecuteDart = Pointer<Utf8> Function(Pointer<Utf8>);

/// Thin TDLib JSON client (libtdjson) for Linux desktop Telegram login.
///
/// Process singleton: hot restart wipes Dart state but leaves native TDLib
/// clients holding the binlog — recreating via [Provider] would double-lock.
/// One shared instance + fresh DB dir recovery avoids that.
class TdjsonClient {
  factory TdjsonClient() => instance;

  TdjsonClient._();

  static final TdjsonClient instance = TdjsonClient._();

  DynamicLibrary? _lib;
  late final _TdCreateClientIdDart _createClientId;
  late final _TdSendDart _send;
  late final _TdReceiveDart _receive;
  late final _TdExecuteDart _execute;

  int? _clientId;
  Timer? _pollTimer;
  bool _running = false;
  bool _parametersSent = false;
  bool _recoveringLock = false;
  int _lockRecoveries = 0;
  Completer<void>? _closedCompleter;
  int _extraCounter = 0;
  final _pendingExtra = <String, Completer<Map<String, dynamic>>>{};
  String? _databaseDirectory;
  Future<void>? _startGate;

  final _authStep = StreamController<TelegramAuthStep>.broadcast();
  final _updates = StreamController<Map<String, dynamic>>.broadcast();
  final _codeInfoController =
      StreamController<TelegramCodeInfo?>.broadcast();

  TelegramAuthStep currentAuthStep = TelegramAuthStep.idle;
  String? lastError;
  TelegramCodeInfo? codeInfo;

  Stream<TelegramAuthStep> get authStepStream => _authStep.stream;
  Stream<Map<String, dynamic>> get updates => _updates.stream;
  Stream<TelegramCodeInfo?> get codeInfoStream => _codeInfoController.stream;

  bool get isReady => currentAuthStep == TelegramAuthStep.ready;
  bool get isLoaded => _lib != null;
  bool get isRunning => _running;

  /// True once TDLib has finished init and can accept a phone number / resume auth.
  bool get canAcceptPhone =>
      currentAuthStep == TelegramAuthStep.waitPhone ||
      currentAuthStep == TelegramAuthStep.waitCode ||
      currentAuthStep == TelegramAuthStep.waitPassword ||
      currentAuthStep == TelegramAuthStep.ready;

  /// Starts TDLib and waits until the saved session is [ready], or throws if
  /// re-login is required (WaitPhone / WaitCode / …).
  Future<void> ensureReady({
    Duration timeout = const Duration(seconds: 25),
  }) async {
    await ensureStarted(timeout: timeout);
    if (currentAuthStep == TelegramAuthStep.ready) return;
    throw StateError(
      'Telegram session expired. Tap Connect to sign in again.',
    );
  }

  Future<void> ensureStarted({
    Duration timeout = const Duration(seconds: 25),
  }) async {
    if (!TelegramConfig.hasCredentials) {
      throw StateError(
        'Missing TELEGRAM_API_ID / TELEGRAM_API_HASH. See docs/telegram_setup.md',
      );
    }

    // Serialize concurrent start/resume/connect calls.
    final existing = _startGate;
    if (existing != null) {
      await existing;
      await waitUntilCanAcceptPhone(timeout: timeout);
      return;
    }

    final gate = Completer<void>();
    _startGate = gate.future;
    try {
      await _ensureStartedBody(timeout: timeout);
    } finally {
      if (!gate.isCompleted) gate.complete();
      _startGate = null;
    }
  }

  Future<void> _ensureStartedBody({required Duration timeout}) async {
    if (currentAuthStep == TelegramAuthStep.error) {
      await close(clearRegistry: false);
      await _shutdownRegisteredClients(includeBruteForce: true);
    }

    if (!_running) {
      _loadLibrary();
      await execute({
        '@type': 'setLogVerbosityLevel',
        'new_verbosity_level': 0,
      });

      final reg = await _readRuntimeRegistry();
      final known = ((reg['clients'] as List?) ?? const []).isNotEmpty;
      // Only reclaim orphans when we are about to create a new client.
      await _shutdownRegisteredClients(includeBruteForce: !known);

      _clientId = _createClientId();
      await _registerClientId(_clientId!);
      _running = true;
      _parametersSent = false;
      _lockRecoveries = 0;
      lastError = null;
      codeInfo = null;
      _setAuthStep(TelegramAuthStep.waitTdlib);
      _pollTimer?.cancel();
      _pollTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        _drain();
      });

      send({'@type': 'getOption', 'name': 'version'});
      // Ask explicitly — some updates can be missed around restart.
      send({'@type': 'getAuthorizationState'});
    } else if (!canAcceptPhone) {
      send({'@type': 'getAuthorizationState'});
    }

    await waitUntilCanAcceptPhone(timeout: timeout);
  }

  /// Blocks until WaitPhoneNumber (or later auth step), or throws on timeout/error.
  Future<void> waitUntilCanAcceptPhone({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (canAcceptPhone) return;
    if (currentAuthStep == TelegramAuthStep.error) {
      throw StateError(lastError ?? 'Telegram init failed');
    }

    final done = Completer<void>();
    late final StreamSubscription<TelegramAuthStep> sub;
    sub = authStepStream.listen((step) {
      if (canAcceptPhone) {
        if (!done.isCompleted) done.complete();
      } else if (step == TelegramAuthStep.error) {
        if (!done.isCompleted) {
          done.completeError(StateError(lastError ?? 'Telegram init failed'));
        }
      }
    });

    // Avoid missing a step emitted between the check and subscribe.
    if (canAcceptPhone) {
      if (!done.isCompleted) done.complete();
    } else if (currentAuthStep == TelegramAuthStep.error) {
      if (!done.isCompleted) {
        done.completeError(StateError(lastError ?? 'Telegram init failed'));
      }
    }

    try {
      await done.future.timeout(timeout);
    } on TimeoutException {
      throw StateError(
        'Telegram is taking too long to initialize. Fully quit the app and try again.',
      );
    } finally {
      await sub.cancel();
    }
  }

  /// Closes TDLib and waits until the binlog lock is released.
  Future<void> close({bool clearRegistry = true}) async {
    if (!_running && _clientId == null) {
      _pollTimer?.cancel();
      _pollTimer = null;
      if (clearRegistry) await _clearRuntimeRegistry();
      return;
    }

    _closedCompleter = Completer<void>();
    final closingId = _clientId;
    try {
      if (closingId != null && _lib != null) {
        send({'@type': 'close'});
        await _closedCompleter!.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {},
        );
      }
    } catch (_) {
      // Best-effort close.
    } finally {
      _pollTimer?.cancel();
      _pollTimer = null;
      _running = false;
      _clientId = null;
      _parametersSent = false;
      _closedCompleter = null;
      _lockRecoveries = 0;
      codeInfo = null;
      _setCodeInfo(null);
      _setAuthStep(TelegramAuthStep.idle);
      if (clearRegistry) {
        await _clearRuntimeRegistry();
      } else if (closingId != null) {
        await _unregisterClientId(closingId);
      }
      // Brief pause so the OS releases the file lock.
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> reset() => close();

  void send(Map<String, dynamic> request) {
    final id = _clientId;
    if (id == null) {
      throw StateError('TDLib client not started');
    }
    final json = jsonEncode(request);
    final ptr = json.toNativeUtf8();
    try {
      _send(id, ptr);
    } finally {
      malloc.free(ptr);
    }
  }

  /// Sends a request and waits for the matching `@extra` response / error.
  Future<Map<String, dynamic>> sendForResult(
    Map<String, dynamic> request, {
    Duration timeout = const Duration(seconds: 45),
  }) async {
    final extra = 'gc_${++_extraCounter}_${DateTime.now().microsecondsSinceEpoch}';
    final completer = Completer<Map<String, dynamic>>();
    _pendingExtra[extra] = completer;
    send({...request, '@extra': extra});
    try {
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      _pendingExtra.remove(extra);
      throw StateError('Telegram request timed out');
    }
  }

  Future<void> downloadFile(int fileId, {int priority = 1}) async {
    send({
      '@type': 'downloadFile',
      'file_id': fileId,
      'priority': priority,
      'offset': 0,
      'limit': 0,
      'synchronous': false,
    });
  }

  Future<Map<String, dynamic>> getMessageResult({
    required int chatId,
    required int messageId,
  }) {
    return sendForResult({
      '@type': 'getMessage',
      'chat_id': chatId,
      'message_id': messageId,
    });
  }

  /// Downloads a file and waits until TDLib returns the completed [file].
  Future<String?> downloadFilePath(int fileId, {int priority = 32}) async {
    final result = await sendForResult({
      '@type': 'downloadFile',
      'file_id': fileId,
      'priority': priority,
      'offset': 0,
      'limit': 0,
      'synchronous': true,
    });
    if (result['@type'] == 'error') return null;
    final local = result['local'] as Map<String, dynamic>?;
    if (local?['is_downloading_completed'] == true) {
      final path = local?['path'] as String?;
      if (path != null && path.isNotEmpty) return path;
    }
    return null;
  }

  Future<Map<String, dynamic>> getChatResult(int chatId) {
    return sendForResult({'@type': 'getChat', 'chat_id': chatId});
  }

  Future<Map<String, dynamic>> getUserResult(int userId) {
    return sendForResult({'@type': 'getUser', 'user_id': userId});
  }

  Future<Map<String, dynamic>> getUserFullInfoResult(int userId) {
    return sendForResult({'@type': 'getUserFullInfo', 'user_id': userId});
  }

  Future<Map<String, dynamic>> getSupergroupFullInfoResult(int supergroupId) {
    return sendForResult({
      '@type': 'getSupergroupFullInfo',
      'supergroup_id': supergroupId,
    });
  }

  Future<Map<String, dynamic>> getBasicGroupFullInfoResult(int basicGroupId) {
    return sendForResult({
      '@type': 'getBasicGroupFullInfo',
      'basic_group_id': basicGroupId,
    });
  }

  Future<int> countChatMessages({
    required int chatId,
    required String filterType,
  }) async {
    final result = await sendForResult({
      '@type': 'searchChatMessages',
      'chat_id': chatId,
      'query': '',
      'from_message_id': 0,
      'offset': 0,
      'limit': 1,
      'filter': {'@type': filterType},
    });
    if (result['@type'] == 'error') return 0;
    return result['total_count'] as int? ?? 0;
  }

  /// Mute forever (`muteForSeconds` large) or unmute (`0`).
  Future<Map<String, dynamic>> setChatMuteFor({
    required int chatId,
    required int muteForSeconds,
    Map<String, dynamic>? existingSettings,
  }) {
    final base = Map<String, dynamic>.from(
      existingSettings ?? const <String, dynamic>{},
    );
    base['@type'] = 'chatNotificationSettings';
    base['use_default_mute_for'] = false;
    base['mute_for'] = muteForSeconds;
    // Keep other fields if present; otherwise use defaults.
    base.putIfAbsent('use_default_sound', () => true);
    base.putIfAbsent('sound_id', () => 0);
    base.putIfAbsent('use_default_show_preview', () => true);
    base.putIfAbsent('show_preview', () => true);
    base.putIfAbsent(
      'use_default_disable_pinned_message_notifications',
      () => true,
    );
    base.putIfAbsent('disable_pinned_message_notifications', () => false);
    base.putIfAbsent(
      'use_default_disable_mention_notifications',
      () => true,
    );
    base.putIfAbsent('disable_mention_notifications', () => false);
    return sendForResult({
      '@type': 'setChatNotificationSettings',
      'chat_id': chatId,
      'notification_settings': base,
    });
  }

  Future<Map<String, dynamic>> addOrEditContact({
    required int userId,
    required String phoneNumber,
    required String firstName,
    required String lastName,
  }) {
    return sendForResult({
      '@type': 'addContact',
      'user_id': userId,
      'contact': {
        '@type': 'contact',
        'phone_number': phoneNumber,
        'first_name': firstName,
        'last_name': lastName,
        'vcard': '',
        'user_id': userId,
      },
      'share_phone_number': false,
    });
  }

  Future<Map<String, dynamic>> removeContacts(List<int> userIds) {
    return sendForResult({
      '@type': 'removeContacts',
      'user_ids': userIds,
    });
  }

  /// Prefer modern block-list API; fall back to toggle.
  Future<Map<String, dynamic>> setUserBlocked({
    required int userId,
    required bool blocked,
  }) async {
    final modern = await sendForResult({
      '@type': 'setMessageSenderBlockList',
      'sender_id': {
        '@type': 'messageSenderUser',
        'user_id': userId,
      },
      'block_list': blocked
          ? {'@type': 'blockListMain'}
          : null,
    });
    if (modern['@type'] != 'error') return modern;
    return sendForResult({
      '@type': 'toggleMessageSenderIsBlocked',
      'sender_id': {
        '@type': 'messageSenderUser',
        'user_id': userId,
      },
      'is_blocked': blocked,
    });
  }

  Future<Map<String, dynamic>?> execute(Map<String, dynamic> request) async {
    _loadLibrary();
    final json = jsonEncode(request);
    final ptr = json.toNativeUtf8();
    try {
      final result = _execute(ptr);
      if (result == nullptr) return null;
      return jsonDecode(result.toDartString()) as Map<String, dynamic>;
    } finally {
      malloc.free(ptr);
    }
  }

  Future<void> setPhoneNumber(String phone) async {
    await waitUntilCanAcceptPhone();
    if (currentAuthStep != TelegramAuthStep.waitPhone) {
      throw StateError(
        'Telegram is not waiting for a phone number (state: $currentAuthStep)',
      );
    }
    var normalized = phone.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (normalized.isNotEmpty && !normalized.startsWith('+')) {
      normalized = '+$normalized';
    }
    send({
      '@type': 'setAuthenticationPhoneNumber',
      'phone_number': normalized,
    });
  }

  Future<void> checkCode(String code) async {
    final normalized = code.trim().replaceAll(RegExp(r'\s'), '');
    send({
      '@type': 'checkAuthenticationCode',
      'code': normalized,
    });
  }

  Future<void> checkPassword(String password) async {
    send({
      '@type': 'checkAuthenticationPassword',
      'password': password,
    });
  }

  /// Ask Telegram to resend the code (often switches to SMS / next type).
  Future<void> resendAuthenticationCode() async {
    send({'@type': 'resendAuthenticationCode'});
  }

  Future<void> loadChats({int limit = 100}) async {
    send({
      '@type': 'loadChats',
      'chat_list': {'@type': 'chatListMain'},
      'limit': limit,
    });
  }

  Future<void> getChat(int chatId) async {
    send({
      '@type': 'getChat',
      'chat_id': chatId,
    });
  }

  Future<void> getChatHistory({
    required int chatId,
    int fromMessageId = 0,
    int limit = 50,
  }) async {
    send({
      '@type': 'getChatHistory',
      'chat_id': chatId,
      'from_message_id': fromMessageId,
      'offset': 0,
      'limit': limit,
      'only_local': false,
    });
  }

  Future<void> sendTextMessage({
    required int chatId,
    required String text,
    int? replyToMessageId,
  }) async {
    final result = await sendForResult({
      '@type': 'sendMessage',
      'chat_id': chatId,
      if (replyToMessageId != null)
        'reply_to': {
          '@type': 'inputMessageReplyToMessage',
          'message_id': replyToMessageId,
        },
      'input_message_content': {
        '@type': 'inputMessageText',
        'text': {
          '@type': 'formattedText',
          'text': text,
          'entities': <Map<String, dynamic>>[],
        },
        'clear_draft': true,
      },
    });
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'Send failed');
    }
  }

  Future<void> editTextMessage({
    required int chatId,
    required int messageId,
    required String text,
  }) async {
    final result = await sendForResult({
      '@type': 'editMessageText',
      'chat_id': chatId,
      'message_id': messageId,
      'input_message_content': {
        '@type': 'inputMessageText',
        'text': {
          '@type': 'formattedText',
          'text': text,
          'entities': <Map<String, dynamic>>[],
        },
      },
    });
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'Edit failed');
    }
  }

  Future<void> deleteMessages({
    required int chatId,
    required List<int> messageIds,
    bool revoke = true,
  }) async {
    final result = await sendForResult({
      '@type': 'deleteMessages',
      'chat_id': chatId,
      'message_ids': messageIds,
      'revoke': revoke,
    });
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'Delete failed');
    }
  }

  Future<void> viewMessages({
    required int chatId,
    required List<int> messageIds,
  }) async {
    send({
      '@type': 'viewMessages',
      'chat_id': chatId,
      'message_ids': messageIds,
      'force_read': true,
    });
  }

  Future<void> openChat(int chatId) async {
    send({'@type': 'openChat', 'chat_id': chatId});
  }

  Future<Map<String, dynamic>> sendDocumentMessage({
    required int chatId,
    required String filePath,
    String? caption,
  }) async {
    final path = await _stageReadableFile(filePath);
    // TDLib 1.8.65+: inputMessageDocument.document is inputDocument, which
    // wraps InputFile. Passing inputFileLocal directly → "InputFile is not specified".
    final result = await sendForResult(
      {
        '@type': 'sendMessage',
        'chat_id': chatId,
        'input_message_content': {
          '@type': 'inputMessageDocument',
          'document': {
            '@type': 'inputDocument',
            'document': {
              '@type': 'inputFileLocal',
              'path': path,
            },
            'disable_content_type_detection': false,
          },
          if (caption != null && caption.isNotEmpty)
            'caption': {
              '@type': 'formattedText',
              'text': caption,
              'entities': <Map<String, dynamic>>[],
            },
        },
      },
      timeout: const Duration(minutes: 3),
    );
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'File send failed');
    }
    return result;
  }

  Future<Map<String, dynamic>> sendPhotoMessage({
    required int chatId,
    required String filePath,
    String? caption,
  }) async {
    final path = await _stageReadableFile(filePath);
    // TDLib 1.8.65+: inputMessagePhoto.photo is inputPhoto (wrapper).
    final result = await sendForResult(
      {
        '@type': 'sendMessage',
        'chat_id': chatId,
        'input_message_content': {
          '@type': 'inputMessagePhoto',
          'photo': {
            '@type': 'inputPhoto',
            'photo': {
              '@type': 'inputFileLocal',
              'path': path,
            },
            'added_sticker_file_ids': <int>[],
            'width': 0,
            'height': 0,
          },
          if (caption != null && caption.isNotEmpty)
            'caption': {
              '@type': 'formattedText',
              'text': caption,
              'entities': <Map<String, dynamic>>[],
            },
        },
      },
      timeout: const Duration(minutes: 3),
    );
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'Photo upload failed');
    }
    return result;
  }

  Future<Map<String, dynamic>> sendVoiceNoteMessage({
    required int chatId,
    required String filePath,
    required int durationSeconds,
  }) async {
    final oggPath = await _ensureOggOpus(filePath);
    final path = await _stageReadableFile(oggPath);
    // TDLib 1.8.65+: inputMessageVoiceNote.voice_note is inputVoiceNote.
    final result = await sendForResult(
      {
        '@type': 'sendMessage',
        'chat_id': chatId,
        'input_message_content': {
          '@type': 'inputMessageVoiceNote',
          'voice_note': {
            '@type': 'inputVoiceNote',
            'voice_note': {
              '@type': 'inputFileLocal',
              'path': path,
            },
            'duration': durationSeconds.clamp(1, 3600),
            // TDLib expects base64 waveform bytes (5-bit samples). Dummy mid bars.
            'waveform': base64Encode(
              List<int>.generate(63, (i) => 15 + (i * 7) % 20),
            ),
          },
        },
      },
      timeout: const Duration(minutes: 2),
    );
    if (result['@type'] == 'error') {
      throw StateError(result['message'] as String? ?? 'Voice send failed');
    }
    return result;
  }

  /// Waits until [sendResult] finishes uploading/sending.
  ///
  /// [onProgress] receives 0.0–1.0 while TDLib reports upload progress.
  Future<void> waitForOutgoingSend(
    Map<String, dynamic> sendResult, {
    String label = 'Send failed',
    void Function(double progress)? onProgress,
  }) =>
      _ensureOutgoingSendFinished(
        sendResult,
        label: label,
        onProgress: onProgress,
      );

  /// Copy into app cache so TDLib can always open the path (portals / mounts).
  Future<String> _stageReadableFile(String filePath) async {
    final src = File(filePath);
    if (!await src.exists()) {
      throw StateError('File not found: $filePath');
    }
    final len = await src.length();
    if (len <= 0) {
      throw StateError('File is empty');
    }
    // Already under our temp / support dirs — reuse.
    final normalized = p.normalize(src.absolute.path);
    final tmpRoot = p.normalize((await getTemporaryDirectory()).path);
    final supportRoot =
        p.normalize((await getApplicationSupportDirectory()).path);
    if (normalized.startsWith(tmpRoot) ||
        normalized.startsWith(supportRoot)) {
      return normalized;
    }

    final destDir = Directory(p.join(tmpRoot, 'tg_uploads'));
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }
    final safeName =
        p.basename(normalized).replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final destPath = p.join(
      destDir.path,
      '${DateTime.now().microsecondsSinceEpoch}_$safeName',
    );
    await src.copy(destPath);
    return destPath;
  }

  /// sendMessage returns a pending message; wait until upload/send finishes.
  Future<void> _ensureOutgoingSendFinished(
    Map<String, dynamic> sendResult, {
    required String label,
    void Function(double progress)? onProgress,
  }) async {
    if (sendResult['@type'] == 'error') {
      throw StateError(sendResult['message'] as String? ?? label);
    }
    final sending = sendResult['sending_state'] as Map<String, dynamic>?;
    if (sending == null) return;
    if (sending['@type'] == 'messageSendingStateFailed') {
      throw StateError(
        sending['error_message'] as String? ?? label,
      );
    }
    if (sending['@type'] != 'messageSendingStatePending') return;

    final tempId = sendResult['id'];
    final chatId = sendResult['chat_id'];
    if (tempId == null || chatId == null) return;

    final uploadFileIds = _outgoingFileIds(sendResult);

    final done = Completer<void>();
    late final StreamSubscription<Map<String, dynamic>> sub;
    sub = updates.listen((update) {
      final type = update['@type'] as String?;
      if (type == 'updateFile' && onProgress != null) {
        final file = update['file'] as Map<String, dynamic>?;
        final fileId = file?['id'];
        if (fileId != null && uploadFileIds.contains(fileId)) {
          final remote = file?['remote'] as Map<String, dynamic>?;
          final size = (file?['expected_size'] as int?) ??
              (file?['size'] as int?) ??
              0;
          final uploaded = remote?['uploaded_size'] as int? ?? 0;
          if (size > 0) {
            onProgress((uploaded / size).clamp(0.0, 1.0));
          } else if (remote?['is_uploading_active'] == true) {
            onProgress(0.05);
          }
        }
        return;
      }
      if (type == 'updateMessageSendSucceeded') {
        final oldId = update['old_message_id'];
        if (oldId == tempId && !done.isCompleted) {
          onProgress?.call(1);
          done.complete();
        }
        return;
      }
      if (type == 'updateMessageSendFailed') {
        final oldId = update['old_message_id'];
        if (oldId != tempId) return;
        final error = update['error'] as Map<String, dynamic>?;
        final message = update['message'] as Map<String, dynamic>?;
        final state = message?['sending_state'] as Map<String, dynamic>?;
        final msg = error?['message'] as String? ??
            state?['error_message'] as String? ??
            label;
        if (!done.isCompleted) {
          done.completeError(StateError(msg));
        }
      }
    });
    try {
      await done.future.timeout(const Duration(minutes: 3));
    } on TimeoutException {
      throw StateError('Upload timed out');
    } finally {
      await sub.cancel();
    }
  }

  Set<Object> _outgoingFileIds(Map<String, dynamic> message) {
    final ids = <Object>{};
    final content = message['content'] as Map<String, dynamic>?;
    if (content == null) return ids;
    final type = content['@type'] as String?;
    void addFile(Map<String, dynamic>? file) {
      final id = file?['id'];
      if (id is Object) ids.add(id);
    }

    if (type == 'messagePhoto') {
      final photo = content['photo'] as Map<String, dynamic>?;
      final sizes = (photo?['sizes'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();
      for (final s in sizes) {
        addFile(s['photo'] as Map<String, dynamic>?);
      }
    } else if (type == 'messageDocument') {
      final doc = content['document'] as Map<String, dynamic>?;
      addFile(doc?['document'] as Map<String, dynamic>?);
    } else if (type == 'messageVoiceNote') {
      final vn = content['voice_note'] as Map<String, dynamic>?;
      addFile(vn?['voice'] as Map<String, dynamic>?);
    }
    return ids;
  }

  /// Convert WAV/other to OGG Opus for [inputMessageVoiceNote].
  Future<String> _ensureOggOpus(String filePath) async {
    final lower = filePath.toLowerCase();
    if (lower.endsWith('.ogg') || lower.endsWith('.opus')) {
      final f = File(filePath);
      if (!await f.exists() || await f.length() < 64) {
        throw StateError('Voice file missing or empty');
      }
      return filePath;
    }
    final outPath = '${p.withoutExtension(filePath)}.ogg';
    final result = await Process.run('ffmpeg', [
      '-y',
      '-i',
      filePath,
      '-c:a',
      'libopus',
      '-b:a',
      '36k',
      '-ar',
      '48000',
      '-ac',
      '1',
      outPath,
    ]);
    if (result.exitCode != 0) {
      final err = (result.stderr as String?)?.trim() ?? '';
      throw StateError(
        err.isEmpty
            ? 'ffmpeg failed to encode voice (exit ${result.exitCode})'
            : 'ffmpeg: ${err.split('\n').last}',
      );
    }
    final out = File(outPath);
    if (!await out.exists() || await out.length() < 64) {
      throw StateError('Encoded voice file is empty');
    }
    return outPath;
  }

  Future<void> getMe() async {
    send({'@type': 'getMe'});
  }

  void _loadLibrary() {
    if (_lib != null) return;

    final candidates = <String>[
      if (TelegramConfig.tdlibPath.isNotEmpty) TelegramConfig.tdlibPath,
      'libtdjson.so',
      'libtdjson.so.1.8.0',
      '/usr/local/lib/libtdjson.so',
      '/usr/lib/libtdjson.so',
      '/usr/lib/x86_64-linux-gnu/libtdjson.so',
      p.join(Directory.current.path, 'libtdjson.so'),
      p.join(Directory.current.path, 'native', 'libtdjson.so'),
    ];

    Object? lastError;
    for (final path in candidates) {
      if (path.isEmpty) continue;
      try {
        final lib = DynamicLibrary.open(path);
        _lib = lib;
        lastError = null;
        break;
      } catch (e) {
        lastError = e;
      }
    }

    if (_lib == null) {
      final tried = candidates.where((c) => c.isNotEmpty).join('\n  - ');
      throw StateError(
        'Could not load libtdjson.so. Tried:\n  - $tried\n'
        'Set TELEGRAM_TDLIB_PATH to the real .so path (quote paths with spaces, '
        'do not use \\ ). See docs/telegram_setup.md.\nLast error: $lastError',
      );
    }

    _createClientId =
        _lib!.lookupFunction<_TdCreateClientIdC, _TdCreateClientIdDart>(
      'td_create_client_id',
    );
    _send = _lib!.lookupFunction<_TdSendC, _TdSendDart>('td_send');
    _receive = _lib!.lookupFunction<_TdReceiveC, _TdReceiveDart>('td_receive');
    _execute = _lib!.lookupFunction<_TdExecuteC, _TdExecuteDart>('td_execute');
  }

  Future<void> _setTdlibParameters({bool forceFreshDb = false}) async {
    if (_parametersSent && !forceFreshDb) return;
    _parametersSent = true;

    final dbDir = await _prepareDatabaseDir(forceFresh: forceFreshDb);
    _databaseDirectory = dbDir.path;
    final filesDir = Directory(p.join(dbDir.path, 'files'));
    if (!filesDir.existsSync()) {
      filesDir.createSync(recursive: true);
    }
    await _writeRuntimeRegistry();

    send({
      '@type': 'setTdlibParameters',
      'use_test_dc': false,
      'database_directory': dbDir.path,
      'files_directory': filesDir.path,
      'database_encryption_key': '',
      'use_file_database': true,
      'use_chat_info_database': true,
      'use_message_database': true,
      'use_secret_chats': false,
      'api_id': int.parse(TelegramConfig.apiId),
      'api_hash': TelegramConfig.apiHash,
      'system_language_code': 'en',
      'device_model': 'GizeCare Desktop',
      'system_version': Platform.operatingSystemVersion,
      'application_version': '0.1.0',
    });
  }

  Future<Directory> _prepareDatabaseDir({required bool forceFresh}) async {
    final support = await getApplicationSupportDirectory();
    final primary = Directory(p.join(support.path, 'telegram_tdlib'));

    if (forceFresh) {
      await _retireDirectory(primary);
      for (final d in _tdlibCandidateDirs(support)) {
        await _retireDirectory(d);
      }
      await _cleanupRetiredTdlibDirs(support);
      final fresh = Directory(
        p.join(
          support.path,
          'telegram_tdlib_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      fresh.createSync(recursive: true);
      return fresh;
    }

    // Prefer a directory that already has a TDLib session (binlog), including
    // timestamped dirs created after a lock recovery.
    final withSession = _tdlibCandidateDirs(support)
        .where((d) => File(p.join(d.path, 'td.binlog')).existsSync())
        .toList()
      ..sort((a, b) {
        final aStat = File(p.join(a.path, 'td.binlog')).statSync();
        final bStat = File(p.join(b.path, 'td.binlog')).statSync();
        return bStat.modified.compareTo(aStat.modified);
      });
    if (withSession.isNotEmpty) {
      return withSession.first;
    }

    if (!primary.existsSync()) {
      primary.createSync(recursive: true);
    }
    return primary;
  }

  List<Directory> _tdlibCandidateDirs(Directory support) {
    final out = <Directory>[];
    final primary = Directory(p.join(support.path, 'telegram_tdlib'));
    if (primary.existsSync()) out.add(primary);
    try {
      for (final entity in support.listSync()) {
        if (entity is! Directory) continue;
        final name = p.basename(entity.path);
        if (name == 'telegram_tdlib') continue;
        if (name.startsWith('telegram_tdlib.retired_')) continue;
        if (name.startsWith('telegram_tdlib_')) out.add(entity);
      }
    } catch (_) {}
    return out;
  }

  Future<void> _retireDirectory(Directory dir) async {
    if (!dir.existsSync()) return;
    try {
      final retired = Directory(
        '${dir.path}.retired_${DateTime.now().millisecondsSinceEpoch}',
      );
      dir.renameSync(retired.path);
    } catch (_) {
      try {
        await dir.delete(recursive: true);
      } catch (e) {
        debugPrint('TDLib could not retire db dir: $e');
      }
    }
  }

  Future<void> _cleanupRetiredTdlibDirs(Directory support) async {
    try {
      final retired = support
          .listSync()
          .whereType<Directory>()
          .where(
            (d) =>
                p.basename(d.path).startsWith('telegram_tdlib.retired_') ||
                (p.basename(d.path).startsWith('telegram_tdlib_') &&
                    p.basename(d.path) != 'telegram_tdlib'),
          )
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));
      // Keep the newest retired copy; drop older ones (best effort).
      for (final d in retired.skip(1)) {
        try {
          await d.delete(recursive: true);
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _recoverFromBinlogLock() async {
    if (_recoveringLock) return;
    if (_lockRecoveries >= 3) {
      lastError =
          'Telegram session is locked. Quit GizeCare completely (press q in '
          'the terminal / close the window), then run again.';
      _setAuthStep(TelegramAuthStep.error);
      return;
    }
    _recoveringLock = true;
    _lockRecoveries++;
    try {
      debugPrint(
        'TDLib binlog locked — shutting down native clients in this process '
        '(attempt $_lockRecoveries)',
      );
      lastError = null;
      // Close every client id we know about for this PID, including the current
      // one, then recreate a single client against the existing session.
      final current = _clientId;
      _pollTimer?.cancel();
      _pollTimer = null;
      _running = false;
      _clientId = null;
      _parametersSent = false;
      await _shutdownRegisteredClients(includeBruteForce: true);
      if (current != null) {
        await _forceCloseClientId(current);
      }
      await Future<void>.delayed(
        Duration(milliseconds: 500 * _lockRecoveries),
      );

      _clientId = _createClientId();
      await _registerClientId(_clientId!);
      _running = true;
      _setAuthStep(TelegramAuthStep.waitTdlib);
      _pollTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        _drain();
      });
      send({'@type': 'getOption', 'name': 'version'});
    } finally {
      _recoveringLock = false;
    }
  }

  Future<File> _runtimeRegistryFile() async {
    final support = await getApplicationSupportDirectory();
    return File(p.join(support.path, 'telegram_tdlib_clients.json'));
  }

  Future<Map<String, dynamic>> _readRuntimeRegistry() async {
    try {
      final file = await _runtimeRegistryFile();
      if (!file.existsSync()) return {'pid': pid, 'clients': <int>[]};
      final raw = jsonDecode(await file.readAsString());
      if (raw is! Map) return {'pid': pid, 'clients': <int>[]};
      final map = Map<String, dynamic>.from(raw);
      if (map['pid'] != pid) {
        // Different process left the file — ignore orphan ids.
        return {'pid': pid, 'clients': <int>[], 'dbPath': map['dbPath']};
      }
      return map;
    } catch (_) {
      return {'pid': pid, 'clients': <int>[]};
    }
  }

  Future<void> _writeRuntimeRegistry({List<int>? clients}) async {
    final file = await _runtimeRegistryFile();
    final existing = await _readRuntimeRegistry();
    final ids = clients ??
        ((existing['clients'] as List?) ?? const [])
            .whereType<num>()
            .map((e) => e.toInt())
            .toList();
    await file.writeAsString(
      jsonEncode({
        'pid': pid,
        'clients': ids,
        if (_databaseDirectory != null) 'dbPath': _databaseDirectory,
        if (_databaseDirectory == null && existing['dbPath'] != null)
          'dbPath': existing['dbPath'],
      }),
    );
  }

  Future<void> _registerClientId(int id) async {
    final reg = await _readRuntimeRegistry();
    final ids = ((reg['clients'] as List?) ?? const [])
        .whereType<num>()
        .map((e) => e.toInt())
        .toSet()
      ..add(id);
    await _writeRuntimeRegistry(clients: ids.toList()..sort());
  }

  Future<void> _unregisterClientId(int id) async {
    final reg = await _readRuntimeRegistry();
    final ids = ((reg['clients'] as List?) ?? const [])
        .whereType<num>()
        .map((e) => e.toInt())
        .where((e) => e != id)
        .toList();
    await _writeRuntimeRegistry(clients: ids);
  }

  Future<void> _clearRuntimeRegistry() async {
    try {
      final file = await _runtimeRegistryFile();
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }

  Future<void> _shutdownRegisteredClients({bool includeBruteForce = false}) async {
    _loadLibrary();
    final reg = await _readRuntimeRegistry();
    final ids = ((reg['clients'] as List?) ?? const [])
        .whereType<num>()
        .map((e) => e.toInt())
        .toSet();
    if (includeBruteForce) {
      // Hot restart can lose the registry while native clients still hold the
      // binlog. Unused ids are ignored — just send close, don't wait per-id.
      for (var i = 1; i <= 32; i++) {
        ids.add(i);
      }
    }
    if (ids.isEmpty) return;

    debugPrint('Closing TDLib client id(s): ${ids.toList()..sort()}');
    for (final id in ids) {
      _sendCloseOnly(id);
    }

    // One short shared drain for all closes — never N×seconds.
    final deadline = DateTime.now().add(const Duration(milliseconds: 800));
    while (DateTime.now().isBefore(deadline)) {
      final ptr = _receive(0.05);
      if (ptr == nullptr) {
        await Future<void>.delayed(const Duration(milliseconds: 15));
        continue;
      }
      try {
        jsonDecode(ptr.toDartString());
      } catch (_) {}
    }

    await _writeRuntimeRegistry(clients: []);
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  void _sendCloseOnly(int id) {
    try {
      final json = jsonEncode({'@type': 'close'});
      final ptr = json.toNativeUtf8();
      try {
        _send(id, ptr);
      } finally {
        malloc.free(ptr);
      }
    } catch (_) {}
  }

  Future<void> _forceCloseClientId(int id) async {
    _loadLibrary();
    _sendCloseOnly(id);
    final deadline = DateTime.now().add(const Duration(milliseconds: 200));
    while (DateTime.now().isBefore(deadline)) {
      final ptr = _receive(0.02);
      if (ptr == nullptr) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        continue;
      }
      try {
        final map = jsonDecode(ptr.toDartString()) as Map<String, dynamic>;
        final state = map['authorization_state'] as Map<String, dynamic>?;
        if (map['@type'] == 'updateAuthorizationState' &&
            state?['@type'] == 'authorizationStateClosed') {
          break;
        }
      } catch (_) {}
    }
  }

  void _drain() {
    if (_lib == null) return;
    // Keep draining while closing so we receive authorizationStateClosed.
    if (!_running && _closedCompleter == null) return;
    while (true) {
      final ptr = _receive(0.0);
      if (ptr == nullptr) break;
      try {
        final raw = ptr.toDartString();
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final extra = map['@extra']?.toString();
        if (extra != null && _pendingExtra.containsKey(extra)) {
          final c = _pendingExtra.remove(extra)!;
          if (!c.isCompleted) c.complete(map);
        }
        final type = map['@type'] as String?;
        // getAuthorizationState returns the state object directly.
        if (type != null && type.startsWith('authorizationState')) {
          _handleUpdate({
            '@type': 'updateAuthorizationState',
            'authorization_state': map,
          });
        } else {
          _handleUpdate(map);
        }
        if (!_updates.isClosed) {
          _updates.add(map);
        }
      } catch (e) {
        debugPrint('TDLib parse error: $e');
      }
    }
  }

  void _handleUpdate(Map<String, dynamic> update) {
    final type = update['@type'] as String?;
    if (type == 'updateAuthorizationState') {
      final state = update['authorization_state'] as Map<String, dynamic>?;
      final stateType = state?['@type'] as String?;
      switch (stateType) {
        case 'authorizationStateWaitTdlibParameters':
          _parametersSent = false;
          _setAuthStep(TelegramAuthStep.waitTdlib);
          unawaited(_setTdlibParameters());
        case 'authorizationStateWaitEncryptionKey':
          send({
            '@type': 'setDatabaseEncryptionKey',
            'new_encryption_key': '',
          });
        case 'authorizationStateWaitPhoneNumber':
          lastError = null;
          _setCodeInfo(null);
          _setAuthStep(TelegramAuthStep.waitPhone);
        case 'authorizationStateWaitCode':
          lastError = null;
          final info = state?['code_info'] as Map<String, dynamic>?;
          _setCodeInfo(_parseCodeInfo(info));
          _setAuthStep(TelegramAuthStep.waitCode);
        case 'authorizationStateWaitPassword':
          lastError = null;
          _setAuthStep(TelegramAuthStep.waitPassword);
        case 'authorizationStateReady':
          lastError = null;
          _setCodeInfo(null);
          _setAuthStep(TelegramAuthStep.ready);
        case 'authorizationStateClosing':
          break;
        case 'authorizationStateClosed':
          _setAuthStep(TelegramAuthStep.idle);
          final c = _closedCompleter;
          if (c != null && !c.isCompleted) {
            c.complete();
          }
        case 'authorizationStateLoggingOut':
          _setAuthStep(TelegramAuthStep.idle);
        default:
          break;
      }
    } else if (type == 'error') {
      final message = update['message'] as String? ?? 'Telegram error';
      if (message.contains('Unexpected setTdlibParameters') ||
          message.contains('Unexpected setDatabaseEncryptionKey')) {
        debugPrint('TDLib ignored: $message');
        return;
      }

      // Binlog held by an orphan native client (common after hot restart).
      if (message.contains('already in use') || message.contains("Can't lock")) {
        unawaited(_recoverFromBinlogLock());
        return;
      }

      // Phone sent before init finished — re-kick parameters, stay on waitTdlib.
      if (message.contains('setTdlibParameters first') ||
          message.contains('Initialization parameters are needed')) {
        lastError = null;
        _parametersSent = false;
        _setAuthStep(TelegramAuthStep.waitTdlib);
        unawaited(_setTdlibParameters());
        return;
      }

      lastError = message;

      final recoverable = message.contains('PHONE_CODE') ||
          message.contains('PHONE_NUMBER') ||
          message.contains('PASSWORD') ||
          message.contains('CODE_INVALID') ||
          message.contains('CODE_EMPTY') ||
          message.contains('PASSWORD_HASH_INVALID');
      if (recoverable) {
        if (!_authStep.isClosed) {
          _authStep.add(currentAuthStep);
        }
        return;
      }

      _setAuthStep(TelegramAuthStep.error);
    }
  }

  TelegramCodeInfo? _parseCodeInfo(Map<String, dynamic>? info) {
    if (info == null) return null;
    final type = info['type'] as Map<String, dynamic>?;
    final next = info['next_type'] as Map<String, dynamic>?;
    return TelegramCodeInfo(
      delivery: _deliveryFromType(type?['@type'] as String?),
      nextDelivery: next == null
          ? null
          : _deliveryFromType(next['@type'] as String?),
      timeoutSeconds: info['timeout'] as int? ?? 0,
    );
  }

  TelegramCodeDelivery _deliveryFromType(String? type) {
    return switch (type) {
      'authenticationCodeTypeTelegramMessage' =>
        TelegramCodeDelivery.telegramApp,
      'authenticationCodeTypeSms' ||
      'authenticationCodeTypeSmsWord' ||
      'authenticationCodeTypeSmsPhrase' =>
        TelegramCodeDelivery.sms,
      'authenticationCodeTypeCall' => TelegramCodeDelivery.call,
      'authenticationCodeTypeFlashCall' ||
      'authenticationCodeTypeMissedCall' =>
        TelegramCodeDelivery.flashCall,
      'authenticationCodeTypeFragment' => TelegramCodeDelivery.fragment,
      'authenticationCodeTypeFirebaseAndroid' ||
      'authenticationCodeTypeFirebaseIos' =>
        TelegramCodeDelivery.firebase,
      _ => TelegramCodeDelivery.other,
    };
  }

  void _setCodeInfo(TelegramCodeInfo? info) {
    codeInfo = info;
    if (!_codeInfoController.isClosed) {
      _codeInfoController.add(info);
    }
  }

  void _setAuthStep(TelegramAuthStep step) {
    currentAuthStep = step;
    if (!_authStep.isClosed) {
      _authStep.add(step);
    }
  }

  /// Re-emit the current step (helps UI catch up after resume/connect).
  void publishAuthStep() {
    if (!_authStep.isClosed) {
      _authStep.add(currentAuthStep);
    }
  }
}
