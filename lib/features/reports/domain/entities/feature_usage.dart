/// One closed dwell interval on a feature / page.
class FeatureUsageSession {
  const FeatureUsageSession({
    required this.id,
    required this.featureKey,
    required this.featureLabel,
    required this.startedAt,
    required this.endedAt,
    required this.durationMs,
    this.avgRamPercent,
    this.avgCpuPercent,
  });

  final String id;
  final String featureKey;
  final String featureLabel;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMs;
  final double? avgRamPercent;
  final double? avgCpuPercent;
}

/// Aggregated time + visit count for a feature in a history window.
class FeatureUsageSummary {
  const FeatureUsageSummary({
    required this.featureKey,
    required this.featureLabel,
    required this.totalDurationMs,
    required this.visitCount,
    this.avgRamPercent,
    this.avgCpuPercent,
  });

  final String featureKey;
  final String featureLabel;
  final int totalDurationMs;
  final int visitCount;
  /// Duration-weighted average RAM % across visits that recorded it.
  final double? avgRamPercent;
  /// Duration-weighted average CPU % across visits that recorded it.
  final double? avgCpuPercent;

  Duration get totalDuration => Duration(milliseconds: totalDurationMs);
}
