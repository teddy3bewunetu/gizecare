import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/browser/app_link_opener.dart';

/// Helpers for Gmail HTML bodies (read + compose).
abstract final class GmailHtml {
  /// Prepare email HTML for in-app rendering.
  ///
  /// Keeps layout/CSS that email clients rely on, but strips scripts and
  /// CSS at-rules (`@media`, `@font-face`, …) that break Flutter HTML parsers.
  static String sanitize(String html) {
    var out = html;
    out = out.replaceAll(
      RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
      '',
    );
    out = out.replaceAll(
      RegExp(r'<iframe[\s\S]*?</iframe>', caseSensitive: false),
      '',
    );
    out = out.replaceAll(
      RegExp(r'''\son\w+\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)''',
          caseSensitive: false),
      '',
    );
    // Outlook conditionals.
    out = out.replaceAll(
      RegExp(r'<!--\[if[\s\S]*?<!\[endif\]-->', caseSensitive: false),
      '',
    );
    out = out.replaceAll(
      RegExp(r'<link[^>]*stylesheet[^>]*/?>', caseSensitive: false),
      '',
    );
    // Clean <style> blocks in place (do not delete the whole email).
    out = out.replaceAllMapped(
      RegExp(r'(<style[^>]*>)([\s\S]*?)(</style>)', caseSensitive: false),
      (m) => '${m[1]}${_stripCssAtRules(m[2]!)}${m[3]}',
    );
    return out.trim();
  }

