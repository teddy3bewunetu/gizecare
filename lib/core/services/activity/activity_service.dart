import 'dart:async';

/// Aggregates keyboard / pointer activity into a percentage and key rankings.
class ActivityService {
  ActivityService({
    DateTime Function()? clock,
    this.window = const Duration(minutes: 1),
  }) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Duration window;

  final List<DateTime> _events = [];
  final Map<String, int> _keyCounts = {};
  int _currentPercentage = 0;
  Timer? _timer;
  void Function(int percentage)? onPercentageChanged;

  /// Latest computed activity percentage (0–100).
  int get currentPercentage => _currentPercentage;

  /// Snapshot of key → press count for the current session.
  Map<String, int> get keyCounts => Map.unmodifiable(_keyCounts);

  /// Keys sorted by frequency (most used first).
  List<MapEntry<String, int>> rankedKeys({int limit = 30}) {
    final entries = _keyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (entries.length <= limit) return entries;
    return entries.sublist(0, limit);
  }

  int get totalKeyPresses =>
      _keyCounts.values.fold<int>(0, (sum, c) => sum + c);

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _recompute());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Records a key press. Pass [keyLabel] (e.g. `a`, `Enter`) to count it.
  void recordKeyEvent([String? keyLabel]) {
    _record();
    final label = _normalizeKeyLabel(keyLabel);
    if (label == null) return;
    _keyCounts[label] = (_keyCounts[label] ?? 0) + 1;
  }

  void recordPointerEvent() => _record();

  /// Clears sliding-window activity and key tallies (call on new session).
  void resetSession() {
    _events.clear();
    _keyCounts.clear();
    _currentPercentage = 0;
  }

  /// Returns and clears key counts (for persisting at session end).
  Map<String, int> takeKeyCounts() {
    final copy = Map<String, int>.from(_keyCounts);
    _keyCounts.clear();
    return copy;
  }

  void dispose() {
    stop();
    _events.clear();
    _keyCounts.clear();
  }

  void _record() {
    _events.add(_clock());
    _recompute();
  }

  void _recompute() {
    final cutoff = _clock().subtract(window);
    _events.removeWhere((e) => e.isBefore(cutoff));
    // Heuristic: 60+ events/minute ≈ 100% activity.
    final score = ((_events.length / 60) * 100).clamp(0, 100).round();
    if (score != _currentPercentage) {
      _currentPercentage = score;
      onPercentageChanged?.call(score);
    }
  }

  String? _normalizeKeyLabel(String? raw) {
    if (raw == null) return null;
    var label = raw.trim();
    if (label.isEmpty) return null;
    // Collapse whitespace-only labels.
    if (label == ' ') return 'Space';
    // Cap length for weird OS key names.
    if (label.length > 24) {
      label = label.substring(0, 24);
    }
    return label;
  }
}
