import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/database_provider.dart';
import 'package:gizecare/core/services/system/host_system_metrics_sampler.dart';
import 'package:gizecare/features/reports/data/repositories/drift_feature_usage_repository.dart';
import 'package:gizecare/features/reports/data/repositories/drift_system_metrics_repository.dart';
import 'package:gizecare/features/reports/domain/entities/feature_usage.dart';
import 'package:gizecare/features/reports/domain/entities/system_metric_sample.dart';
import 'package:gizecare/features/reports/domain/repositories/feature_usage_repository.dart';
import 'package:gizecare/features/reports/domain/repositories/system_metrics_repository.dart';
import 'package:gizecare/features/reports/presentation/providers/feature_usage_tracker.dart';

final systemMetricsRepositoryProvider = Provider<SystemMetricsRepository>((ref) {
  return DriftSystemMetricsRepository(ref.watch(appDatabaseProvider));
});

final featureUsageRepositoryProvider = Provider<FeatureUsageRepository>((ref) {
  return DriftFeatureUsageRepository(ref.watch(appDatabaseProvider));
});

final hostSystemMetricsSamplerProvider = Provider<HostSystemMetricsSampler>((ref) {
  return HostSystemMetricsSampler();
});

/// How far back System history charts look.
enum SystemHistoryRange { hours6, hours24, days7 }

final systemHistoryRangeProvider =
    StateProvider<SystemHistoryRange>((ref) => SystemHistoryRange.hours24);

Duration historyDurationFor(SystemHistoryRange range) {
  switch (range) {
    case SystemHistoryRange.hours6:
      return const Duration(hours: 6);
    case SystemHistoryRange.hours24:
      return const Duration(hours: 24);
    case SystemHistoryRange.days7:
      return const Duration(days: 7);
  }
}

/// Live sample (refreshed while watched). Also persists on each tick.
final liveSystemMetricsProvider =
    StreamProvider.autoDispose<SystemMetricSample>((ref) async* {
  final sampler = ref.watch(hostSystemMetricsSamplerProvider);
  final repo = ref.watch(systemMetricsRepositoryProvider);

  // Prime CPU baseline.
  await sampler.sample();
  await Future<void>.delayed(const Duration(seconds: 1));

  Future<SystemMetricSample> capture() async {
    final sample = await sampler.sample();
    await repo.insert(sample);
    // Keep ~14 days of history.
    await repo.pruneOlderThan(DateTime.now().subtract(const Duration(days: 14)));
    return sample;
  }

  yield await capture();
  final timer = Stream<void>.periodic(const Duration(seconds: 5));
  await for (final _ in timer) {
    yield await capture();
  }
});

/// Persisted samples for charts.
final systemMetricsHistoryProvider =
    StreamProvider.autoDispose<List<SystemMetricSample>>((ref) {
  final range = ref.watch(systemHistoryRangeProvider);
  final since = DateTime.now().subtract(historyDurationFor(range));
  return ref.watch(systemMetricsRepositoryProvider).watchSince(since);
});

/// Aggregated in-app feature dwell for the selected System range.
final featureUsageSummariesProvider =
    StreamProvider.autoDispose<List<FeatureUsageSummary>>((ref) {
  final range = ref.watch(systemHistoryRangeProvider);
  final since = DateTime.now().subtract(historyDurationFor(range));
  return ref.watch(featureUsageRepositoryProvider).watchSummariesSince(since);
});

/// Records route dwell while the shell is mounted.
final featureUsageTrackerProvider = Provider<FeatureUsageTracker>((ref) {
  final tracker = FeatureUsageTracker(
    repository: ref.watch(featureUsageRepositoryProvider),
    sampler: ref.watch(hostSystemMetricsSamplerProvider),
  );
  ref.onDispose(tracker.dispose);
  tracker.start();
  return tracker;
});

/// Background capture while the app runs (slower than the live tab).
final systemMetricsCaptureControllerProvider =
    Provider<SystemMetricsCaptureController>((ref) {
  final controller = SystemMetricsCaptureController(
    sampler: ref.watch(hostSystemMetricsSamplerProvider),
    repository: ref.watch(systemMetricsRepositoryProvider),
  );
  ref.onDispose(controller.dispose);
  controller.start();
  return controller;
});

/// Periodically stores host metrics even when Reports is not open.
class SystemMetricsCaptureController {
  SystemMetricsCaptureController({
    required HostSystemMetricsSampler sampler,
    required SystemMetricsRepository repository,
  })  : _sampler = sampler,
        _repository = repository;

  final HostSystemMetricsSampler _sampler;
  final SystemMetricsRepository _repository;
  Timer? _timer;
  var _started = false;

  void start() {
    if (_started) return;
    _started = true;
    unawaited(_tick());
    _timer = Timer.periodic(const Duration(minutes: 2), (_) {
      unawaited(_tick());
    });
  }

  Future<void> _tick() async {
    try {
      // Two quick samples so CPU % is meaningful after cold start.
      await _sampler.sample();
      await Future<void>.delayed(const Duration(seconds: 1));
      final sample = await _sampler.sample();
      await _repository.insert(sample);
      await _repository
          .pruneOlderThan(DateTime.now().subtract(const Duration(days: 14)));
    } catch (_) {}
  }

  void dispose() {
    _timer?.cancel();
  }
}
