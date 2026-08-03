import 'package:path/path.dart' as p;

/// Turns raw file/folder names into readable title-style labels.
///
/// Examples:
/// - `getting_started.md` → `Getting Started`
/// - `api-reference` → `Api Reference`
/// - `README.md` → `README`
String formatDisplayTitle(String rawName, {required bool isFolder}) {
  var name = rawName.trim();
  if (name.isEmpty) return name;

  if (!isFolder) {
    name = p.basenameWithoutExtension(name);
  }

  final words = name
      .replaceAll(RegExp(r'[_\-\.+]+'), ' ')
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty);

  return words.map(_titleCaseWord).join(' ');
}

/// Formats the last segment of [path] for display.
String displayNameFromPath(String path, {required bool isFolder}) {
  return formatDisplayTitle(p.basename(path), isFolder: isFolder);
}

String _titleCaseWord(String word) {
  if (word.isEmpty) return word;

  final hasLetter = word.contains(RegExp(r'[A-Za-z]'));
  if (hasLetter && word == word.toUpperCase()) {
    return word;
  }

  if (word.length == 1) {
    return word.toUpperCase();
  }

  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}
