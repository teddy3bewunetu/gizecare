import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';

void main() {
  group('Result', () {
    test('Success exposes value', () {
      const result = Success<int>(42);

      expect(result.isSuccess, isTrue);
      expect(result.requireValue, 42);
      expect(
        result.when(onSuccess: (v) => v, onFailure: (_) => -1),
        42,
      );
    });

    test('Err exposes failure', () {
      const result = Err<int>(ValidationFailure('invalid'));

      expect(result.isFailure, isTrue);
      expect(result.requireFailure, isA<ValidationFailure>());
      expect(
        result.when(
          onSuccess: (_) => 'ok',
          onFailure: (f) => f.message,
        ),
        'invalid',
      );
    });
  });
}
