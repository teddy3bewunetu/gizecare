import 'dart:io';
import 'dart:ui' show Color;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/database/tables.dart';
import 'package:gizecare/features/tasks/domain/board_defaults.dart';

part 'app_database.g.dart';

/// Local SQLite database for offline-first ጊዜCare data.
@DriftDatabase(
  tables: [
    Projects,
    BoardColumns,
    Tasks,
    ProjectLabels,
    TaskLabelLinks,
    TaskChecklists,
    TaskChecklistItems,
    TaskComments,
    TaskAttachments,
    TaskActivity,
    TimeEntries,
    Screenshots,
    AppSettings,
    Alarms,
    StopwatchLaps,
    KeystrokeCounts,
    Notebooks,
    Notes,
    CalendarAccounts,
    CachedCalendarEvents,
    TelegramAccounts,
    TelegramChats,
    TelegramMessages,
    GmailAccounts,
    GmailThreads,
    GmailMessages,
    SlackAccounts,
    SlackConversations,
    SlackMessages,
    BrowserBookmarks,
    SystemMetricSamples,
    FeatureUsageSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 19;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedDefaultNotebookIfEmpty();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(projects, projects.clientName);
            await m.addColumn(projects, projects.description);
            await m.addColumn(projects, projects.hourlyRate);
            await m.addColumn(projects, projects.weeklyLimitHours);
            await m.addColumn(projects, projects.contractType);
          }
          if (from < 3) {
            await m.createTable(alarms);
            await m.createTable(stopwatchLaps);
          }
          if (from < 4) {
            await m.createTable(keystrokeCounts);
          }
          if (from < 5) {
            // Idempotent: a prior partial upgrade can leave tables/columns
            // behind while user_version stays at 4 (SQLite DDL auto-commits).
            await _createTableIfMissing(m, boardColumns);
            await _createTableIfMissing(m, projectLabels);
            await _createTableIfMissing(m, taskLabelLinks);
            await _createTableIfMissing(m, taskChecklists);
            await _createTableIfMissing(m, taskChecklistItems);
            await _createTableIfMissing(m, taskComments);
            await _createTableIfMissing(m, taskAttachments);
            await _createTableIfMissing(m, taskActivity);

            await _addColumnIfMissing(m, tasks, tasks.columnId);
            await _addColumnIfMissing(m, tasks, tasks.sortOrder);
            await _addColumnIfMissing(m, tasks, tasks.priority);
            await _addColumnIfMissing(m, tasks, tasks.dueAt);
            await _addColumnIfMissing(m, tasks, tasks.coverColor);
            await _addColumnIfMissing(m, tasks, tasks.archived);
            // currentDateAndTime default can fail on ALTER; add with a
            // plain integer default then backfill from created_at.
            await _ensureTasksUpdatedAtColumn();

            await _seedBoardColumnsAndBackfillTasks();
          }
          if (from < 6) {
            await _createTableIfMissing(m, notebooks);
            await _createTableIfMissing(m, notes);
            await seedDefaultNotebookIfEmpty();
          }
          if (from < 7) {
            await _createTableIfMissing(m, calendarAccounts);
            await _createTableIfMissing(m, cachedCalendarEvents);
          }
          if (from < 8) {
            await _createTableIfMissing(m, telegramAccounts);
            await _createTableIfMissing(m, telegramChats);
            await _createTableIfMissing(m, telegramMessages);
          }
          if (from < 9) {
            await _addColumnIfMissing(m, telegramChats, telegramChats.photoPath);
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.contentType,
            );
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.mediaPath,
            );
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.mediaFileId,
            );
          }
          if (from < 10) {
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.replyToMessageId,
            );
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.replyPreview,
            );
            await _addColumnIfMissing(
              m,
              telegramMessages,
              telegramMessages.isEdited,
            );
          }
          if (from < 11) {
            await _createTableIfMissing(m, gmailAccounts);
            await _createTableIfMissing(m, gmailThreads);
            await _createTableIfMissing(m, gmailMessages);
          }
          if (from < 12) {
            await _addColumnIfMissing(
              m,
              gmailMessages,
              gmailMessages.bodyHtml,
            );
          }
          if (from < 13) {
            await _createTableIfMissing(m, slackAccounts);
            await _createTableIfMissing(m, slackConversations);
            await _createTableIfMissing(m, slackMessages);
          }
          if (from < 14) {
            await _addColumnIfMissing(
              m,
              slackMessages,
              slackMessages.replyCount,
            );
            await _addColumnIfMissing(
              m,
              slackMessages,
              slackMessages.reactionsJson,
            );
            await _addColumnIfMissing(
              m,
              slackMessages,
              slackMessages.filesJson,
            );
            await _addColumnIfMissing(
              m,
              slackMessages,
              slackMessages.isEdited,
            );
            await customStatement(
              "UPDATE slack_messages SET reactions_json = '[]' "
              "WHERE reactions_json IS NULL",
            );
            await customStatement(
              "UPDATE slack_messages SET files_json = '[]' "
              "WHERE files_json IS NULL",
            );
            await customStatement(
              'UPDATE slack_messages SET reply_count = 0 '
              'WHERE reply_count IS NULL',
            );
            await customStatement(
              'UPDATE slack_messages SET is_edited = 0 '
              'WHERE is_edited IS NULL',
            );
          }
          if (from < 15) {
            await customStatement(
              "UPDATE slack_messages SET reactions_json = '[]' "
              "WHERE reactions_json IS NULL OR reactions_json = ''",
            );
            await customStatement(
              "UPDATE slack_messages SET files_json = '[]' "
              "WHERE files_json IS NULL OR files_json = ''",
            );
          }
          if (from < 16) {
            await _createTableIfMissing(m, browserBookmarks);
          }
          if (from < 17) {
            await _createTableIfMissing(m, systemMetricSamples);
          }
          if (from < 18) {
            await _createTableIfMissing(m, featureUsageSessions);
          }
          if (from < 19) {
            await _createTableIfMissing(m, featureUsageSessions);
            await _addColumnIfMissing(
              m,
              featureUsageSessions,
              featureUsageSessions.avgRamPercent,
            );
            await _addColumnIfMissing(
              m,
              featureUsageSessions,
              featureUsageSessions.avgCpuPercent,
            );
          }
        },
        beforeOpen: (details) async {
          // Hot-reload / partial upgrades can leave user_version ahead of DDL.
          final m = Migrator(this);
          await _createTableIfMissing(m, browserBookmarks);
          await _createTableIfMissing(m, systemMetricSamples);
          await _createTableIfMissing(m, featureUsageSessions);
          await _addColumnIfMissing(
            m,
            featureUsageSessions,
            featureUsageSessions.avgRamPercent,
          );
          await _addColumnIfMissing(
            m,
            featureUsageSessions,
            featureUsageSessions.avgCpuPercent,
          );
        },
      );

  /// Ensures at least one notebook exists (“My Notebook”).
  Future<void> seedDefaultNotebookIfEmpty() async {
    final existing = await select(notebooks).get();
    if (existing.isNotEmpty) return;
    final now = DateTime.now();
    await into(notebooks).insert(
      NotebooksCompanion.insert(
        id: const Uuid().v4(),
        name: 'My Notebook',
        coverColor: const Color(0xFF009DFE).toARGB32(),
        sortOrder: const Value(0),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<bool> _tableExists(String name) async {
    final rows = await customSelect(
      "SELECT 1 AS ok FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable<String>(name)],
      readsFrom: {},
    ).get();
    return rows.isNotEmpty;
  }

  Future<bool> _columnExists(String tableName, String columnName) async {
    final rows = await customSelect(
      'PRAGMA table_info($tableName)',
      readsFrom: {},
    ).get();
    return rows.any((row) => row.read<String>('name') == columnName);
  }

  Future<void> _createTableIfMissing(
    Migrator m,
    TableInfo<Table, dynamic> table,
  ) async {
    if (!await _tableExists(table.actualTableName)) {
      await m.createTable(table);
    }
  }

  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo<Table, dynamic> table,
    GeneratedColumn<Object> column,
  ) async {
    if (!await _columnExists(table.actualTableName, column.name)) {
      await m.addColumn(table, column);
    }
  }

  Future<void> _ensureTasksUpdatedAtColumn() async {
    if (await _columnExists('tasks', 'updated_at')) return;
    // Avoid Drift's currentDateAndTime expression in ALTER TABLE DEFAULT.
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'UPDATE tasks SET updated_at = created_at WHERE updated_at = 0',
    );
  }

  /// Seeds default columns for every project and places existing tasks in To Do.
  Future<void> _seedBoardColumnsAndBackfillTasks() async {
    const uuid = Uuid();
    final projectRows = await select(projects).get();
    final now = DateTime.now();

    for (final project in projectRows) {
      final existingCols = await (select(boardColumns)
            ..where((c) => c.projectId.equals(project.id)))
          .get();

      String? todoColumnId;
      if (existingCols.isEmpty) {
        for (var i = 0; i < BoardDefaults.columnNames.length; i++) {
          final id = uuid.v4();
          if (i == 0) todoColumnId = id;
          await into(boardColumns).insert(
            BoardColumnsCompanion.insert(
              id: id,
              projectId: project.id,
              name: BoardDefaults.columnNames[i],
              sortOrder: Value(i),
              createdAt: now,
            ),
          );
        }
      } else {
        final todo = existingCols.where((c) => c.name == BoardDefaults.todo);
        todoColumnId =
            todo.isNotEmpty ? todo.first.id : existingCols.first.id;
      }

      if (todoColumnId == null) continue;

      final projectTasks = await (select(tasks)
            ..where((t) => t.projectId.equals(project.id)))
          .get();
      projectTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      for (var i = 0; i < projectTasks.length; i++) {
        final task = projectTasks[i];
        if (task.columnId != null) continue;
        await (update(tasks)..where((t) => t.id.equals(task.id))).write(
          TasksCompanion(
            columnId: Value(todoColumnId),
            sortOrder: Value(i),
            updatedAt: Value(task.createdAt),
          ),
        );
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'gizecare.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
