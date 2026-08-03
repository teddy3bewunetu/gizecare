import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/screenshots/domain/repositories/screenshot_repository.dart';

/// Captures screenshots automatically while tracking.
///
/// Uses the configured interval (default 10 minutes) most of the time, with
/// occasional random jitter — similar to Upwork-style sampling. Scheduling
/// continues for the whole running session without needing manual capture.
class ScreenshotService {
  ScreenshotService({
    required ScreenshotRepository repository,
    required AppLogger logger,
    Uuid? uuid,
    Random? random,
  })  : _repository = repository,
        _logger = logger,
        _uuid = uuid ?? const Uuid(),
        _random = random ?? Random();

  final ScreenshotRepository _repository;
  final AppLogger _logger;
  final Uuid _uuid;
  final Random _random;

  Timer? _timer;
  String? _activeTimeEntryId;
  Duration _baseInterval = AppConstants.defaultScreenshotInterval;
  bool _capturing = false;
  bool _sessionActive = false;

  /// Whether a capture session is active for a time entry.
  bool get isRunning => _sessionActive && _activeTimeEntryId != null;

  String? get activeTimeEntryId => _activeTimeEntryId;

  void start({
    required String timeEntryId,
    required Duration interval,
  }) {
    stop();
    if (!AppPlatform.supportsAutoScreenshots) {
      _logger.info(
        'Screenshot capture skipped on mobile — desktop feature only',
      );
      return;
    }
    _activeTimeEntryId = timeEntryId;
    _sessionActive = true;
    _baseInterval = interval < const Duration(seconds: 30)
        ? const Duration(seconds: 30)
        : interval;
    final firstDelay = _nextDelay(preferStandard: false);
    _logger.info(
      'Screenshot session started for $timeEntryId '
      '(base ${_baseInterval.inMinutes} min; first in '
      '${firstDelay.inSeconds}s)',
    );
    _schedule(firstDelay);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _sessionActive = false;
    _activeTimeEntryId = null;
  }

  Future<Result<ScreenshotItem>> captureNow({String? timeEntryId}) async {
    final entryId = timeEntryId ?? _activeTimeEntryId;
    if (entryId == null) {
      return const Err(ValidationFailure('No active time entry for screenshot'));
    }
    if (_capturing) {
      return const Err(ValidationFailure('Screenshot already in progress'));
    }
    _capturing = true;

    try {
      final dir = await _ensureScreenshotDir();
      final fileName =
          'gizecare_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = p.join(dir.path, fileName);
      final captured = await _captureToFile(filePath);
      if (!captured) {
        _logger.warning(
          'Screenshot tool unavailable — install ImageMagick (import), '
          'gnome-screenshot, scrot, or grim',
        );
        return const Err(
          PlatformFailure('Screenshot tool unavailable on this system'),
        );
      }

      final item = ScreenshotItem(
        id: _uuid.v4(),
        timeEntryId: entryId,
        filePath: filePath,
        takenAt: DateTime.now(),
      );
      final saved = await _repository.create(item);
      saved.when(
        onSuccess: (_) => _logger.info('Screenshot saved: $filePath'),
        onFailure: (f) => _logger.warning('Screenshot DB save failed: $f'),
      );
      return saved;
    } catch (e, st) {
      _logger.warning('Failed to capture screenshot', e, st);
      return Err(PlatformFailure('Failed to capture screenshot', cause: e));
    } finally {
      _capturing = false;
    }
  }

  void dispose() => stop();

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, () => unawaited(_onTick()));
  }

  Future<void> _onTick() async {
    if (!_sessionActive) return;
    final entryId = _activeTimeEntryId;
    if (entryId == null) return;

    await captureNow(timeEntryId: entryId);
    if (!_sessionActive) return;

    final next = _nextDelay(preferStandard: true);
    _logger.verbose('Next screenshot in ${next.inSeconds}s');
    _schedule(next);
  }

  /// Mostly the configured interval; ~30% of the time apply mild random jitter.
  Duration _nextDelay({required bool preferStandard}) {
    final baseMs = _baseInterval.inMilliseconds;
    // First shot in a session: land randomly inside the interval window so
    // capture is not tied to the Start button moment.
    if (!preferStandard) {
      final minMs = max(30 * 1000, (baseMs * 0.4).round());
      final span = max(1, baseMs - minMs);
      return Duration(milliseconds: minMs + _random.nextInt(span));
    }

    // ~70% exact standard interval.
    if (_random.nextDouble() < 0.7) {
      return _baseInterval;
    }

    // ~30% jitter ±20% around the standard interval.
    final factor = 0.8 + _random.nextDouble() * 0.4;
    final ms = max(30 * 1000, (baseMs * factor).round());
    return Duration(milliseconds: ms);
  }

  Future<Directory> _ensureScreenshotDir() async {
    final pictures = await getApplicationDocumentsDirectory();
    Directory dir;
    if (Platform.isLinux || Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        dir = Directory(
          p.join(home, 'Pictures', AppConstants.screenshotsFolderName),
        );
      } else {
        dir = Directory(
          p.join(pictures.path, AppConstants.screenshotsFolderName),
        );
      }
    } else {
      dir = Directory(p.join(pictures.path, AppConstants.screenshotsFolderName));
    }
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<bool> _captureToFile(String path) async {
    if (Platform.isLinux) {
      return _captureLinux(path);
    }
    if (Platform.isMacOS) {
      return _runCapture(['screencapture', '-x', path], path);
    }
    return false;
  }

  Future<bool> _captureLinux(String path) async {
    final isWayland = Platform.environment['XDG_SESSION_TYPE'] == 'wayland' ||
        (Platform.environment['WAYLAND_DISPLAY']?.isNotEmpty ?? false);

    final candidates = <List<String>>[
      if (isWayland) ...[
        ['grim', path],
        ['gnome-screenshot', '-f', path],
        ['spectacle', '-b', '-n', '-o', path],
      ],
      ['import', '-window', 'root', path],
      ['import', '-silent', '-window', 'root', path],
      ['gnome-screenshot', '-f', path],
      ['spectacle', '-b', '-n', '-o', path],
      ['scrot', path],
      ['flameshot', 'full', '-p', path],
    ];

    for (final command in candidates) {
      final ok = await _runCapture(command, path);
      if (ok) return true;
    }
    return false;
  }

  Future<bool> _runCapture(List<String> command, String path) async {
    try {
      final env = Map<String, String>.from(Platform.environment);
      env.putIfAbsent('DISPLAY', () => ':0');

      final result = await Process.run(
        command.first,
        command.sublist(1),
        environment: env,
        runInShell: false,
      );

      if (result.exitCode == 0 && await File(path).exists()) {
        final size = await File(path).length();
        if (size > 0) return true;
        await File(path).delete();
      } else {
        final err = result.stderr.toString().trim();
        if (err.isNotEmpty) {
          _logger.verbose('Screenshot ${command.first} failed: $err');
        }
      }
    } catch (e) {
      _logger.verbose('Screenshot ${command.first} unavailable: $e');
    }
    return false;
  }
}
