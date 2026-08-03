import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/utils/formatters.dart';
import 'package:gizecare/features/tracker/domain/entities/time_entry.dart';

/// Today's time entries.
final todayEntriesProvider = StreamProvider<List<TimeEntry>>((ref) {
  final start = Formatters.startOfDay(DateTime.now());
  final end = start.add(const Duration(days: 1));
  return ref
      .watch(timeEntryRepositoryProvider)
      .watchEntries(from: start, to: end);
});

/// This week's time entries.
final weekEntriesProvider = StreamProvider<List<TimeEntry>>((ref) {
  final start = Formatters.startOfWeek(DateTime.now());
  final end = start.add(const Duration(days: 7));
  return ref
      .watch(timeEntryRepositoryProvider)
      .watchEntries(from: start, to: end);
});

/// Report range selection.
enum ReportRange { daily, weekly, monthly }

final reportRangeProvider = StateProvider<ReportRange>((ref) => ReportRange.weekly);

final reportEntriesProvider = StreamProvider<List<TimeEntry>>((ref) {
  final range = ref.watch(reportRangeProvider);
  final now = DateTime.now();
  late final DateTime from;
  late final DateTime to;
  switch (range) {
    case ReportRange.daily:
      from = Formatters.startOfDay(now);
      to = from.add(const Duration(days: 1));
    case ReportRange.weekly:
      from = Formatters.startOfWeek(now);
      to = from.add(const Duration(days: 7));
    case ReportRange.monthly:
      from = Formatters.startOfMonth(now);
      to = DateTime(from.year, from.month + 1);
  }
  return ref
      .watch(timeEntryRepositoryProvider)
      .watchEntries(from: from, to: to);
});
