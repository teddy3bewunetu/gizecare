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
    this.lastReadOutboxMessageId,
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
  /// Highest outgoing message id the peer has read (null = none known).
  final String? lastReadOutboxMessageId;
  final String? photoPath;

  /// Whether an outgoing [messageId] has been read by the peer.
  bool isOutgoingMessageRead(String messageId) {
    final last = lastReadOutboxMessageId;
    if (last == null || last.isEmpty) return false;
    final a = int.tryParse(messageId);
    final b = int.tryParse(last);
    if (a == null || b == null || b <= 0) return false;
    return a <= b;
  }

  TelegramChat copyWith({
    bool? isAllowed,
    String? photoPath,
    String? lastReadOutboxMessageId,
  }) {
    return TelegramChat(
      id: id,
      telegramChatId: telegramChatId,
      title: title,
      chatType: chatType,
      isAllowed: isAllowed ?? this.isAllowed,
      username: username,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      lastReadOutboxMessageId:
          lastReadOutboxMessageId ?? this.lastReadOutboxMessageId,
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
        lastReadOutboxMessageId,
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
    this.mediaFileId,
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
  final int? mediaFileId;
  final String? replyToMessageId;
  final String? replyPreview;
  final bool isEdited;

  bool get hasPhoto =>
      contentType == 'photo' && mediaPath != null && mediaPath!.isNotEmpty;

  bool get hasDocument => contentType == 'document';

  /// Document file name (first segment of [text] when encoded as `name|caption`).
  String get documentFileName {
    if (!hasDocument) return 'Document';
    final name = text.split('|').first.trim();
    return name.isEmpty ? 'Document' : name;
  }

  String? get documentCaption {
    if (!hasDocument) return null;
    final parts = text.split('|');
    if (parts.length < 2) return null;
    final caption = parts.sublist(1).join('|').trim();
    return caption.isEmpty ? null : caption;
  }

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
        mediaFileId,
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

/// Toast / badge payload when a new inbound message arrives.
class TelegramIncomingNotice extends Equatable {
  const TelegramIncomingNotice({
    required this.chatId,
    required this.chatTitle,
    required this.preview,
    required this.receivedAt,
    this.photoPath,
    this.senderName,
    this.chatType = TelegramChatType.private,
    this.contentType = 'text',
  });

  final String chatId;
  final String chatTitle;
  final String preview;
  final DateTime receivedAt;
  final String? photoPath;
  final String? senderName;
  final TelegramChatType chatType;
  final String contentType;

  bool get isGroupLike =>
      chatType == TelegramChatType.group ||
      chatType == TelegramChatType.channel;

  @override
  List<Object?> get props => [
        chatId,
        chatTitle,
        preview,
        receivedAt,
        photoPath,
        senderName,
        chatType,
        contentType,
      ];
}
