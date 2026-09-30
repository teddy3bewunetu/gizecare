/// One captured snapshot of host RAM / CPU / disk usage.
class SystemMetricSample {
  const SystemMetricSample({
    required this.id,
    required this.capturedAt,
    required this.ramUsedMb,
    required this.ramTotalMb,
    required this.cpuPercent,
    required this.diskUsedMb,
    required this.diskTotalMb,
    this.loadAvg1,
    this.hostname,
    this.platformLabel,
  });

  final String id;
  final DateTime capturedAt;
  final int ramUsedMb;
  final int ramTotalMb;
  final double cpuPercent;
  final int diskUsedMb;
  final int diskTotalMb;
  final double? loadAvg1;
  final String? hostname;
  final String? platformLabel;

  double get ramPercent =>
      ramTotalMb <= 0 ? 0 : (ramUsedMb / ramTotalMb) * 100;

  double get diskPercent =>
      diskTotalMb <= 0 ? 0 : (diskUsedMb / diskTotalMb) * 100;
}
