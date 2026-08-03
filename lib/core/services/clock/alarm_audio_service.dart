import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/constants/alarm_sounds.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/services/app_logger.dart';

/// Plays bundled alarm ringtones.
///
/// Desktop uses `ffplay`/`aplay`. Mobile uses [SystemSound] (no native audio
/// plugin — keeps Linux desktop builds free of gstreamer).
class AlarmAudioService {
  AlarmAudioService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  Process? _process;
  Timer? _mobileLoop;
  bool _playing = false;
  bool _wantLoop = false;
  String? _activePath;

  bool get isPlaying => _playing;

  Future<void> preview(AlarmSound sound) async {
    await stop();
    try {
      if (AppPlatform.isMobile) {
        await _playMobile(loop: false);
      } else {
        final path = await _materializeAsset(sound.assetPath);
        await _spawn(path, loop: false);
      }
    } catch (e, st) {
      _logger.warning('Alarm preview failed', e, st);
    }
  }

  Future<void> ring(AlarmSound sound) async {
    await stop();
    try {
      if (AppPlatform.isMobile) {
        await _playMobile(loop: true);
      } else {
        final path = await _materializeAsset(sound.assetPath);
        await _spawn(path, loop: true);
      }
    } catch (e, st) {
      _logger.warning('Alarm ring failed', e, st);
      _playing = false;
    }
  }

  Future<void> stop() async {
    _wantLoop = false;
    _activePath = null;
    _playing = false;
    _mobileLoop?.cancel();
    _mobileLoop = null;

    final proc = _process;
    _process = null;
    if (proc == null) return;
    try {
      proc.kill(ProcessSignal.sigterm);
      await proc.exitCode.timeout(const Duration(milliseconds: 800));
    } catch (_) {
      try {
        proc.kill(ProcessSignal.sigkill);
      } catch (_) {}
    }
  }

  Future<void> dispose() => stop();

  Future<void> _playMobile({required bool loop}) async {
    _wantLoop = loop;
    _playing = true;
    await SystemSound.play(SystemSoundType.alert);
    if (!loop) {
      _playing = false;
      return;
    }
    _mobileLoop = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!_wantLoop) return;
      await SystemSound.play(SystemSoundType.alert);
    });
  }

  Future<String> _materializeAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();
    final outDir = Directory(p.join(dir.path, 'gizecare_alarms'));
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }
    final file = File(p.join(outDir.path, p.basename(assetPath)));
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    return file.path;
  }

  Future<void> _spawn(String path, {required bool loop}) async {
    _wantLoop = loop;
    _activePath = path;

    if (await _commandExists('ffplay')) {
      _process = await Process.start(
        'ffplay',
        [
          '-nodisp',
          '-loglevel',
          'quiet',
          if (loop) ...['-loop', '0'],
          if (!loop) '-autoexit',
          path,
        ],
        mode: ProcessStartMode.normal,
      );
      _playing = true;
      unawaited(_watchExit(path, loop: loop));
      return;
    }

    if (await _commandExists('aplay')) {
      _process = await Process.start('aplay', ['-q', path]);
      _playing = true;
      unawaited(_watchExit(path, loop: loop));
      return;
    }

    throw StateError(
      'No audio player found — install ffmpeg (ffplay) or alsa-utils (aplay)',
    );
  }

  Future<void> _watchExit(String path, {required bool loop}) async {
    final proc = _process;
    if (proc == null) return;
    final code = await proc.exitCode;
    if (_process != proc) return;
    _process = null;
    if (loop && _wantLoop && _activePath == path) {
      try {
        await _spawn(path, loop: true);
      } catch (e, st) {
        _playing = false;
        _logger.warning('Alarm loop restart failed', e, st);
      }
    } else {
      _playing = false;
      if (code != 0 && code != -15 && code != -9) {
        _logger.verbose('Alarm player exited with code $code');
      }
    }
  }

  Future<bool> _commandExists(String name) async {
    try {
      final result = await Process.run('which', [name]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}
