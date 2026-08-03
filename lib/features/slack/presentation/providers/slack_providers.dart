import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/features/slack/data/repositories/drift_slack_repository.dart';
import 'package:gizecare/features/slack/data/slack_auth_service.dart';
import 'package:gizecare/features/slack/data/slack_token_store.dart';
import 'package:gizecare/features/slack/domain/entities/slack_entities.dart';
import 'package:gizecare/features/slack/domain/repositories/slack_repository.dart';

final slackTokenStoreProvider = Provider<SlackTokenStore>((ref) {
  return SlackTokenStore();
});

final slackAuthServiceProvider = Provider<SlackAuthService>((ref) {
  final service = SlackAuthService(
    tokenStore: ref.watch(slackTokenStoreProvider),
  );
  ref.onDispose(service.close);
  return service;
});

final slackRepositoryProvider = Provider<SlackRepository>((ref) {
  return DriftSlackRepository(
    db: ref.watch(appDatabaseProvider),
    auth: ref.watch(slackAuthServiceProvider),
  );
});

final slackAccountProvider = StreamProvider<SlackAccount?>((ref) {
  return ref.watch(slackRepositoryProvider).watchAccount();
});

final slackConversationsProvider =
    StreamProvider<List<SlackConversation>>((ref) {
  return ref.watch(slackRepositoryProvider).watchConversations();
});

final slackUnreadTotalProvider = Provider<int>((ref) {
  final conversations = ref.watch(slackConversationsProvider).valueOrNull;
  if (conversations == null) return 0;
  return conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);
});

final selectedSlackConversationIdProvider = StateProvider<String?>((ref) => null);

final selectedSlackThreadTsProvider = StateProvider<String?>((ref) => null);

final slackMessagesProvider =
    StreamProvider.family<List<SlackMessage>, String>((ref, conversationId) {
  return ref.watch(slackRepositoryProvider).watchMessages(conversationId);
});

/// Curated reaction names for the picker.
const slackQuickReactions = <String>[
  'thumbsup',
  'heart',
  'eyes',
  'joy',
  'tada',
  'fire',
  'clap',
  'thinking_face',
];
