import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/slack/domain/entities/slack_entities.dart';

abstract class SlackRepository {
  Stream<SlackAccount?> watchAccount();

  Future<Result<SlackAccount?>> getAccount();

  Future<Result<SlackAccount>> connect();

  Future<Result<Unit>> disconnect();

  Future<Result<Unit>> syncConversations();

  Stream<List<SlackConversation>> watchConversations();

  Stream<List<SlackMessage>> watchMessages(String conversationId);

  /// When [soft] is true, upsert recent messages without wiping the cache.
  Future<Result<Unit>> syncMessages(
    String conversationId, {
    int limit = 50,
    bool soft = false,
  });

  Future<Result<Unit>> syncThreadReplies({
    required String conversationId,
    required String threadTs,
  });

  Future<Result<Unit>> sendMessage({
    required String conversationId,
    required String text,
    String? threadTs,
  });

  Future<Result<Unit>> editMessage({
    required String conversationId,
    required String messageTs,
    required String text,
  });

  Future<Result<Unit>> deleteMessage({
    required String conversationId,
    required String messageTs,
  });

  Future<Result<Unit>> addReaction({
    required String conversationId,
    required String messageTs,
    required String emojiName,
  });

  Future<Result<Unit>> removeReaction({
    required String conversationId,
    required String messageTs,
    required String emojiName,
  });

  Future<Result<Unit>> sendFile({
    required String conversationId,
    required String filePath,
    String? caption,
    String? threadTs,
  });

  /// Downloads a private Slack file; returns local path.
  Future<Result<String>> downloadFile(SlackFileRef file);

  Future<Result<Unit>> markRead(String conversationId);

  /// Refresh unread for one conversation via conversations.info.
  Future<Result<Unit>> refreshConversationUnread(String conversationId);
}
