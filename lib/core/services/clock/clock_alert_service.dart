import 'dart:io';

import 'package:flutter/material.dart';

import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/core/services/clock/alarm_audio_service.dart';

/// Desktop alerts for alarms and countdown completion.
class ClockAlertService {
  ClockAlertService({
    required AppLogger logger,
    required AlarmAudioService audio,
    required Future<AlarmSound> Function() resolveSound,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _logger = logger,
        _audio = audio,
        _resolveSound = resolveSound,
        navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final AppLogger _logger;
  final AlarmAudioService _audio;
  final Future<AlarmSound> Function() _resolveSound;
  final GlobalKey<NavigatorState> navigatorKey;

  BuildContext? get _context => navigatorKey.currentContext;

  Future<void> ring({
    required String title,
    required String body,
    List<ClockAlertAction> actions = const [],
  }) async {
    final sound = await _resolveSound();
    await notifyDesktop(title, body);
    await _audio.ring(sound);

    final context = _context;
    if (context == null || !context.mounted) {
      _logger.info('Clock alert (no UI context): $title — $body');
      // Keep ringing briefly even without dialog, then stop.
      await Future<void>.delayed(const Duration(seconds: 8));
      await _audio.stop();
      return;
    }

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              for (final action in actions)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    action.onPressed();
                  },
                  child: Text(action.label),
                ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Dismiss'),
              ),
            ],
          );
        },
      );
    } finally {
      await _audio.stop();
    }
  }

  Future<void> notifyDesktop(String title, String body) async {
    if (!Platform.isLinux) return;
    try {
      await Process.run('notify-send', [
        '--app-name=GizeCare',
        '--urgency=critical',
        title,
        body,
      ]);
    } catch (e) {
      _logger.verbose('notify-send unavailable: $e');
    }
  }
}

class ClockAlertAction {
  const ClockAlertAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}
