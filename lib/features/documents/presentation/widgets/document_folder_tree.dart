import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:gizecare/features/documents/domain/document_format.dart';
import 'package:gizecare/features/documents/presentation/display_name.dart';

/// Kept for callers that still expect the old name.
bool isMarkdownFile(String path) => isMarkdownDocument(path);

IconData documentIconForPath(String path) {
  return switch (documentFormatForPath(path)) {
    DocumentFormat.pdf => Icons.picture_as_pdf_outlined,
    DocumentFormat.epub => Icons.menu_book_outlined,
    DocumentFormat.markdown || null => Icons.article_outlined,
  };
}

/// A folder or document file node in the documents sidebar tree.
class DocumentTreeNode {
  const DocumentTreeNode({
    required this.name,
    required this.path,
    required this.isFolder,
    this.children = const [],
  });

  final String name;
  final String path;
  final bool isFolder;
  final List<DocumentTreeNode> children;

  bool get hasSubfolders =>
      isFolder && children.any((child) => child.isFolder);
}

int _compareEntities(FileSystemEntity a, FileSystemEntity b) {
  final aIsDir = a is Directory;
  final bIsDir = b is Directory;
  if (aIsDir != bIsDir) return aIsDir ? -1 : 1;
  return p.basename(a.path).toLowerCase().compareTo(
        p.basename(b.path).toLowerCase(),
      );
}

/// Builds the top-level children for [directory] (files and subfolders).
List<DocumentTreeNode> buildDocumentTreeChildren(Directory directory) {
  final nodes = <DocumentTreeNode>[];

  List<FileSystemEntity> entities;
  try {
    entities = directory.listSync(followLinks: false).toList()
      ..sort(_compareEntities);
  } on FileSystemException {
    return nodes;
  }

  for (final entity in entities) {
    if (entity is Directory) {
      final child = _buildFolderNode(entity);
      if (child != null) nodes.add(child);
    } else if (entity is File && isReadableDocumentFile(entity.path)) {
      nodes.add(
        DocumentTreeNode(
          name: p.basename(entity.path),
          path: entity.path,
          isFolder: false,
        ),
      );
    }
  }

  return nodes;
}

DocumentTreeNode? _buildFolderNode(Directory directory) {
  final children = buildDocumentTreeChildren(directory);
  if (children.isEmpty) return null;

  return DocumentTreeNode(
    name: p.basename(directory.path),
    path: directory.path,
    isFolder: true,
    children: children,
  );
}

/// Flattens readable document file paths from a tree.
List<String> collectDocumentPaths(List<DocumentTreeNode> nodes) {
  final paths = <String>[];
  for (final node in nodes) {
    if (node.isFolder) {
      paths.addAll(collectDocumentPaths(node.children));
    } else {
      paths.add(node.path);
    }
  }
  paths.sort();
  return paths;
}

/// Alias kept for older call sites.
List<String> collectMarkdownPaths(List<DocumentTreeNode> nodes) =>
    collectDocumentPaths(nodes);


/// Returns folder paths that must be expanded to reveal [filePath].
List<String> folderAncestorPaths(String filePath, String rootPath) {
  final relative = p.relative(filePath, from: rootPath);
  final segments = p.split(relative);
  if (segments.length <= 1) return const [];

  final ancestors = <String>[];
  var current = rootPath;
  for (var i = 0; i < segments.length - 1; i++) {
    current = p.join(current, segments[i]);
    ancestors.add(current);
  }
  return ancestors;
}

/// Keeps folders that contain visible files and matching file nodes.
List<DocumentTreeNode> pruneDocumentTree(
  List<DocumentTreeNode> nodes,
  Set<String> visibleFilePaths,
) {
  final pruned = <DocumentTreeNode>[];

  for (final node in nodes) {
    if (node.isFolder) {
      final children = pruneDocumentTree(node.children, visibleFilePaths);
      if (children.isNotEmpty) {
        pruned.add(
          DocumentTreeNode(
            name: node.name,
            path: node.path,
            isFolder: true,
            children: children,
          ),
        );
      }
    } else if (visibleFilePaths.contains(node.path)) {
      pruned.add(node);
    }
  }

  return pruned;
}

