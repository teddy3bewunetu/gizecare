import 'dart:io';

import 'package:path/path.dart' as p;

bool isMarkdownPath(String path) {
  final ext = p.extension(path).toLowerCase();
  return ext == '.md' || ext == '.markdown';
}

/// Whether [href] should be opened in an external app or browser.
bool isExternalLink(String href) {
  final uri = Uri.tryParse(href);
  if (uri == null) return false;
  return uri.hasScheme &&
      uri.scheme != 'file' &&
      uri.scheme != '' &&
      !p.isAbsolute(href);
}

/// Resolves a markdown [href] from [currentFilePath] to a local markdown file.
///
/// Returns `null` when the link is external, anchor-only, or cannot be resolved.
String? resolveMarkdownFileLink({
  required String href,
  required String currentFilePath,
}) {
  if (href.isEmpty || href.startsWith('#')) return null;

  final hashIndex = href.indexOf('#');
  final pathPart = hashIndex >= 0 ? href.substring(0, hashIndex) : href;
  if (pathPart.isEmpty) return null;

  final uri = Uri.tryParse(pathPart);
  if (uri != null && uri.hasScheme && uri.scheme != 'file') {
    return null;
  }

  String resolved;
  if (uri != null && uri.scheme == 'file') {
    resolved = uri.toFilePath();
  } else if (p.isAbsolute(pathPart)) {
    resolved = p.normalize(pathPart);
  } else {
    resolved = p.normalize(p.join(p.dirname(currentFilePath), pathPart));
  }

  if (File(resolved).existsSync() && isMarkdownPath(resolved)) {
    return resolved;
  }

  if (!isMarkdownPath(resolved)) {
    final withMd = '$resolved.md';
    if (File(withMd).existsSync()) return withMd;

    final withMarkdown = '$resolved.markdown';
    if (File(withMarkdown).existsSync()) return withMarkdown;
  }

  return null;
}
