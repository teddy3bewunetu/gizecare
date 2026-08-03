import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/notebook/domain/note_colors.dart';
import 'package:gizecare/features/notebook/presentation/providers/notebook_providers.dart';
import 'package:gizecare/features/notebook/presentation/widgets/note_create_empty_state.dart';
import 'package:gizecare/features/notebook/presentation/widgets/note_editor_pane.dart';
import 'package:gizecare/features/notebook/presentation/widgets/notes_list_pane.dart';

/// Evernote-style Notes: list pane + editor (app sidebar is global nav).
class NotebookPage extends ConsumerStatefulWidget {
  const NotebookPage({
    super.key,
    this.createOnOpen = false,
    this.projectId,
    this.taskId,
    this.notebookId,
  });

  final bool createOnOpen;
  final String? projectId;
  final String? taskId;
  final String? notebookId;

  @override
  ConsumerState<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends ConsumerState<NotebookPage> {
  var _handledDeepLink = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleDeepLink());
  }

  @override
  void didUpdateWidget(covariant NotebookPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.createOnOpen &&
        (widget.projectId != oldWidget.projectId ||
            widget.taskId != oldWidget.taskId ||
            widget.notebookId != oldWidget.notebookId)) {
      _handledDeepLink = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleDeepLink());
    }
  }

  Future<void> _handleDeepLink() async {
    if (_handledDeepLink || !widget.createOnOpen) return;
    _handledDeepLink = true;
    await _createNote(
      projectId: widget.projectId,
      taskId: widget.taskId,
      notebookId: widget.notebookId,
    );
    if (!mounted) return;
    context.go('/notebook');
  }

  Future<String?> _resolveNotebookId(String? preferred) async {
    if (preferred != null) return preferred;
    final selected = ref.read(selectedNotebookIdProvider);
    if (selected != null) return selected;
    final result = await ref.read(notebookRepositoryProvider).ensureDefault();
    if (!result.isSuccess) return null;
    return result.requireValue.id;
  }

  Future<void> _createNote({
    NoteType type = NoteType.text,
    String? projectId,
    String? taskId,
    String? notebookId,
  }) async {
    final nbId = await _resolveNotebookId(notebookId);
    if (nbId == null) {
      if (mounted) AppSnackBar.show(context, 'No notebook available');
      return;
    }
    final result = await ref.read(noteRepositoryProvider).create(
          notebookId: nbId,
          noteType: type,
          color: NoteColors.random(),
          projectId: projectId,
          taskId: taskId,
        );
    if (!result.isSuccess) {
      if (mounted) AppSnackBar.show(context, 'Could not create note');
      return;
    }
    ref.read(selectedNoteIdProvider.notifier).state = result.requireValue.id;
  }

  Future<void> _createNotebook() async {
    final nameController = TextEditingController(text: 'New Notebook');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New notebook'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    const colors = AppColors.projectPalette;
    final result = await ref.read(notebookRepositoryProvider).create(
          name: name.trim(),
          coverColor: colors[DateTime.now().millisecond % colors.length],
        );
    if (!result.isSuccess) {
      if (mounted) AppSnackBar.show(context, 'Could not create notebook');
      return;
    }
    ref.read(notebookListFilterProvider.notifier).state =
        NotebookListFilter.notebook;
    ref.read(selectedNotebookIdProvider.notifier).state =
        result.requireValue.id;
  }

  Future<void> _renameNotebook(String id, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename notebook'),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    final notebooks = ref.read(notebooksProvider).valueOrNull ?? [];
    final match = notebooks.where((n) => n.id == id);
    if (match.isEmpty) return;
    await ref
        .read(notebookRepositoryProvider)
        .update(match.first.copyWith(name: name.trim()));
  }

  Future<void> _deleteNotebook(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete notebook?'),
        content: const Text('All notes in this notebook will be deleted.'),
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
    if (ok != true) return;
    await ref.read(notebookRepositoryProvider).delete(id);
    if (ref.read(selectedNotebookIdProvider) == id) {
      ref.read(selectedNotebookIdProvider.notifier).state = null;
      ref.read(notebookListFilterProvider.notifier).state =
          NotebookListFilter.all;
    }
    ref.read(selectedNoteIdProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 900;
    final note = ref.watch(selectedNoteProvider);
    final notebooks = ref.watch(notebooksProvider).valueOrNull ?? [];
    final notebookName = note == null
        ? null
        : notebooks.where((n) => n.id == note.notebookId).firstOrNull?.name;

    final listPane = NotesListPane(
      onNewNote: () => _createNote(),
      onNewNotebook: _createNotebook,
      onRenameNotebook: _renameNotebook,
      onDeleteNotebook: _deleteNotebook,
    );

    final editor = note != null
        ? NoteEditorPane(
            key: ValueKey(note.id),
            note: note,
            notebookName: notebookName,
          )
        : NoteCreateEmptyState(onNewPage: () => _createNote());

    if (narrow) {
      if (note != null) {
        return ColoredBox(
          color: scheme.surface,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Back to notes',
                  onPressed: () =>
                      ref.read(selectedNoteIdProvider.notifier).state = null,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              Expanded(child: editor),
            ],
          ),
        );
      }
      return ColoredBox(color: scheme.surfaceContainerLow, child: listPane);
    }

    return ColoredBox(
      color: scheme.surface,
      child: Row(
        children: [
          SizedBox(width: 300, child: listPane),
          VerticalDivider(width: 1, color: scheme.outlineVariant),
          Expanded(child: editor),
        ],
      ),
    );
  }
}
