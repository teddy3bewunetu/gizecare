/// Formatting helpers for clock tools.
abstract final class ClockFormatters {
  static String stopwatch(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    final cs = (d.inMilliseconds.remainder(1000) / 10).floor();
    final body =
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${cs.toString().padLeft(2, '0')}';
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$body';
    }
    return body;
  }

  static String countdown(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  static String alarmTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String lapDuration(int ms) =>
      stopwatch(Duration(milliseconds: ms));
}
