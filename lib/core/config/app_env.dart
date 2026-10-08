import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads local `.env` for desktop/dev and Snap installs (never commit secrets).
///
/// Search order:
/// 1. `$SNAP_USER_COMMON/.env` (recommended for Snap Store installs)
/// 2. `$SNAP_USER_DATA/.env`
/// 3. `$SNAP_REAL_HOME/.config/gizecare/.env`
/// 4. Project / cwd `.env` (local `flutter run`)
///
/// OAuth values still prefer `--dart-define` over `.env` (see feature configs).
Future<void> loadAppEnv() async {
  final candidates = <File>[
    for (final dir in _envSearchDirs()) File('$dir${Platform.pathSeparator}.env'),
    File('.env'),
    File('${Directory.current.path}${Platform.pathSeparator}.env'),
  ];

  final seen = <String>{};
  for (final file in candidates) {
    final path = file.absolute.path;
    if (!seen.add(path)) continue;
    if (await file.exists()) {
      dotenv.loadFromString(
        envString: await file.readAsString(),
        isOptional: true,
      );
      return;
    }
  }

  // Ensure dotenv is initialized even when no file is present.
  dotenv.loadFromString(envString: '', isOptional: true);
}

/// Directories where users may place a `.env` for Snap / desktop installs.
List<String> _envSearchDirs() {
  final env = Platform.environment;
  final dirs = <String>[
    if ((env['SNAP_USER_COMMON'] ?? '').isNotEmpty) env['SNAP_USER_COMMON']!,
    if ((env['SNAP_USER_DATA'] ?? '').isNotEmpty) env['SNAP_USER_DATA']!,
  ];

  final realHome = env['SNAP_REAL_HOME'] ??
      ((env['SNAP'] ?? '').isEmpty ? (env['HOME'] ?? '') : '');
  if (realHome.isNotEmpty) {
    dirs.add(
      '$realHome${Platform.pathSeparator}.config'
      '${Platform.pathSeparator}gizecare',
    );
  }
  return dirs;
}
