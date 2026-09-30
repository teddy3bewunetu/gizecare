import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/browser/data/drift_browser_bookmark_repository.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark_repository.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

final browserBookmarkRepositoryProvider =
    Provider<BrowserBookmarkRepository>((ref) {
  return DriftBrowserBookmarkRepository(ref.watch(appDatabaseProvider));
});

final browserBookmarksProvider = StreamProvider<List<BrowserBookmark>>((ref) {
  return ref.watch(browserBookmarkRepositoryProvider).watchAll();
});

final browserSearchEngineProvider =
    FutureProvider<BrowserSearchEngine>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  final result = await repo.get(SettingKeys.browserSearchEngine);
  final raw = result.when(onSuccess: (v) => v, onFailure: (_) => null);
  return BrowserSearchEngine.fromStorage(raw);
});

/// When true, shell hides the sidebar and the browser uses immersive chrome.
final browserFullscreenProvider = StateProvider<bool>((ref) => false);

Future<void> setBrowserSearchEngine(
  WidgetRef ref,
  BrowserSearchEngine engine,
) async {
  await ref
      .read(settingsRepositoryProvider)
      .set(SettingKeys.browserSearchEngine, engine.name);
  ref.invalidate(browserSearchEngineProvider);
}
