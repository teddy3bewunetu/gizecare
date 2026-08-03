import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';

/// Telegram-style message composer: attach, emoji, text, send / voice.
class TelegramComposer extends StatefulWidget {
  const TelegramComposer({
    super.key,
    required this.onSendText,
    required this.onSendFile,
    required this.onSendVoice,
    this.replyTo,
    this.editing,
    this.onCancelReplyOrEdit,
    this.initialText,
  });

  final Future<void> Function(String text) onSendText;
  final Future<void> Function(String path) onSendFile;
  final Future<void> Function(String path, int durationSeconds) onSendVoice;
  final TelegramMessage? replyTo;
  final TelegramMessage? editing;
  final VoidCallback? onCancelReplyOrEdit;
  final String? initialText;

  @override
  State<TelegramComposer> createState() => _TelegramComposerState();
}

class _TelegramComposerState extends State<TelegramComposer> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  var _showEmoji = false;
  var _hasText = false;
  var _recording = false;
  var _sending = false;
  DateTime? _recordStartedAt;
  Timer? _tick;
  Duration _elapsed = Duration.zero;
  String? _recordPath;
  Process? _recordProcess;

  static const _emojis = [
    '😀', '😁', '😂', '🤣', '😊', '😍', '😘', '😎', '🤔', '😅',
    '😢', '😭', '😡', '👍', '👎', '👏', '🙏', '🔥', '❤️', '💯',
    '🎉', '✨', '⭐', '✅', '❌', '👀', '💬', '📎', '📷', '🎵',
    '☕', '🍕', '🚀', '💡', '📌', '🤝', '👋', '💪', '😴', '🤗',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
      _hasText = widget.initialText!.trim().isNotEmpty;
    }
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void didUpdateWidget(covariant TelegramComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editing?.id != oldWidget.editing?.id &&
        widget.editing != null) {
      _controller.text = widget.editing!.text;
      _hasText = widget.editing!.text.trim().isNotEmpty;
    }
    if (widget.editing == null &&
        oldWidget.editing != null &&
        widget.replyTo == null) {
      // Keep text unless switching modes explicitly cleared.
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    unawaited(_killRecorder());
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _killRecorder() async {
    final proc = _recordProcess;
    _recordProcess = null;
    if (proc == null) return;
    try {
      proc.kill(ProcessSignal.sigint);
      await proc.exitCode.timeout(const Duration(seconds: 2));
    } catch (_) {
      try {
        proc.kill(ProcessSignal.sigkill);
      } catch (_) {}
    }
  }

  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await widget.onSendText(text);
      _controller.clear();
      _focus.requestFocus();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickFile() async {
    final file = await openFile();
    if (file == null || !mounted) return;
    setState(() => _sending = true);
    try {
      await widget.onSendFile(file.path);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _toggleRecord() async {
    if (_recording) {
      await _stopAndSendVoice();
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final path = p.join(
        dir.path,
        'gizecare_voice_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      final proc = await _startRecorder(path);
      _recordProcess = proc;
      _recordPath = path;
      _recordStartedAt = DateTime.now();
      _elapsed = Duration.zero;
      _tick?.cancel();
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        final started = _recordStartedAt;
        if (started == null || !mounted) return;
        setState(() => _elapsed = DateTime.now().difference(started));
      });
      setState(() {
        _recording = true;
        _showEmoji = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Microphone unavailable ($e). Install ffmpeg or use pulseaudio tools.',
          ),
        ),
      );
    }
  }

  Future<Process> _startRecorder(String path) async {
    // Prefer tools present on this Linux host (record package needs parecord).
    final attempts = <List<String>>[
      ['ffmpeg', '-y', '-f', 'pulse', '-i', 'default', '-ac', '1', '-ar', '48000', path],
      ['pw-record', '--rate', '48000', '--channels', '1', path],
      ['arecord', '-f', 'S16_LE', '-r', '48000', '-c', '1', path],
    ];
    Object? lastError;
    for (final cmd in attempts) {
      final bin = cmd.first;
      if (!await _commandExists(bin)) continue;
      try {
        return await Process.start(bin, cmd.sublist(1));
      } catch (e) {
        lastError = e;
      }
    }
    throw StateError(
      lastError?.toString() ??
          'No recorder found (tried ffmpeg, pw-record, arecord)',
    );
  }

  Future<bool> _commandExists(String name) async {
    try {
      final r = await Process.run('which', [name]);
      return r.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  Future<void> _cancelRecord() async {
    _tick?.cancel();
    await _killRecorder();
    final path = _recordPath;
    if (path != null) {
      try {
        File(path).deleteSync();
      } catch (_) {}
    }
    setState(() {
      _recording = false;
      _recordPath = null;
      _elapsed = Duration.zero;
    });
  }

  Future<void> _stopAndSendVoice() async {
    _tick?.cancel();
    final path = _recordPath;
    final started = _recordStartedAt;
    final seconds = started == null
        ? 1
        : DateTime.now().difference(started).inSeconds.clamp(1, 3600);
    await _killRecorder();
    // Let ffmpeg / arecord flush the WAV before we convert to Opus.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    setState(() {
      _recording = false;
      _recordPath = null;
      _elapsed = Duration.zero;
    });
    if (path == null || !File(path).existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording failed — empty file')),
        );
      }
      return;
    }
    // Wait briefly if the file is still tiny (encoder finishing).
    for (var i = 0; i < 8; i++) {
      if (File(path).lengthSync() >= 1000) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (File(path).lengthSync() < 100) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording too short')),
        );
      }
      return;
    }
    setState(() => _sending = true);
    try {
      await widget.onSendVoice(path, seconds);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final next = text.replaceRange(start, end, emoji);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF1C1C1C) : scheme.surfaceContainerHigh;
    final fieldColor = isDark ? const Color(0xFF2A2A2A) : scheme.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyTo != null || widget.editing != null)
          Container(
            color: barColor,
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
            child: Row(
              children: [
                Icon(
                  widget.editing != null
                      ? Icons.edit_outlined
                      : Icons.reply_rounded,
                  size: 18,
                  color: AppColors.brand,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.editing != null ? 'Editing message' : 'Reply',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.brand,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        (widget.editing ?? widget.replyTo)!.text.isEmpty
                            ? ((widget.editing ?? widget.replyTo)!.hasPhoto
                                ? 'Photo'
                                : 'Message')
                            : (widget.editing ?? widget.replyTo)!.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cancel',
                  onPressed: widget.onCancelReplyOrEdit,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          ),
        if (_showEmoji)
          Container(
            height: 200,
            width: double.infinity,
            color: barColor,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: GridView.builder(
              itemCount: _emojis.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, i) {
                final e = _emojis[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _insertEmoji(e),
                  child: Center(
                    child: Text(e, style: const TextStyle(fontSize: 22)),
                  ),
                );
              },
            ),
          ),
        Container(
          color: barColor,
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
          child: _recording
              ? Row(
                  children: [
                    IconButton(
                      tooltip: 'Cancel',
                      onPressed: _sending ? null : _cancelRecord,
                      icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Recording ${_formatElapsed(_elapsed)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      tooltip: 'Send voice',
                      onPressed: _sending ? null : _stopAndSendVoice,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Attach file',
                      onPressed: _sending ? null : _pickFile,
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focus,
                          minLines: 1,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Write a message…',
                            filled: true,
                            fillColor: fieldColor,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Emoji',
                      onPressed: () {
                        setState(() => _showEmoji = !_showEmoji);
                        if (!_showEmoji) _focus.requestFocus();
                      },
                      icon: Icon(
                        _showEmoji
                            ? Icons.keyboard_alt_outlined
                            : Icons.emoji_emotions_outlined,
                        color: _showEmoji
                            ? AppColors.brand
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    if (_hasText)
                      IconButton.filled(
                        tooltip: 'Send',
                        onPressed: _sending ? null : _sendText,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.brand,
                          foregroundColor: Colors.white,
                        ),
                        icon: _sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                      )
                    else
                      IconButton(
                        tooltip: 'Voice message',
                        onPressed: _sending ? null : _toggleRecord,
                        icon: Icon(
                          Icons.mic_none_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
