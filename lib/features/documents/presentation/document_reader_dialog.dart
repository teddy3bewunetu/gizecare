import 'package:flutter/material.dart';

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
}) async {
  final format = documentFormatForPath(filePath);
  if (format == null) {
    if (context.mounted) {
      AppSnackBar.show(context, 'Unsupported file type');
    }
    return;
  }

  if (format == DocumentFormat.markdown) {
    await openMarkdownViewer(
      context,
      filePath: filePath,
      onNavigateToFile: onNavigateToFile,
      highlightQuery: highlightQuery,
    );
    return;
  }

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _BinaryDocumentViewerDialog(
      filePath: filePath,
      format: format,
    ),
  );
}

class _BinaryDocumentViewerDialog extends StatelessWidget {
  const _BinaryDocumentViewerDialog({
    required this.filePath,
    required this.format,
  });

  final String filePath;
  final DocumentFormat format;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fileName = displayNameFromPath(filePath, isFolder: false);

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
