import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Video;

/// Plays a YouTube watch URL inside Flutter (media_kit), avoiding WebKitGTK
/// media which crashes when nested under the Flutter Linux GL compositor.
class YoutubeWatchPane extends StatefulWidget {
  const YoutubeWatchPane({
    required this.url,
    required this.onClose,
    super.key,
  });

  final String url;
  final VoidCallback onClose;

  static String? extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final host = uri.host.toLowerCase();
    if (host.contains('youtu.be')) {
      final id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
      return (id != null && id.isNotEmpty) ? id : null;
    }
    if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
      final v = uri.queryParameters['v'];
      if (v != null && v.isNotEmpty) return v;
      final parts = uri.pathSegments;
      for (var i = 0; i < parts.length - 1; i++) {
        if (parts[i] == 'shorts' || parts[i] == 'embed' || parts[i] == 'live') {
          final id = parts[i + 1];
          if (id.isNotEmpty) return id;
        }
      }
    }
    return null;
  }

  static bool isWatchUrl(String url) {
    final u = url.toLowerCase();
    return u.contains('youtube.com/watch') ||
        u.contains('youtube.com/shorts/') ||
        u.contains('youtube.com/embed/') ||
        u.contains('youtube.com/live/') ||
        u.contains('youtu.be/') ||
        u.contains('youtube-nocookie.com/');
  }

  @override
  State<YoutubeWatchPane> createState() => _YoutubeWatchPaneState();
}

class _YoutubeWatchPaneState extends State<YoutubeWatchPane> {
  late final Player _player = Player();
  late final VideoController _controller = VideoController(_player);
  final _yt = YoutubeExplode();

  var _loading = true;
  String? _error;
  String? _title;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final id = YoutubeWatchPane.extractVideoId(widget.url);
    if (id == null) {
      setState(() {
        _loading = false;
        _error = 'Could not parse this YouTube link.';
      });
      return;
    }
    try {
      final video = await _yt.videos.get(id);
      final manifest = await _yt.videos.streamsClient.getManifest(id);
      final muxed = manifest.muxed;
      if (muxed.isEmpty) {
        throw StateError('No playable streams for this video.');
      }
      final stream = muxed.withHighestBitrate();
      if (!mounted) return;
      setState(() {
        _title = video.title;
        _loading = false;
      });
      await _player.open(Media(stream.url.toString()));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Could not play in-app. You can open it externally.\n$e';
      });
    }
  }

  Future<void> _openExternal() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _yt.close();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: Colors.black,
      child: Column(
        children: [
          Material(
            color: scheme.surface,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back to page',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    _title ?? 'YouTube',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Open in system browser',
                  onPressed: _openExternal,
                  icon: const Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: _openExternal,
                                icon: const Icon(Icons.open_in_new),
                                label: const Text('Open externally'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Video(
                        controller: _controller,
                        controls: MaterialVideoControls,
                      ),
          ),
        ],
      ),
    );
  }
}
