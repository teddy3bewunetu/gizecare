import 'package:equatable/equatable.dart';

enum SlackConversationType { channel, group, im, mpim, unknown }

class SlackAccount extends Equatable {
  const SlackAccount({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.userId,
    this.displayName,
    required this.connectedAt,
    this.lastSyncAt,
  });

  final String id;
  final String teamId;
  final String teamName;
  final String userId;
  final String? displayName;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;

  @override
  List<Object?> get props =>
      [id, teamId, teamName, userId, displayName, connectedAt, lastSyncAt];
}

class SlackConversation extends Equatable {
  const SlackConversation({
    required this.id,
    required this.conversationId,
    required this.name,
    required this.conversationType,
    this.isMuted = false,
    this.isAllowed = true,
    this.unreadCount = 0,
    this.lastMessageAt,
  });

  final String id;
  final String conversationId;
  final String name;
  final SlackConversationType conversationType;
  final bool isMuted;
  final bool isAllowed;
  final int unreadCount;
  final DateTime? lastMessageAt;

  @override
  List<Object?> get props => [
        id,
        conversationId,
        name,
        conversationType,
        isMuted,
        isAllowed,
        unreadCount,
        lastMessageAt,
      ];
}

class SlackReaction extends Equatable {
  const SlackReaction({
    required this.name,
    required this.count,
    this.isMine = false,
  });

  final String name;
  final int count;
  final bool isMine;

  Map<String, dynamic> toJson() => {
        'name': name,
        'count': count,
        'isMine': isMine,
      };

  factory SlackReaction.fromJson(Map<String, dynamic> json) {
    return SlackReaction(
      name: json['name'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [name, count, isMine];
}

class SlackFileRef extends Equatable {
  const SlackFileRef({
    required this.id,
    required this.name,
    this.mimetype,
    this.urlPrivate,
    this.thumbUrl,
  });

  final String id;
  final String name;
  final String? mimetype;
  final String? urlPrivate;
  final String? thumbUrl;

  bool get isImage =>
      (mimetype ?? '').startsWith('image/') ||
      name.toLowerCase().endsWith('.png') ||
      name.toLowerCase().endsWith('.jpg') ||
      name.toLowerCase().endsWith('.jpeg') ||
      name.toLowerCase().endsWith('.gif') ||
      name.toLowerCase().endsWith('.webp');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (mimetype != null) 'mimetype': mimetype,
        if (urlPrivate != null) 'urlPrivate': urlPrivate,
        if (thumbUrl != null) 'thumbUrl': thumbUrl,
      };

  factory SlackFileRef.fromJson(Map<String, dynamic> json) {
    return SlackFileRef(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'file',
      mimetype: json['mimetype'] as String?,
      urlPrivate: json['urlPrivate'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, mimetype, urlPrivate, thumbUrl];
}

class SlackMessage extends Equatable {
  SlackMessage({
    required this.id,
    required this.conversationId,
    required this.messageTs,
    this.threadTs,
    this.senderName,
    this.senderUserId,
    required this.text,
    required this.sentAt,
    this.isOutgoing = false,
    this.replyCount = 0,
    List<SlackReaction>? reactions,
    List<SlackFileRef>? files,
    this.isEdited = false,
  })  : _reactions = reactions,
        _files = files;

  final String id;
  final String conversationId;
  final String messageTs;
  final String? threadTs;
  final String? senderName;
  final String? senderUserId;
  final String text;
  final DateTime sentAt;
  final bool isOutgoing;
  final int replyCount;
  final List<SlackReaction>? _reactions;
  final List<SlackFileRef>? _files;
  final bool isEdited;

  /// Coalesces null (e.g. after hot reload / incomplete rows).
  List<SlackReaction> get reactions => _reactions ?? const [];

  List<SlackFileRef> get files => _files ?? const [];

  /// Top-level channel message (not a reply inside a thread).
  bool get isParent => threadTs == null || threadTs == messageTs;

  @override
  List<Object?> get props => [
        id,
        conversationId,
        messageTs,
        threadTs,
        senderName,
        senderUserId,
        text,
        sentAt,
        isOutgoing,
        replyCount,
        reactions,
        files,
        isEdited,
      ];
}

SlackConversationType slackConversationTypeFromString(String raw) {
  return switch (raw) {
    'channel' => SlackConversationType.channel,
    'group' => SlackConversationType.group,
    'im' => SlackConversationType.im,
    'mpim' => SlackConversationType.mpim,
    _ => SlackConversationType.unknown,
  };
}

String slackConversationTypeToString(SlackConversationType type) {
  return switch (type) {
    SlackConversationType.channel => 'channel',
    SlackConversationType.group => 'group',
    SlackConversationType.im => 'im',
    SlackConversationType.mpim => 'mpim',
    SlackConversationType.unknown => 'unknown',
  };
}
