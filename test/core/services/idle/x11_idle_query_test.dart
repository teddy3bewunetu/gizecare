import 'package:flutter_test/flutter_test.dart';

import 'package:gizecare/core/services/idle/x11_idle_query.dart';

void main() {
  test('X11 idle query returns a non-negative duration on Linux X11', () {
    final idle = queryX11IdleDuration();
    // On CI without DISPLAY this may be null; locally on X11 it should work.
    if (idle != null) {
      expect(idle.inMilliseconds, greaterThanOrEqualTo(0));
    }
  });
}
