import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Persists note images under app support so embeds survive restarts.
abstract final class NoteImageStore {
  static Future<Directory> folderFor(String noteId) async {
    final dir = await getApplicationSupportDirectory();
    final folder = Directory(p.join(dir.path, 'notebook_images', noteId));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  /// Writes [bytes] and returns an absolute file path for Quill image embeds.
  static Future<String> saveBytes(
    String noteId,
    Uint8List bytes, {
    String extension = '.png',
  }) async {
    final folder = await folderFor(noteId);
    final ext = extension.startsWith('.') ? extension : '.$extension';
    final dest = File(p.join(folder.path, '${const Uuid().v4()}$ext'));
    await dest.writeAsBytes(bytes, flush: true);
    return dest.path;
  }

  static Future<String> saveFile(String noteId, String sourcePath) async {
    final bytes = await File(sourcePath).readAsBytes();
    final ext = p.extension(sourcePath).isEmpty ? '.png' : p.extension(sourcePath);
    return saveBytes(noteId, bytes, extension: ext);
  }
}
