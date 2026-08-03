import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:gizecare/features/gmail/data/repositories/drift_gmail_repository.dart';
import 'package:gizecare/features/gmail/domain/entities/gmail_entities.dart';
import 'package:gizecare/features/gmail/domain/repositories/gmail_repository.dart';

final gmailRepositoryProvider = Provider<GmailRepository>((ref) {
  return DriftGmailRepository(
    db: ref.watch(appDatabaseProvider),
    auth: ref.watch(googleCalendarAuthServiceProvider),
  );
});

final gmailAccountProvider = StreamProvider<GmailAccount?>((ref) {
  return ref.watch(gmailRepositoryProvider).watchAccount();
});

final gmailThreadsProvider = StreamProvider<List<GmailThread>>((ref) {
  return ref.watch(gmailRepositoryProvider).watchThreads();
});

final gmailUnreadTotalProvider = Provider<int>((ref) {
  final threads = ref.watch(gmailThreadsProvider).valueOrNull;
  if (threads == null) return 0;
  return threads.where((t) => t.isUnread).length;
});

final selectedGmailThreadIdProvider = StateProvider<String?>((ref) => null);

final gmailThreadSearchProvider = StateProvider<String>((ref) => '');

final gmailThreadMessagesProvider =
    StreamProvider.family<List<GmailMessage>, String>((ref, threadId) {
  return ref.watch(gmailRepositoryProvider).watchThreadMessages(threadId);
});
