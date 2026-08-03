import 'package:equatable/equatable.dart';

enum TelegramChatType { private, group, channel, secret, unknown }

enum TelegramAuthStep {
  idle,
  waitTdlib,
  waitPhone,
  waitCode,
  waitPassword,
  ready,
  error,
}

/// How Telegram is delivering (or can deliver) the login code.
enum TelegramCodeDelivery {
  telegramApp,
  sms,
  call,
  flashCall,
  fragment,
  firebase,
  other,
}

class TelegramCodeInfo extends Equatable {
  const TelegramCodeInfo({
    required this.delivery,
    this.nextDelivery,
    this.timeoutSeconds = 0,
  });

  final TelegramCodeDelivery delivery;
  final TelegramCodeDelivery? nextDelivery;
  final int timeoutSeconds;

  String get deliveryLabel => _label(delivery);

  String? get nextDeliveryLabel =>
      nextDelivery == null ? null : _label(nextDelivery!);

  static String _label(TelegramCodeDelivery d) {
    return switch (d) {
      TelegramCodeDelivery.telegramApp => 'Telegram app',
      TelegramCodeDelivery.sms => 'SMS',
      TelegramCodeDelivery.call => 'Phone call',
      TelegramCodeDelivery.flashCall => 'Flash call',
      TelegramCodeDelivery.fragment => 'Fragment',
      TelegramCodeDelivery.firebase => 'Firebase SMS',
      TelegramCodeDelivery.other => 'Other',
    };
  }

  @override
  List<Object?> get props => [delivery, nextDelivery, timeoutSeconds];
}

class TelegramAccount extends Equatable {
  const TelegramAccount({
    required this.id,
    required this.phoneNumber,
    required this.connectedAt,
    this.telegramUserId,
    this.username,
    this.displayName,
    this.lastSyncAt,
  });

  final String id;
  final String phoneNumber;
  final String? telegramUserId;
  final String? username;
  final String? displayName;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;

  @override
  List<Object?> get props =>
      [id, phoneNumber, telegramUserId, username, displayName, connectedAt, lastSyncAt];
}

class TelegramChat extends Equatable {
  const TelegramChat({
    required this.id,
    required this.telegramChatId,
    required this.title,
    required this.chatType,
    required this.isAllowed,
    this.username,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.photoPath,
  });

  final String id;
  final String telegramChatId;
  final String title;
  final TelegramChatType chatType;
  final bool isAllowed;
  final String? username;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final String? photoPath;

  TelegramChat copyWith({bool? isAllowed, String? photoPath}) {
    return TelegramChat(
      id: id,
      telegramChatId: telegramChatId,
      title: title,
      chatType: chatType,
      isAllowed: isAllowed ?? this.isAllowed,
      username: username,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        telegramChatId,
        title,
        chatType,
        isAllowed,
        username,
        lastMessageAt,
        unreadCount,
        photoPath,
      ];
}

class TelegramMessage extends Equatable {
  const TelegramMessage({
    required this.id,
    required this.telegramChatId,
    required this.telegramMessageId,
    required this.text,
    required this.sentAt,
    required this.isOutgoing,
    this.senderName,
    this.contentType = 'text',
    this.mediaPath,
    this.replyToMessageId,
    this.replyPreview,
    this.isEdited = false,
  });

  final String id;
  final String telegramChatId;
  final String telegramMessageId;
  final String text;
  final DateTime sentAt;
  final bool isOutgoing;
  final String? senderName;
  final String contentType;
  final String? mediaPath;
  final String? replyToMessageId;
  final String? replyPreview;
  final bool isEdited;

  bool get hasPhoto =>
      contentType == 'photo' && mediaPath != null && mediaPath!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        telegramChatId,
        telegramMessageId,
        text,
        sentAt,
        isOutgoing,
        senderName,
        contentType,
        mediaPath,
        replyToMessageId,
        replyPreview,
        isEdited,
      ];
}

/// Profile / chat info for the Telegram profile sheet.
class TelegramProfile extends Equatable {
  const TelegramProfile({
    required this.chatId,
    required this.title,
    required this.chatType,
    this.userId,
    this.username,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.bio,
    this.statusText,
    this.photoPath,
    this.isMuted = false,
    this.isContact = false,
    this.isBlocked = false,
    this.photoCount = 0,
    this.videoCount = 0,
    this.fileCount = 0,
    this.linkCount = 0,
    this.voiceCount = 0,
    this.gifCount = 0,
  });

  final String chatId;
  final String title;
  final TelegramChatType chatType;
  final String? userId;
  final String? username;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? statusText;
  final String? photoPath;
  final bool isMuted;
  final bool isContact;
  final bool isBlocked;
  final int photoCount;
  final int videoCount;
  final int fileCount;
  final int linkCount;
  final int voiceCount;
  final int gifCount;

  bool get isPrivate => chatType == TelegramChatType.private;

  @override
  List<Object?> get props => [
        chatId,
        title,
        chatType,
        userId,
        username,
        phoneNumber,
        firstName,
        lastName,
        bio,
        statusText,
        photoPath,
        isMuted,
        isContact,
        isBlocked,
        photoCount,
        videoCount,
        fileCount,
        linkCount,
        voiceCount,
        gifCount,
      ];
}

TelegramChatType telegramChatTypeFromString(String raw) {
  return switch (raw) {
    'private' => TelegramChatType.private,
    'group' => TelegramChatType.group,
    'channel' => TelegramChatType.channel,
    'secret' => TelegramChatType.secret,
    _ => TelegramChatType.unknown,
  };
}

String telegramChatTypeToString(TelegramChatType type) {
  return switch (type) {
    TelegramChatType.private => 'private',
    TelegramChatType.group => 'group',
    TelegramChatType.channel => 'channel',
    TelegramChatType.secret => 'secret',
    TelegramChatType.unknown => 'unknown',
  };
}
