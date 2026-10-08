import 'package:gizecare/core/services/app_logger.dart';

/// System tray integration.
///
/// Under Flutter **snap** + system ayatana, `tray_manager` fails to link
/// (`g_once_init_enter_pointer` / glib ABI). This stub keeps the API so the
/// desktop app builds and runs; close-to-tray simply closes/hides via window
/// manager when tray is unavailable.
class TrayService {
  TrayService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  bool _ready = false;
  bool _trackingActive = false;

  Future<void> Function()? onOpenCompact;
  Future<void> Function()? onOpenFull;
  Future<void> Function()? onStart;
  Future<void> Function()? onPause;
  Future<void> Function()? onStop;
  Future<void> Function()? onQuit;

  bool get isReady => _ready;

  bool get trackingActive => _trackingActive;

  Future<void> init({
    required Future<void> Function() onOpenCompact,
    required Future<void> Function() onOpenFull,
    required Future<void> Function() onStart,
    required Future<void> Function() onPause,
    required Future<void> Function() onStop,
    required Future<void> Function() onQuit,
    bool trackingActive = false,
  }) async {
    this.onOpenCompact = onOpenCompact;
    this.onOpenFull = onOpenFull;
    this.onStart = onStart;
    this.onPause = onPause;
    this.onStop = onStop;
    this.onQuit = onQuit;
    _trackingActive = trackingActive;
    _ready = false;
    _logger.info(
      'System tray disabled (Flutter snap / tray_manager link incompatible). '
      'Use the taskbar window instead.',
    );
  }

  Future<void> setTrackingActive(bool active) async {
    _trackingActive = active;
  }

  void dispose() {
    _ready = false;
  }
}
