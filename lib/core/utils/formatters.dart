import 'package:intl/intl.dart';

/// Duration and date formatting helpers.
abstract final class Formatters {
  static String duration(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  static String hoursCompact(Duration value) {
    final hours = value.inMinutes / 60.0;
    if (hours < 10) {
      return '${hours.toStringAsFixed(1)}h';
    }
    return '${hours.toStringAsFixed(0)}h';
  }

  /// Upwork-style `26:40 hrs` (hours:minutes).
  static String hoursHm(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')} hrs';
  }

  static String money(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String dayLabel(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  static String dateTime(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime startOfWeek(DateTime date) {
    final day = startOfDay(date);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);
}
