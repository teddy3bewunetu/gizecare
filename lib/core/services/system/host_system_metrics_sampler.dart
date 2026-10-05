import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/features/reports/domain/entities/system_metric_sample.dart';

/// Reads live host RAM / CPU / disk metrics (Linux-first; other platforms best-effort).
class HostSystemMetricsSampler {
  HostSystemMetricsSampler({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  _CpuSnap? _prevCpu;

  /// Collect one sample. Call at least ~1s apart for a meaningful CPU %.
  Future<SystemMetricSample> sample() async {
    final now = DateTime.now();
    final mem = await _readMemoryMb();
    final disk = await _readDiskMb();
    final cpu = await _readCpuPercent();
    final load = await _readLoadAvg1();

    return SystemMetricSample(
      id: _uuid.v4(),
      capturedAt: now,
      ramUsedMb: mem.$1,
      ramTotalMb: mem.$2,
      cpuPercent: cpu,
      diskUsedMb: disk.$1,
      diskTotalMb: disk.$2,
      loadAvg1: load,
      hostname: Platform.localHostname,
      platformLabel: '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
    );
  }

  Future<(int usedMb, int totalMb)> _readMemoryMb() async {
    if (Platform.isLinux) {
      try {
        final lines = await File('/proc/meminfo').readAsLines();
        var totalKb = 0;
        var availableKb = 0;
        for (final line in lines) {
          if (line.startsWith('MemTotal:')) {
            totalKb = _firstInt(line) ?? 0;
          } else if (line.startsWith('MemAvailable:')) {
            availableKb = _firstInt(line) ?? 0;
          }
        }
        if (totalKb > 0) {
          final usedKb = (totalKb - availableKb).clamp(0, totalKb);
          return (usedKb ~/ 1024, totalKb ~/ 1024);
        }
      } catch (e) {
        debugPrint('HostSystemMetricsSampler meminfo: $e');
      }
    }
    return (0, 0);
  }

  Future<(int usedMb, int totalMb)> _readDiskMb() async {
    try {
      if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('df', ['-kP', '/']);
        if (result.exitCode == 0) {
          final out = (result.stdout as String).trim().split('\n');
          if (out.length >= 2) {
            final parts = out.last.trim().split(RegExp(r'\s+'));
            // Filesystem 1024-blocks Used Available Capacity Mounted
            if (parts.length >= 4) {
              final totalKb = int.tryParse(parts[1]) ?? 0;
              final usedKb = int.tryParse(parts[2]) ?? 0;
              return (usedKb ~/ 1024, totalKb ~/ 1024);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('HostSystemMetricsSampler df: $e');
    }
    return (0, 0);
  }

  Future<double> _readCpuPercent() async {
    if (!Platform.isLinux) return 0;
    try {
      final line = (await File('/proc/stat').readAsLines())
          .firstWhere((l) => l.startsWith('cpu '), orElse: () => '');
      if (line.isEmpty) return 0;
      final parts = line.trim().split(RegExp(r'\s+'));
      // cpu user nice system idle iowait irq softirq steal ...
      if (parts.length < 5) return 0;
      final user = int.parse(parts[1]);
      final nice = int.parse(parts[2]);
      final system = int.parse(parts[3]);
      final idle = int.parse(parts[4]);
      final iowait = parts.length > 5 ? int.parse(parts[5]) : 0;
      final irq = parts.length > 6 ? int.parse(parts[6]) : 0;
      final softirq = parts.length > 7 ? int.parse(parts[7]) : 0;
      final steal = parts.length > 8 ? int.parse(parts[8]) : 0;
      final idleAll = idle + iowait;
      final nonIdle = user + nice + system + irq + softirq + steal;
      final total = idleAll + nonIdle;
      final snap = _CpuSnap(total: total, idle: idleAll);
      final prev = _prevCpu;
      _prevCpu = snap;
      if (prev == null) return 0;
      final totalDelta = snap.total - prev.total;
      final idleDelta = snap.idle - prev.idle;
      if (totalDelta <= 0) return 0;
      final busy = (1.0 - (idleDelta / totalDelta)) * 100.0;
      return busy.clamp(0, 100);
    } catch (e) {
      debugPrint('HostSystemMetricsSampler cpu: $e');
      return 0;
    }
  }

  Future<double?> _readLoadAvg1() async {
    if (!Platform.isLinux) return null;
    try {
      final raw = await File('/proc/loadavg').readAsString();
      return double.tryParse(raw.split(RegExp(r'\s+')).first);
    } catch (_) {
      return null;
    }
  }

  int? _firstInt(String line) {
    final m = RegExp(r'(\d+)').firstMatch(line);
    return m == null ? null : int.tryParse(m.group(1)!);
  }
}

class _CpuSnap {
  const _CpuSnap({required this.total, required this.idle});
  final int total;
  final int idle;
}
