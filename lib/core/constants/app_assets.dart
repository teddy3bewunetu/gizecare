/// Brand asset paths for ጊዜCare.
abstract final class AppAssets {
  /// Preferred in-app mark (vector).
  static const String logoSvg = 'assets/brand/gc-logo.svg';

  /// Full brand tile (cyan mark on black) — window / launcher icons.
  static const String logo = 'assets/brand/gc-logo.png';

  /// Raster mark for sidebar / places that prefer PNG.
  static const String logoMark = 'assets/brand/gc-logo-mark.png';

  /// Exact original artwork the user provided (reference / fallback).
  static const String logoOriginal = 'assets/brand/gc-logo-original.png';

  /// Alias kept for older references / tooling.
  static const String logoLegacy = 'assets/brand/logo.png';

  static const String appIcon48 = 'assets/icons/app_icon_48.png';
  static const String appIcon64 = 'assets/icons/app_icon_64.png';
  static const String appIcon128 = 'assets/icons/app_icon_128.png';
  static const String appIcon256 = 'assets/icons/app_icon_256.png';

  /// Colored tray icon — used while the timer is running.
  static const String trayIconActive22 = 'assets/icons/tray_icon_22.png';
  static const String trayIconActive32 = 'assets/icons/tray_icon_32.png';

  /// Black & white tray icon — used when the timer is idle / paused / stopped.
  static const String trayIconIdle22 = 'assets/icons/tray_icon_22_idle.png';
  static const String trayIconIdle32 = 'assets/icons/tray_icon_32_idle.png';
}
