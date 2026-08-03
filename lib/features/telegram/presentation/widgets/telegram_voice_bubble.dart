import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';

/// Shared player so only one voice note plays at a time.
class _TelegramVoicePlayer {
  _TelegramVoicePlayer._();
  static final instance = _TelegramVoicePlayer._();

  final AudioPlayer player = AudioPlayer();
  String? currentPath;
}

/// Telegram Desktop-style voice note bubble (play + waveform + duration).
class TelegramVoiceBubble extends StatefulWidget {
  const TelegramVoiceBubble({
    required this.message,
    required this.foreground,
    required this.accent,
    super.key,
  });

  final TelegramMessage message;
  final Color foreground;
  final Color accent;

  @override
  State<TelegramVoiceBubble> createState() => _TelegramVoiceBubbleState();
}

class _TelegramVoiceBubbleState extends State<TelegramVoiceBubble> {
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration?>? _durSub;
  StreamSubscription<Duration>? _posSub;
  var _playing = false;
  var _loading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  String? get _path {
    final p = widget.message.mediaPath;
    if (p == null || p.isEmpty) return null;
    if (!File(p).existsSync()) return null;
    return p;
  }

  int get _fallbackSeconds {
    final parts = widget.message.text.split('|');
    if (parts.length > 1) return int.tryParse(parts.last) ?? 0;
    return 0;
  }

  int get _fileBytes {
    final path = _path;
    if (path == null) return 0;
    try {
      return File(path).lengthSync();
    } catch (_) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    final shared = _TelegramVoicePlayer.instance;
    _stateSub = shared.player.playerStateStream.listen((s) {
      if (!mounted) return;
      final mine = shared.currentPath == _path;
      setState(() {
        _playing = mine && s.playing;
        if (!mine) _position = Duration.zero;
      });
    });
    _durSub = shared.player.durationStream.listen((d) {
      if (!mounted) return;
      if (shared.currentPath == _path && d != null) {
        setState(() => _duration = d);
      }
    });
    _posSub = shared.player.positionStream.listen((p) {
      if (!mounted) return;
      if (shared.currentPath == _path) {
        setState(() => _position = p);
      }
    });
    final fallback = _fallbackSeconds;
    if (fallback > 0) {
      _duration = Duration(seconds: fallback);
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _durSub?.cancel();
    _posSub?.cancel();
    super.dispose();
  }

  Future<void> _toggle() async {
    final path = _path;
    if (path == null) return;
    final shared = _TelegramVoicePlayer.instance;
    try {
      if (shared.currentPath == path && shared.player.playing) {
        await shared.player.pause();
        return;
      }
      setState(() => _loading = true);
      if (shared.currentPath != path) {
        await shared.player.setFilePath(path);
        shared.currentPath = path;
      }
      await shared.player.play();
    } catch (_) {
      // Ignore play errors (missing codec / path).
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _fmt(Duration d) {
    final total = d.inSeconds;
    final m = (total ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _sizeLabel(int bytes) {
    if (bytes <= 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  List<double> _bars() {
    final seed = widget.message.telegramMessageId.hashCode;
    final rng = math.Random(seed);
    return List<double>.generate(28, (_) => 0.25 + rng.nextDouble() * 0.75);
  }

  @override
  Widget build(BuildContext context) {
    final path = _path;
    final bars = _bars();
    final progress = _duration.inMilliseconds <= 0
        ? 0.0
        : (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
    final shown = _playing || _position > Duration.zero
        ? _position
        : (_duration == Duration.zero && _fallbackSeconds > 0
            ? Duration(seconds: _fallbackSeconds)
            : _duration);
    final size = _sizeLabel(_fileBytes);

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          Material(
            color: widget.accent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: path == null || _loading ? null : _toggle,
              child: SizedBox(
                width: 40,
                height: 40,
                child: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 28,
                  child: CustomPaint(
                    painter: _WaveformPainter(
                      bars: bars,
                      progress: progress,
                      active: widget.accent,
                      inactive: widget.foreground.withValues(alpha: 0.35),
                    ),
                    size: const Size(double.infinity, 28),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  size.isEmpty
                      ? _fmt(shown)
                      : '${_fmt(shown)}, $size',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: widget.foreground.withValues(alpha: 0.75),
                        fontSize: 11,
                      ),
                ),
                if (path == null)
                  Text(
                    'Downloading…',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: widget.foreground.withValues(alpha: 0.55),
                          fontSize: 10,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.bars,
    required this.progress,
    required this.active,
    required this.inactive,
  });

  final List<double> bars;
  final double progress;
  final Color active;
  final Color inactive;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final paint = Paint()..strokeCap = StrokeCap.round;
    final gap = 2.0;
    final barWidth =
        ((size.width - gap * (bars.length - 1)) / bars.length).clamp(1.5, 4.0);
    final mid = size.height / 2;
    for (var i = 0; i < bars.length; i++) {
      final h = bars[i] * size.height * 0.9;
      final x = i * (barWidth + gap) + barWidth / 2;
      final played = i / bars.length <= progress;
      paint
        ..color = played ? active : inactive
        ..strokeWidth = barWidth;
      canvas.drawLine(
        Offset(x, mid - h / 2),
        Offset(x, mid + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.bars != bars ||
        oldDelegate.active != active ||
        oldDelegate.inactive != inactive;
  }
}
