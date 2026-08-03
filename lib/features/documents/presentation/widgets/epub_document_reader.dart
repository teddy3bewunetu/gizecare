import 'dart:io';
import 'dart:typed_data';

import 'package:epub_pro/epub_pro.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path/path.dart' as p;

class _TocEntry {
  const _TocEntry({
    required this.title,
    required this.html,
    required this.depth,
  });

  final String title;
  final String html;
  final int depth;
}

/// In-app EPUB reader: TOC + HTML chapter body.
class EpubDocumentReader extends StatefulWidget {
  const EpubDocumentReader({
    required this.filePath,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final String filePath;
  final EdgeInsets padding;

  @override
  State<EpubDocumentReader> createState() => _EpubDocumentReaderState();
}

class _EpubDocumentReaderState extends State<EpubDocumentReader> {
  late Future<_EpubLoadResult> _loadFuture;
  int _chapterIndex = 0;
  final ScrollController _bodyScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadBook(widget.filePath);
  }

  @override
  void didUpdateWidget(EpubDocumentReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _chapterIndex = 0;
      _loadFuture = _loadBook(widget.filePath);
    }
  }

  @override
  void dispose() {
    _bodyScroll.dispose();
    super.dispose();
  }

  Future<_EpubLoadResult> _loadBook(String path) async {
    final bytes = await File(path).readAsBytes();
    final book = await EpubReader.readBook(bytes);
    final toc = <_TocEntry>[];
    void walk(List<EpubChapter> chapters, int depth) {
      for (final chapter in chapters) {
        final html = chapter.htmlContent?.trim() ?? '';
        if (html.isNotEmpty) {
          toc.add(
            _TocEntry(
              title: (chapter.title?.trim().isNotEmpty ?? false)
                  ? chapter.title!.trim()
                  : (chapter.contentFileName ?? 'Chapter ${toc.length + 1}'),
              html: html,
              depth: depth,
            ),
          );
        }
        if (chapter.subChapters.isNotEmpty) {
          walk(chapter.subChapters, depth + 1);
        }
      }
    }

    walk(book.chapters, 0);

    if (toc.isEmpty) {
      final htmlFiles = book.content?.html ?? {};
      for (final entry in htmlFiles.entries) {
        final html = entry.value.content?.trim() ?? '';
        if (html.isEmpty) continue;
        toc.add(
          _TocEntry(
            title: p.basenameWithoutExtension(entry.key),
            html: html,
            depth: 0,
          ),
        );
      }
    }

    final images = <String, Uint8List>{};
    final rawImages = book.content?.images ?? {};
    for (final entry in rawImages.entries) {
      final data = entry.value.content;
      if (data == null || data.isEmpty) continue;
      final bytesList = Uint8List.fromList(data);
      images[entry.key] = bytesList;
      images[p.basename(entry.key)] = bytesList;
    }

    return _EpubLoadResult(
      title: book.title?.trim().isNotEmpty == true
          ? book.title!.trim()
          : p.basenameWithoutExtension(path),
      author: book.author?.trim(),
      chapters: toc,
      images: images,
    );
  }

  void _selectChapter(int index) {
    if (index == _chapterIndex) return;
    setState(() => _chapterIndex = index);
    if (_bodyScroll.hasClients) {
      _bodyScroll.jumpTo(0);
    }
  }

  Uint8List? _resolveImage(String? src, Map<String, Uint8List> images) {
    if (src == null || src.isEmpty) return null;
    final cleaned = src.split('?').first.split('#').first;
    if (images.containsKey(cleaned)) return images[cleaned];
    final base = p.basename(cleaned);
    if (images.containsKey(base)) return images[base];
    // Try path suffix match (../Images/foo.jpg → Images/foo.jpg)
    for (final key in images.keys) {
      if (cleaned.endsWith(key) || key.endsWith(cleaned) || key.endsWith(base)) {
        return images[key];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<_EpubLoadResult>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined, size: 48, color: scheme.error),
                  const SizedBox(height: 12),
                  Text(
                    'Could not open EPUB',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final book = snapshot.data!;
        if (book.chapters.isEmpty) {
          return Center(
            child: Text(
              'No readable chapters in this EPUB',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          );
        }

        final safeIndex = _chapterIndex.clamp(0, book.chapters.length - 1);
        final chapter = book.chapters[safeIndex];

        return Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: scheme.surfaceContainerHigh,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (book.author != null && book.author!.isNotEmpty)
                        Text(
                          book.author!,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 220,
                      child: Material(
                        color: scheme.surfaceContainerLow,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: book.chapters.length,
                          itemBuilder: (context, index) {
                            final entry = book.chapters[index];
                            final selected = index == safeIndex;
                            return InkWell(
                              onTap: () => _selectChapter(index),
                              child: Container(
                                color: selected
                                    ? scheme.primary.withValues(alpha: 0.12)
                                    : null,
                                padding: EdgeInsets.fromLTRB(
                                  12 + entry.depth * 12.0,
                                  10,
                                  12,
                                  10,
                                ),
                                child: Text(
                                  entry.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: selected
                                            ? scheme.primary
                                            : scheme.onSurface,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: scheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _bodyScroll,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                        child: Html(
                          data: chapter.html,
                          style: {
                            'body': Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.55),
                              color: scheme.onSurface,
                            ),
                            'p': Style(margin: Margins.only(bottom: 12)),
                            'h1': Style(
                              fontSize: FontSize(26),
                              fontWeight: FontWeight.w700,
                              margin: Margins.only(bottom: 12, top: 8),
                            ),
                            'h2': Style(
                              fontSize: FontSize(22),
                              fontWeight: FontWeight.w700,
                              margin: Margins.only(bottom: 10, top: 8),
                            ),
                            'h3': Style(
                              fontSize: FontSize(18),
                              fontWeight: FontWeight.w600,
                              margin: Margins.only(bottom: 8, top: 6),
                            ),
                            'a': Style(color: scheme.primary),
                            'img': Style(
                              alignment: Alignment.center,
                              margin: Margins.symmetric(vertical: 12),
                            ),
                          },
                          extensions: [
                            TagExtension(
                              tagsToExtend: {'img'},
                              builder: (extensionContext) {
                                final src =
                                    extensionContext.attributes['src'];
                                final bytes =
                                    _resolveImage(src, book.images);
                                if (bytes == null) {
                                  return const SizedBox.shrink();
                                }
                                return Image.memory(
                                  bytes,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox.shrink(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EpubLoadResult {
  const _EpubLoadResult({
    required this.title,
    required this.chapters,
    required this.images,
    this.author,
  });

  final String title;
  final String? author;
  final List<_TocEntry> chapters;
  final Map<String, Uint8List> images;
}
