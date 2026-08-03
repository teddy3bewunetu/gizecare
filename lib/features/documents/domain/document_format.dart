import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;

/// Supported in-app document reader formats.
enum DocumentFormat { markdown, pdf, epub }

/// Detects a readable document format from [path], or null if unsupported.
DocumentFormat? documentFormatForPath(String path) {
  final ext = p.extension(path).toLowerCase();
  return switch (ext) {
    '.md' || '.markdown' => DocumentFormat.markdown,
    '.pdf' => DocumentFormat.pdf,
    '.epub' => DocumentFormat.epub,
    _ => null,
  };
}

bool isReadableDocumentFile(String path) => documentFormatForPath(path) != null;

bool isMarkdownDocument(String path) =>
    documentFormatForPath(path) == DocumentFormat.markdown;

/// File picker groups for Open file.
const documentFileTypeGroups = <XTypeGroup>[
  XTypeGroup(
    label: 'Documents',
    extensions: ['md', 'markdown', 'pdf', 'epub'],
  ),
  XTypeGroup(
    label: 'Markdown',
    extensions: ['md', 'markdown'],
  ),
  XTypeGroup(
    label: 'PDF',
    extensions: ['pdf'],
  ),
  XTypeGroup(
    label: 'EPUB',
    extensions: ['epub'],
  ),
];
