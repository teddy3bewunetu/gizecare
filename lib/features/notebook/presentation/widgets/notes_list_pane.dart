import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/notebook/presentation/providers/notebook_providers.dart';
import 'package:gizecare/features/notebook/presentation/widgets/note_list_tile.dart';

/// Evernote middle column: notes list with soft cards.
class NotesListPane extends ConsumerStatefulWidget {
  const NotesListPane({
    required this.onNewNote,
    required this.onNewNotebook,
    required this.onRenameNotebook,
    required this.onDeleteNotebook,
    super.key,
  });

  final VoidCallback onNewNote;
  final VoidCallback onNewNotebook;
  final Future<void> Function(String id, String name) onRenameNotebook;
  final Future<void> Function(String id) onDeleteNotebook;

  @override
  ConsumerState<NotesListPane> createState() => _NotesListPaneState();
}

class _NotesListPaneState extends ConsumerState<NotesListPane> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(notebookSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filter = ref.watch(notebookListFilterProvider);
    final notebooks = ref.watch(notebooksProvider).valueOrNull ?? [];
    final notesAsync = ref.watch(filteredNotesProvider);
    final selectedNoteId = ref.watch(selectedNoteIdProvider);
    final selectedNotebookId = ref.watch(selectedNotebookIdProvider);
    final noteCount = notesAsync.valueOrNull?.length;

    final title = switch (filter) {
      NotebookListFilter.all => 'Notes',
      NotebookListFilter.favorites => 'Favorites',
      NotebookListFilter.notebook =>
        notebooks.where((n) => n.id == selectedNotebookId).firstOrNull?.name ??
            'Notebook',
    };

    final notebookById = {for (final n in notebooks) n.id: n};

    return ColoredBox(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (noteCount != null)
                          TextSpan(
                            text: '  $noteCount',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'New note',
                  onPressed: widget.onNewNote,
                  icon: const Icon(Icons.note_add_outlined),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Notebook options',
                  onSelected: (value) async {
                    switch (value) {
                      case 'all':
                        ref.read(notebookListFilterProvider.notifier).state =
                            NotebookListFilter.all;
                        ref.read(selectedNotebookIdProvider.notifier).state =
                            null;
                      case 'favorites':
                        ref.read(notebookListFilterProvider.notifier).state =
                            NotebookListFilter.favorites;
                        ref.read(selectedNotebookIdProvider.notifier).state =
                            null;
                      case 'new_notebook':
                        widget.onNewNotebook();
                      default:
                        if (value.startsWith('nb:')) {
                          final id = value.substring(3);
                          ref.read(notebookListFilterProvider.notifier).state =
                              NotebookListFilter.notebook;
                          ref.read(selectedNotebookIdProvider.notifier).state =
                              id;
                        } else if (value.startsWith('rename:')) {
                          final id = value.substring(7);
                          final nb = notebookById[id];
                          if (nb != null) {
                            await widget.onRenameNotebook(id, nb.name);
                          }
                        } else if (value.startsWith('delete:')) {
                          await widget.onDeleteNotebook(value.substring(7));
                        }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'all', child: Text('All notes')),
                    const PopupMenuItem(
                      value: 'favorites',
                      child: Text('Favorites'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'new_notebook',
                      child: Text('New notebook'),
                    ),
                    for (final nb in notebooks) ...[
                      PopupMenuItem(
                        value: 'nb:${nb.id}',
                        child: Text(nb.name),
                      ),
                    ],
                    if (selectedNotebookId != null) ...[
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'rename:$selectedNotebookId',
                        child: const Text('Rename notebook'),
                      ),
                      PopupMenuItem(
                        value: 'delete:$selectedNotebookId',
                        child: const Text('Delete notebook'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (q) =>
                  ref.read(notebookSearchQueryProvider.notifier).state = q,
              decoration: const InputDecoration(
                hintText: 'Search notes',
                prefixIcon: Icon(Icons.search_rounded, size: 18),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (notes) {
                if (notes.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 40,
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No notes yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.brand,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: widget.onNewNote,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create note'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final nb = notebookById[note.notebookId];
                    return NoteListTile(
                      note: note,
                      notebookName: filter == NotebookListFilter.all
                          ? nb?.name
                          : null,
                      selected: note.id == selectedNoteId,
                      onTap: () => ref
                          .read(selectedNoteIdProvider.notifier)
                          .state = note.id,
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
}
