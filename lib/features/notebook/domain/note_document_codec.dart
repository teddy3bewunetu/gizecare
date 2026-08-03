import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Encode / decode Quill [Document] for Drift `Notes.body` storage.
///
/// New notes store `{"ops":[...]}`. Legacy AppFlowy `{"document":...}` and
/// plain/markdown bodies are migrated on first load.
abstract final class NoteDocumentCodec {
  static bool looksLikeQuillJson(String body) {
    final trimmed = body.trimLeft();
    if (trimmed.startsWith('[')) return true;
    return trimmed.startsWith('{') && trimmed.contains('"ops"');
  }

  static bool looksLikeAppFlowyJson(String body) {
    final trimmed = body.trimLeft();
    return trimmed.startsWith('{') && trimmed.contains('"document"');
  }

  /// True when [body] is structured editor JSON (Quill or legacy AppFlowy).
  static bool looksLikeDocumentJson(String body) {
    return looksLikeQuillJson(body) || looksLikeAppFlowyJson(body);
  }

  static Document blank({bool withInitialText = true}) {
    return Document();
  }

  /// Seeds a document with a single unchecked checklist item.
  static Document checklistSeed() {
    return Document.fromJson(const [
      {
        'insert': '\n',
        'attributes': {'list': 'unchecked'},
      },
    ]);
  }

  static String encode(Document document) {
    return jsonEncode(<String, dynamic>{
      'ops': document.toDelta().toJson(),
    });
  }

