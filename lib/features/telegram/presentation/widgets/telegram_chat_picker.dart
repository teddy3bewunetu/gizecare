import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';

/// Multi-select chats/groups/channels that GizeCare may access.
Future<void> showTelegramChatPicker(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
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
  var _loaded = false;
  var _saving = false;
  TelegramChatType? _filter;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(telegramChatsProvider(false));

    return AlertDialog(
      title: const Text('Choose chats for GizeCare'),
      content: SizedBox(
        width: 520,
        height: 480,
        child: chatsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (chats) {
            if (!_loaded) {
              _selected
                ..clear()
                ..addAll(
                  chats.where((c) => c.isAllowed).map((c) => c.telegramChatId),
                );
              _loaded = true;
            }
            final q = _search.text.trim().toLowerCase();
            final filtered = chats.where((c) {
              if (_filter != null && c.chatType != _filter) return false;
              if (q.isEmpty) return true;
              return c.title.toLowerCase().contains(q) ||
                  (c.username?.toLowerCase().contains(q) ?? false);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Only selected chats will sync and appear in this app. '
                  'Telegram still grants the full account session — this filter is enforced by GizeCare.',
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
                      onSelected: (_) =>
                          setState(() => _filter = TelegramChatType.private),
                    ),
                    FilterChip(
                      label: const Text('Groups'),
                      selected: _filter == TelegramChatType.group,
                      onSelected: (_) =>
                          setState(() => _filter = TelegramChatType.group),
                    ),
                    FilterChip(
                      label: const Text('Channels'),
                      selected: _filter == TelegramChatType.channel,
                      onSelected: (_) =>
                          setState(() => _filter = TelegramChatType.channel),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No chats yet — sync first'))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final chat = filtered[index];
                            final checked =
                                _selected.contains(chat.telegramChatId);
                            return CheckboxListTile(
                              value: checked,
                              dense: true,
                              secondary: Icon(_iconFor(chat.chatType)),
                              title: Text(chat.title),
                              subtitle: Text(
                                [
                                  chat.chatType.name,
                                  if (chat.username != null) '@${chat.username}',
                                ].join(' · '),
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
            );
          },
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
          child: const Text('Save'),
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
