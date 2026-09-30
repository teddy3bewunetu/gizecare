import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import 'package:gizecare/core/browser/app_link_opener.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/core/widgets/linkable_text.dart';
import 'package:gizecare/features/slack/domain/entities/slack_entities.dart';
import 'package:gizecare/features/slack/domain/slack_config.dart';
import 'package:gizecare/features/slack/presentation/providers/slack_live_sync.dart';
import 'package:gizecare/features/slack/presentation/providers/slack_providers.dart';

/// Slack workspace — conversation list + thread (user OAuth).
class SlackPage extends ConsumerStatefulWidget {
  const SlackPage({super.key});

  @override
  ConsumerState<SlackPage> createState() => _SlackPageState();
}

class _SlackPageState extends ConsumerState<SlackPage> {
  final _composer = TextEditingController();
  final _threadComposer = TextEditingController();
  var _busy = false;
  var _liveStarted = false;

  @override
  void dispose() {
    _composer.dispose();
    _threadComposer.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    try {
      ref.read(slackLiveSyncControllerProvider.notifier).stop();
      _liveStarted = false;
    } catch (_) {}
    super.deactivate();
  }

  void _ensureLive(bool connected) {
    final live = ref.read(slackLiveSyncControllerProvider.notifier);
    if (connected && !_liveStarted) {
      _liveStarted = true;
      live.start(
        conversationId: ref.read(selectedSlackConversationIdProvider),
      );
    } else if (!connected && _liveStarted) {
      _liveStarted = false;
      live.stop();
    }
  }

