import 'package:drift/drift.dart';

/// Work projects the user tracks time against.
@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get color => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  /// Client / contract counterpart display name.
  TextColumn get clientName => text().nullable()();
  /// Longer contract / project description.
  TextColumn get description => text().nullable()();
  /// Hourly rate in major currency units (e.g. 9.26).
  RealColumn get hourlyRate => real().nullable()();
  /// Soft weekly hour cap (Upwork-style).
  IntColumn get weeklyLimitHours =>
      integer().nullable().withDefault(const Constant(40))();
  /// e.g. Hourly, Fixed.
  TextColumn get contractType =>
      text().nullable().withDefault(const Constant('Hourly'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Kanban columns for a project board (one board per project).
@DataClassName('BoardColumnRow')
class BoardColumns extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get wipLimit => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Tasks belonging to a [Projects] row (Kanban cards).
@DataClassName('TaskRow')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  /// Board column; nullable only for migration safety — always set in app code.
  TextColumn get columnId => text().nullable().references(BoardColumns, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  /// none | low | medium | high | urgent
  TextColumn get priority =>
      text().withDefault(const Constant('none'))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  IntColumn get coverColor => integer().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Project-scoped labels for Kanban cards.
@DataClassName('ProjectLabelRow')
class ProjectLabels extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  IntColumn get color => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Many-to-many: task ↔ label.
@DataClassName('TaskLabelLinkRow')
class TaskLabelLinks extends Table {
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get labelId => text().references(ProjectLabels, #id)();

  @override
  Set<Column<Object>> get primaryKey => {taskId, labelId};
}

/// Checklist group on a task card.
@DataClassName('TaskChecklistRow')
class TaskChecklists extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Checklist item under a [TaskChecklists] row.
@DataClassName('TaskChecklistItemRow')
class TaskChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get checklistId => text().references(TaskChecklists, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Comment on a task card.
@DataClassName('TaskCommentRow')
class TaskComments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local file attachment on a task card.
@DataClassName('TaskAttachmentRow')
class TaskAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get byteSize => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Activity / audit events for a task card.
@DataClassName('TaskActivityRow')
class TaskActivity extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get type => text()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Timed work sessions.
@DataClassName('TimeEntryRow')
class TimeEntries extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get activityPercentage => integer().nullable()();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Screenshots captured while a timer is running.
@DataClassName('ScreenshotRow')
class Screenshots extends Table {
  TextColumn get id => text()();
  TextColumn get timeEntryId => text().references(TimeEntries, #id)();
  TextColumn get filePath => text()();
  DateTimeColumn get takenAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Key/value application settings store.
@DataClassName('SettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// User-configured clock alarms.
@DataClassName('AlarmRow')
class Alarms extends Table {
  TextColumn get id => text()();
  TextColumn get label => text().withDefault(const Constant('Alarm'))();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  /// Bitmask: bit0=Mon … bit6=Sun. 0 = one-shot (next matching time).
  IntColumn get repeatDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Persisted stopwatch lap rows (history kept across resets).
@DataClassName('StopwatchLapRow')
class StopwatchLaps extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get lapIndex => integer()();
  IntColumn get lapMs => integer()();
  IntColumn get totalMs => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Aggregated key-press counts for a time entry (ranked “top keys”).
@DataClassName('KeystrokeCountRow')
class KeystrokeCounts extends Table {
  TextColumn get id => text()();
  TextColumn get timeEntryId => text().references(TimeEntries, #id)();
  TextColumn get keyLabel => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Notebook collections for the Notebook module.
@DataClassName('NotebookRow')
class Notebooks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get coverColor => integer()();
  TextColumn get coverImagePath => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Individual notes belonging to a [Notebooks] row.
@DataClassName('NoteRow')
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get notebookId => text().references(Notebooks, #id)();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  /// text | todo
  TextColumn get noteType => text().withDefault(const Constant('text'))();
  IntColumn get color => integer()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  TextColumn get projectId => text()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.setNull)();
  TextColumn get taskId =>
      text().nullable().references(Tasks, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Connected external calendar accounts (e.g. Google).
@DataClassName('CalendarAccountRow')
class CalendarAccounts extends Table {
  TextColumn get id => text()();
  /// google
  TextColumn get provider => text()();
  TextColumn get email => text()();
  TextColumn get calendarId => text()();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached remote calendar events for offline / fast UI.
@DataClassName('CachedCalendarEventRow')
class CachedCalendarEvents extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(CalendarAccounts, #id)();
  TextColumn get googleEventId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime()();
  BoolColumn get allDay => boolean().withDefault(const Constant(false))();
  TextColumn get htmlLink => text().nullable()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Connected Gmail mailbox metadata (OAuth tokens shared with Calendar).
@DataClassName('GmailAccountRow')
class GmailAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached Gmail threads (inbox).
@DataClassName('GmailThreadRow')
class GmailThreads extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(GmailAccounts, #id)();
  TextColumn get gmailThreadId => text()();
  TextColumn get subject => text()();
  TextColumn get snippet => text()();
  TextColumn get fromName => text().nullable()();
  TextColumn get fromEmail => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isUnread => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached messages within a Gmail thread.
@DataClassName('GmailMessageRow')
class GmailMessages extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(GmailAccounts, #id)();
  TextColumn get gmailThreadId => text()();
  TextColumn get gmailMessageId => text()();
  TextColumn get fromName => text().nullable()();
  TextColumn get fromEmail => text().nullable()();
  TextColumn get toEmails => text().withDefault(const Constant(''))();
  TextColumn get subject => text()();
  TextColumn get bodyText => text()();
  /// Original HTML body when available (for styled rendering).
  TextColumn get bodyHtml => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isUnread => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Connected Telegram user account (session files live under app support).
@DataClassName('TelegramAccountRow')
class TelegramAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get telegramUserId => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Telegram chats discovered for the account; [isAllowed] gates app access.
@DataClassName('TelegramChatRow')
class TelegramChats extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(TelegramAccounts, #id)();
  /// Telegram chat id as string (may be negative for groups/channels).
  TextColumn get telegramChatId => text()();
  TextColumn get title => text()();
  /// private | group | channel | secret | unknown
  TextColumn get chatType => text()();
  TextColumn get username => text().nullable()();
  BoolColumn get isAllowed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  /// Local path to downloaded chat avatar (small).
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Connected Slack workspace (user OAuth; tokens in SlackTokenStore).
@DataClassName('SlackAccountRow')
class SlackAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get teamId => text()();
  TextColumn get teamName => text()();
  TextColumn get userId => text()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached Slack conversations (channels / DMs).
@DataClassName('SlackConversationRow')
class SlackConversations extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(SlackAccounts, #id)();
  TextColumn get conversationId => text()();
  TextColumn get name => text()();
  /// channel | group | im | mpim
  TextColumn get conversationType => text()();
  BoolColumn get isMuted => boolean().withDefault(const Constant(false))();
  BoolColumn get isAllowed => boolean().withDefault(const Constant(true))();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached Slack messages within a conversation.
@DataClassName('SlackMessageRow')
class SlackMessages extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(SlackAccounts, #id)();
  TextColumn get conversationId => text()();
  TextColumn get messageTs => text()();
  TextColumn get threadTs => text().nullable()();
  TextColumn get senderName => text().nullable()();
  TextColumn get senderUserId => text().nullable()();
  TextColumn get body => text()();
  BoolColumn get isOutgoing => boolean().withDefault(const Constant(false))();
  IntColumn get replyCount => integer().withDefault(const Constant(0))();
  /// JSON list of {name, count, isMine}.
  TextColumn get reactionsJson => text().withDefault(const Constant('[]'))();
  /// JSON list of {id, name, mimetype, urlPrivate, thumbUrl}.
  TextColumn get filesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  DateTimeColumn get sentAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached messages for allowlisted chats only.
@DataClassName('TelegramMessageRow')
class TelegramMessages extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(TelegramAccounts, #id)();
  TextColumn get telegramChatId => text()();
  TextColumn get telegramMessageId => text()();
  TextColumn get senderName => text().nullable()();
  TextColumn get body => text()();
  /// text | photo | document | voice | video | sticker | other
  TextColumn get contentType => text().withDefault(const Constant('text'))();
  /// Local path for downloaded photo / document preview / voice file.
  TextColumn get mediaPath => text().nullable()();
  IntColumn get mediaFileId => integer().nullable()();
  /// Telegram message id this message replies to (if any).
  TextColumn get replyToMessageId => text().nullable()();
  TextColumn get replyPreview => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  BoolColumn get isOutgoing => boolean().withDefault(const Constant(false))();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
