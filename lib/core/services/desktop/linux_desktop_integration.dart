import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gizecare/core/constants/app_assets.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/services/app_logger.dart';
import 'package:path/path.dart' as p;

/// Registers the Linux app icon so GNOME/Ubuntu dock + taskbar show ጊዜCare
/// instead of a generic placeholder.
///
/// GNOME Wayland often ignores [gtk_window_set_icon] and looks up
/// `Icon=` via a `.desktop` file matching [applicationId] / StartupWMClass.
class LinuxDesktopIntegration {
  LinuxDesktopIntegration({required AppLogger logger}) : _logger = logger;

  static const applicationId = 'com.gizecare.gizecare';

  final AppLogger _logger;

  Future<void> ensureAppIconRegistered() async {
    if (!Platform.isLinux) return;

    try {
      final home = Platform.environment['HOME'];
      if (home == null || home.isEmpty) return;

      await _installHicolorIcons(home);
      await _installDesktopEntry(home);
      await _refreshIconCache(home);
      _logger.info('Linux desktop icon registered ($applicationId)');
    } catch (e, st) {
      _logger.warning('Failed to register Linux desktop icon', e, st);
    }
  }

  Future<void> _installHicolorIcons(String home) async {
    final sizes = <int, String>{
      256: AppAssets.appIcon256,
      128: AppAssets.appIcon128,
      64: AppAssets.appIcon64,
      48: AppAssets.appIcon48,
    };

    for (final entry in sizes.entries) {
      final dir = Directory(
        p.join(
          home,
          '.local',
          'share',
          'icons',
          'hicolor',
          '${entry.key}x${entry.key}',
          'apps',
        ),
      );
      await dir.create(recursive: true);
      final bytes = await rootBundle.load(entry.value);
      final out = File(p.join(dir.path, '$applicationId.png'));
      await out.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }
  }

  Future<void> _installDesktopEntry(String home) async {
    final appsDir = Directory(p.join(home, '.local', 'share', 'applications'));
    await appsDir.create(recursive: true);

    final execPath = Platform.resolvedExecutable;
    final desktop = File(p.join(appsDir.path, '$applicationId.desktop'));
    await desktop.writeAsString(
      '''
[Desktop Entry]
Version=1.0
Type=Application
Name=${AppConstants.displayName}
GenericName=Workday Hub
Comment=${AppConstants.tagline}
Exec="$execPath"
Icon=$applicationId
Terminal=false
Categories=Office;Utility;
StartupNotify=true
StartupWMClass=$applicationId
X-GNOME-UsesNotifications=true
''',
      flush: true,
    );
  }

  Future<void> _refreshIconCache(String home) async {
    final hicolor = p.join(home, '.local', 'share', 'icons', 'hicolor');
    try {
      await Process.run('gtk-update-icon-cache', ['-f', '-t', hicolor]);
    } catch (_) {
      // Optional — missing cache tool is fine; DE will pick up files later.
    }
    try {
      await Process.run('update-desktop-database', [
        p.join(home, '.local', 'share', 'applications'),
      ]);
    } catch (_) {}
  }
}