  Future<void> _connect() async {
    setState(() => _busy = true);
    final result = await ref.read(slackRepositoryProvider).connect();
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Slack connected');
        _ensureLive(true);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _disconnect() async {
    setState(() => _busy = true);
    ref.read(slackLiveSyncControllerProvider.notifier).stop();
    _liveStarted = false;
    final result = await ref.read(slackRepositoryProvider).disconnect();
    if (!mounted) return;
    setState(() => _busy = false);
    ref.read(selectedSlackConversationIdProvider.notifier).state = null;
    ref.read(selectedSlackThreadTsProvider.notifier).state = null;
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Slack disconnected'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _refresh() async {
    setState(() => _busy = true);
    final result = await ref.read(slackRepositoryProvider).syncConversations();
    final selected = ref.read(selectedSlackConversationIdProvider);
    if (selected != null) {
      await ref.read(slackRepositoryProvider).syncMessages(selected);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Slack synced'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _openConversation(SlackConversation conversation) async {
    ref.read(selectedSlackConversationIdProvider.notifier).state =
        conversation.conversationId;
    ref.read(selectedSlackThreadTsProvider.notifier).state = null;
    ref
        .read(slackLiveSyncControllerProvider.notifier)
        .setConversation(conversation.conversationId);
    await ref
        .read(slackRepositoryProvider)
        .syncMessages(conversation.conversationId);
    await ref
        .read(slackRepositoryProvider)
        .markRead(conversation.conversationId);
  }

  Future<void> _send(String conversationId, {String? threadTs}) async {
    final ctrl = threadTs == null ? _composer : _threadComposer;
    final text = ctrl.text;
    if (text.trim().isEmpty) return;
    ctrl.clear();
    final result = await ref.read(slackRepositoryProvider).sendMessage(
          conversationId: conversationId,
          text: text,
          threadTs: threadTs,
        );
    if (!mounted) return;
    result.when(
      onSuccess: (_) {},
      onFailure: (f) {
        ctrl.text = text;
        AppSnackBar.show(context, f.message);
      },
    );
  }

  Future<void> _attach(String conversationId, {String? threadTs}) async {
    final file = await openFile();
    if (file == null) return;
    setState(() => _busy = true);
    final result = await ref.read(slackRepositoryProvider).sendFile(
          conversationId: conversationId,
          filePath: file.path,
          threadTs: threadTs,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'File sent'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accountAsync = ref.watch(slackAccountProvider);
    final conversationsAsync = ref.watch(slackConversationsProvider);
    final selectedId = ref.watch(selectedSlackConversationIdProvider);
    final threadTs = ref.watch(selectedSlackThreadTsProvider);
    final isLive = ref.watch(slackLiveSyncControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listColor =
        isDark ? const Color(0xFF1F1F1F) : scheme.surfaceContainerLow;
    final threadColor = isDark ? const Color(0xFF141414) : scheme.surface;

    final connected = accountAsync.valueOrNull != null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ensureLive(connected);
    });

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
                  'Slack',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 12),
                accountAsync.when(
                  data: (account) => account == null
                      ? const SizedBox.shrink()
                      : Text(
                          '${account.teamName}'
                          '${account.displayName != null ? ' · ${account.displayName}' : ''}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                if (connected && isLive) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Live',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                if (_busy)
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                if (connected) ...[
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: _busy ? null : _refresh,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  TextButton(
                    onPressed: _busy ? null : _disconnect,
                    child: const Text('Disconnect'),
                  ),
                ] else
                  FilledButton.icon(
                    onPressed: SlackConfig.hasCredentials &&
                            AppPlatform.isLinux &&
                            !_busy
                        ? _connect
                        : null,
                    icon: const Icon(Icons.tag_outlined),
                    label: const Text('Connect Slack'),
                  ),
              ],
            ),
          ),
          if (!SlackConfig.hasCredentials)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Add SLACK_CLIENT_ID / SLACK_CLIENT_SECRET to .env. '
                'See docs/slack_setup.md',
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
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tag_outlined,
                            size: 56,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Connect your Slack workspace',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in with your Slack user account to browse '
                            'channels and DMs inside GizeCare.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: ColoredBox(
                        color: listColor,
                        child: conversationsAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('$e')),
                          data: (conversations) {
                            if (conversations.isEmpty) {
                              return const Center(
                                child: Text('No conversations yet'),
                              );
                            }
                            return ListView.builder(
                              itemCount: conversations.length,
                              itemBuilder: (context, i) {
                                final c = conversations[i];
                                final selected =
                                    c.conversationId == selectedId;
                                return ListTile(
                                  selected: selected,
                                  leading: Icon(
                                    switch (c.conversationType) {
                                      SlackConversationType.im =>
                                        Icons.person_outline,
                                      SlackConversationType.mpim =>
                                        Icons.groups_outlined,
                                      _ => Icons.tag,
                                    },
                                    size: 20,
                                  ),
                                  title: Text(
                                    c.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: c.unreadCount > 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.brand,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${c.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      : null,
                                  onTap: () => _openConversation(c),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: scheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: threadColor,
                        child: selectedId == null
                            ? Center(
                                child: Text(
                                  'Select a conversation',
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _ChannelPane(
                                      conversationId: selectedId,
                                      composer: _composer,
                                      onSend: () => _send(selectedId),
                                      onAttach: () => _attach(selectedId),
                                      onOpenThread: (ts) async {
                                        ref
                                            .read(
                                              selectedSlackThreadTsProvider
                                                  .notifier,
                                            )
                                            .state = ts;
                                        await ref
                                            .read(slackRepositoryProvider)
                                            .syncThreadReplies(
                                              conversationId: selectedId,
                                              threadTs: ts,
                                            );
                                      },
                                    ),
                                  ),
                                  if (threadTs != null) ...[
                                    VerticalDivider(
                                      width: 1,
                                      color: scheme.outlineVariant
                                          .withValues(alpha: 0.4),
                                    ),
                                    SizedBox(
                                      width: 320,
                                      child: _ThreadSidePanel(
                                        conversationId: selectedId,
                                        threadTs: threadTs,
                                        composer: _threadComposer,
                                        onClose: () => ref
                                            .read(
                                              selectedSlackThreadTsProvider
                                                  .notifier,
                                            )
                                            .state = null,
                                        onSend: () => _send(
                                          selectedId,
                                          threadTs: threadTs,
                                        ),
                                        onAttach: () => _attach(
                                          selectedId,
                                          threadTs: threadTs,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelPane extends ConsumerWidget {
  const _ChannelPane({
    required this.conversationId,
    required this.composer,
    required this.onSend,
    required this.onAttach,
    required this.onOpenThread,
  });

  final String conversationId;
  final TextEditingController composer;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final ValueChanged<String> onOpenThread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(slackMessagesProvider(conversationId));
    final scheme = Theme.of(context).colorScheme;
    final conversations =
        ref.watch(slackConversationsProvider).valueOrNull ?? const [];
    String? title;
    for (final c in conversations) {
      if (c.conversationId == conversationId) {
        title = c.name;
        break;
      }
    }

    return Column(
      children: [
        _PaneHeader(title: title ?? conversationId),
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (messages) {
              final parents = messages.where((m) => m.isParent).toList();
              if (parents.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: parents.length,
                itemBuilder: (context, i) {
                  final msg = parents[i];
                  return _MessageBubble(
                    message: msg,
                    conversationId: conversationId,
                    onOpenThread: () => onOpenThread(msg.messageTs),
                  );
                },
              );
            },
          ),
        ),
        _ComposerBar(
          controller: composer,
          hint: 'Message…',
          onSend: onSend,
          onAttach: onAttach,
        ),
      ],
    );
  }
}

class _ThreadSidePanel extends ConsumerWidget {
  const _ThreadSidePanel({
    required this.conversationId,
    required this.threadTs,
    required this.composer,
    required this.onClose,
    required this.onSend,
    required this.onAttach,
  });

  final String conversationId;
  final String threadTs;
  final TextEditingController composer;
  final VoidCallback onClose;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(slackMessagesProvider(conversationId));
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Thread',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (messages) {
              final thread = messages
                  .where(
                    (m) =>
                        m.messageTs == threadTs || m.threadTs == threadTs,
                  )
                  .toList();
              if (thread.isEmpty) {
                return const Center(child: Text('Loading thread…'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: thread.length,
                itemBuilder: (context, i) {
                  return _MessageBubble(
                    message: thread[i],
                    conversationId: conversationId,
                    compact: true,
                  );
                },
              );
            },
          ),
        ),
        _ComposerBar(
          controller: composer,
          hint: 'Reply in thread…',
          onSend: onSend,
          onAttach: onAttach,
        ),
      ],
    );
  }
}

class _PaneHeader extends StatelessWidget {
  const _PaneHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.hint,
    required this.onSend,
    required this.onAttach,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Attach file',
            onPressed: onAttach,
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: onSend,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({
    required this.message,
    required this.conversationId,
    this.onOpenThread,
    this.compact = false,
  });

  final SlackMessage message;
  final String conversationId;
  final VoidCallback? onOpenThread;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final timeFmt = DateFormat.jm();
    final align =
        message.isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubble = message.isOutgoing
        ? AppColors.brand.withValues(alpha: 0.25)
        : scheme.surfaceContainerHighest;

    Future<void> showActions(Offset globalPos) async {
      final selected = await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(
          globalPos.dx,
          globalPos.dy,
          globalPos.dx,
          globalPos.dy,
        ),
        items: [
          if (message.isOutgoing)
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
          const PopupMenuItem(value: 'copy', child: Text('Copy')),
          if (onOpenThread != null)
            const PopupMenuItem(value: 'thread', child: Text('Reply in thread')),
          const PopupMenuItem(value: 'react', child: Text('Add reaction')),
        ],
      );
      if (selected == null || !context.mounted) return;
      switch (selected) {
        case 'copy':
          await Clipboard.setData(ClipboardData(text: message.text));
          if (context.mounted) AppSnackBar.show(context, 'Copied');
        case 'thread':
          onOpenThread?.call();
        case 'react':
          await _pickReaction(context, ref);
        case 'edit':
          await _edit(context, ref);
        case 'delete':
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete message?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (ok == true) {
            final result = await ref.read(slackRepositoryProvider).deleteMessage(
                  conversationId: conversationId,
                  messageTs: message.messageTs,
                );
            if (context.mounted) {
              result.when(
                onSuccess: (_) {},
                onFailure: (f) => AppSnackBar.show(context, f.message),
              );
            }
          }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (!message.isOutgoing && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 4),
              child: Text(
                message.senderName!,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          GestureDetector(
            onSecondaryTapDown: (d) => showActions(d.globalPosition),
            onLongPressStart: (d) => showActions(d.globalPosition),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width *
                    (compact ? 0.28 : 0.42),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bubble,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.text.isNotEmpty) LinkableText(message.text),
                      if (message.files.isNotEmpty) ...[
                        if (message.text.isNotEmpty) const SizedBox(height: 6),
                        for (final file in message.files)
                          _FileChip(
                            file: file,
                            onOpen: () => _openFile(context, ref, file),
                          ),
                      ],
                      if (message.reactions.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (final r in message.reactions)
                              ActionChip(
                                visualDensity: VisualDensity.compact,
                                label: Text(':${r.name}: ${r.count}'),
                                backgroundColor: r.isMine
                                    ? AppColors.brand.withValues(alpha: 0.2)
                                    : null,
                                onPressed: () async {
                                  final repo =
                                      ref.read(slackRepositoryProvider);
                                  final result = r.isMine
                                      ? await repo.removeReaction(
                                          conversationId: conversationId,
                                          messageTs: message.messageTs,
                                          emojiName: r.name,
                                        )
                                      : await repo.addReaction(
                                          conversationId: conversationId,
                                          messageTs: message.messageTs,
                                          emojiName: r.name,
                                        );
                                  if (context.mounted) {
                                    result.when(
                                      onSuccess: (_) {},
                                      onFailure: (f) =>
                                          AppSnackBar.show(context, f.message),
                                    );
                                  }
                                },
                              ),
                            ActionChip(
                              visualDensity: VisualDensity.compact,
                              label: const Text('+'),
                              onPressed: () => _pickReaction(context, ref),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeFmt.format(message.sentAt.toLocal()),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          if (message.isEdited) ...[
                            const SizedBox(width: 6),
                            Text(
                              'edited',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onOpenThread != null && message.replyCount > 0)
            TextButton.icon(
              onPressed: onOpenThread,
              icon: const Icon(Icons.forum_outlined, size: 16),
              label: Text(
                message.replyCount == 1
                    ? '1 reply'
                    : '${message.replyCount} replies',
              ),
            )
          else if (onOpenThread != null)
            TextButton(
              onPressed: onOpenThread,
              child: const Text('Reply in thread'),
            ),
        ],
      ),
    );
  }

  Future<void> _pickReaction(BuildContext context, WidgetRef ref) async {
    final name = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            for (final emoji in slackQuickReactions)
              ListTile(
                title: Text(':$emoji:'),
                onTap: () => Navigator.pop(ctx, emoji),
              ),
          ],
        ),
      ),
    );
    if (name == null) return;
    final result = await ref.read(slackRepositoryProvider).addReaction(
          conversationId: conversationId,
          messageTs: message.messageTs,
          emojiName: name,
        );
    if (context.mounted) {
      result.when(
        onSuccess: (_) {},
        onFailure: (f) => AppSnackBar.show(context, f.message),
      );
    }
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: message.text);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    final text = ctrl.text;
    ctrl.dispose();
    if (saved != true) return;
    final result = await ref.read(slackRepositoryProvider).editMessage(
          conversationId: conversationId,
          messageTs: message.messageTs,
          text: text,
        );
    if (context.mounted) {
      result.when(
        onSuccess: (_) {},
        onFailure: (f) => AppSnackBar.show(context, f.message),
      );
    }
  }

  Future<void> _openFile(
    BuildContext context,
    WidgetRef ref,
    SlackFileRef file,
  ) async {
    final result = await ref.read(slackRepositoryProvider).downloadFile(file);
    if (!context.mounted) return;
    if (result.isFailure) {
      AppSnackBar.show(context, result.requireFailure.message);
      final url = file.urlPrivate;
      if (url != null) {
        await AppLinkOpener.open(context, url, title: file.name ?? 'File');
      }
      return;
    }
    final path = result.requireValue;
    if (file.isImage && File(path).existsSync()) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => Dialog(
          child: InteractiveViewer(
            child: Image.file(File(path)),
          ),
        ),
      );
    } else {
      await OpenFilex.open(path);
    }
  }
}

class _FileChip extends StatelessWidget {
  const _FileChip({required this.file, required this.onOpen});

  final SlackFileRef file;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onOpen,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              file.isImage ? Icons.image_outlined : Icons.insert_drive_file_outlined,
              size: 16,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
