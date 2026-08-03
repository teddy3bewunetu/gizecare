import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/database/app_database.dart';

/// Provides the shared [AppDatabase] instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
