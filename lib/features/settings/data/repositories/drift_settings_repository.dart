import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Drift-backed [SettingsRepository].
class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<String?>> get(String key) async {
    try {
      final row =
          await (_db.select(_db.appSettings)..where((t) => t.key.equals(key)))
              .getSingleOrNull();
      return Success(row?.value);
    } catch (e) {
      return Err(CacheFailure('Failed to read setting', cause: e));
    }
  }

  @override
  Future<Result<Unit>> set(String key, String value) async {
    try {
      await _db.into(_db.appSettings).insertOnConflictUpdate(
            AppSettingsCompanion.insert(key: key, value: value),
          );
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to write setting', cause: e));
    }
  }

  @override
  Stream<String?> watch(String key) {
    return (_db.select(_db.appSettings)..where((t) => t.key.equals(key)))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first.value);
  }
}
