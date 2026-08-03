import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/telegram_config.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_chat_picker.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_composer.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_connect_dialog.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_message_actions.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_profile_dialog.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_voice_bubble.dart';

/// Telegram inbox — Desktop-style folders + chat list + thread.
class TelegramPage extends ConsumerStatefulWidget {
  const TelegramPage({super.key});

  @override
  ConsumerState<TelegramPage> createState() => _TelegramPageState();
}

class _TelegramPageState extends ConsumerState<TelegramPage> {
  var _resuming = false;
  var _didAttemptResume = false;
  String? _sessionHint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resumeSession());
  }

  Future<void> _resumeSession() async {
    if (_resuming) return;
    final account = ref.read(telegramAccountProvider).valueOrNull;
    if (account == null) return;
    if (ref.read(tdjsonClientProvider).isReady) {
      setState(() => _sessionHint = null);
      return;
    }
    _didAttemptResume = true;
    setState(() {
      _resuming = true;
      _sessionHint = null;
    });
    final result = await ref.read(telegramRepositoryProvider).resumeSession();
    if (!mounted) return;
    setState(() => _resuming = false);
    result.when(
      onSuccess: (_) => setState(() => _sessionHint = null),
      onFailure: (f) {
        setState(() {
          _sessionHint =
              'Saved chats are visible offline, but Telegram needs a live '
              'session. Tap Connect to sign in again.';
        });
      },
    );
  }

  Future<void> _connect() async {
    if (!AppPlatform.isLinux) {
      AppSnackBar.show(context, 'Telegram connect is available on Linux only');
      return;
    }
    if (!TelegramConfig.hasCredentials) {
      AppSnackBar.show(
        context,
        'Set TELEGRAM_API_ID / HASH (see docs/telegram_setup.md)',
      );
      return;
    }
    final ok = await showTelegramConnectDialog(context, ref);
    if (!ok || !mounted) return;
    final sync = await ref.read(telegramRepositoryProvider).syncChats();
    if (!mounted) return;
    sync.when(
      onSuccess: (_) => showTelegramChatPicker(context, ref),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _disconnect() async {
    final result = await ref.read(telegramRepositoryProvider).disconnect();
    if (!mounted) return;
    result.when(
      onSuccess: (_) {
        ref.read(selectedTelegramChatIdProvider.notifier).state = null;
        AppSnackBar.show(context, 'Telegram disconnected');
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _syncAndPick() async {
    final result = await ref.read(telegramRepositoryProvider).syncChats();
    if (!mounted) return;
    result.when(
      onSuccess: (_) => showTelegramChatPicker(context, ref),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _openChat(TelegramChat chat) async {
    ref.read(selectedTelegramChatIdProvider.notifier).state =
        chat.telegramChatId;
    if (!ref.read(tdjsonClientProvider).isReady) {
      await _resumeSession();
      if (!mounted || !ref.read(tdjsonClientProvider).isReady) return;
    }
    unawaited(ref.read(telegramRepositoryProvider).markChatRead(chat.telegramChatId));
    final result = await ref
        .read(telegramRepositoryProvider)
        .syncMessages(chat.telegramChatId);
    if (!mounted) return;
    result.when(
      onSuccess: (_) {},
      onFailure: (f) {
        if (f.message.contains('session expired') ||
            f.message.contains('Connect')) {
          setState(() {
            _sessionHint =
                'Saved chats are visible offline, but Telegram needs a live '
                'session. Tap Connect to sign in again.';
          });
          return;
        }
        AppSnackBar.show(context, f.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final account = ref.watch(telegramAccountProvider).valueOrNull;
    final chatsAsync = ref.watch(telegramChatsProvider(true));
    final selectedId = ref.watch(selectedTelegramChatIdProvider);
    final folder = ref.watch(telegramFolderFilterProvider);
    final search = ref.watch(telegramChatSearchProvider);

    ref.listen(telegramAccountProvider, (prev, next) {
      if (_didAttemptResume || _resuming) return;
      if (next.valueOrNull != null) {
        _resumeSession();
      }
    });

    final railColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFE8EEF4);
    final listColor = isDark ? const Color(0xFF171717) : const Color(0xFFF3F6F9);
    final threadColor = isDark ? const Color(0xFF0B0B0B) : scheme.surface;

    if (account == null) {
      return ColoredBox(
        color: scheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              account: null,
              onConnect: _connect,
              onDisconnect: _disconnect,
              onChooseChats: _syncAndPick,
            ),
            Expanded(child: _EmptyConnect(onConnect: _connect)),
          ],
        ),
      );
    }

    return ColoredBox(
      color: threadColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(
            account: account,
            onConnect: _connect,
            onDisconnect: _disconnect,
            onChooseChats: _syncAndPick,
          ),
          if (_resuming)
            const LinearProgressIndicator(minHeight: 2),
          if (_sessionHint != null)
            Material(
              color: AppColors.warning.withValues(alpha: 0.18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _sessionHint!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _connect,
                      child: const Text('Connect'),
                    ),
                    IconButton(
                      tooltip: 'Dismiss',
                      onPressed: () => setState(() => _sessionHint = null),
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: chatsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (allChats) {
                final counts = _folderCounts(allChats);
                final filtered = _filterChats(allChats, folder, search);
                final selected = allChats
                    .where((c) => c.telegramChatId == selectedId)
                    .firstOrNull;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FolderRail(
                      color: railColor,
                      selected: folder,
                      counts: counts,
                      onSelect: (f) {
                        ref.read(telegramFolderFilterProvider.notifier).state =
                            f;
                      },
                    ),
                    SizedBox(
                      width: 320,
                      child: ColoredBox(
                        color: listColor,
                        child: _ChatListPane(
                          chats: filtered,
                          selectedId: selectedId,
                          search: search,
                          onSearch: (q) {
                            ref.read(telegramChatSearchProvider.notifier).state =
                                q;
                          },
                          onOpen: _openChat,
                          onChooseChats: _syncAndPick,
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
                        child: selectedId == null || selected == null
                            ? const _ThreadPlaceholder()
                            : _ChatThreadPane(chat: selected),
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

  Map<TelegramFolderFilter, int> _folderCounts(List<TelegramChat> chats) {
    var personal = 0;
    var groups = 0;
    var channels = 0;
    var unreadAll = 0;
    for (final c in chats) {
      unreadAll += c.unreadCount;
      switch (c.chatType) {
        case TelegramChatType.private:
        case TelegramChatType.secret:
          personal += c.unreadCount;
        case TelegramChatType.group:
          groups += c.unreadCount;
        case TelegramChatType.channel:
          channels += c.unreadCount;
        case TelegramChatType.unknown:
          break;
      }
    }
    return {
      TelegramFolderFilter.all: unreadAll,
      TelegramFolderFilter.personal: personal,
      TelegramFolderFilter.groups: groups,
      TelegramFolderFilter.channels: channels,
    };
  }

  List<TelegramChat> _filterChats(
    List<TelegramChat> chats,
    TelegramFolderFilter folder,
    String search,
  ) {
    Iterable<TelegramChat> out = chats;
    out = switch (folder) {
      TelegramFolderFilter.all => out,
      TelegramFolderFilter.personal => out.where(
          (c) =>
              c.chatType == TelegramChatType.private ||
              c.chatType == TelegramChatType.secret,
        ),
      TelegramFolderFilter.groups =>
        out.where((c) => c.chatType == TelegramChatType.group),
      TelegramFolderFilter.channels =>
        out.where((c) => c.chatType == TelegramChatType.channel),
    };
    final q = search.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out.where((c) => c.title.toLowerCase().contains(q));
    }
    final list = out.toList()
      ..sort((a, b) {
        final at = a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bt.compareTo(at);
      });
    return list;
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.account,
    required this.onConnect,
    required this.onDisconnect,
    required this.onChooseChats,
  });

  final TelegramAccount? account;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onChooseChats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Row(
        children: [
          Text(
            'Telegram',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (account != null) ...[
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                [
                  if (account!.displayName != null) account!.displayName!,
                  if (account!.username != null) '@${account!.username}',
                ].where((e) => e.trim().isNotEmpty).join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
          const Spacer(),
          if (account != null) ...[
            TextButton.icon(
              onPressed: onChooseChats,
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text('Choose chats'),
            ),
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: onDisconnect,
              child: const Text('Disconnect'),
            ),
          ] else
            FilledButton.icon(
              onPressed: onConnect,
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}

class _FolderRail extends StatelessWidget {
  const _FolderRail({
    required this.color,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  final Color color;
  final TelegramFolderFilter selected;
  final Map<TelegramFolderFilter, int> counts;
  final ValueChanged<TelegramFolderFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            const SizedBox(height: 8),
            _FolderItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'All',
              selected: selected == TelegramFolderFilter.all,
              badge: counts[TelegramFolderFilter.all] ?? 0,
              onTap: () => onSelect(TelegramFolderFilter.all),
            ),
            _FolderItem(
              icon: Icons.person_outline_rounded,
              label: 'Personal',
              selected: selected == TelegramFolderFilter.personal,
              badge: counts[TelegramFolderFilter.personal] ?? 0,
              onTap: () => onSelect(TelegramFolderFilter.personal),
            ),
            _FolderItem(
              icon: Icons.groups_outlined,
              label: 'Groups',
              selected: selected == TelegramFolderFilter.groups,
              badge: counts[TelegramFolderFilter.groups] ?? 0,
              onTap: () => onSelect(TelegramFolderFilter.groups),
            ),
            _FolderItem(
              icon: Icons.campaign_outlined,
              label: 'Channels',
              selected: selected == TelegramFolderFilter.channels,
              badge: counts[TelegramFolderFilter.channels] ?? 0,
              onTap: () => onSelect(TelegramFolderFilter.channels),
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderItem extends StatelessWidget {
  const _FolderItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        color: selected
            ? AppColors.brand.withValues(alpha: 0.22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: selected
                            ? AppColors.brand
                            : scheme.onSurfaceVariant,
                      ),
                      if (badge > 0)
                        Positioned(
                          right: -10,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brand,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(minWidth: 18),
                            child: Text(
                              badge > 99 ? '99+' : '$badge',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: selected
                              ? AppColors.brand
                              : scheme.onSurfaceVariant,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatListPane extends StatelessWidget {
  const _ChatListPane({
    required this.chats,
    required this.selectedId,
    required this.search,
    required this.onSearch,
    required this.onOpen,
    required this.onChooseChats,
  });

  final List<TelegramChat> chats;
  final String? selectedId;
  final String search;
  final ValueChanged<String> onSearch;
  final ValueChanged<TelegramChat> onOpen;
  final VoidCallback onChooseChats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchFill = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              filled: true,
              fillColor: searchFill,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: chats.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          search.trim().isEmpty
                              ? 'No chats in this folder'
                              : 'No matches',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (search.trim().isEmpty) ...[
                          const SizedBox(height: 12),
                          FilledButton.tonal(
                            onPressed: onChooseChats,
                            child: const Text('Choose chats'),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final selected = chat.telegramChatId == selectedId;
                    return _ChatTile(
                      chat: chat,
                      selected: selected,
                      onTap: () => onOpen(chat),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({
    required this.chat,
    required this.selected,
    required this.onTap,
  });

  final TelegramChat chat;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final time = chat.lastMessageAt == null
        ? ''
        : _formatChatTime(chat.lastMessageAt!.toLocal());
    final initial = chat.title.trim().isEmpty
        ? '?'
        : chat.title.trim().characters.first.toUpperCase();

    return Material(
      color: selected
          ? AppColors.brand.withValues(alpha: 0.16)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _avatarColor(chat.title),
                backgroundImage: chat.photoPath != null &&
                        File(chat.photoPath!).existsSync()
                    ? FileImage(File(chat.photoPath!))
                    : null,
                child: chat.photoPath != null &&
                        File(chat.photoPath!).existsSync()
                    ? null
                    : Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                            chat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _subtitleFor(chat),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brand,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat.unreadCount > 99
                                  ? '99+'
                                  : '${chat.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitleFor(TelegramChat chat) {
    return switch (chat.chatType) {
      TelegramChatType.private => 'Personal chat',
      TelegramChatType.group => 'Group',
      TelegramChatType.channel => 'Channel',
      TelegramChatType.secret => 'Secret chat',
      TelegramChatType.unknown => 'Chat',
    };
  }

  Color _avatarColor(String seed) {
    final palette = AppColors.projectPalette;
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return palette[hash % palette.length];
  }

  String _formatChatTime(DateTime dt) {
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
        'Select a chat to start messaging',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _ChatThreadPane extends ConsumerStatefulWidget {
  const _ChatThreadPane({required this.chat});

  final TelegramChat chat;

  @override
  ConsumerState<_ChatThreadPane> createState() => _ChatThreadPaneState();
}

class _ChatThreadPaneState extends ConsumerState<_ChatThreadPane> {
  TelegramMessage? _replyTo;
  TelegramMessage? _editing;
  final _listController = ScrollController();
  String? _highlightMessageId;
  String? _statusText;
  var _profileLoading = false;
  var _searchOpen = false;
  final _searchController = TextEditingController();
  List<TelegramMessage> _searchHits = const [];
  var _searchBusy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadStatus());
  }

  @override
  void didUpdateWidget(covariant _ChatThreadPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chat.telegramChatId != widget.chat.telegramChatId) {
      _statusText = null;
      _searchOpen = false;
      _searchController.clear();
      _searchHits = const [];
      unawaited(_loadStatus());
    }
  }

  Future<void> _loadStatus() async {
    final result = await ref
        .read(telegramRepositoryProvider)
        .getChatProfile(widget.chat.telegramChatId);
    if (!mounted) return;
    result.when(
      onSuccess: (p) => setState(() => _statusText = p.statusText),
      onFailure: (_) {},
    );
  }

  Future<void> _openProfile() async {
    await showTelegramProfileDialog(
      context,
      telegramChatId: widget.chat.telegramChatId,
    );
    if (mounted) unawaited(_loadStatus());
  }

  Future<void> _startCall() async {
    if (_profileLoading) return;
    setState(() => _profileLoading = true);
    final result = await ref
        .read(telegramRepositoryProvider)
        .startCall(widget.chat.telegramChatId);
    if (!mounted) return;
    setState(() => _profileLoading = false);
    result.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Opening call…'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchController.clear();
        _searchHits = const [];
      }
    });
  }

  Future<void> _runSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() => _searchHits = const []);
      return;
    }
    setState(() => _searchBusy = true);
    final result = await ref.read(telegramRepositoryProvider).searchMessages(
          telegramChatId: widget.chat.telegramChatId,
          query: q,
        );
    if (!mounted) return;
    setState(() => _searchBusy = false);
    result.when(
      onSuccess: (hits) => setState(() => _searchHits = hits),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _sendText(String text) async {
    final chat = widget.chat;
    if (_editing != null) {
      final result = await ref.read(telegramRepositoryProvider).editMessage(
            telegramChatId: chat.telegramChatId,
            telegramMessageId: _editing!.telegramMessageId,
            text: text,
          );
      if (!mounted) return;
      result.when(
        onSuccess: (_) {
          setState(() => _editing = null);
          ref.invalidate(telegramMessagesProvider(chat.telegramChatId));
        },
        onFailure: (f) => AppSnackBar.show(context, f.message),
      );
      return;
    }

    final result = await ref.read(telegramRepositoryProvider).sendMessage(
          telegramChatId: chat.telegramChatId,
          text: text,
          replyToMessageId: _replyTo?.telegramMessageId,
        );
    if (!mounted) return;
    result.when(
      onSuccess: (_) {
        setState(() => _replyTo = null);
        ref.invalidate(telegramMessagesProvider(chat.telegramChatId));
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _onMessageAction(
    TelegramMessage message,
    Offset globalPosition,
  ) async {
    final action = await showTelegramMessageActions(
      context,
      message: message,
      globalPosition: globalPosition,
    );
    if (action == null || !mounted) return;
    switch (action) {
      case TelegramMessageAction.reply:
        setState(() {
          _editing = null;
          _replyTo = message;
        });
      case TelegramMessageAction.copy:
        await copyTelegramMessage(message);
        if (mounted) AppSnackBar.show(context, 'Copied');
      case TelegramMessageAction.edit:
        setState(() {
          _replyTo = null;
          _editing = message;
        });
      case TelegramMessageAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete message?'),
            content: const Text('This removes the message for everyone when possible.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (ok != true || !mounted) return;
        final result = await ref.read(telegramRepositoryProvider).deleteMessage(
              telegramChatId: widget.chat.telegramChatId,
              telegramMessageId: message.telegramMessageId,
            );
        if (!mounted) return;
        result.when(
          onSuccess: (_) {
            ref.invalidate(
              telegramMessagesProvider(widget.chat.telegramChatId),
            );
          },
          onFailure: (f) => AppSnackBar.show(context, f.message),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final messagesAsync =
        ref.watch(telegramMessagesProvider(chat.telegramChatId));
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor =
        isDark ? const Color(0xFF1C1C1C) : scheme.surfaceContainerHigh;
    final timeFmt = DateFormat.jm();

    Future<void> sendFile(String path) async {
      final result = await ref.read(telegramRepositoryProvider).sendDocument(
            telegramChatId: chat.telegramChatId,
            filePath: path,
          );
      if (!context.mounted) return;
      result.when(
        onSuccess: (_) {
          AppSnackBar.show(context, 'File sent');
          ref.invalidate(telegramMessagesProvider(chat.telegramChatId));
        },
        onFailure: (f) => AppSnackBar.show(context, f.message),
      );
    }

    Future<void> sendVoice(String path, int seconds) async {
      final result = await ref.read(telegramRepositoryProvider).sendVoiceNote(
            telegramChatId: chat.telegramChatId,
            filePath: path,
            durationSeconds: seconds,
          );
      if (!context.mounted) return;
      result.when(
        onSuccess: (_) {
          AppSnackBar.show(context, 'Voice message sent');
          ref.invalidate(telegramMessagesProvider(chat.telegramChatId));
        },
        onFailure: (f) => AppSnackBar.show(context, f.message),
      );
    }

    void jumpToReply(String messageId) {
      final key = GlobalObjectKey('tg-msg-$messageId');
      final ctx = key.currentContext;
      if (ctx == null) {
        AppSnackBar.show(context, 'Original message not loaded');
        return;
      }
      setState(() => _highlightMessageId = messageId);
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        alignment: 0.35,
      );
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        if (mounted && _highlightMessageId == messageId) {
          setState(() => _highlightMessageId = null);
        }
      });
    }

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: headerColor,
            border: Border(
              bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: _openProfile,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.brand.withValues(alpha: 0.25),
                  backgroundImage: chat.photoPath != null &&
                          File(chat.photoPath!).existsSync()
                      ? FileImage(File(chat.photoPath!))
                      : null,
                  child: chat.photoPath != null &&
                          File(chat.photoPath!).existsSync()
                      ? null
                      : Text(
                          chat.title.trim().isEmpty
                              ? '?'
                              : chat.title
                                  .trim()
                                  .characters
                                  .first
                                  .toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _openProfile,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          _statusText ??
                              switch (chat.chatType) {
                                TelegramChatType.private => 'personal chat',
                                TelegramChatType.group => 'group',
                                TelegramChatType.channel => 'channel',
                                TelegramChatType.secret => 'secret chat',
                                TelegramChatType.unknown => 'chat',
                              },
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (chat.unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              IconButton(
                tooltip: _searchOpen ? 'Close search' : 'Search',
                onPressed: _toggleSearch,
                icon: Icon(
                  _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                ),
              ),
              if (chat.chatType == TelegramChatType.private)
                IconButton(
                  tooltip: 'Call',
                  onPressed: _profileLoading ? null : _startCall,
                  icon: _profileLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.call_outlined),
                ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () {
                  ref
                      .read(telegramRepositoryProvider)
                      .syncMessages(chat.telegramChatId);
                  ref
                      .read(telegramRepositoryProvider)
                      .markChatRead(chat.telegramChatId);
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ),
        if (_searchOpen)
          Material(
            color: headerColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search messages…',
                      isDense: true,
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchBusy
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : (_searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchHits = const []);
                                  },
                                  icon: const Icon(Icons.clear_rounded),
                                )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (v) {
                      setState(() {});
                      _runSearch(v);
                    },
                  ),
                  if (_searchHits.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 180),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchHits.length,
                        itemBuilder: (context, i) {
                          final hit = _searchHits[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              hit.text.isEmpty
                                  ? '[${hit.contentType}]'
                                  : hit.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(timeFmt.format(hit.sentAt.toLocal())),
                            onTap: () {
                              jumpToReply(hit.telegramMessageId);
                            },
                          );
                        },
                      ),
                    ),
                  ] else if (_searchController.text.trim().isNotEmpty &&
                      !_searchBusy)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'No messages found',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0E0E0E) : const Color(0xFFE7EBEE),
            ),
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _listController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final showDate = index == 0 ||
                        !_sameDay(messages[index - 1].sentAt, msg.sentAt);
                    final replied = msg.replyToMessageId == null
                        ? null
                        : messages
                            .where(
                              (m) =>
                                  m.telegramMessageId == msg.replyToMessageId,
                            )
                            .firstOrNull;
                    return Column(
                      key: GlobalObjectKey('tg-msg-${msg.telegramMessageId}'),
                      children: [
                        if (showDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black45
                                    : Colors.black.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _dateLabel(msg.sentAt.toLocal()),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ),
                        _MessageBubble(
                          message: msg,
                          timeLabel: timeFmt.format(msg.sentAt.toLocal()),
                          showSender:
                              chat.chatType == TelegramChatType.group ||
                                  chat.chatType == TelegramChatType.channel,
                          highlighted:
                              _highlightMessageId == msg.telegramMessageId,
                          replyLabel: replied?.senderName ??
                              (replied?.isOutgoing == true ? 'You' : null),
                          replyBody: replied?.text.split('|').first ??
                              msg.replyPreview,
                          onOpenImage: msg.hasPhoto
                              ? () => showTelegramImageViewer(
                                    context,
                                    msg.mediaPath!,
                                  )
                              : null,
                          onActions: (pos) => _onMessageAction(msg, pos),
                          onReplyTap: msg.replyToMessageId != null
                              ? () => jumpToReply(msg.replyToMessageId!)
                              : null,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        TelegramComposer(
          key: ValueKey('composer-${_replyTo?.id}-${_editing?.id}'),
          replyTo: _replyTo,
          editing: _editing,
          initialText: _editing?.text,
          onCancelReplyOrEdit: () => setState(() {
            _replyTo = null;
            _editing = null;
          }),
          onSendText: _sendText,
          onSendFile: sendFile,
          onSendVoice: sendVoice,
        ),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    if (day == today) return 'Today';
    if (today.difference(day).inDays == 1) return 'Yesterday';
    return DateFormat.yMMMd().format(dt);
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.timeLabel,
    required this.showSender,
    this.highlighted = false,
    this.replyLabel,
    this.replyBody,
    this.onOpenImage,
    this.onActions,
    this.onReplyTap,
  });

  final TelegramMessage message;
  final String timeLabel;
  final bool showSender;
  final bool highlighted;
  final String? replyLabel;
  final String? replyBody;
  final VoidCallback? onOpenImage;
  final ValueChanged<Offset>? onActions;
  final VoidCallback? onReplyTap;

  @override
  Widget build(BuildContext context) {
    final isOut = message.isOutgoing;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isOut
        ? (isDark ? const Color(0xFF2B5278) : const Color(0xFFD0E6FA))
        : (isDark ? const Color(0xFF212121) : Colors.white);
    final fg = isDark || !isOut
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF102A43);
    final accent = isOut ? const Color(0xFF6BB6FF) : AppColors.brand;

    return Align(
      alignment: isOut ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.only(
            bottom: 6,
            left: isOut ? 48 : 0,
            right: isOut ? 0 : 48,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: AppColors.brand.withValues(alpha: 0.45),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: Builder(
              builder: (context) {
                Offset? tapPos;
                return GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTapDown: (d) => tapPos = d.globalPosition,
                  onSecondaryTapDown: (d) => tapPos = d.globalPosition,
                  onLongPressStart: (d) {
                    onActions?.call(d.globalPosition);
                  },
                  onTap: () {
                    final p = tapPos;
                    if (p != null) onActions?.call(p);
                  },
                  onSecondaryTap: () {
                    final p = tapPos;
                    if (p != null) onActions?.call(p);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isOut ? 14 : 4),
                        bottomRight: Radius.circular(isOut ? 4 : 14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showSender && !isOut && message.senderName != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              message.senderName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        if (message.replyToMessageId != null &&
                            (replyBody != null ||
                                message.replyPreview != null)) ...[
                          GestureDetector(
                            onTap: onReplyTap,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: accent, width: 2),
                                ),
                                color: Colors.black.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (replyLabel != null)
                                    Text(
                                      replyLabel!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: accent,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  Text(
                                    (replyBody ?? message.replyPreview)!
                                        .split('|')
                                        .first,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: fg.withValues(alpha: 0.85),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (message.hasPhoto) ...[
                          if (message.text.isNotEmpty &&
                              message.text != 'Photo') ...[
                            Text(
                              message.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: fg,
                                    height: 1.35,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                          GestureDetector(
                            onTap: onOpenImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(message.mediaPath!),
                                width: 260,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                  '📷 Photo unavailable',
                                  style: TextStyle(
                                    color: fg.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else if (message.contentType == 'photo')
                          Text(
                            message.text.isNotEmpty && message.text != 'Photo'
                                ? message.text
                                : '📷 Loading photo…',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: fg),
                          )
                        else if (message.contentType == 'document')
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.insert_drive_file_outlined,
                                size: 16,
                                color: fg,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  message.text.isEmpty
                                      ? 'Document'
                                      : message.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: fg),
                                ),
                              ),
                            ],
                          )
                        else if (message.contentType == 'voice')
                          GestureDetector(
                            // Absorb taps so play doesn't open the action menu.
                            onTap: () {},
                            child: TelegramVoiceBubble(
                              message: message,
                              foreground: fg,
                              accent: accent,
                            ),
                          )
                        else
                          Text(
                            message.text.isEmpty
                                ? '📎 Attachment'
                                : message.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: fg,
                                  height: 1.35,
                                ),
                          ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (message.isEdited) ...[
                                Text(
                                  'edited',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: fg.withValues(alpha: 0.55),
                                        fontSize: 10,
                                      ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                timeLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: fg.withValues(alpha: 0.65),
                                      fontSize: 11,
                                    ),
                              ),
                              if (isOut) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.done_all_rounded,
                                  size: 14,
                                  color: AppColors.brandMuted,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyConnect extends StatelessWidget {
  const _EmptyConnect({required this.onConnect});

  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.send_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Manage Telegram from ጊዜCare',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Connect your account, then pick the private chats, groups, and channels this app may access.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onConnect,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Connect Telegram'),
            ),
          ],
        ),
      ),
    );
  }
}
