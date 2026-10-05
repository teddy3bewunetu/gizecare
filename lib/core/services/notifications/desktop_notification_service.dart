import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';

/// OS-level desktop notifications that appear above other apps.
///
/// Linux uses `notify-send` (libnotify). Clicking the notification can invoke
/// [onActivated] when the daemon supports actions + `--wait`.
class DesktopNotificationService {
  DesktopNotificationService();

  var _seq = 0;

  /// Show a system notification.
  ///
  /// [onActivated] is called if the user clicks an action (when supported).
  Future<void> show({
    required String title,
    required String body,
    String appName = 'GizeCare',
    String? iconPath,
    Duration timeout = const Duration(seconds: 6),
    VoidCallback? onActivated,
  }) async {
    if (!Platform.isLinux) {
      debugPrint('DesktopNotificationService: only Linux is implemented');
      return;
    }

    final id = 'gizecare-n-${++_seq}';
    final args = <String>[
      '--app-name=$appName',
      '--urgency=normal',
      '--category=im.received',
      '--hint=string:desktop-entry:com.gizecare.gizecare',
      '--hint=string:x-canonical-private-synchronous:$id',
      '-t',
      '${timeout.inMilliseconds}',
    ];

    final icon = _resolveIcon(iconPath);
    if (icon != null) {
      args.addAll(['--icon', icon]);
    }

    // Actions + wait so a click can focus the app (best-effort).
    if (onActivated != null) {
      args.addAll([
        '--action=default=Open',
        '--action=open=Open',
        '--wait',
      ]);
    }

    args.addAll([title, body]);

    try {
      if (onActivated == null) {
        await Process.run('notify-send', args);
        return;
      }

      final process = await Process.start('notify-send', args);
      final stdoutFuture = process.stdout.transform(utf8.decoder).join();
      final stderrFuture = process.stderr.transform(utf8.decoder).join();
      final code = await process.exitCode.timeout(
        timeout + const Duration(seconds: 30),
        onTimeout: () {
          process.kill();
          return -1;
        },
      );
      final out = (await stdoutFuture).trim();
      await stderrFuture;
      if (code == 0 &&
          (out == 'default' ||
              out == 'open' ||
              out.contains('default') ||
              out.contains('open'))) {
        onActivated();
      }
    } catch (e) {
      debugPrint('DesktopNotificationService notify-send failed: $e');
    }
  }

  /// Bring the GizeCare window above other apps.
  Future<void> focusAppWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (e) {
      debugPrint('DesktopNotificationService focus failed: $e');
    }
  }

  String? _resolveIcon(String? preferred) {
    if (preferred != null &&
        preferred.startsWith('/') &&
        File(preferred).existsSync()) {
      return preferred;
    }
    // Prefer packaged app icons next to the binary.
    final exe = Platform.resolvedExecutable;
    final candidates = <String>[
      p.join(p.dirname(exe), 'data', 'flutter_assets', 'assets', 'icons',
          'app_icon_256.png'),
      p.join(p.dirname(exe), 'data', 'flutter_assets', 'assets', 'brand',
          'logo.png'),
      '/usr/share/icons/hicolor/256x256/apps/com.gizecare.gizecare.png',
      'telegram',
      'mail-message-new',
    ];
    for (final c in candidates) {
      if (!c.contains('/')) return c; // theme icon name
      if (File(c).existsSync()) return c;
    }
    return 'dialog-information';
  }
}
