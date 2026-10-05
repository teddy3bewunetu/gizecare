import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/browser/app_link_opener.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/notebook/domain/entities/note.dart';
import 'package:gizecare/features/notebook/domain/note_colors.dart';
import 'package:gizecare/features/notebook/domain/note_document_codec.dart';
import 'package:gizecare/features/notebook/domain/note_image_store.dart';
import 'package:gizecare/features/notebook/presentation/providers/notebook_providers.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';

/// Evernote-style rich note editor with Quill (paste, images, formatting).
class NoteEditorPane extends ConsumerStatefulWidget {
  const NoteEditorPane({required this.note, this.notebookName, super.key});

  final Note note;
  final String? notebookName;

  @override
  ConsumerState<NoteEditorPane> createState() => _NoteEditorPaneState();
}

class _NoteEditorPaneState extends ConsumerState<NoteEditorPane> {
  static const _contentPadH = 28.0;
  static const _contentMaxWidth = 820.0;

  late TextEditingController _titleController;
  late QuillController _quillController;
  late FocusNode _editorFocus;
  late FocusNode _titleFocus;
  late ScrollController _editorScroll;
  StreamSubscription<DocChange>? _docSub;
  Timer? _debounce;
  String? _boundNoteId;
  var _legacyMigrated = false;

  static const _imageTypes = XTypeGroup(
    label: 'images',
    extensions: <String>['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'],
  );

  @override
  void initState() {
    super.initState();
    _bindNote(widget.note, force: true);
  }