  /// Decode stored body, migrating legacy formats if needed.
  static Document decode(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) {
      return blank();
    }
    if (looksLikeQuillJson(trimmed)) {
      try {
        return _decodeQuill(trimmed);
      } catch (_) {
        // Fall through.
      }
    }
    if (looksLikeAppFlowyJson(trimmed)) {
      try {
        final map = jsonDecode(trimmed) as Map<String, dynamic>;
        return fromAppFlowyJson(map);
      } catch (_) {
        // Fall through.
      }
    }
    return fromLegacyPlainText(body);
  }

  static Document _decodeQuill(String trimmed) {
    final decoded = jsonDecode(trimmed);
    if (decoded is List) {
      return Document.fromJson(decoded);
    }
    if (decoded is Map<String, dynamic>) {
      final ops = decoded['ops'];
      if (ops is List) {
        return Document.fromJson(ops);
      }
    }
    return blank();
  }

  /// Convert legacy AppFlowy document JSON into a Quill [Document].
  static Document fromAppFlowyJson(Map<String, dynamic> map) {
    final root = map['document'];
    if (root is! Map) return blank();
    final ops = <Map<String, dynamic>>[];
    final children = root['children'];
    if (children is List) {
      for (final child in children) {
        if (child is Map) {
          _appendAppFlowyNode(Map<String, dynamic>.from(child), ops);
        }
      }
    }
    if (ops.isEmpty) return blank();
    // Quill documents must end with a newline op.
    final last = ops.last;
    final lastInsert = last['insert'];
    if (lastInsert is! String || !lastInsert.endsWith('\n')) {
      ops.add(<String, dynamic>{'insert': '\n'});
    }
    try {
      return Document.fromJson(ops);
    } catch (_) {
      return fromLegacyPlainText(_plainFromAppFlowyOps(ops));
    }
  }

  static void _appendAppFlowyNode(
    Map<String, dynamic> node,
    List<Map<String, dynamic>> ops,
  ) {
    final type = node['type'] as String? ?? 'paragraph';
    final data = node['data'] is Map
        ? Map<String, dynamic>.from(node['data'] as Map)
        : <String, dynamic>{};

    if (type == 'divider') {
      ops.add(<String, dynamic>{'insert': '---\n'});
      return;
    }

    if (type == 'image') {
      final url = (data['url'] ?? data['image'] ?? '').toString();
      if (url.isNotEmpty) {
        ops.add(<String, dynamic>{
          'insert': <String, dynamic>{'image': url},
        });
        ops.add(<String, dynamic>{'insert': '\n'});
      }
      return;
    }

    final delta = data['delta'];
    if (delta is List) {
      for (final op in delta) {
        if (op is! Map) continue;
        final insert = op['insert'];
        if (insert is! String || insert.isEmpty) continue;
        final mapped = <String, dynamic>{'insert': insert};
        final attrs = op['attributes'];
        if (attrs is Map && attrs.isNotEmpty) {
          mapped['attributes'] = _mapInlineAttrs(
            Map<String, dynamic>.from(attrs),
          );
        }
        ops.add(mapped);
      }
    }

    final blockAttrs = <String, dynamic>{};
    switch (type) {
      case 'heading':
        final level = data['level'];
        blockAttrs['header'] = level is int ? level : int.tryParse('$level') ?? 1;
      case 'bulleted_list':
        blockAttrs['list'] = 'bullet';
      case 'numbered_list':
        blockAttrs['list'] = 'ordered';
      case 'todo_list':
        final checked = data['checked'] == true;
        blockAttrs['list'] = checked ? 'checked' : 'unchecked';
      case 'quote':
        blockAttrs['blockquote'] = true;
      case 'code':
      case 'code_block':
        blockAttrs['code-block'] = true;
      default:
        break;
    }
    ops.add(<String, dynamic>{
      'insert': '\n',
      if (blockAttrs.isNotEmpty) 'attributes': blockAttrs,
    });

    final nested = node['children'];
    if (nested is List) {
      for (final child in nested) {
        if (child is Map) {
          _appendAppFlowyNode(Map<String, dynamic>.from(child), ops);
        }
      }
    }
  }

  static Map<String, dynamic> _mapInlineAttrs(Map<String, dynamic> attrs) {
    final out = <String, dynamic>{};
    if (attrs['bold'] == true) out['bold'] = true;
    if (attrs['italic'] == true) out['italic'] = true;
    if (attrs['underline'] == true) out['underline'] = true;
    if (attrs['strikethrough'] == true || attrs['strike'] == true) {
      out['strike'] = true;
    }
    if (attrs['code'] == true) out['code'] = true;
    final href = attrs['href'] ?? attrs['link'];
    if (href is String && href.isNotEmpty) out['link'] = href;
    final bg = attrs['bgColor'] ?? attrs['backgroundColor'];
    if (bg != null) out['background'] = bg.toString();
    return out;
  }

  static String _plainFromAppFlowyOps(List<Map<String, dynamic>> ops) {
    final buf = StringBuffer();
    for (final op in ops) {
      final insert = op['insert'];
      if (insert is String) buf.write(insert);
    }
    return buf.toString();
  }

  /// Convert legacy plain text / markdown checklist lines into a Document.
  static Document fromLegacyPlainText(String body) {
    final lines = body.split('\n');
    final delta = Delta();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final t = line.trimLeft();
      if (t.startsWith('- [x]') || t.startsWith('- [X]')) {
        delta.insert('${t.substring(5).trimLeft()}\n', {'list': 'checked'});
      } else if (t.startsWith('- [ ]')) {
        delta.insert('${t.substring(5).trimLeft()}\n', {'list': 'unchecked'});
      } else if (t.startsWith('- ') || t.startsWith('* ')) {
        delta.insert('${t.substring(2)}\n', {'list': 'bullet'});
      } else if (RegExp(r'^\d+\.\s').hasMatch(t)) {
        final text = t.replaceFirst(RegExp(r'^\d+\.\s'), '');
        delta.insert('$text\n', {'list': 'ordered'});
      } else {
        delta.insert('$line\n');
      }
    }
    if (delta.isEmpty) {
      return Document();
    }
    return Document.fromDelta(delta);
  }

  /// Plain-text preview for sidebar snippets.
  static String snippetFromBody(String body, {int maxLen = 120}) {
    if (body.trim().isEmpty) return '';
    late final String plain;
    try {
      if (looksLikeDocumentJson(body)) {
        plain = decode(body).toPlainText();
      } else {
        plain = body;
      }
    } catch (_) {
      plain = body;
    }
    final collapsed = plain
        .replaceAll(RegExp(r'^\s*[-*+]\s*\[[ xX]\]\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (collapsed.length <= maxLen) return collapsed;
    return '${collapsed.substring(0, maxLen).trimRight()}…';
  }

  static bool hasVisibleContent(Document document) {
    final plain = document.toPlainText().replaceAll('\n', '').trim();
    return plain.isNotEmpty;
  }
}
