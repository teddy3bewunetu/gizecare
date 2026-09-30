import 'package:gizecare/features/reports/domain/entities/feature_usage.dart';

/// Persisted in-app feature / page dwell sessions.
abstract class FeatureUsageRepository {
  Future<void> insert(FeatureUsageSession session);

  Stream<List<FeatureUsageSummary>> watchSummariesSince(DateTime since);

  Future<void> pruneOlderThan(DateTime before);
}