/// Collects all folder paths in [nodes] (for auto-expand during search).
Set<String> collectFolderPaths(List<DocumentTreeNode> nodes) {
  final paths = <String>{};
  for (final node in nodes) {
    if (node.isFolder) {
      paths.add(node.path);
      paths.addAll(collectFolderPaths(node.children));
    }
  }
  return paths;
}

/// Expandable tree for browsing documents inside a folder.
class DocumentFolderTree extends StatelessWidget {
  const DocumentFolderTree({
    required this.nodes,
    required this.rootPath,
    required this.selectedFilePath,
    required this.expandedFolders,
    required this.onToggleFolder,
    required this.onSelectFile,
    this.searchQuery = '',
    this.snippetForFile,
    super.key,
  });

  final List<DocumentTreeNode> nodes;
  final String rootPath;
  final String? selectedFilePath;
  final Set<String> expandedFolders;
  final ValueChanged<String> onToggleFolder;
  final ValueChanged<String> onSelectFile;
  final String searchQuery;
  final String? Function(String filePath)? snippetForFile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 0, 12, 28),
      children: [
        for (var i = 0; i < nodes.length; i++)
          _DocumentTreeTile(
            node: nodes[i],
            depth: 0,
            rootPath: rootPath,
            selectedFilePath: selectedFilePath,
            expandedFolders: expandedFolders,
            onToggleFolder: onToggleFolder,
            onSelectFile: onSelectFile,
            searchQuery: searchQuery,
            snippetForFile: snippetForFile,
          ),
      ],
    );
  }
}

class _DocumentTreeTile extends StatelessWidget {
  const _DocumentTreeTile({
    required this.node,
    required this.depth,
    required this.rootPath,
    required this.selectedFilePath,
    required this.expandedFolders,
    required this.onToggleFolder,
    required this.onSelectFile,
    required this.searchQuery,
    this.snippetForFile,
  });

  final DocumentTreeNode node;
  final int depth;
  final String rootPath;
  final String? selectedFilePath;
  final Set<String> expandedFolders;
  final ValueChanged<String> onToggleFolder;
  final ValueChanged<String> onSelectFile;
  final String searchQuery;
  final String? Function(String filePath)? snippetForFile;

  @override
  Widget build(BuildContext context) {
    if (node.isFolder) {
      return _buildFolderTile(context);
    }
    return _buildFileTile(context, node.path, node.name);
  }

  Widget _buildFolderTile(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final expanded = expandedFolders.contains(node.path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: depth * 14.0, bottom: 4),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onToggleFolder(node.path),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      expanded
                          ? Icons.folder_open_rounded
                          : Icons.folder_rounded,
                      size: 18,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formatDisplayTitle(node.name, isFolder: true),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (expanded)
          for (final child in node.children)
            _DocumentTreeTile(
              node: child,
              depth: depth + 1,
              rootPath: rootPath,
              selectedFilePath: selectedFilePath,
              expandedFolders: expandedFolders,
              onToggleFolder: onToggleFolder,
              onSelectFile: onSelectFile,
              searchQuery: searchQuery,
              snippetForFile: snippetForFile,
            ),
      ],
    );
  }

  Widget _buildFileTile(BuildContext context, String path, String label) {
    final scheme = Theme.of(context).colorScheme;
    final selected = path == selectedFilePath;
    final snippet = snippetForFile?.call(path);

    return Padding(
      padding: EdgeInsets.only(left: depth * 14.0, bottom: 6),
      child: Material(
        color: selected
            ? scheme.primary.withValues(alpha: 0.12)
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelectFile(path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  documentIconForPath(path),
                  size: 18,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDisplayTitle(label, isFolder: false),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: selected ? scheme.primary : null,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (snippet != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          snippet,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
