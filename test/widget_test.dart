import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/utils/formatters.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('app constants expose display name and tagline', () {
    expect(AppConstants.displayName, 'ጊዜCare');
    expect(AppConstants.appName, 'GizeCare');
    expect(AppConstants.tagline, 'Your workday. One place.');
    expect(AppConstants.taglineSupporting, isNotEmpty);
  });

  test('duration formatter pads components', () {
    expect(
      Formatters.duration(const Duration(hours: 1, minutes: 2, seconds: 3)),
      '01:02:03',
    );
  });
}
