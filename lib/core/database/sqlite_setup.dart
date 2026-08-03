import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Ensures Drift can load SQLite on Linux desktop / tests.
void ensureSqliteLoaded() {
  if (!Platform.isLinux) return;
  open.overrideFor(OperatingSystem.linux, _openLinuxSqlite);
}

DynamicLibrary _openLinuxSqlite() {
  final candidates = <String>[
    'libsqlite3.so.0',
    'libsqlite3.so',
    '/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
    '/usr/lib/libsqlite3.so.0',
  ];
  Object? lastError;
  for (final path in candidates) {
    try {
      return DynamicLibrary.open(path);
    } catch (e) {
      lastError = e;
    }
  }
  throw StateError('Unable to load libsqlite3: $lastError');
}
