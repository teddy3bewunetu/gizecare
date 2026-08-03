import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/services/activity/activity_service.dart';

void main() {
  test('activity percentage increases with events', () {
    var now = DateTime(2026, 1, 1, 12);
    final service = ActivityService(clock: () => now);
    expect(service.currentPercentage, 0);

    for (var i = 0; i < 30; i++) {
      service.recordKeyEvent('a');
    }
    expect(service.currentPercentage, greaterThan(0));
    expect(service.currentPercentage, lessThanOrEqualTo(100));
    expect(service.keyCounts['a'], 30);

    now = now.add(const Duration(minutes: 2));
    service.recordPointerEvent();
    expect(service.currentPercentage, lessThanOrEqualTo(100));
  });

  test('ranked keys are sorted by frequency', () {
    final service = ActivityService();
    service.recordKeyEvent('a');
    service.recordKeyEvent('b');
    service.recordKeyEvent('a');
    service.recordKeyEvent('Enter');
    service.recordKeyEvent('a');

    final ranked = service.rankedKeys();
    expect(ranked.first.key, 'a');
    expect(ranked.first.value, 3);
    expect(ranked.map((e) => e.key).toList(), containsAll(['a', 'b', 'Enter']));
  });
}
