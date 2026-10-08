import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/features/notebook/domain/note_document_codec.dart';

void main() {
  test('blank document round-trips through JSON', () {
    final doc = NoteDocumentCodec.blank();
    final encoded = NoteDocumentCodec.encode(doc);
    expect(NoteDocumentCodec.looksLikeQuillJson(encoded), isTrue);

    final decoded = NoteDocumentCodec.decode(encoded);
    expect(decoded.toPlainText(), isNotEmpty);
    expect(jsonDecode(encoded), isA<Map<String, dynamic>>());
  });

  test('legacy plain text becomes paragraphs', () {
    const legacy = 'Hello world\nSecond line';
    final doc = NoteDocumentCodec.decode(legacy);
    expect(doc.toPlainText(), contains('Hello world'));
    final snippet = NoteDocumentCodec.snippetFromBody(legacy);
    expect(snippet, contains('Hello'));
  });

  test('legacy markdown checklists become checklist lines', () {
    const legacy = '- [ ] buy milk\n- [x] done thing\nplain';
    final doc = NoteDocumentCodec.fromLegacyPlainText(legacy);
    final delta = doc.toDelta().toJson();
    expect(delta, isNotEmpty);
    final encoded = jsonEncode(delta);
    expect(encoded, contains('unchecked'));
    expect(encoded, contains('checked'));
  });

  test('checklist seed has an unchecked list line', () {
    final doc = NoteDocumentCodec.checklistSeed();
    final encoded = jsonEncode(doc.toDelta().toJson());
    expect(encoded, contains('unchecked'));
  });

  test('snippet strips checklist markers from markdown', () {
    final snippet = NoteDocumentCodec.snippetFromBody('- [ ] buy milk');
    expect(snippet.toLowerCase(), contains('buy milk'));
    expect(snippet.contains('[ ]'), isFalse);
  });

  test('migrates AppFlowy document JSON to Quill', () {
    const appFlowy = '''
{
  "document": {
    "type": "page",
    "children": [
      {
        "type": "paragraph",
        "data": {
          "delta": [{"insert": "Hello"}]
        }
      },
      {
        "type": "todo_list",
        "data": {
          "checked": false,
          "delta": [{"insert": "Task"}]
        }
      }
    ]
  }
}
''';
    final doc = NoteDocumentCodec.decode(appFlowy);
    expect(doc.toPlainText(), contains('Hello'));
    expect(doc.toPlainText(), contains('Task'));
    final reencoded = NoteDocumentCodec.encode(doc);
    expect(NoteDocumentCodec.looksLikeQuillJson(reencoded), isTrue);
  });
}
