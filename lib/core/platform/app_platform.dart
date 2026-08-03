import 'package:flutter/foundation.dart';

/// Shared platform checks used across desktop and mobile shells.
abstract final class AppPlatform {
  static bool get isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  static bool get isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  static bool get supportsSystemTray => isDesktop;

  static bool get supportsWindowModes => isDesktop;

  /// Periodic desktop screenshots (ImageMagick / screencapture).
  static bool get supportsAutoScreenshots => isDesktop;
}
