import 'package:gizecare/features/reports/domain/entities/system_metric_sample.dart';

/// Persisted host performance samples for Reports → System.
abstract class SystemMetricsRepository {
  Future<void> insert(SystemMetricSample sample);

  /// Newest-first samples since [since] (inclusive).
  Future<List<SystemMetricSample>> listSince(DateTime since);

  Stream<List<SystemMetricSample>> watchSince(DateTime since);

  /// Drop samples older than [before].
  Future<void> pruneOlderThan(DateTime before);
}
