import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/features/reports/domain/entities/system_metric_sample.dart';
import 'package:gizecare/features/reports/domain/repositories/system_metrics_repository.dart';

/// Drift-backed [SystemMetricsRepository].
class DriftSystemMetricsRepository implements SystemMetricsRepository {
  DriftSystemMetricsRepository(this._db, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<void> insert(SystemMetricSample sample) async {
    await _db.into(_db.systemMetricSamples).insert(
          SystemMetricSamplesCompanion.insert(
            id: sample.id.isEmpty ? _uuid.v4() : sample.id,
            capturedAt: sample.capturedAt,
            ramUsedMb: sample.ramUsedMb,
            ramTotalMb: sample.ramTotalMb,
            cpuPercent: sample.cpuPercent,
            diskUsedMb: sample.diskUsedMb,
            diskTotalMb: sample.diskTotalMb,
            loadAvg1: Value(sample.loadAvg1),
            hostname: Value(sample.hostname),
            platformLabel: Value(sample.platformLabel),
          ),
        );
  }

  @override
  Future<List<SystemMetricSample>> listSince(DateTime since) async {
    final rows = await (_db.select(_db.systemMetricSamples)
          ..where((t) => t.capturedAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.capturedAt)]))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Stream<List<SystemMetricSample>> watchSince(DateTime since) {
    return (_db.select(_db.systemMetricSamples)
          ..where((t) => t.capturedAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.capturedAt)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Future<void> pruneOlderThan(DateTime before) async {
    await (_db.delete(_db.systemMetricSamples)
          ..where((t) => t.capturedAt.isSmallerThanValue(before)))
        .go();
  }

  SystemMetricSample _map(SystemMetricSampleRow row) {
    return SystemMetricSample(
      id: row.id,
      capturedAt: row.capturedAt,
      ramUsedMb: row.ramUsedMb,
      ramTotalMb: row.ramTotalMb,
      cpuPercent: row.cpuPercent,
      diskUsedMb: row.diskUsedMb,
      diskTotalMb: row.diskTotalMb,
      loadAvg1: row.loadAvg1,
      hostname: row.hostname,
      platformLabel: row.platformLabel,
    );
  }
}
