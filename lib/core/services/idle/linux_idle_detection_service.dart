import 'dart:async';
import 'dart:io';

import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/core/services/idle/idle_detection_service.dart';
import 'package:gizecare/core/services/idle/x11_idle_query.dart';

/// Linux idle detection using **system-wide** input idle time.
///
/// Resolution order:
/// 1. `xprintidle` (if installed)
/// 2. X11 XScreenSaver via libXss (works when the app is minimized)
/// 3. In-app heartbeat — only while the tracker window is focused; when the
///    window is unfocused/minimized we treat the user as active so background
///    work is not miscounted as idle.
class LinuxIdleDetectionService implements IdleDetectionService {
  LinuxIdleDetectionService({
    required AppLogger logger,
    DateTime Function()? clock,
    Future<bool> Function()? isWindowFocused,
  })  : _logger = logger,
        _clock = clock ?? DateTime.now,
        _isWindowFocused = isWindowFocused;

  final AppLogger _logger;
  final DateTime Function() _clock;
  final Future<bool> Function()? _isWindowFocused;

  Timer? _timer;
  DateTime _lastActivity = DateTime.now();
  bool? _xprintidleAvailable;
  bool? _xssAvailable;
  bool _loggedFallback = false;
  bool _idleLatched = false;

  /// Call when local input is observed (mouse/keyboard in-app).
  void bumpActivity() {
    _lastActivity = _clock();
  }

  @override
  Future<IdleInfo> getIdleInfo({required Duration timeout}) async {
    final idle = await _resolveIdleDuration();
    final status = idle >= timeout ? IdleStatus.idle : IdleStatus.active;
    return IdleInfo(idleDuration: idle, status: status);
  }

  @override
  void startMonitoring({
    required Duration timeout,
    required void Function(IdleInfo info) onIdle,
    Duration pollInterval = const Duration(seconds: 5),
  }) {
    stopMonitoring();
    _idleLatched = false;
    _timer = Timer.periodic(pollInterval, (_) async {
      final info = await getIdleInfo(timeout: timeout);
      if (info.status == IdleStatus.idle) {
        if (_idleLatched) return;
        _idleLatched = true;
        onIdle(info);
      } else {
        _idleLatched = false;
      }
    });
  }

  @override
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _idleLatched = false;
  }

  @override
  void dispose() {
    stopMonitoring();
  }

  Future<Duration> _resolveIdleDuration() async {
    final fromXprintidle = await _idleFromXprintidle();
    if (fromXprintidle != null) return fromXprintidle;

    final fromXss = _idleFromXss();
    if (fromXss != null) return fromXss;

    return _idleFromAppHeartbeat();
  }

  Future<Duration?> _idleFromXprintidle() async {
    if (_xprintidleAvailable == false || !Platform.isLinux) return null;
    try {
      final result = await Process.run('xprintidle', []);
      if (result.exitCode == 0) {
        final ms = int.tryParse(result.stdout.toString().trim());
        if (ms != null) {
          _xprintidleAvailable = true;
          return Duration(milliseconds: ms);
        }
      }
      _xprintidleAvailable = false;
    } catch (_) {
      _xprintidleAvailable = false;
    }
    return null;
  }

  Duration? _idleFromXss() {
    if (_xssAvailable == false || !Platform.isLinux) return null;
    try {
      final idle = queryX11IdleDuration();
      if (idle != null) {
        if (_xssAvailable != true) {
          _xssAvailable = true;
          _logger.info('Using X11 system idle (libXss) for idle detection');
        }
        return idle;
      }
      _xssAvailable = false;
    } catch (e, st) {
      _xssAvailable = false;
      _logger.verbose('X11 idle query failed', e, st);
    }
    return null;
  }

  Future<Duration> _idleFromAppHeartbeat() async {
    if (!_loggedFallback) {
      _loggedFallback = true;
      _logger.warning(
        'System idle tools unavailable; using in-app heartbeat only while '
        'the window is focused (minimized app will not count as idle)',
      );
    }

    final focused = await _isWindowFocused?.call() ?? true;
    if (!focused) {
      // User is likely working in another app — do not treat as idle.
      _lastActivity = _clock();
      return Duration.zero;
    }
    return _clock().difference(_lastActivity);
  }
}