  /// Wrap HTML so it renders on a light canvas (emails assume white).
  static String wrapForViewer(String html, {required bool darkChrome}) {
    final body = sanitize(html);
    final pageBg = darkChrome ? '#1e1e1e' : '#e8eaed';
    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<style>
  html, body { margin: 0; padding: 0; background: $pageBg; }
  .gize-mail-frame {
    max-width: 720px;
    margin: 0 auto;
    background: #ffffff;
    color: #202124;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14px;
    line-height: 1.45;
    padding: 16px 20px 28px;
  }
  .gize-mail-frame img { max-width: 100%; height: auto; }
  .gize-mail-frame a { color: #1a73e8; }
  .gize-mail-frame table { max-width: 100%; }
</style>
</head>
<body>
<div class="gize-mail-frame">$body</div>
</body>
</html>
''';
  }

  /// Write HTML to a temp file and open it in the in-app browser.
  static Future<void> openInAppBrowser(BuildContext context, String html) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(dir.path, 'gizecare_mail_${DateTime.now().millisecondsSinceEpoch}.html'),
    );
    await file.writeAsString(wrapForViewer(html, darkChrome: false), flush: true);
    if (!context.mounted) return;
    await AppLinkOpener.openUri(
      context,
      Uri.file(file.path),
      title: 'Original message',
    );
  }

  /// Legacy alias — prefers the in-app browser when a [context] is available.
  static Future<void> openInSystemBrowser(String html) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(dir.path, 'gizecare_mail_${DateTime.now().millisecondsSinceEpoch}.html'),
    );
    await file.writeAsString(wrapForViewer(html, darkChrome: false), flush: true);
    await AppLinkOpener.openExternal(Uri.file(file.path).toString());
  }

  static String _stripCssAtRules(String css) {
    final out = css.replaceAll(
      RegExp(r'@import[^;]+;', caseSensitive: false),
      '',
    );
    final buffer = StringBuffer();
    var i = 0;
    final atRule = RegExp(
      r'@(media|font-face|keyframes|supports|page|-webkit-[a-z0-9-]+|-moz-[a-z0-9-]+)\b',
      caseSensitive: false,
    );
    while (i < out.length) {
      final m = atRule.matchAsPrefix(out, i);
      if (m != null) {
        var j = m.end;
        while (j < out.length && out[j] != '{' && out[j] != ';') {
          j++;
        }
        if (j < out.length && out[j] == ';') {
          i = j + 1;
          continue;
        }
        if (j < out.length && out[j] == '{') {
          var depth = 0;
          for (; j < out.length; j++) {
            final ch = out[j];
            if (ch == '{') {
              depth++;
            } else if (ch == '}') {
              depth--;
              if (depth == 0) {
                j++;
                break;
              }
            }
          }
          i = j;
          continue;
        }
      }
      buffer.write(out[i]);
      i++;
    }
    return buffer.toString();
  }

  /// Convert Quill [Document] to simple HTML for Gmail send.
  static String documentToHtml(Document document) {
    final delta = document.toDelta();
    final buffer = StringBuffer();
    var openList = false;
    var listTag = 'ul';

    void closeList() {
      if (openList) {
        buffer.write('</$listTag>');
        openList = false;
      }
    }

    for (final op in delta.toList()) {
      final data = op.data;
      if (data is! String) continue;
      final attrs = op.attributes ?? const <String, dynamic>{};
      final lines = data.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final isLineBreak = i < lines.length - 1;
        if (line.isEmpty && isLineBreak) {
          final list = attrs['list'] as String?;
          if (list != null) {
            final tag = list == 'ordered' ? 'ol' : 'ul';
            if (!openList || listTag != tag) {
              closeList();
              listTag = tag;
              buffer.write('<$listTag>');
              openList = true;
            }
            buffer.write('<li></li>');
          } else {
            closeList();
            buffer.write('<br/>');
          }
          continue;
        }

        var styled = _escape(line);
        if (styled.isNotEmpty) {
          if (attrs['bold'] == true) styled = '<b>$styled</b>';
          if (attrs['italic'] == true) styled = '<i>$styled</i>';
          if (attrs['underline'] == true) styled = '<u>$styled</u>';
          if (attrs['strike'] == true) styled = '<s>$styled</s>';
          final link = attrs['link'] as String?;
          if (link != null && link.isNotEmpty) {
            styled = '<a href="${_escapeAttr(link)}">$styled</a>';
          }
          final color = attrs['color'] as String?;
          if (color != null && color.isNotEmpty) {
            styled = '<span style="color:$color">$styled</span>';
          }
        }

        if (isLineBreak) {
          final list = attrs['list'] as String?;
          final header = attrs['header'];
          if (list != null) {
            final tag = list == 'ordered' ? 'ol' : 'ul';
            if (!openList || listTag != tag) {
              closeList();
              listTag = tag;
              buffer.write('<$listTag>');
              openList = true;
            }
            buffer.write('<li>$styled</li>');
          } else if (header != null) {
            closeList();
            final level = header is int ? header : int.tryParse('$header') ?? 1;
            final h = level.clamp(1, 3);
            buffer.write('<h$h>$styled</h$h>');
          } else {
            closeList();
            if (styled.isEmpty) {
              buffer.write('<br/>');
            } else {
              buffer.write('<p>$styled</p>');
            }
          }
        } else if (styled.isNotEmpty) {
          closeList();
          buffer.write(styled);
        }
      }
    }
    closeList();
    final html = buffer.toString().trim();
    if (html.isEmpty) return '<p></p>';
    if (!html.contains('<')) {
      return '<p>${_escape(html).replaceAll('\n', '<br/>')}</p>';
    }
    return html;
  }

  static String plainFromDocument(Document document) =>
      document.toPlainText().trim();

  static String buildMultipartRfc822({
    required String to,
    required String subject,
    required String plainBody,
    required String htmlBody,
    String? inReplyTo,
  }) {
    const boundary = 'gizecare_boundary_7a3f';
    final buffer = StringBuffer()
      ..writeln('To: $to')
      ..writeln('Subject: $subject')
      ..writeln('MIME-Version: 1.0');
    if (inReplyTo != null && inReplyTo.isNotEmpty) {
      buffer.writeln('In-Reply-To: $inReplyTo');
      buffer.writeln('References: $inReplyTo');
    }
    buffer
      ..writeln('Content-Type: multipart/alternative; boundary="$boundary"')
      ..writeln()
      ..writeln('--$boundary')
      ..writeln('Content-Type: text/plain; charset="UTF-8"')
      ..writeln('Content-Transfer-Encoding: 7bit')
      ..writeln()
      ..writeln(plainBody)
      ..writeln()
      ..writeln('--$boundary')
      ..writeln('Content-Type: text/html; charset="UTF-8"')
      ..writeln('Content-Transfer-Encoding: 7bit')
      ..writeln()
      ..writeln(
        '<div style="font-family:Arial,Helvetica,sans-serif;font-size:14px;'
        'line-height:1.45;color:#202124">$htmlBody</div>',
      )
      ..writeln()
      ..writeln('--$boundary--');
    return buffer.toString();
  }

  static String encodeRaw(String rfc822) =>
      base64UrlEncode(utf8.encode(rfc822)).replaceAll('=', '');

  /// Prefer HTML body; fall back to plain (and derive plain from HTML).
  static ({String plain, String? html}) bodiesFromPayload(
    gmail.MessagePart? payload,
  ) {
    String? plain;
    String? html;

    void walk(gmail.MessagePart? part) {
      if (part == null) return;
      final data = part.body?.data;
      if (part.mimeType == 'text/plain' && data != null && plain == null) {
        plain = _decodeBody(data);
      } else if (part.mimeType == 'text/html' && data != null && html == null) {
        html = _decodeBody(data);
      }
      for (final child in part.parts ?? const <gmail.MessagePart>[]) {
        walk(child);
      }
    }

    walk(payload);
    // Store raw HTML; sanitize only when rendering so we can improve later.
    final plainOut = (plain != null && plain!.trim().isNotEmpty)
        ? plain!
        : (html != null ? stripHtmlToText(html!) : '');
    return (plain: plainOut, html: html);
  }

  static String stripHtmlToText(String html) {
    return html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }

  static String _decodeBody(String data) {
    var normalized = data.replaceAll('-', '+').replaceAll('_', '/');
    switch (normalized.length % 4) {
      case 2:
        normalized += '==';
      case 3:
        normalized += '=';
    }
    return utf8.decode(base64Decode(normalized), allowMalformed: true);
  }

  static String _escape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');

  static String _escapeAttr(String s) =>
      _escape(s).replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}
