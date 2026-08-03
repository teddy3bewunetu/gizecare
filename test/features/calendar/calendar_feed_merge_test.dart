import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/features/calendar/data/repositories/calendar_feed_repository_impl.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';

void main() {
  test('mergeCalendarFeed sorts and respects layer flags', () {
    final google = [
      CalendarItem(
        id: 'g1',
        source: CalendarItemSource.google,
        title: 'Meet',
        startAt: DateTime(2026, 8, 1, 10),
        endAt: DateTime(2026, 8, 1, 11),
        allDay: false,
        color: Colors.green,
      ),
    ];
    final tasks = [
      CalendarItem(
        id: 't1',
        source: CalendarItemSource.task,
        title: 'Due task',
        startAt: DateTime(2026, 8, 1, 9),
        endAt: DateTime(2026, 8, 1, 9, 30),
        allDay: false,
        color: Colors.purple,
      ),
    ];
    final time = [
      CalendarItem(
        id: 'e1',
        source: CalendarItemSource.timeEntry,
        title: 'Tracked',
        startAt: DateTime(2026, 8, 1, 12),
        endAt: DateTime(2026, 8, 1, 13),
        allDay: false,
        color: Colors.blue,
      ),
    ];

    final all = mergeCalendarFeed(
      googleEvents: google,
      tasks: tasks,
      timeEntries: time,
    );
    expect(all.map((e) => e.id).toList(), ['t1', 'g1', 'e1']);

    final noTasks = mergeCalendarFeed(
      googleEvents: google,
      tasks: tasks,
      timeEntries: time,
      includeTasks: false,
    );
    expect(noTasks.map((e) => e.id).toList(), ['g1', 'e1']);
  });
}
