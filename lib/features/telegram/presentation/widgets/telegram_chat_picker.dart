import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';

/// Multi-select chats/groups/channels that GizeCare may access.
Future<void> showTelegramChatPicker(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _TelegramChatPickerDialog(),
  );
}

class _TelegramChatPickerDialog extends ConsumerStatefulWidget {
  const _TelegramChatPickerDialog();

  @override
  ConsumerState<_TelegramChatPickerDialog> createState() =>
      _TelegramChatPickerDialogState();
}

class _TelegramChatPickerDialogState
    extends ConsumerState<_TelegramChatPickerDialog> {
  final _search = TextEditingController();
  final _selected = <String>{};
  List<TelegramChat> _chats = const [];
  var _loading = true;
  var _saving = false;
  String? _error;
  TelegramChatType? _filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(telegramRepositoryProvider).getChats();
    if (!mounted) return;
    result.when(
      onSuccess: (chats) {
        setState(() {
          _chats = chats;
          _selected
            ..clear()
            ..addAll(
              chats.where((c) => c.isAllowed).map((c) => c.telegramChatId),
            );
          _loading = false;
        });
      },
      onFailure: (f) {
        setState(() {
          _loading = false;
          _error = f.message;
        });
      },
    );
  }

  List<TelegramChat> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _chats.where((c) {
      if (_filter != null && c.chatType != _filter) return false;
      if (q.isEmpty) return true;
      return c.title.toLowerCase().contains(q) ||
          (c.username?.toLowerCase().contains(q) ?? false);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Choose chats for GizeCare')),
          if (!_loading)
            IconButton(
              tooltip: 'Refresh list',
              onPressed: _saving ? null : _load,
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
        ],
      ),
      content: SizedBox(
        width: 520,
        height: 480,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Only selected chats will sync and appear in this app.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _search,
                        decoration: const InputDecoration(
                          hintText: 'Search chats',
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _filter == null,
                            onSelected: (_) => setState(() => _filter = null),
                          ),
                          FilterChip(
                            label: const Text('Private'),
                            selected: _filter == TelegramChatType.private,
                            onSelected: (_) => setState(
                              () => _filter = TelegramChatType.private,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Groups'),
                            selected: _filter == TelegramChatType.group,
                            onSelected: (_) => setState(
                              () => _filter = TelegramChatType.group,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Channels'),
                            selected: _filter == TelegramChatType.channel,
                            onSelected: (_) => setState(
                              () => _filter = TelegramChatType.channel,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _filtered.isEmpty
                            ? const Center(
                                child: Text('No chats yet — sync first'),
                              )
                            : ListView.builder(
                                itemCount: _filtered.length,
                                // Keep scroll/selection snappy for large lists.
                                itemExtent: 64,
                                cacheExtent: 400,
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: true,
                                itemBuilder: (context, index) {
                                  final chat = _filtered[index];
                                  final checked =
                                      _selected.contains(chat.telegramChatId);
                                  return CheckboxListTile(
                                    value: checked,
                                    dense: true,
                                    secondary: Icon(_iconFor(chat.chatType)),
                                    title: Text(
                                      chat.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      [
                                        chat.chatType.name,
                                        if (chat.username != null)
                                          '@${chat.username}',
                                      ].join(' · '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v == true) {
                                          _selected.add(chat.telegramChatId);
                                        } else {
                                          _selected.remove(chat.telegramChatId);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                      Text(
                        '${_selected.length} selected',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving
              ? null
              : () async {
                  setState(() => _saving = true);
                  final result = await ref
                      .read(telegramRepositoryProvider)
                      .setAllowedChats(_selected);
                  if (!context.mounted) return;
                  setState(() => _saving = false);
                  result.when(
                    onSuccess: (_) {
                      Navigator.pop(context);
                      AppSnackBar.show(context, 'Chat access updated');
                    },
                    onFailure: (f) => AppSnackBar.show(context, f.message),
                  );
                },
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  IconData _iconFor(TelegramChatType type) {
    return switch (type) {
      TelegramChatType.private => Icons.person_outline,
      TelegramChatType.group => Icons.groups_outlined,
      TelegramChatType.channel => Icons.campaign_outlined,
      TelegramChatType.secret => Icons.lock_outline,
      TelegramChatType.unknown => Icons.chat_bubble_outline,
    };
  }
}