  @override
  void didUpdateWidget(covariant NoteEditorPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.note.id != _boundNoteId) {
      _bindNote(widget.note, force: true);
      setState(() {});
    }
  }

  void _bindNote(Note note, {required bool force}) {
    if (!force && note.id == _boundNoteId) return;
    _debounce?.cancel();
    _docSub?.cancel();
    if (_boundNoteId != null) {
      _titleController.dispose();
      _quillController.dispose();
      _editorFocus.dispose();
      _titleFocus.dispose();
      _editorScroll.dispose();
    }

    _boundNoteId = note.id;
    _legacyMigrated = !NoteDocumentCodec.looksLikeQuillJson(note.body) &&
        note.body.trim().isNotEmpty;
    _titleController = TextEditingController(text: note.title);
    _titleController.addListener(_scheduleSave);
    _titleFocus = FocusNode();
    _editorFocus = FocusNode();
    _editorScroll = ScrollController();

    final document = NoteDocumentCodec.decode(note.body);
    _quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: _persistPastedImage,
        ),
      ),
    );
    _docSub = _quillController.document.changes.listen((_) => _scheduleSave());

    if (_legacyMigrated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _saveContent());
    }
  }

  Future<String?> _persistPastedImage(Uint8List bytes) async {
    try {
      return await NoteImageStore.saveBytes(widget.note.id, bytes);
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(context, 'Could not paste image');
      }
      return null;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _docSub?.cancel();
    _titleController.dispose();
    _quillController.dispose();
    _editorFocus.dispose();
    _titleFocus.dispose();
    _editorScroll.dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _saveContent);
  }

  Future<void> _saveContent() async {
    final note = widget.note;
    final title = _titleController.text;
    final body = NoteDocumentCodec.encode(_quillController.document);
    if (title == note.title && body == note.body) return;
    await ref.read(noteRepositoryProvider).update(
          note.copyWith(title: title, body: body),
        );
  }

  Future<void> _patch(Note Function(Note n) transform) async {
    final result =
        await ref.read(noteRepositoryProvider).update(transform(widget.note));
    if (!result.isSuccess && mounted) {
      AppSnackBar.show(context, 'Could not update note');
    }
  }

  Future<void> _pickAndInsertImage() async {
    final file = await openFile(acceptedTypeGroups: const [_imageTypes]);
    if (file == null) return;
    try {
      final path = await NoteImageStore.saveFile(widget.note.id, file.path);
      _insertImageEmbed(path);
    } catch (_) {
      if (mounted) AppSnackBar.show(context, 'Could not insert image');
    }
  }

  void _insertImageEmbed(String path) {
    _editorFocus.requestFocus();
    var index = _quillController.selection.baseOffset;
    var length =
        _quillController.selection.extentOffset - index;
    if (index < 0) {
      index = (_quillController.document.length - 1).clamp(0, 1 << 30);
      length = 0;
    }
    if (length < 0) length = 0;
    _quillController.replaceText(
      index,
      length,
      BlockEmbed.image(path),
      TextSelection.collapsed(offset: index + 1),
    );
    // Keep a blank line after the image for easy continued typing.
    _quillController.replaceText(
      index + 1,
      0,
      '\n',
      TextSelection.collapsed(offset: index + 2),
    );
    _scheduleSave();
  }

  DefaultStyles _editorStyles(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseColor = scheme.onSurface;
    final muted = scheme.onSurfaceVariant.withValues(alpha: 0.42);
    final base = TextStyle(
      fontSize: 15.5,
      height: 1.45,
      color: baseColor,
      letterSpacing: 0.1,
    );
    const zeroH = HorizontalSpacing.zero;
    const zeroV = VerticalSpacing.zero;

    return DefaultStyles.getInstance(context).merge(
      DefaultStyles(
        paragraph: DefaultTextBlockStyle(base, zeroH, zeroV, zeroV, null),
        placeHolder: DefaultTextBlockStyle(
          base.copyWith(color: muted, height: 1.45),
          zeroH,
          zeroV,
          zeroV,
          null,
        ),
        h1: DefaultTextBlockStyle(
          base.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.4,
          ),
          zeroH,
          const VerticalSpacing(16, 6),
          zeroV,
          null,
        ),
        h2: DefaultTextBlockStyle(
          base.copyWith(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.2,
          ),
          zeroH,
          const VerticalSpacing(14, 4),
          zeroV,
          null,
        ),
        h3: DefaultTextBlockStyle(
          base.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          zeroH,
          const VerticalSpacing(12, 3),
          zeroV,
          null,
        ),
        lists: DefaultListBlockStyle(
          base,
          zeroH,
          const VerticalSpacing(1, 1),
          zeroV,
          null,
          null,
        ),
        quote: DefaultTextBlockStyle(
          base.copyWith(
            color: scheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
          const HorizontalSpacing(12, 0),
          const VerticalSpacing(6, 6),
          zeroV,
          BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 3,
                color: AppColors.brand.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        code: DefaultTextBlockStyle(
          TextStyle(
            fontFamily: 'monospace',
            fontSize: 13.5,
            height: 1.4,
            color: baseColor,
          ),
          const HorizontalSpacing(8, 8),
          const VerticalSpacing(8, 8),
          zeroV,
          BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inlineCode: InlineCodeStyle(
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13.5,
            color: baseColor,
          ),
          backgroundColor: scheme.surfaceContainerHighest,
          radius: const Radius.circular(4),
        ),
        link: TextStyle(
          color: AppColors.brand,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.brand.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  QuillSimpleToolbarConfig _toolbarConfig(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconTheme = QuillIconTheme(
      iconButtonUnselectedData: IconButtonData(
        iconSize: 18,
        color: scheme.onSurfaceVariant,
        hoverColor: scheme.onSurface.withValues(alpha: 0.06),
      ),
      iconButtonSelectedData: IconButtonData(
        iconSize: 18,
        color: AppColors.brand,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.brand.withValues(alpha: 0.14),
          foregroundColor: AppColors.brand,
        ),
      ),
    );

    return QuillSimpleToolbarConfig(
      multiRowsDisplay: false,
      showDividers: true,
      toolbarSectionSpacing: 2,
      sectionDividerSpace: 6,
      sectionDividerColor: scheme.outlineVariant.withValues(alpha: 0.5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      iconTheme: iconTheme,
      buttonOptions: QuillSimpleToolbarButtonOptions(
        base: QuillToolbarBaseButtonOptions(
          iconTheme: iconTheme,
          afterButtonPressed: () => _editorFocus.requestFocus(),
        ),
      ),
      showFontFamily: false,
      showFontSize: true,
      showBoldButton: true,
      showItalicButton: true,
      showUnderLineButton: true,
      showStrikeThrough: true,
      showInlineCode: true,
      showColorButton: true,
      showBackgroundColorButton: true,
      showClearFormat: true,
      showHeaderStyle: true,
      headerStyleType: HeaderStyleType.buttons,
      showListNumbers: true,
      showListBullets: true,
      showListCheck: true,
      showCodeBlock: true,
      showQuote: true,
      showIndent: true,
      showLink: true,
      showUndo: true,
      showRedo: true,
      showSearchButton: true,
      showSubscript: false,
      showSuperscript: false,
      showAlignmentButtons: false,
      showDirection: false,
      showLineHeightButton: false,
      showClipboardCopy: true,
      showClipboardCut: true,
      showClipboardPaste: true,
      linkStyleType: LinkStyleType.original,
      embedButtons: [
        (context, embedContext) => QuillToolbarCustomButton(
              controller: embedContext.controller,
              options: QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.image_outlined),
                tooltip: 'Insert image',
                iconTheme: embedContext.iconTheme,
                onPressed: _pickAndInsertImage,
              ),
            ),
      ],
    );
  }

  Future<void> _openLink(String? raw) async {
    if (raw == null || raw.trim().isEmpty) return;
    if (!mounted) return;
    await AppLinkOpener.open(context, raw.trim());
  }

  /// Quill desktop defaults to Ctrl/Cmd+click only. Always attach a tap
  /// recognizer so links show a pointer cursor and open on a normal click.
  GestureRecognizer? _linkRecognizer(Attribute<dynamic> attribute, Node leaf) {
    if (attribute.key != Attribute.link.key) return null;
    final href = attribute.value;
    if (href is! String || href.trim().isEmpty) return null;
    return TapGestureRecognizer()
      ..onTap = () {
        _openLink(href);
      };
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final scheme = Theme.of(context).colorScheme;
    final projectAsync = note.projectId == null
        ? null
        : ref.watch(_linkedProjectProvider(note.projectId!));
    final taskAsync = note.taskId == null
        ? null
        : ref.watch(_linkedTaskProvider(note.taskId!));
    final breadcrumbTitle =
        note.title.trim().isEmpty ? 'Untitled' : note.title.trim();
    final notebookLabel = widget.notebookName ?? 'Notebook';

    return ColoredBox(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$notebookLabel  ›  $breadcrumbTitle',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 0.1,
                        ),
                  ),
                ),
                _ChromeIcon(
                  tooltip: note.isPinned ? 'Unpin' : 'Pin',
                  icon: note.isPinned
                      ? Icons.push_pin_rounded
                      : Icons.push_pin_outlined,
                  onPressed: () =>
                      _patch((n) => n.copyWith(isPinned: !n.isPinned)),
                ),
                _ChromeIcon(
                  tooltip: note.isFavorite ? 'Unfavorite' : 'Favorite',
                  icon: note.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  onPressed: () =>
                      _patch((n) => n.copyWith(isFavorite: !n.isFavorite)),
                ),
                PopupMenuButton<Color>(
                  tooltip: 'Note color',
                  icon: Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                  onSelected: (c) => _patch((n) => n.copyWith(color: c)),
                  itemBuilder: (context) => [
                    for (final color in NoteColors.palette)
                      PopupMenuItem(
                        value: color,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                        ),
                      ),
                  ],
                ),
                _ChromeIcon(
                  tooltip: 'Delete note',
                  icon: Icons.delete_outline_rounded,
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete note?'),
                        content: const Text('This cannot be undone.'),
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
                    await ref.read(noteRepositoryProvider).delete(note.id);
                    ref.read(selectedNoteIdProvider.notifier).state = null;
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: QuillSimpleToolbar(
              controller: _quillController,
              config: _toolbarConfig(context),
            ),
          ),
          if (note.projectId != null || note.taskId != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (note.projectId != null)
                    InputChip(
                      avatar: const Icon(Icons.folder_outlined, size: 16),
                      label:
                          Text(projectAsync?.valueOrNull?.name ?? 'Project'),
                      onDeleted: () => _patch(
                        (n) => n.copyWith(
                          clearProjectId: true,
                          clearTaskId: note.taskId != null,
                        ),
                      ),
                    ),
                  if (note.taskId != null)
                    InputChip(
                      avatar: const Icon(Icons.checklist_rounded, size: 16),
                      label: Text(taskAsync?.valueOrNull?.name ?? 'Task'),
                      onDeleted: () =>
                          _patch((n) => n.copyWith(clearTaskId: true)),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                child: Shortcuts(
                  shortcuts: const <ShortcutActivator, Intent>{
                    SingleActivator(LogicalKeyboardKey.keyB, control: true):
                        _FormatIntent(Attribute.bold),
                    SingleActivator(LogicalKeyboardKey.keyI, control: true):
                        _FormatIntent(Attribute.italic),
                    SingleActivator(LogicalKeyboardKey.keyU, control: true):
                        _FormatIntent(Attribute.underline),
                  },
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      _FormatIntent: CallbackAction<_FormatIntent>(
                        onInvoke: (intent) {
                          _quillController.formatSelection(intent.attribute);
                          return null;
                        },
                      ),
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            _contentPadH,
                            22,
                            _contentPadH,
                            8,
                          ),
                          child: TextField(
                            controller: _titleController,
                            focusNode: _titleFocus,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                  fontSize: 32,
                                  letterSpacing: -0.5,
                                ),
                            cursorColor: AppColors.brand,
                            decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                    height: 1.15,
                                    letterSpacing: -0.5,
                                    color: scheme.onSurfaceVariant
                                        .withValues(alpha: 0.32),
                                  ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => setState(() {}),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => _editorFocus.requestFocus(),
                          ),
                        ),
                        Expanded(
                          child: QuillEditor.basic(
                            controller: _quillController,
                            focusNode: _editorFocus,
                            scrollController: _editorScroll,
                            config: QuillEditorConfig(
                              padding: const EdgeInsets.fromLTRB(
                                _contentPadH,
                                0,
                                _contentPadH,
                                56,
                              ),
                              placeholder:
                                  'Start writing, or paste text and images…',
                              customStyles: _editorStyles(context),
                              embedBuilders: [
                                _NoteImageEmbedBuilder(
                                  onRequestDelete: _scheduleSave,
                                ),
                              ],
                              autoFocus: false,
                              expands: true,
                              scrollable: true,
                              showCursor: true,
                              enableSelectionToolbar: true,
                              paintCursorAboveText: true,
                              onLaunchUrl: _openLink,
                              // Bypass Quill’s Ctrl/Cmd+click-only desktop rule.
                              customRecognizerBuilder: _linkRecognizer,
                              linkActionPickerDelegate:
                                  (context, link, node) async =>
                                      LinkMenuAction.launch,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatIntent extends Intent {
  const _FormatIntent(this.attribute);
  final Attribute<dynamic> attribute;
}

class _ChromeIcon extends StatelessWidget {
  const _ChromeIcon({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      iconSize: 20,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class _NoteImageEmbedBuilder extends EmbedBuilder {
  const _NoteImageEmbedBuilder({required this.onRequestDelete});

  final VoidCallback onRequestDelete;

  @override
  String get key => BlockEmbed.imageType;

  @override
  String toPlainText(Embed node) => '[image]';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final raw = embedContext.node.value.data;
    final src = raw is String ? raw : raw.toString();
    final scheme = Theme.of(context).colorScheme;

    Widget image;
    if (src.startsWith('http://') || src.startsWith('https://')) {
      image = Image.network(
        src,
        fit: BoxFit.contain,
        errorBuilder: (_, error, stackTrace) => _missing(scheme),
      );
    } else {
      final file = File(src);
      image = file.existsSync()
          ? Image.file(file, fit: BoxFit.contain)
          : _missing(scheme);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          onSecondaryTapDown: (details) async {
            final selected = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                details.globalPosition.dx,
                details.globalPosition.dy,
              ),
              items: const [
                PopupMenuItem(value: 'copy', child: Text('Copy image path')),
                PopupMenuItem(value: 'delete', child: Text('Remove image')),
              ],
            );
            if (selected == 'copy') {
              await Clipboard.setData(ClipboardData(text: src));
            } else if (selected == 'delete') {
              final offset = embedContext.node.documentOffset;
              embedContext.controller.replaceText(
                offset,
                1,
                '',
                TextSelection.collapsed(offset: offset),
              );
              onRequestDelete();
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: image,
            ),
          ),
        ),
      ),
    );
  }

  Widget _missing(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Image unavailable',
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

final _linkedProjectProvider =
    FutureProvider.family<Project?, String>((ref, id) async {
  final result = await ref.watch(projectRepositoryProvider).getById(id);
  return result.isSuccess ? result.requireValue : null;
});

final _linkedTaskProvider =
    FutureProvider.family<TaskItem?, String>((ref, id) async {
  final result = await ref.watch(taskRepositoryProvider).getById(id);
  return result.isSuccess ? result.requireValue : null;
});
