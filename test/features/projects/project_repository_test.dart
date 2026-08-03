import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizecare/core/database/app_database.dart';
import 'package:gizecare/core/database/sqlite_setup.dart';
import 'package:gizecare/features/projects/data/repositories/drift_project_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository repo;

  setUpAll(ensureSqliteLoaded);

  setUp(() {
    db = AppDatabase.memory();
    repo = DriftProjectRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('create and list projects', () async {
    final created = await repo.create(
      name: 'GizeCare',
      color: const Color(0xFF14B8A6),
    );
    expect(created.isSuccess, isTrue);

    final listed = await repo.getProjects();
    expect(listed.isSuccess, isTrue);
    expect(listed.requireValue, hasLength(1));
    expect(listed.requireValue.first.name, 'GizeCare');
  });

  test('archive project hides from active list', () async {
    final created = await repo.create(
      name: 'Archive Me',
      color: Colors.orange,
    );
    expect(created.isSuccess, isTrue);
    final id = created.requireValue.id;
    await repo.archive(id);

    final active = await repo.getProjects();
    expect(active.requireValue, isEmpty);

    final all = await repo.getProjects(includeArchived: true);
    expect(all.requireValue, hasLength(1));
    expect(all.requireValue.first.archived, isTrue);
  });
}
