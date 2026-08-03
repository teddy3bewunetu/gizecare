import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/errors/failures.dart';
import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/activity/domain/entities/keystroke_count.dart';
import 'package:gizecare/features/activity/domain/repositories/keystroke_repository.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';

/// Drift-backed [KeystrokeRepository].
class DriftKeystrokeRepository implements KeystrokeRepository {
  DriftKeystrokeRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<Result<Unit>> replaceForEntry({
    required String timeEntryId,
    required Map<String, int> counts,
  }) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.keystrokeCounts)
              ..where((t) => t.timeEntryId.equals(timeEntryId)))
            .go();
        for (final entry in counts.entries) {
          if (entry.value <= 0) continue;
          await _db.into(_db.keystrokeCounts).insert(
                KeystrokeCountsCompanion.insert(
                  id: _uuid.v4(),
                  timeEntryId: timeEntryId,
                  keyLabel: entry.key,
                  count: Value(entry.value),
                ),
              );
        }
      });
      return const Success(unit);
    } catch (e) {
      return Err(CacheFailure('Failed to save keystroke counts', cause: e));
    }
  }

  @override
  Stream<List<KeystrokeCount>> watchForEntry(String timeEntryId) {
    final query = _db.select(_db.keystrokeCounts)
      ..where((t) => t.timeEntryId.equals(timeEntryId))
      ..orderBy([(t) => OrderingTerm.desc(t.count)]);
    return query.watch().map(_mapRows);
  }

  @override
  Stream<List<KeystrokeCount>> watchForTask(String taskId) {
    final query = _db.select(_db.keystrokeCounts).join([
      innerJoin(
        _db.timeEntries,
        _db.timeEntries.id.equalsExp(_db.keystrokeCounts.timeEntryId),
      ),
    ])
      ..where(_db.timeEntries.taskId.equals(taskId))
      ..orderBy([OrderingTerm.desc(_db.keystrokeCounts.count)]);

    return query.watch().map((rows) {
      final byKey = <String, int>{};
      for (final row in rows) {
        final k = row.readTable(_db.keystrokeCounts);
        byKey[k.keyLabel] = (byKey[k.keyLabel] ?? 0) + k.count;
      }
      final aggregated = byKey.entries
          .map(
            (e) => KeystrokeCount(
              id: e.key,
              timeEntryId: taskId,
              keyLabel: e.key,
              count: e.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
      return aggregated;
    });
  }

  @override
  Future<Result<List<KeystrokeCount>>> getForTask(String taskId) async {
    try {
      final list = await watchForTask(taskId).first;
      return Success(list);
    } catch (e) {
      return Err(CacheFailure('Failed to load keystroke counts', cause: e));
    }
  }

  List<KeystrokeCount> _mapRows(List<KeystrokeCountRow> rows) {
    return [
      for (final r in rows)
        KeystrokeCount(
          id: r.id,
          timeEntryId: r.timeEntryId,
          keyLabel: r.keyLabel,
          count: r.count,
        ),
    ];
  }
}
