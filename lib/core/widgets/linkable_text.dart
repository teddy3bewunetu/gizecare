import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:gizecare/core/browser/app_link_opener.dart';
import 'package:gizecare/core/theme/app_colors.dart';

/// http(s), www., and common bare domains with a path/query.
final _urlPattern = RegExp(
  r'''(?:https?:\/\/|www\.)[^\s<>"']+|'''
  r'''(?<![A-Za-z0-9@])(?:[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?\.)+(?:com|org|net|io|dev|app|co|me|ai|info|edu|gov|us|uk|de|fr|ca|au|jp|cn|ru|br|in|et)(?:\/[^\s<>"']*)?''',
  caseSensitive: false,
);

/// Selectable text that turns URLs into tappable links (in-app browser).
class LinkableText extends StatefulWidget {
  const LinkableText(
    this.text, {
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<LinkableText> createState() => _LinkableTextState();
}

class _LinkableTextState extends State<LinkableText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LinkableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      for (final r in _recognizers) {
        r.dispose();
      }
      _recognizers.clear();
    }
  }

  TapGestureRecognizer _recognizerFor(String raw) {
    final r = TapGestureRecognizer()
      ..onTap = () {
        AppLinkOpener.open(context, raw);
      };
    _recognizers.add(r);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.style ?? DefaultTextStyle.of(context).style;
    final linkStyle = base.copyWith(
      color: AppColors.brand,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.brand.withValues(alpha: 0.55),
    );

    final text = widget.text;
    final matches = _urlPattern.allMatches(text).toList();
    if (matches.isEmpty) {
      return SelectableText(text, style: base);
    }

    // Rebuild recognizers for this frame.
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final raw = match.group(0)!;
      spans.add(
        TextSpan(
          text: raw,
          style: linkStyle,
          recognizer: _recognizerFor(raw),
          mouseCursor: SystemMouseCursors.click,
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return SelectableText.rich(
      TextSpan(style: base, children: spans),
    );
  }
}
