import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/documents/data/document_history_store.dart';
import 'package:gizecare/features/documents/domain/document_format.dart';
import 'package:gizecare/features/documents/domain/entities/document_history_entry.dart';
import 'package:gizecare/features/documents/presentation/display_name.dart';
import 'package:gizecare/features/documents/presentation/document_reader_dialog.dart';
import 'package:gizecare/features/documents/presentation/markdown_viewer.dart';
import 'package:gizecare/features/documents/presentation/widgets/document_folder_tree.dart';
import 'package:gizecare/features/documents/presentation/widgets/epub_document_reader.dart';
import 'package:gizecare/features/documents/presentation/widgets/pdf_document_reader.dart';

String _formatAccessedAt(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat.yMMMd().format(time.toLocal());
}

/// Pick and preview local markdown, PDF, and EPUB files or folders.
class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final DocumentHistoryStore _historyStore;
  List<DocumentHistoryEntry> _history = const [];
  String? _folderPath;
  List<DocumentTreeNode> _treeNodes = const [];
  Set<String> _expandedFolders = {};
  List<String> _allFolderFiles = const [];
  List<String> _folderFiles = const [];
  String? _filePath;
  String? _content;
  String? _error;
  String _searchQuery = '';
  String? _highlightQuery;

  @override
  void initState() {
    super.initState();
    _historyStore = DocumentHistoryStore(ref.read(settingsRepositoryProvider));
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final entries = await _historyStore.load();
    if (!mounted) return;
    setState(() => _history = entries);
  }

  List<String> _filterFiles(List<String> files, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return files;

    return files.where((path) {
      final relativePath = _folderPath == null
          ? p.basename(path).toLowerCase()
          : p.relative(path, from: _folderPath!).toLowerCase();
      if (relativePath.contains(normalizedQuery)) return true;

      // Content search only for text markdown; skip binary PDF/EPUB.
      if (!isMarkdownDocument(path)) return false;

      try {
        final content = File(path).readAsStringSync().toLowerCase();
        return content.contains(normalizedQuery);
      } on FileSystemException {
        return false;
      }
    }).toList();
  }

  String? _contentMatchSnippet(String path, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty || !isMarkdownDocument(path)) return null;

    try {
      final content = File(path).readAsStringSync();
      final index = content.toLowerCase().indexOf(normalizedQuery);
      if (index < 0) return null;

      const context = 40;
      final start = (index - context).clamp(0, content.length);
      final end = (index + normalizedQuery.length + context).clamp(0, content.length);
      final snippet = content.substring(start, end).replaceAll(RegExp(r'\s+'), ' ').trim();

      final prefix = start > 0 ? '…' : '';
      final suffix = end < content.length ? '…' : '';
      return '$prefix$snippet$suffix';
    } on FileSystemException {
      return null;
    }
  }

  void _updateSearch(String query) {
    final filteredFiles = _filterFiles(_allFolderFiles, query);
    final normalizedQuery = query.trim();
    setState(() {
      _searchQuery = query;
      _folderFiles = filteredFiles;
      if (normalizedQuery.isEmpty) {
        _highlightQuery = null;
        _expandedFolders = {};
      } else if (_folderPath != null) {
        final pruned = pruneDocumentTree(
          _treeNodes,
          filteredFiles.toSet(),
        );
        _expandedFolders = collectFolderPaths(pruned);
      }
      if (_filePath != null && !filteredFiles.contains(_filePath)) {
        _filePath = null;
        _content = null;
        _highlightQuery = null;
      }
    });
  }

  void _toggleFolder(String folderPath) {
    setState(() {
      if (_expandedFolders.contains(folderPath)) {
        _expandedFolders = Set.of(_expandedFolders)..remove(folderPath);
      } else {
        _expandedFolders = Set.of(_expandedFolders)..add(folderPath);
      }
    });
  }

  void _expandFoldersForFile(String filePath) {
    if (_folderPath == null) return;
    final ancestors = folderAncestorPaths(filePath, _folderPath!);
    if (ancestors.isEmpty) return;
    setState(() {
      _expandedFolders = Set.of(_expandedFolders)..addAll(ancestors);
    });
  }

  Future<void> _recordCurrentBrowsing() async {
    if (_folderPath != null) {
      await _historyStore.recordFolder(
        _folderPath!,
        lastFilePath: _filePath,
      );
    } else if (_filePath != null) {
      await _historyStore.recordFile(_filePath!);
    }
    await _loadHistory();
  }

  Future<void> _loadFile(
    String path, {
    String? scrollToQuery,
    bool expandTreePath = true,
  }) async {
    final file = File(path);
    if (!file.existsSync()) {
      setState(() {
        _error = 'File not found';
        _filePath = null;
        _content = null;
        _highlightQuery = null;
      });
      return;
    }

    final format = documentFormatForPath(path);
    if (format == null) {
      setState(() {
        _error = 'Unsupported file type';
        _filePath = null;
        _content = null;
        _highlightQuery = null;
      });
      return;
    }

    try {
      if (format == DocumentFormat.markdown) {
        final text = await file.readAsString();
        if (!mounted) return;
        final query = scrollToQuery?.trim();
        setState(() {
          _filePath = path;
          _content = text;
          _error = null;
          _highlightQuery = query == null || query.isEmpty ? null : query;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _filePath = path;
          _content = null;
          _error = null;
          _highlightQuery = null;
        });
      }
      if (expandTreePath) {
        _expandFoldersForFile(path);
      }
      await _recordCurrentBrowsing();
    } on FileSystemException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _filePath = null;
        _content = null;
        _highlightQuery = null;
      });
    }
  }

  Future<void> _openFile() async {
    final file = await openFile(acceptedTypeGroups: documentFileTypeGroups);
    if (file == null || !mounted) return;

    setState(() {
      _folderPath = null;
      _treeNodes = const [];
      _expandedFolders = {};
      _allFolderFiles = const [];
      _folderFiles = const [];
      _searchQuery = '';
    });
    _searchController.clear();
    await _loadFile(file.path);
  }

  Future<void> _openFolder() async {
    final directoryPath = await getDirectoryPath();
    if (directoryPath == null || !mounted) return;

    await _refreshFolder(directoryPath: directoryPath, preserveSelection: false);
  }

  Future<void> _openFromHistory(DocumentHistoryEntry entry) async {
    switch (entry.kind) {
      case DocumentHistoryKind.file:
        setState(() {
          _folderPath = null;
          _treeNodes = const [];
          _expandedFolders = {};
          _allFolderFiles = const [];
          _folderFiles = const [];
          _searchQuery = '';
        });
        _searchController.clear();
        await _loadFile(entry.path);
      case DocumentHistoryKind.folder:
        await _refreshFolder(
          directoryPath: entry.path,
          preferredFilePath: entry.lastFilePath,
          preserveSelection: false,
        );
    }
  }

  Future<void> _removeHistoryEntry(String path) async {
    await _historyStore.remove(path);
    await _loadHistory();
  }

  Future<void> _clearHistory() async {
    await _historyStore.clear();
    await _loadHistory();
  }

  Future<void> _refreshFolder({
    String? directoryPath,
    String? preferredFilePath,
    bool preserveSelection = true,
  }) async {
    final targetPath = directoryPath ?? _folderPath;
    if (targetPath == null) return;

    final directory = Directory(targetPath);
    if (!directory.existsSync()) {
      setState(() {
        _error = 'Folder not found';
        _folderPath = null;
        _treeNodes = const [];
        _expandedFolders = {};
        _allFolderFiles = const [];
        _folderFiles = const [];
        _filePath = null;
        _content = null;
      });
      return;
    }

    final treeNodes = buildDocumentTreeChildren(directory);
    final files = collectDocumentPaths(treeNodes);
    if (!mounted) return;

    final previousPath = _folderPath;
    final isSameFolder = previousPath == targetPath;
    final query = isSameFolder ? _searchQuery : '';
    final filteredFiles = _filterFiles(files, query);

    final nextFile = preferredFilePath != null && filteredFiles.contains(preferredFilePath)
        ? preferredFilePath
        : preserveSelection && _filePath != null && filteredFiles.contains(_filePath)
            ? _filePath
            : (filteredFiles.isEmpty ? null : filteredFiles.first);

    setState(() {
      _folderPath = targetPath;
      _treeNodes = treeNodes;
      _expandedFolders = {};
      _allFolderFiles = files;
      _folderFiles = filteredFiles;
      _searchQuery = query;
    });
    if (!isSameFolder) {
      _searchController.clear();
    }

    if (filteredFiles.isEmpty) {
      setState(() {
        _error = files.isEmpty
            ? 'No markdown, PDF, or EPUB files found in this folder'
            : 'No search results found';
        _filePath = null;
        _content = null;
      });
      await _recordCurrentBrowsing();
      return;
    }

    await _loadFile(nextFile!, expandTreePath: false);
  }

  void _showHistorySheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> refreshSheet() async {
              await _loadHistory();
              setSheetState(() {});
            }

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Recent browsing',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (_history.isNotEmpty)
                          TextButton(
                            onPressed: () async {
                              await _clearHistory();
                              if (context.mounted) {
                                setSheetState(() {});
                              }
                            },
                            child: const Text('Clear all'),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _history.isEmpty
                        ? Center(
                            child: Text(
                              'No recent files or folders yet',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: _history.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final entry = _history[index];
                              return _HistoryTile(
                                entry: entry,
                                onOpen: () {
                                  Navigator.of(sheetContext).pop();
                                  _openFromHistory(entry);
                                },
                                onRemove: () async {
                                  await _removeHistoryEntry(entry.path);
                                  if (context.mounted) {
                                    await refreshSheet();
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _filePath == null
        ? null
        : displayNameFromPath(_filePath!, isFolder: false);
    final hasFolder = _folderPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Documents',
          subtitle: 'Open markdown, PDF, or EPUB files and folders',
          actions: [
            if (_history.isNotEmpty)
              IconButton(
                tooltip: 'Recent browsing',
                onPressed: _showHistorySheet,
                icon: const Icon(Icons.history_rounded),
              ),
            if (hasFolder)
              IconButton(
                tooltip: 'Refresh folder',
                onPressed: _refreshFolder,
                icon: const Icon(Icons.refresh_rounded),
              ),
            if (_filePath != null)
              IconButton(
                tooltip: 'Open fullscreen',
                onPressed: () => openDocumentViewer(
                  context,
                  filePath: _filePath!,
                  onNavigateToFile: _loadFile,
                  highlightQuery: _highlightQuery,
                ),
                icon: const Icon(Icons.fullscreen_rounded),
              ),
            OutlinedButton.icon(
              onPressed: _openFolder,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('Open folder'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _openFile,
              icon: const Icon(Icons.description_outlined),
              label: const Text('Open file'),
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: AppPanel(
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_error!)),
                ],
              ),
            ),
          ),
        Expanded(
          child: hasFolder
              ? _buildFolderLayout(context, fileName)
              : _buildBody(context, fileName),
        ),
      ],
    );
  }

  Widget _buildHistorySection({EdgeInsetsGeometry? padding}) {
    if (_history.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: _showHistorySheet,
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final entry in _history.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _HistoryTile(
                entry: entry,
                onOpen: () => _openFromHistory(entry),
                onRemove: () => _removeHistoryEntry(entry.path),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFolderLayout(BuildContext context, String? fileName) {
    final scheme = Theme.of(context).colorScheme;
    final folderName = displayNameFromPath(_folderPath!, isFolder: true);
    final hasSubfolders = _treeNodes.any((node) => node.isFolder);
    final displayNodes = _searchQuery.trim().isEmpty
        ? _treeNodes
        : pruneDocumentTree(_treeNodes, _folderFiles.toSet());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 12, 8),
                child: AppPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.folder_outlined, color: scheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              folderName,
                              style: Theme.of(context).textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              hasSubfolders
                                  ? '${_folderFiles.length} of ${_allFolderFiles.length} file${_allFolderFiles.length == 1 ? '' : 's'} · tree view'
                                  : '${_folderFiles.length} of ${_allFolderFiles.length} document${_allFolderFiles.length == 1 ? '' : 's'}',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search files and contents',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              _updateSearch('');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
              ),
              Expanded(
                child: _folderFiles.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _allFolderFiles.isEmpty
                                ? 'No readable documents in this folder'
                                : 'No files match your search',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : DocumentFolderTree(
                        nodes: displayNodes,
                        rootPath: _folderPath!,
                        selectedFilePath: _filePath,
                        expandedFolders: _expandedFolders,
                        onToggleFolder: _toggleFolder,
                        onSelectFile: (path) => _loadFile(
                          path,
                          scrollToQuery: _searchQuery.trim().isEmpty
                              ? null
                              : _searchQuery,
                        ),
                        searchQuery: _searchQuery,
                        snippetForFile: _searchQuery.trim().isEmpty
                            ? null
                            : (path) => _contentMatchSnippet(path, _searchQuery),
                      ),
              ),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: scheme.outline.withValues(alpha: 0.2)),
        Expanded(child: _buildPreview(context, fileName)),
      ],
    );
  }

  Widget _buildBody(BuildContext context, String? fileName) {
    if (_filePath == null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No file open',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a markdown, PDF, or EPUB file or folder',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton.icon(
                    onPressed: _openFolder,
                    icon: const Icon(Icons.create_new_folder_outlined),
                    label: const Text('Open folder'),
                  ),
                  FilledButton.icon(
                    onPressed: _openFile,
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Open file'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildHistorySection(),
            ],
          ),
        ),
      );
    }

    return _buildPreview(context, fileName);
  }

  Widget _buildPreview(BuildContext context, String? fileName) {
    final path = _filePath;
    if (path == null) {
      return const SizedBox.shrink();
    }

    final format = documentFormatForPath(path);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(_folderPath == null ? 28 : 16, 0, 28, 8),
          child: AppPanel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(documentIconForPath(path), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fileName ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => openDocumentExternally(path),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Open externally'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: switch (format) {
            DocumentFormat.markdown when _content != null => MarkdownPreview(
                key: ValueKey('$path|${_highlightQuery ?? ''}'),
                data: _content!,
                baseFilePath: path,
                onNavigateToFile: (next) => _loadFile(next),
                highlightQuery: _highlightQuery,
                padding: EdgeInsets.fromLTRB(
                  _folderPath == null ? 28 : 16,
                  16,
                  28,
                  28,
                ),
              ),
            DocumentFormat.pdf => PdfDocumentReader(
                key: ValueKey(path),
                filePath: path,
                padding: EdgeInsets.fromLTRB(
                  _folderPath == null ? 28 : 16,
                  0,
                  28,
                  16,
                ),
              ),
            DocumentFormat.epub => EpubDocumentReader(
                key: ValueKey(path),
                filePath: path,
                padding: EdgeInsets.fromLTRB(
                  _folderPath == null ? 28 : 16,
                  0,
                  28,
                  16,
                ),
              ),
            _ => Center(
                child: Text(
                  'Could not preview this file',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
          },
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.onOpen,
    required this.onRemove,
  });

  final DocumentHistoryEntry entry;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFolder = entry.kind == DocumentHistoryKind.folder;
    final title = displayNameFromPath(
      entry.path,
      isFolder: isFolder,
    );
    final subtitle = isFolder
        ? entry.lastFilePath == null
            ? entry.path
            : '${entry.path}\nLast file: ${displayNameFromPath(entry.lastFilePath!, isFolder: false)}'
        : entry.path;

    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isFolder
                    ? Icons.folder_outlined
                    : documentIconForPath(entry.path),
                size: 20,
                color: scheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAccessedAt(entry.accessedAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from history',
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
