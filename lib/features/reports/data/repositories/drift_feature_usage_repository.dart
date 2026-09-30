import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/features/reports/domain/entities/feature_usage.dart';
import 'package:gizecare/features/reports/domain/repositories/feature_usage_repository.dart';

/// Drift-backed [FeatureUsageRepository].
class DriftFeatureUsageRepository implements FeatureUsageRepository {
  DriftFeatureUsageRepository(this._db, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<void> insert(FeatureUsageSession session) async {
    await _db.into(_db.featureUsageSessions).insert(
          FeatureUsageSessionsCompanion.insert(
            id: session.id.isEmpty ? _uuid.v4() : session.id,
            featureKey: session.featureKey,
            featureLabel: session.featureLabel,
            startedAt: session.startedAt,
            endedAt: session.endedAt,
            durationMs: session.durationMs,
            avgRamPercent: Value(session.avgRamPercent),
            avgCpuPercent: Value(session.avgCpuPercent),
          ),
        );
  }

  @override
  Stream<List<FeatureUsageSummary>> watchSummariesSince(DateTime since) {
    return (_db.select(_db.featureUsageSessions)
          ..where((t) => t.endedAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.desc(t.endedAt)]))
        .watch()
        .map(_aggregate);
  }

  @override
  Future<void> pruneOlderThan(DateTime before) async {
    await (_db.delete(_db.featureUsageSessions)
          ..where((t) => t.endedAt.isSmallerThanValue(before)))
        .go();
  }

  List<FeatureUsageSummary> _aggregate(List<FeatureUsageSessionRow> rows) {
    final byKey = <String, _Agg>{};
    for (final row in rows) {
      final existing = byKey[row.featureKey];
      if (existing == null) {
        byKey[row.featureKey] = _Agg(
          featureKey: row.featureKey,
          featureLabel: row.featureLabel,
          totalDurationMs: row.durationMs,
          visitCount: 1,
        ).._addMetrics(row);
      } else {
        existing.totalDurationMs += row.durationMs;
        existing.visitCount += 1;
        existing.featureLabel = row.featureLabel;
        existing._addMetrics(row);
      }
    }
    final list = byKey.values
        .map(
          (a) => FeatureUsageSummary(
            featureKey: a.featureKey,
            featureLabel: a.featureLabel,
            totalDurationMs: a.totalDurationMs,
            visitCount: a.visitCount,
            avgRamPercent: a.ramWeightMs > 0
                ? a.ramWeightedSum / a.ramWeightMs
                : null,
            avgCpuPercent: a.cpuWeightMs > 0
                ? a.cpuWeightedSum / a.cpuWeightMs
                : null,
          ),
        )
        .toList()
      ..sort((a, b) => b.totalDurationMs.compareTo(a.totalDurationMs));
    return list;
  }
}

class _Agg {
  _Agg({
    required this.featureKey,
    required this.featureLabel,
    required this.totalDurationMs,
    required this.visitCount,
  });

  final String featureKey;
  String featureLabel;
  int totalDurationMs;
  int visitCount;
  double ramWeightedSum = 0;
  int ramWeightMs = 0;
  double cpuWeightedSum = 0;
  int cpuWeightMs = 0;

  void _addMetrics(FeatureUsageSessionRow row) {
    final w = row.durationMs <= 0 ? 1 : row.durationMs;
    if (row.avgRamPercent != null) {
      ramWeightedSum += row.avgRamPercent! * w;
      ramWeightMs += w;
    }
    if (row.avgCpuPercent != null) {
      cpuWeightedSum += row.avgCpuPercent! * w;
      cpuWeightMs += w;
    }
  }
}
