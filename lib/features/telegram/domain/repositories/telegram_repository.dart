import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';

/// Telegram connect / allowlist / messaging.
abstract class TelegramRepository {
  Stream<TelegramAccount?> watchAccount();

  Future<Result<TelegramAccount?>> getAccount();

  Stream<TelegramAuthStep> watchAuthStep();

  Stream<TelegramCodeInfo?> watchCodeInfo();

  Future<Result<Unit>> startClient();

  Future<Result<Unit>> submitPhone(String phoneNumber);

  Future<Result<Unit>> submitCode(String code);

  Future<Result<Unit>> submitPassword(String password);

  /// Resend login code (may switch to SMS / next delivery type).
  Future<Result<Unit>> resendCode();

  /// Resumes a saved TDLib session (no phone UI). Fails if re-login is needed.
  Future<Result<Unit>> resumeSession();

  Future<Result<Unit>> disconnect();

  Future<Result<Unit>> syncChats();

  Stream<List<TelegramChat>> watchChats({bool allowedOnly = false});

  Future<Result<List<TelegramChat>>> getChats({bool allowedOnly = false});

  Future<Result<Unit>> setAllowedChats(Set<String> telegramChatIds);

  Future<Result<Unit>> syncMessages(String telegramChatId, {int limit = 50});

  Stream<List<TelegramMessage>> watchMessages(String telegramChatId);

  Future<Result<Unit>> sendMessage({
    required String telegramChatId,
    required String text,
    String? replyToMessageId,
  });

  Future<Result<Unit>> editMessage({
    required String telegramChatId,
    required String telegramMessageId,
    required String text,
  });

  Future<Result<Unit>> deleteMessage({
    required String telegramChatId,
    required String telegramMessageId,
  });

  Future<Result<Unit>> markChatRead(String telegramChatId);

  /// Ensures a message attachment is downloaded; returns the local file path.
  Future<Result<String>> ensureMessageMedia(
    String telegramChatId,
    String telegramMessageId,
  );

  Future<Result<Unit>> sendDocument({
    required String telegramChatId,
    required String filePath,
    String? caption,
  });

  Future<Result<Unit>> sendVoiceNote({
    required String telegramChatId,
    required String filePath,
    required int durationSeconds,
  });

  /// Loads profile details (user/chat) for the profile sheet.
  Future<Result<TelegramProfile>> getChatProfile(String telegramChatId);

  /// Starts or opens a call for a private chat (phone / Telegram deep link).
  Future<Result<Unit>> startCall(String telegramChatId);

  /// Mute (`muted == true`) or unmute a chat's notifications.
  Future<Result<Unit>> setChatMuted({
    required String telegramChatId,
    required bool muted,
  });

  /// Add or edit a private-chat contact name.
  Future<Result<Unit>> editContact({
    required String telegramChatId,
    required String firstName,
    String lastName = '',
  });

  /// Remove the user from Telegram contacts.
  Future<Result<Unit>> deleteContact(String telegramChatId);

  /// Block or unblock the other user in a private chat.
  Future<Result<Unit>> setUserBlocked({
    required String telegramChatId,
    required bool blocked,
  });

  /// Open the chat / user in the system Telegram client.
  Future<Result<Unit>> openInTelegram(String telegramChatId);

  /// Search synced messages in a chat (local cache).
  Future<Result<List<TelegramMessage>>> searchMessages({
    required String telegramChatId,
    required String query,
  });

  /// Which allowlisted chat is currently open in the UI (null = none).
  /// Incoming messages for this chat do not bump unread / toast.
  void setFocusedChatId(String? telegramChatId);

  /// Live notices for new incoming messages on allowlisted chats.
  Stream<TelegramIncomingNotice> watchIncomingNotices();
}
