import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/features/browser/presentation/providers/browser_providers.dart';

Future<void> showBrowserHistorySheet(
  BuildContext context,
  WidgetRef ref, {
  required ValueChanged<String> onOpenUrl,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) => _BrowserHistorySheet(onOpenUrl: onOpenUrl),
  );
}

class _BrowserHistorySheet extends ConsumerStatefulWidget {
  const _BrowserHistorySheet({required this.onOpenUrl});

  final ValueChanged<String> onOpenUrl;

  @override
  ConsumerState<_BrowserHistorySheet> createState() =>
      _BrowserHistorySheetState();
}

class _BrowserHistorySheetState extends ConsumerState<_BrowserHistorySheet> {
  final _search = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(browserHistoryProvider);
    final scheme = Theme.of(context).colorScheme;
    final timeFmt = DateFormat.yMMMd().add_jm();
    final height = MediaQuery.sizeOf(context).height * 0.72;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'History',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear history?'),
                          content: const Text(
                            'This removes all visited pages from ጊዜCare Browser.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      await ref
                          .read(browserHistoryRepositoryProvider)
                          .clearAll();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search history',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.clear_rounded),
                        ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: historyAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (entries) {
                    final q = _query.toLowerCase();
                    final filtered = q.isEmpty
                        ? entries
                        : entries
                            .where(
                              (e) =>
                                  e.url.toLowerCase().contains(q) ||
                                  e.title.toLowerCase().contains(q),
                            )
                            .toList();
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          q.isEmpty
                              ? 'No history yet'
                              : 'No matching visits',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final e = filtered[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.history_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                          title: Text(
                            e.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${e.url}\n${timeFmt.format(e.visitedAt.toLocal())}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              ref
                                  .read(browserHistoryRepositoryProvider)
                                  .remove(e.id);
                            },
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onOpenUrl(e.url);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
