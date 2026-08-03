import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';

/// Day or multi-day hour grid with overlapping event chips.
class CalendarDayGrid extends StatelessWidget {
  const CalendarDayGrid({
    required this.focusDay,
    required this.rangeStart,
    required this.dayCount,
    required this.items,
    required this.onTapItem,
    super.key,
  });

  final DateTime focusDay;
  final DateTime rangeStart;
  final int dayCount;
  final List<CalendarItem> items;
  final ValueChanged<CalendarItem> onTapItem;

  static const _hourHeight = 56.0;
  static const _hours = 24;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        if (dayCount > 1)
          SizedBox(
            height: 36,
            child: Row(
              children: [
                const SizedBox(width: 56),
                for (var i = 0; i < dayCount; i++)
                  Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('EEE d').format(
                          rangeStart.add(Duration(days: i)),
                        ),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: _isSameDay(
                                    rangeStart.add(Duration(days: i)),
                                    focusDay,
                                  )
                                  ? AppColors.brand
                                  : scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              height: _hourHeight * _hours,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        for (var h = 0; h < _hours; h++)
                          SizedBox(
                            height: _hourHeight,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8, top: 0),
                                child: Text(
                                  _hourLabel(h),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  for (var d = 0; d < dayCount; d++)
                    Expanded(
                      child: _DayColumn(
                        day: rangeStart.add(Duration(days: d)),
                        items: items,
                        hourHeight: _hourHeight,
                        hours: _hours,
                        onTapItem: onTapItem,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _hourLabel(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.items,
    required this.hourHeight,
    required this.hours,
    required this.onTapItem,
  });

  final DateTime day;
  final List<CalendarItem> items;
  final double hourHeight;
  final int hours;
  final ValueChanged<CalendarItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayItems = items.where((item) {
      return item.startAt.isBefore(dayEnd) && item.endAt.isAfter(dayStart);
    }).toList();

    return Stack(
      children: [
        Column(
          children: [
            for (var h = 0; h < hours; h++)
              Container(
                height: hourHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: scheme.outlineVariant.withValues(alpha: 0.35),
                    ),
                    left: BorderSide(
                      color: scheme.outlineVariant.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (final item in dayItems)
          _EventBlock(
            item: item,
            dayStart: dayStart,
            hourHeight: hourHeight,
            onTap: () => onTapItem(item),
          ),
      ],
    );
  }
}

class _EventBlock extends StatelessWidget {
  const _EventBlock({
    required this.item,
    required this.dayStart,
    required this.hourHeight,
    required this.onTap,
  });

  final CalendarItem item;
  final DateTime dayStart;
  final double hourHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final start = item.startAt.isBefore(dayStart) ? dayStart : item.startAt;
    final dayEnd = dayStart.add(const Duration(days: 1));
    final end = item.endAt.isAfter(dayEnd) ? dayEnd : item.endAt;
    final minutesFromMidnight =
        start.difference(dayStart).inMinutes.clamp(0, 24 * 60);
    final durationMinutes =
        end.difference(start).inMinutes.clamp(20, 24 * 60).toDouble();
    final top = minutesFromMidnight / 60.0 * hourHeight;
    final height = durationMinutes / 60.0 * hourHeight;
    final color = item.color ?? AppColors.brand;

    return Positioned(
      left: 4,
      right: 4,
      top: top,
      height: height,
      child: Material(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border(
                left: BorderSide(color: color, width: 3),
              ),
            ),
            child: Text(
              item.title,
              maxLines: height < 40 ? 1 : 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
