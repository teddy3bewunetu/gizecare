import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads local `.env` for desktop/dev (never commit real secrets).
///
/// Resolution order for calendar OAuth values is handled in
/// [GoogleCalendarConfig]: dart-define → `.env` → process environment.
Future<void> loadAppEnv() async {
  final candidates = <File>[
    File('.env'),
    File('${Directory.current.path}/.env'),
  ];

  for (final file in candidates) {
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
