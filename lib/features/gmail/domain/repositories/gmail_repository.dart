import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/gmail/domain/entities/gmail_entities.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

abstract class GmailRepository {
  Stream<GmailAccount?> watchAccount();

  Future<Result<GmailAccount?>> getAccount();

  /// Opens Google OAuth (shared with Calendar). Re-consent if Gmail scope missing.
  Future<Result<GmailAccount>> connect();

  Future<Result<Unit>> disconnect();

  Future<Result<Unit>> syncInbox({int maxThreads = 40});

  Stream<List<GmailThread>> watchThreads();

  Stream<List<GmailMessage>> watchThreadMessages(String gmailThreadId);

  Future<Result<Unit>> openThread(String gmailThreadId);

  Future<Result<Unit>> markThreadRead(String gmailThreadId);

  Future<Result<Unit>> sendMessage({
    required String to,
    required String subject,
    required String body,
    String? bodyHtml,
    String? replyToThreadId,
    String? inReplyToMessageId,
  });
}
