import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/documents/domain/document_format.dart';
import 'package:gizecare/features/documents/presentation/display_name.dart';
import 'package:gizecare/features/documents/presentation/markdown_viewer.dart';
import 'package:gizecare/features/documents/presentation/widgets/epub_document_reader.dart';
import 'package:gizecare/features/documents/presentation/widgets/pdf_document_reader.dart';

/// Opens a document (markdown / PDF / EPUB) in a fullscreen in-app reader.
Future<void> openDocumentViewer(
  BuildContext context, {
  required String filePath,
  ValueChanged<String>? onNavigateToFile,
  String? highlightQuery,
  String? displayName,
}) async {
  var path = filePath;
  var format = await documentFormatForFile(path);
  // TDLib often stores files without an extension — copy to a temp name so
  // readers that key off the path suffix still work.
  if (format == DocumentFormat.pdf && documentFormatForPath(path) == null) {
    final base =
        displayName != null && displayName.toLowerCase().endsWith('.pdf')
            ? displayName
            : '${p.basename(path)}.pdf';
    final dest = p.join(
      Directory.systemTemp.path,
      'gizecare_tg_${DateTime.now().millisecondsSinceEpoch}_$base',
    );
    await File(path).copy(dest);
    path = dest;
    format = DocumentFormat.pdf;
  }
  if (!context.mounted) return;
  if (format == null) {
    AppSnackBar.show(context, 'Unsupported file type');
    return;
  }

  if (format == DocumentFormat.markdown) {
    await openMarkdownViewer(
      context,
      filePath: path,
      onNavigateToFile: onNavigateToFile,
      highlightQuery: highlightQuery,
    );
    return;
  }

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _BinaryDocumentViewerDialog(
      filePath: path,
      format: format!,
      titleOverride: displayName,
    ),
  );
}

class _BinaryDocumentViewerDialog extends StatelessWidget {
  const _BinaryDocumentViewerDialog({
    required this.filePath,
    required this.format,
    this.titleOverride,
  });

  final String filePath;
  final DocumentFormat format;
  final String? titleOverride;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fileName = (titleOverride != null && titleOverride!.trim().isNotEmpty)
        ? titleOverride!.trim()
        : displayNameFromPath(filePath, isFolder: false);

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
                    onPressed: () => openDocumentExternally(filePath),
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
              child: switch (format) {
                DocumentFormat.pdf => PdfDocumentReader(filePath: filePath),
                DocumentFormat.epub => EpubDocumentReader(filePath: filePath),
                DocumentFormat.markdown => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
