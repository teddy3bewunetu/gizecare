import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/services/system/host_system_metrics_sampler.dart';
import 'package:gizecare/features/reports/domain/entities/feature_usage.dart';
import 'package:gizecare/features/reports/domain/feature_path_mapper.dart';
import 'package:gizecare/features/reports/domain/repositories/feature_usage_repository.dart';

/// Records dwell time + host RAM/CPU while a feature/page is open.
class FeatureUsageTracker with WidgetsBindingObserver {
  FeatureUsageTracker({
    required FeatureUsageRepository repository,
    required HostSystemMetricsSampler sampler,
    Uuid? uuid,
  })  : _repository = repository,
        _sampler = sampler,
        _uuid = uuid ?? const Uuid();

  final FeatureUsageRepository _repository;
  final HostSystemMetricsSampler _sampler;
  final Uuid _uuid;

  String? _activeKey;
  String? _activeLabel;
  DateTime? _startedAt;
  final _ramSamples = <double>[];
  final _cpuSamples = <double>[];
  Timer? _metricTimer;
  var _observing = false;
  var _disposed = false;

  void start() {
    if (_observing) return;
    _observing = true;
    WidgetsBinding.instance.addObserver(this);
  }

  /// Call whenever the shell route path changes.
  void onPathChanged(String path) {
    if (_disposed) return;
    final feature = featureForPath(path);
    if (feature.key == _activeKey) return;
    unawaited(_rollTo(feature.key, feature.label));
  }

  Future<void> _rollTo(String key, String label) async {
    await _closeCurrent();
    _activeKey = key;
    _activeLabel = label;
    _startedAt = DateTime.now();
    _ramSamples.clear();
    _cpuSamples.clear();
    unawaited(_captureMetrics());
    _metricTimer?.cancel();
    _metricTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      unawaited(_captureMetrics());
    });
  }

  Future<void> _captureMetrics({bool quick = false}) async {
    try {
      if (!quick) {
        // Two reads ~1s apart so CPU % is meaningful.
        await _sampler.sample();
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      final sample = await _sampler.sample();
      if (_activeKey == null) return;
      _ramSamples.add(sample.ramPercent.clamp(0, 100));
      _cpuSamples.add(sample.cpuPercent.clamp(0, 100));
    } catch (_) {}
  }

  double? _avg(List<double> values) {
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  Future<void> _closeCurrent() async {
    _metricTimer?.cancel();
    _metricTimer = null;

    final key = _activeKey;
    final label = _activeLabel;
    final started = _startedAt;
    if (key == null || label == null || started == null) {
      _activeKey = null;
      _activeLabel = null;
      _startedAt = null;
      _ramSamples.clear();
      _cpuSamples.clear();
      return;
    }

    final ended = DateTime.now();
    final ms = ended.difference(started).inMilliseconds;
    // Ignore tiny flicker navigations.
    if (ms < 800) {
      _activeKey = null;
      _activeLabel = null;
      _startedAt = null;
      _ramSamples.clear();
      _cpuSamples.clear();
      return;
    }

    // Final sample while this feature is still marked active.
    await _captureMetrics(quick: _ramSamples.isNotEmpty || _cpuSamples.isNotEmpty);
    final avgRam = _avg(_ramSamples);
    final avgCpu = _avg(_cpuSamples);

    _activeKey = null;
    _activeLabel = null;
    _startedAt = null;
    _ramSamples.clear();
    _cpuSamples.clear();

    try {
      await _repository.insert(
        FeatureUsageSession(
          id: _uuid.v4(),
          featureKey: key,
          featureLabel: label,
          startedAt: started,
          endedAt: ended,
          durationMs: ms,
          avgRamPercent: avgRam,
          avgCpuPercent: avgCpu,
        ),
      );
      await _repository
          .pruneOlderThan(DateTime.now().subtract(const Duration(days: 14)));
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_closeCurrent());
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _metricTimer?.cancel();
    if (_observing) {
      WidgetsBinding.instance.removeObserver(this);
      _observing = false;
    }
    await _closeCurrent();
  }
}
