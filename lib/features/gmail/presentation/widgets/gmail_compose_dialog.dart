import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/gmail/domain/gmail_html.dart';
import 'package:gizecare/features/gmail/presentation/providers/gmail_providers.dart';

/// Gmail-style compose / reply sheet with rich-text body.
Future<bool?> showGmailComposeDialog(
  BuildContext context, {
  String initialTo = '',
  String initialSubject = '',
  String? replyToThreadId,
  String? inReplyToMessageId,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => GmailComposeDialog(
      initialTo: initialTo,
      initialSubject: initialSubject,
      replyToThreadId: replyToThreadId,
      inReplyToMessageId: inReplyToMessageId,
    ),
  );
}

class GmailComposeDialog extends ConsumerStatefulWidget {
  const GmailComposeDialog({
    super.key,
    this.initialTo = '',
    this.initialSubject = '',
    this.replyToThreadId,
    this.inReplyToMessageId,
  });

  final String initialTo;
  final String initialSubject;
  final String? replyToThreadId;
  final String? inReplyToMessageId;

  @override
  ConsumerState<GmailComposeDialog> createState() => _GmailComposeDialogState();
}

class _GmailComposeDialogState extends ConsumerState<GmailComposeDialog> {
  late final TextEditingController _to;
  late final TextEditingController _subject;
  late final QuillController _quill;
  late final FocusNode _editorFocus;
  late final ScrollController _editorScroll;
  var _sending = false;
  var _showFormatting = true;

  bool get _isReply => widget.replyToThreadId != null;

  @override
  void initState() {
    super.initState();
    _to = TextEditingController(text: widget.initialTo);
    _subject = TextEditingController(text: widget.initialSubject);
    _quill = QuillController.basic();
    _editorFocus = FocusNode();
    _editorScroll = ScrollController();
  }

  @override
  void dispose() {
    _to.dispose();
    _subject.dispose();
    _quill.dispose();
    _editorFocus.dispose();
    _editorScroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final plain = GmailHtml.plainFromDocument(_quill.document);
    final html = GmailHtml.documentToHtml(_quill.document);
    setState(() => _sending = true);
    final result = await ref.read(gmailRepositoryProvider).sendMessage(
          to: _to.text,
          subject: _subject.text,
          body: plain,
          bodyHtml: html,
          replyToThreadId: widget.replyToThreadId,
          inReplyToMessageId: widget.inReplyToMessageId,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    result.when(
      onSuccess: (_) => Navigator.pop(context, true),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor =
        isDark ? const Color(0xFF2A3647) : const Color(0xFFD3E3FD);
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      backgroundColor: surface,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 640,
        height: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: headerColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isReply ? 'Reply' : 'New Message',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed:
                          _sending ? null : () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            _ComposeField(
              label: 'Recipients',
              controller: _to,
              keyboardType: TextInputType.emailAddress,
              autofocus: widget.initialTo.isEmpty,
            ),
            Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
            _ComposeField(
              label: 'Subject',
              controller: _subject,
              autofocus: widget.initialTo.isNotEmpty && !_isReply,
            ),
            Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: QuillEditor.basic(
                  controller: _quill,
                  focusNode: _editorFocus,
                  scrollController: _editorScroll,
                  config: QuillEditorConfig(
                    placeholder: 'Write your message…',
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                    autoFocus: _isReply || widget.initialTo.isNotEmpty,
                    expands: true,
                    scrollable: true,
                    customStyles: DefaultStyles.getInstance(context).merge(
                      DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                height: 1.45,
                                fontSize: 14.5,
                              ),
                          HorizontalSpacing.zero,
                          VerticalSpacing.zero,
                          VerticalSpacing.zero,
                          null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_showFormatting)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A3647)
                        : const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QuillSimpleToolbar(
                    controller: _quill,
                    config: const QuillSimpleToolbarConfig(
                      multiRowsDisplay: false,
                      showDividers: false,
                      showFontFamily: false,
                      showFontSize: false,
                      showStrikeThrough: true,
                      showInlineCode: false,
                      showColorButton: true,
                      showBackgroundColorButton: false,
                      showClearFormat: false,
                      showAlignmentButtons: true,
                      showHeaderStyle: false,
                      showListCheck: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showIndent: true,
                      showLink: true,
                      showUndo: true,
                      showRedo: true,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: _sending ? null : _send,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Send'),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Formatting',
                    isSelected: _showFormatting,
                    onPressed: () =>
                        setState(() => _showFormatting = !_showFormatting),
                    icon: const Icon(Icons.text_format_rounded),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        _sending ? null : () => Navigator.pop(context, false),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeField extends StatelessWidget {
  const _ComposeField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
