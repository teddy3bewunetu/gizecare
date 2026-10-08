import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/core/widgets/linkable_text.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';
import 'package:gizecare/features/gmail/domain/entities/gmail_entities.dart';
import 'package:gizecare/features/gmail/presentation/providers/gmail_providers.dart';
import 'package:gizecare/features/gmail/presentation/widgets/gmail_compose_dialog.dart';
import 'package:gizecare/features/gmail/presentation/widgets/gmail_html_body.dart';

/// Gmail inbox — list + thread, shared Google OAuth with Calendar.
class GmailPage extends ConsumerWidget {
  const GmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final accountAsync = ref.watch(gmailAccountProvider);
    final threadsAsync = ref.watch(gmailThreadsProvider);
    final selectedId = ref.watch(selectedGmailThreadIdProvider);
    final search = ref.watch(gmailThreadSearchProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listColor =
        isDark ? const Color(0xFF1F1F1F) : scheme.surfaceContainerLow;
    final threadColor = isDark ? const Color(0xFF141414) : scheme.surface;

    return ColoredBox(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Gmail',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 12),
                accountAsync.when(
                  data: (account) => account == null
                      ? const SizedBox.shrink()
                      : Text(
                          account.email,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const Spacer(),
                if (accountAsync.valueOrNull != null) ...[
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: () => _sync(context, ref),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => _compose(context, ref),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Compose'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _disconnect(context, ref),
                    child: const Text('Disconnect'),
                  ),
                ] else
                  FilledButton.icon(
                    onPressed: GoogleCalendarConfig.hasCredentials &&
                            AppPlatform.isLinux
                        ? () => _connect(context, ref)
                        : null,
                    icon: const Icon(Icons.mail_outline_rounded),
                    label: const Text('Connect Gmail'),
                  ),
              ],
            ),
          ),
          if (!GoogleCalendarConfig.hasCredentials)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Google sign-in is not configured in this build. '
                'Developers: set GOOGLE_CALENDAR_CLIENT_ID / SECRET (.env or CI secrets). '
                'See docs/gmail_setup.md / docs/snap_setup.md',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                    ),
              ),
            ),
          Expanded(
            child: accountAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (account) {
                if (account == null) {
                  return _EmptyConnect(
                    onConnect: GoogleCalendarConfig.hasCredentials &&
                            AppPlatform.isLinux
                        ? () => _connect(context, ref)
                        : null,
                  );
                }
                return threadsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (threads) {
                    final q = search.trim().toLowerCase();
                    final filtered = q.isEmpty
                        ? threads
                        : threads
                            .where(
                              (t) =>
                                  t.subject.toLowerCase().contains(q) ||
                                  t.snippet.toLowerCase().contains(q) ||
                                  t.fromDisplay.toLowerCase().contains(q),
                            )
                            .toList();
                    final selected = selectedId == null
                        ? null
                        : filtered
                            .where((t) => t.gmailThreadId == selectedId)
                            .firstOrNull;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 360,
                          child: ColoredBox(
                            color: listColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    8,
                                    12,
                                    8,
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search mail',
                                      prefixIcon: const Icon(Icons.search),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      ref
                                          .read(
                                            gmailThreadSearchProvider.notifier,
                                          )
                                          .state = v;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: filtered.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Inbox empty',
                                            style: TextStyle(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: filtered.length,
                                          itemBuilder: (context, i) {
                                            final t = filtered[i];
                                            final sel = t.gmailThreadId ==
                                                selectedId;
                                            return _ThreadTile(
                                              thread: t,
                                              selected: sel,
                                              onTap: () =>
                                                  _openThread(context, ref, t),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 1,
                          color: scheme.outlineVariant.withValues(alpha: 0.35),
                        ),
                        Expanded(
                          child: ColoredBox(
                            color: threadColor,
                            child: selected == null
                                ? const _ThreadPlaceholder()
                                : _ThreadView(thread: selected),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    AppSnackBar.show(context, 'Opening Google sign-in…');
    final result = await ref.read(gmailRepositoryProvider).connect();
    if (!context.mounted) return;
    result.when(
      onSuccess: (a) => AppSnackBar.show(context, 'Connected as ${a.email}'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _disconnect(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(gmailRepositoryProvider).disconnect();
    if (!context.mounted) return;
    ref.read(selectedGmailThreadIdProvider.notifier).state = null;
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Gmail disconnected'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(gmailRepositoryProvider).syncInbox();
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Inbox updated'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _openThread(
    BuildContext context,
    WidgetRef ref,
    GmailThread thread,
  ) async {
    ref.read(selectedGmailThreadIdProvider.notifier).state =
        thread.gmailThreadId;
    final result =
        await ref.read(gmailRepositoryProvider).openThread(thread.gmailThreadId);
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {},
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    final sent = await showGmailComposeDialog(context);
    if (sent == true && context.mounted) {
      AppSnackBar.show(context, 'Message sent');
    }
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.selected,
    required this.onTap,
  });

  final GmailThread thread;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final time = _shortTime(thread.date.toLocal());
    return Material(
      color: selected
          ? AppColors.brand.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (thread.isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.brand,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      thread.fromDisplay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: thread.isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                    ),
                  ),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                thread.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          thread.isUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                thread.snippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _shortTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    if (day == today) return DateFormat.jm().format(dt);
    if (today.difference(day).inDays < 7) return DateFormat.E().format(dt);
    return DateFormat.MMMd().format(dt);
  }
}

class _ThreadPlaceholder extends StatelessWidget {
  const _ThreadPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select a conversation',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _ThreadView extends ConsumerWidget {
  const _ThreadView({required this.thread});

  final GmailThread thread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync =
        ref.watch(gmailThreadMessagesProvider(thread.gmailThreadId));
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  thread.subject,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                ),
              ),
              IconButton(
                tooltip: 'Reply',
                onPressed: () => _reply(context, ref),
                icon: const Icon(Icons.reply_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(child: Text('Loading messages…'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final m = messages[i];
                  return _MessageCard(message: m);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _reply(BuildContext context, WidgetRef ref) async {
    final messages =
        ref.read(gmailThreadMessagesProvider(thread.gmailThreadId)).valueOrNull;
    final last = messages?.isNotEmpty == true ? messages!.last : null;
    final to = last?.fromEmail ?? thread.fromEmail ?? '';
    final sent = await showGmailComposeDialog(
      context,
      initialTo: to,
      initialSubject: thread.subject.startsWith('Re:')
          ? thread.subject
          : 'Re: ${thread.subject}',
      replyToThreadId: thread.gmailThreadId,
      inReplyToMessageId: last?.gmailMessageId,
    );
    if (sent == true && context.mounted) {
      AppSnackBar.show(context, 'Reply sent');
    }
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final GmailMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final when = DateFormat('EEE, MMM d, h:mm a').format(message.date.toLocal());
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.brand.withValues(alpha: 0.2),
                    child: Text(
                      message.fromDisplay.isEmpty
                          ? '?'
                          : message.fromDisplay.characters.first.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                message.fromDisplay,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Text(
                              when,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        if (message.toEmails.isNotEmpty)
                          Text(
                            'to ${message.toEmails}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (message.hasHtml)
                GmailHtmlBody(
                  html: message.bodyHtml!,
                  plainFallback: message.bodyText,
                )
              else
                LinkableText(
                  message.bodyText.trim().isEmpty
                      ? '(no text content)'
                      : message.bodyText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontSize: 14.5,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyConnect extends StatelessWidget {
  const _EmptyConnect({this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Read and send Gmail from ጊዜCare',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Uses the same Google sign-in as Calendar. Enable Gmail API and reconnect if you already linked Calendar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onConnect,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Connect Gmail'),
            ),
          ],
        ),
      ),
    );
  }
}
