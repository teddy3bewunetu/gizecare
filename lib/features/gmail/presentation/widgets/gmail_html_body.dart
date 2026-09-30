import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:gizecare/core/browser/app_link_opener.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/linkable_text.dart';
import 'package:gizecare/features/gmail/domain/gmail_html.dart';

/// Renders email HTML with layout/styles preserved on a light mail canvas.
class GmailHtmlBody extends StatelessWidget {
  const GmailHtmlBody({
    required this.html,
    required this.plainFallback,
    super.key,
  });

  final String html;
  final String plainFallback;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prepared = GmailHtml.sanitize(html);
    if (prepared.trim().isEmpty) {
      return _Plain(plainFallback);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => GmailHtml.openInAppBrowser(context, html),
            icon: const Icon(Icons.open_in_browser_rounded, size: 16),
            label: const Text('Open original'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brand,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        const SizedBox(height: 4),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? Colors.white12
                  : Colors.black.withValues(alpha: 0.08),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: HtmlWidget(
                  prepared,
                  textStyle: const TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                  onTapUrl: (url) async {
                    return AppLinkOpener.open(context, url);
                  },
                  customStylesBuilder: (element) {
                    // Keep email inline styles; lightly constrain images/tables.
                    if (element.localName == 'img') {
                      return {
                        'max-width': '100%',
                        'height': 'auto',
                      };
                    }
                    if (element.localName == 'table') {
                      return {'max-width': '100%'};
                    }
                    return null;
                  },
                  renderMode: RenderMode.column,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Plain extends StatelessWidget {
  const _Plain(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return LinkableText(
      text.trim().isEmpty ? '(no text content)' : text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            fontSize: 14.5,
          ),
    );
  }
}
