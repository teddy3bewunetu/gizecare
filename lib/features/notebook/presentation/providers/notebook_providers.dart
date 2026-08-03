import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/notebook/domain/entities/note.dart';
import 'package:gizecare/features/notebook/domain/entities/notebook.dart';

/// Sidebar filter: all notes, one notebook, or favorites only.
enum NotebookListFilter { all, notebook, favorites }

/// Active list filter mode.
final notebookListFilterProvider =
    StateProvider<NotebookListFilter>((ref) => NotebookListFilter.all);

/// Selected notebook id when [NotebookListFilter.notebook] is active.
final selectedNotebookIdProvider = StateProvider<String?>((ref) => null);

/// Selected note id in the document canvas.
final selectedNoteIdProvider = StateProvider<String?>((ref) => null);

/// Sidebar search query.
final notebookSearchQueryProvider = StateProvider<String>((ref) => '');

/// All notebooks stream.
final notebooksProvider = StreamProvider<List<Notebook>>((ref) {
  return ref.watch(notebookRepositoryProvider).watchNotebooks();
});

/// Notes filtered by sidebar filter + search.
final filteredNotesProvider = StreamProvider<List<Note>>((ref) {
  final filter = ref.watch(notebookListFilterProvider);
  final notebookId = ref.watch(selectedNotebookIdProvider);
  final query = ref.watch(notebookSearchQueryProvider);
  final repo = ref.watch(noteRepositoryProvider);

  return switch (filter) {
    NotebookListFilter.all => repo.watchNotes(searchQuery: query),
    NotebookListFilter.favorites =>
      repo.watchNotes(favoritesOnly: true, searchQuery: query),
    NotebookListFilter.notebook => repo.watchNotes(
        notebookId: notebookId,
        searchQuery: query,
      ),
  };
});

/// Currently selected note (list first, then id fetch).
final selectedNoteProvider = Provider<Note?>((ref) {
  final id = ref.watch(selectedNoteIdProvider);
  if (id == null) return null;
  final fromList = ref.watch(filteredNotesProvider).valueOrNull;
  if (fromList != null) {
    for (final note in fromList) {
      if (note.id == id) return note;
    }
  }
  return ref.watch(_noteByIdProvider(id)).valueOrNull;
});

final _noteByIdProvider =
    FutureProvider.family<Note?, String>((ref, id) async {
  final result = await ref.watch(noteRepositoryProvider).getById(id);
  return result.isSuccess ? result.requireValue : null;
});

/// Note counts keyed by notebook id.
final notebookNoteCountsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(noteRepositoryProvider).watchNotes().map((notes) {
    final counts = <String, int>{};
    for (final note in notes) {
      counts[note.notebookId] = (counts[note.notebookId] ?? 0) + 1;
    }
    return counts;
  });
});
