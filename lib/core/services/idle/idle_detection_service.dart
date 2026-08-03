/// Idle status reported by [IdleDetectionService].
enum IdleStatus { active, idle }

/// Snapshot of user idle state.
class IdleInfo {
  const IdleInfo({required this.idleDuration, required this.status});

  final Duration idleDuration;
  final IdleStatus status;
}

/// Platform-abstracted idle detection.
abstract class IdleDetectionService {
  /// Current idle duration and status relative to [timeout].
  Future<IdleInfo> getIdleInfo({required Duration timeout});

  /// Starts polling; invokes [onIdle] when timeout is exceeded.
  void startMonitoring({
    required Duration timeout,
    required void Function(IdleInfo info) onIdle,
    Duration pollInterval = const Duration(seconds: 5),
  });

  void stopMonitoring();

  void dispose();
}
