import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/services/app_logger.dart';

/// Provides the shared [AppLogger] instance.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLogger();
});
