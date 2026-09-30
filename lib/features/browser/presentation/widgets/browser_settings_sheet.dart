import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark.dart';
import 'package:gizecare/features/browser/presentation/providers/browser_providers.dart';

Future<void> showBrowserSettingsSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) => const _BrowserSettingsSheet(),
  );
}

class _BrowserSettingsSheet extends ConsumerWidget {
  const _BrowserSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(browserSearchEngineProvider);
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Browser settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Search engine and browsing data for ጊዜCare Browser.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Default search engine',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            engineAsync.when(
              data: (current) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final engine in BrowserSearchEngine.values)
                    ChoiceChip(
                      label: Text(engine.label),
                      selected: current == engine,
                      onSelected: (_) async {
                        await setBrowserSearchEngine(ref, engine);
                      },
                      selectedColor: AppColors.brand.withValues(alpha: 0.2),
                    ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
            const SizedBox(height: 20),
            Text(
              'Privacy',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final choice = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear browsing data?'),
                    content: const Text(
                      'This clears the in-app browser profile (cookies/cache). '
                      'You can also remove all bookmarks.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, 'cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, 'profile'),
                        child: const Text('Profile only'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, 'all'),
                        child: const Text('Profile + bookmarks'),
                      ),
                    ],
                  ),
                );
                if (choice == null || choice == 'cancel') return;
                await AppDesktopBrowser.clearProfileData();
                if (choice == 'all') {
                  await ref.read(browserBookmarkRepositoryProvider).clearAll();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                  AppSnackBar.show(context, 'Browsing data cleared');
                }
              },
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Clear browsing data'),
            ),
            const SizedBox(height: 12),
            Text(
              'Links from Notes, Mail, and chat open in ጊዜCare Browser by default. '
              'OAuth and tel/tg links still use the system handler.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
