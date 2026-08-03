import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:open_filex/open_filex.dart';

import 'package:gizecare/features/documents/presentation/display_name.dart';
import 'package:gizecare/features/documents/presentation/markdown_link_resolver.dart';

String highlightMarkdownMatches(String data, String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return data;

  return data.replaceAllMapped(
    RegExp(RegExp.escape(trimmed), caseSensitive: false),
    (match) => '**${match.group(0)}**',
  );
}

int? firstMatchIndex(String data, String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return null;
  final index = data.toLowerCase().indexOf(trimmed.toLowerCase());
  return index >= 0 ? index : null;
}

/// Themed markdown body for in-page or dialog preview.
class MarkdownPreview extends StatefulWidget {
  const MarkdownPreview({
    required this.data,
    super.key,
    this.baseFilePath,
    this.onNavigateToFile,
    this.highlightQuery,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
  });

  final String data;
  final String? baseFilePath;
  final ValueChanged<String>? onNavigateToFile;
  final String? highlightQuery;
  final EdgeInsets padding;

  @override
  State<MarkdownPreview> createState() => _MarkdownPreviewState();
}

class _MarkdownPreviewState extends State<MarkdownPreview> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scheduleScrollToMatch();
  }

  @override
  void didUpdateWidget(MarkdownPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.highlightQuery != widget.highlightQuery) {
      _scheduleScrollToMatch();
    }
  }

  void _handleLinkTap(String text, String? href, String title) {
    if (href == null || href.isEmpty) return;
    if (href.startsWith('#')) return;

    if (isExternalLink(href)) {
      openExternalLink(href);
      return;
    }

    final basePath = widget.baseFilePath;
    final onNavigate = widget.onNavigateToFile;
    if (basePath == null || onNavigate == null) {
      openExternalLink(href);
      return;
    }

    final target = resolveMarkdownFileLink(href: href, currentFilePath: basePath);
    if (target != null) {
      onNavigate(target);
      return;
    }

    openExternalLink(href);
  }

  void _scheduleScrollToMatch() {
    final query = widget.highlightQuery;
    final matchIndex = query == null ? null : firstMatchIndex(widget.data, query);
    if (matchIndex == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToMatch(matchIndex));
  }

  void _scrollToMatch(int matchIndex) {
    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToMatch(matchIndex));
      return;
    }

    final linesBefore = '\n'.allMatches(widget.data.substring(0, matchIndex)).length;
    const estimatedLineHeight = 28.0;
    final target = (linesBefore * estimatedLineHeight).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final highlightQuery = widget.highlightQuery?.trim();
    final displayData = highlightQuery == null || highlightQuery.isEmpty
        ? widget.data
        : highlightMarkdownMatches(widget.data, highlightQuery);

    return Markdown(
      controller: _scrollController,
      data: displayData,
      padding: widget.padding,
      selectable: true,
      onTapLink: _handleLinkTap,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        h1: theme.textTheme.headlineMedium,
        h2: theme.textTheme.headlineSmall,
        h3: theme.textTheme.titleLarge,
        p: theme.textTheme.bodyLarge,
        strong: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        code: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: scheme.surfaceContainerHighest,
        ),
        codeblockDecoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: scheme.primary, width: 4),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
        a: TextStyle(color: scheme.primary),
      ),
    );
  }
}

/// Opens a markdown file in a fullscreen in-app reader.
Future<void> openMarkdownViewer(
  BuildContext context, {
  required String filePath,
  ValueChanged<String>? onNavigateToFile,
  String? highlightQuery,
}) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    if (context.mounted) {
      AppSnackBar.show(context, 'File is missing');
    }
    return;
  }

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _MarkdownViewerDialog(
      initialFilePath: filePath,
      onNavigateToFile: onNavigateToFile,
      highlightQuery: highlightQuery,
    ),
  );
}

class _MarkdownViewerDialog extends StatefulWidget {
  const _MarkdownViewerDialog({
    required this.initialFilePath,
    this.onNavigateToFile,
    this.highlightQuery,
  });

  final String initialFilePath;
  final ValueChanged<String>? onNavigateToFile;
  final String? highlightQuery;

  @override
  State<_MarkdownViewerDialog> createState() => _MarkdownViewerDialogState();
}

class _MarkdownViewerDialogState extends State<_MarkdownViewerDialog> {
  late String _filePath;
  late Future<String> _content;
  String? _highlightQuery;

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialFilePath;
    _highlightQuery = widget.highlightQuery;
    _content = _readFile(_filePath);
  }

  Future<String> _readFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('File is missing', path);
    }
    return file.readAsString();
  }

  void _navigateTo(String path) {
    widget.onNavigateToFile?.call(path);
    setState(() {
      _filePath = path;
      _highlightQuery = null;
      _content = _readFile(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fileName = displayNameFromPath(_filePath, isFolder: false);

    return Dialog.fullscreen(
      backgroundColor: scheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Open with system app',
                    onPressed: () => openDocumentExternally(_filePath),
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<String>(
                future: _content,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Could not read file',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return MarkdownPreview(
                    data: snapshot.data!,
                    baseFilePath: _filePath,
                    onNavigateToFile: _navigateTo,
                    highlightQuery: _highlightQuery,
                    padding: EdgeInsets.zero,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens http(s) links and unresolved paths with the OS default handler.
Future<void> openExternalLink(String href) async {
  if (Platform.isAndroid || Platform.isIOS) {
    await OpenFilex.open(href);
    return;
  }
  if (Platform.isLinux) {
    await Process.run('xdg-open', [href]);
  } else if (Platform.isMacOS) {
    await Process.run('open', [href]);
  } else if (Platform.isWindows) {
    await Process.run('cmd', ['/c', 'start', '', href]);
  }
}

/// Opens the file with the OS default app.
Future<void> openDocumentExternally(String filePath) async {
  await openExternalLink(Uri.file(filePath).toString());
}

