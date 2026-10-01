import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/core/services/notifications/desktop_notification_service.dart';
import 'package:gizecare/features/telegram/data/repositories/drift_telegram_repository.dart';
import 'package:gizecare/features/telegram/data/tdjson_client.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/repositories/telegram_repository.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_desktop_toast.dart';

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

final desktopNotificationServiceProvider =
    Provider<DesktopNotificationService>((ref) {
  return DesktopNotificationService();
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

/// Keeps repository focus in sync so open chats don't toast/badge.
final telegramFocusSyncProvider = Provider<void>((ref) {
  ref.listen<String?>(selectedTelegramChatIdProvider, (prev, next) {
    ref.read(telegramRepositoryProvider).setFocusedChatId(next);
  });
  ref
      .read(telegramRepositoryProvider)
      .setFocusedChatId(ref.read(selectedTelegramChatIdProvider));
});

/// Resume TDLib in the background so badges update outside the Telegram page.
final telegramSessionKeepaliveProvider = Provider<void>((ref) {
  Future<void> tryResume() async {
    final account = ref.read(telegramAccountProvider).valueOrNull;
    if (account == null) return;
    if (ref.read(tdjsonClientProvider).isReady) return;
    await ref.read(telegramRepositoryProvider).resumeSession();
  }

  ref.listen(telegramAccountProvider, (prev, next) {
    if (next.valueOrNull != null) {
      unawaited(tryResume());
    }
  });
  unawaited(tryResume());
});

/// OS notification (above other apps) for new Telegram messages.
final telegramNotificationMonitorProvider = Provider<void>((ref) {
  final desktop = ref.watch(desktopNotificationServiceProvider);
  final sub = ref
      .watch(telegramRepositoryProvider)
      .watchIncomingNotices()
      .listen((notice) {
    final body = notice.isGroupLike &&
            notice.senderName != null &&
            notice.senderName!.trim().isNotEmpty
        ? '${notice.senderName}: ${notice.preview}'
        : notice.preview;

    // System notification — appears over every app via the desktop shell.
    unawaited(
      desktop.show(
        title: notice.chatTitle,
        body: body,
        appName: 'Telegram · GizeCare',
        iconPath: notice.photoPath,
        onActivated: () {
          unawaited(desktop.focusAppWindow());
          TelegramDesktopToast.openChat(
            null,
            notice.chatId,
            selectChat: (id) {
              ref.read(selectedTelegramChatIdProvider.notifier).state = id;
            },
          );
        },
      ),
    );
  });
  ref.onDispose(sub.cancel);
});

/// Chat folder filter (Telegram Desktop-style sidebar).
enum TelegramFolderFilter { all, personal, groups, channels }

final telegramFolderFilterProvider =
    StateProvider<TelegramFolderFilter>((ref) => TelegramFolderFilter.all);

final telegramChatSearchProvider = StateProvider<String>((ref) => '');
