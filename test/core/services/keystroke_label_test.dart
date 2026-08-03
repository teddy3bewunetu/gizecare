import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/services/activity/keystroke_label.dart';

void main() {
  test('labels printable characters', () {
    final event = KeyDownEvent(
      physicalKey: PhysicalKeyboardKey.keyA,
      logicalKey: LogicalKeyboardKey.keyA,
      character: 'A',
      timeStamp: Duration.zero,
    );
    expect(keystrokeLabel(event), 'a');
  });

  test('labels logical keys when character is null (Linux-like)', () {
    final event = KeyDownEvent(
      physicalKey: PhysicalKeyboardKey.keyB,
      logicalKey: LogicalKeyboardKey.keyB,
      timeStamp: Duration.zero,
    );
    expect(keystrokeLabel(event), isNotNull);
    expect(keystrokeLabel(event)!.toLowerCase(), 'b');
  });

  test('labels space and enter', () {
    expect(
      keystrokeLabel(
        const KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.space,
          logicalKey: LogicalKeyboardKey.space,
          timeStamp: Duration.zero,
        ),
      ),
      'Space',
    );
    expect(
      keystrokeLabel(
        const KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.enter,
          logicalKey: LogicalKeyboardKey.enter,
          timeStamp: Duration.zero,
        ),
      ),
      'Enter',
    );
  });
}
