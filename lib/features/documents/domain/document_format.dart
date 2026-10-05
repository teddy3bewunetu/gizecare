import 'dart:io';

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

/// Like [documentFormatForPath], but also sniffs PDF magic bytes when the
/// extension is missing (common for Telegram/TDLib downloads).
Future<DocumentFormat?> documentFormatForFile(String path) async {
  final byExt = documentFormatForPath(path);
  if (byExt != null) return byExt;
  try {
    final file = File(path);
    if (!file.existsSync()) return null;
    final raf = await file.open();
    try {
      final header = await raf.read(8);
      if (header.length >= 5) {
        final sig = String.fromCharCodes(header.take(5));
        if (sig.startsWith('%PDF')) return DocumentFormat.pdf;
      }
    } finally {
      await raf.close();
    }
  } catch (_) {}
  return null;
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
