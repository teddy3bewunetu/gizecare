import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gizecare/core/config/app_env.dart';
import 'package:gizecare/core/constants/app_assets.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/database/sqlite_setup.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/core/services/desktop/linux_desktop_integration.dart';
import 'package:media_kit/media_kit.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:window_manager/window_manager.dart';

/// Initializes platform bindings required before [runApp].
///
/// Desktop window configuration lives here so [main] stays thin.
/// Compact vs full geometry is applied after settings load in [_AppBootstrap].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  // Linux/desktop uses native PDFium; WASM is web-only — silence debug noise.
  await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);
  await loadAppEnv();
  ensureSqliteLoaded();

  if (AppPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(380, 720),
      minimumSize: Size(320, 560),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: AppConstants.displayName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await _applyWindowIcon();
      await windowManager.show();
      await windowManager.focus();
    });

    if (Platform.isLinux) {
      await LinuxDesktopIntegration(
        logger: AppLogger(),
      ).ensureAppIconRegistered();
    }
  }
}

/// Sets the window/taskbar icon from Flutter assets (Linux + Windows).
Future<void> _applyWindowIcon() async {
  try {
    // window_manager prefixes this with `<exe>/data/flutter_assets/`.
    await windowManager.setIcon(AppAssets.appIcon256);
  } catch (_) {
    try {
      await windowManager.setIcon(AppAssets.logo);
    } catch (_) {
      // Native GTK fallback in my_application.cc still applies.
    }
  }
}
