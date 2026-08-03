import 'package:equatable/equatable.dart';

class GmailAccount extends Equatable {
  const GmailAccount({
    required this.id,
    required this.email,
    required this.connectedAt,
    this.lastSyncAt,
  });

  final String id;
  final String email;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;

  @override
  List<Object?> get props => [id, email, connectedAt, lastSyncAt];
}

class GmailThread extends Equatable {
  const GmailThread({
    required this.id,
    required this.gmailThreadId,
    required this.subject,
    required this.snippet,
    required this.date,
    required this.isUnread,
    this.fromName,
    this.fromEmail,
  });

  final String id;
  final String gmailThreadId;
  final String subject;
  final String snippet;
  final DateTime date;
  final bool isUnread;
  final String? fromName;
  final String? fromEmail;

  String get fromDisplay {
    final name = fromName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return fromEmail?.trim().isNotEmpty == true ? fromEmail! : 'Unknown';
  }

  @override
  List<Object?> get props => [
        id,
        gmailThreadId,
        subject,
        snippet,
        date,
        isUnread,
        fromName,
        fromEmail,
      ];
}

class GmailMessage extends Equatable {
  const GmailMessage({
    required this.id,
    required this.gmailThreadId,
    required this.gmailMessageId,
    required this.subject,
    required this.bodyText,
    required this.date,
    required this.isUnread,
    required this.toEmails,
    this.bodyHtml,
    this.fromName,
    this.fromEmail,
  });

  final String id;
  final String gmailThreadId;
  final String gmailMessageId;
  final String subject;
  final String bodyText;
  final String? bodyHtml;
  final DateTime date;
  final bool isUnread;
  final String toEmails;
  final String? fromName;
  final String? fromEmail;

  String get fromDisplay {
    final name = fromName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return fromEmail?.trim().isNotEmpty == true ? fromEmail! : 'Unknown';
  }

  bool get hasHtml => bodyHtml != null && bodyHtml!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        gmailThreadId,
        gmailMessageId,
        subject,
        bodyText,
        bodyHtml,
        date,
        isUnread,
        toEmails,
        fromName,
        fromEmail,
      ];
}
