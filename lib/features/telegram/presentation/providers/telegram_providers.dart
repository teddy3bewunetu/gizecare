import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/features/telegram/data/repositories/drift_telegram_repository.dart';
import 'package:gizecare/features/telegram/data/tdjson_client.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/repositories/telegram_repository.dart';

final tdjsonClientProvider = Provider<TdjsonClient>((ref) {
  // Process singleton — do not close on Provider dispose (hot reload/restart
  // would orphan the native client while Dart creates another).
  return TdjsonClient.instance;
});

final telegramRepositoryProvider = Provider<TelegramRepository>((ref) {
  return DriftTelegramRepository(
    db: ref.watch(appDatabaseProvider),
    client: ref.watch(tdjsonClientProvider),
  );
});

final telegramAccountProvider = StreamProvider<TelegramAccount?>((ref) {
  return ref.watch(telegramRepositoryProvider).watchAccount();
});

final telegramAuthStepProvider = StreamProvider<TelegramAuthStep>((ref) {
  return ref.watch(telegramRepositoryProvider).watchAuthStep();
});

final telegramCodeInfoProvider = StreamProvider<TelegramCodeInfo?>((ref) {
  return ref.watch(telegramRepositoryProvider).watchCodeInfo();
});

/// Whether the live TDLib client is authorized (vs cached DB-only UI).
final telegramSessionReadyProvider = Provider<bool>((ref) {
  final step = ref.watch(telegramAuthStepProvider).valueOrNull;
  if (step == TelegramAuthStep.ready) return true;
  return ref.watch(tdjsonClientProvider).isReady;
});

/// Total unread across allowlisted chats (for nav badge).
final telegramUnreadTotalProvider = Provider<int>((ref) {
  final chats = ref.watch(telegramChatsProvider(true)).valueOrNull;
  if (chats == null) return 0;
  return chats.fold<int>(0, (sum, c) => sum + c.unreadCount);
});

final telegramChatsProvider =
    StreamProvider.family<List<TelegramChat>, bool>((ref, allowedOnly) {
  return ref.watch(telegramRepositoryProvider).watchChats(
        allowedOnly: allowedOnly,
      );
});

final telegramMessagesProvider =
    StreamProvider.family<List<TelegramMessage>, String>((ref, chatId) {
  return ref.watch(telegramRepositoryProvider).watchMessages(chatId);
});

final selectedTelegramChatIdProvider = StateProvider<String?>((ref) => null);

/// Chat folder filter (Telegram Desktop-style sidebar).
enum TelegramFolderFilter { all, personal, groups, channels }

final telegramFolderFilterProvider =
    StateProvider<TelegramFolderFilter>((ref) => TelegramFolderFilter.all);

final telegramChatSearchProvider = StateProvider<String>((ref) => '');

