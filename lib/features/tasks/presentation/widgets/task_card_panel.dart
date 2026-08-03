import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/features/projects/domain/entities/project.dart';
import 'package:gizecare/features/tasks/domain/entities/project_label.dart';
import 'package:gizecare/features/tasks/domain/entities/task_activity_event.dart';
import 'package:gizecare/features/tasks/domain/entities/task_checklist.dart';
import 'package:gizecare/features/tasks/domain/entities/task_item.dart';
import 'package:gizecare/features/tasks/domain/entities/task_priority.dart';
import 'package:gizecare/features/tasks/domain/repositories/board_repository.dart';
import 'package:gizecare/features/tasks/presentation/providers/board_provider.dart';
import 'package:go_router/go_router.dart';

/// Editable Kanban card sections with Trello-style inline fields.
class TaskCardPanel extends ConsumerWidget {
  const TaskCardPanel({
    required this.task,
    required this.project,
    this.compact = false,
    this.showTitle = false,
    super.key,
  });

  final TaskItem task;
  final Project? project;
  final bool compact;
  final bool showTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelsAsync = project == null
        ? const AsyncValue<List<ProjectLabel>>.data([])
        : ref.watch(taskLabelsProvider(project!.id));
    final selectedIdsAsync = ref.watch(taskLabelIdsProvider(task.id));
    final checklistsAsync = ref.watch(taskChecklistsProvider(task.id));
    final commentsAsync = ref.watch(taskCommentsProvider(task.id));
    final attachmentsAsync = ref.watch(taskAttachmentsProvider(task.id));
    final activityAsync = ref.watch(taskActivityProvider(task.id));
    final boardRepo = ref.read(boardRepositoryProvider);
    final scheme = Theme.of(context).colorScheme;

    final labels = labelsAsync.valueOrNull ?? const <ProjectLabel>[];
    final selectedIds = selectedIdsAsync.valueOrNull ?? const <String>[];
    final pad = compact
        ? const EdgeInsets.fromLTRB(16, 12, 16, 20)
        : const EdgeInsets.fromLTRB(28, 16, 28, 28);

    return ListView(
      padding: pad,
      children: [
        if (showTitle) ...[
          InlineTaskTitleField(task: task),
          const SizedBox(height: 12),
        ],
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskPriority>(
                key: ValueKey('priority-${task.id}-${task.priority}'),
                initialValue: task.priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: [
                  for (final p in TaskPriority.values)
                    DropdownMenuItem(value: p, child: Text(p.label)),
                ],
                onChanged: (p) async {
                  if (p == null) return;
                  await boardRepo.setCardMeta(taskId: task.id, priority: p);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.note_add_outlined),
                title: const Text('New note'),
                subtitle: const Text('Open Notebook linked to this task'),
                onTap: () {
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context).go(
                    AppRoutes.notebookCreatePath(
                      projectId: task.projectId,
                      taskId: task.id,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due date'),
                subtitle: Text(
                  task.dueAt == null
                      ? 'Not set — tap calendar to choose'
                      : DateFormat.yMMMd().add_jm().format(task.dueAt!),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.dueAt != null)
                      IconButton(
                        tooltip: 'Clear',
                        onPressed: () => boardRepo.setCardMeta(
                          taskId: task.id,
                          clearDueAt: true,
                        ),
                        icon: const Icon(Icons.clear),
                      ),
                    IconButton(
                      tooltip: 'Pick date',
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: task.dueAt ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date == null || !context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            task.dueAt ?? DateTime.now(),
                          ),
                        );
                        final due = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time?.hour ?? 17,
                          time?.minute ?? 0,
                        );
                        await boardRepo.setCardMeta(
                          taskId: task.id,
                          dueAt: due,
                        );
                      },
                      icon: const Icon(Icons.event_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Cover color', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final c in _coverPalette)
                    InkWell(
                      onTap: () => boardRepo.setCardMeta(
                        taskId: task.id,
                        coverColor: c,
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: c,
                        child: task.coverColor?.toARGB32() == c.toARGB32()
                            ? const Icon(Icons.check, size: 16)
                            : null,
                      ),
                    ),
                  ActionChip(
                    label: const Text('Clear'),
                    onPressed: () => boardRepo.setCardMeta(
                      taskId: task.id,
                      clearCoverColor: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              InlineDescriptionField(task: task),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Labels', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (labels.isEmpty)
                Text(
                  'Create labels from the project board toolbar.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final label in labels)
                      FilterChip(
                        selected: selectedIds.contains(label.id),
                        label: Text(label.name),
                        avatar: CircleAvatar(
                          backgroundColor: label.color,
                          radius: 6,
                        ),
                        onSelected: (selected) async {
                          final next = {...selectedIds};
                          if (selected) {
                            next.add(label.id);
                          } else {
                            next.remove(label.id);
                          }
                          await boardRepo.setTaskLabels(
                            task.id,
                            next.toList(),
                          );
                          ref.invalidate(taskLabelIdsProvider(task.id));
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checklists',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InlineComposerField(
                hint: 'Add a checklist…',
                icon: Icons.playlist_add_check_rounded,
                onSubmit: (title) => boardRepo.createChecklist(
                  taskId: task.id,
                  title: title,
                ),
              ),
              const SizedBox(height: 8),
              checklistsAsync.when(
                skipLoadingOnReload: true,
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (checklists) {
                  if (checklists.isEmpty) {
                    return Text(
                      'No checklists yet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    );
                  }
                  return Column(
                    children: [
                      for (final checklist in checklists) ...[
                        _InlineChecklistBlock(checklist: checklist),
                        const Divider(),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comments', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              commentsAsync.when(
                skipLoadingOnReload: true,
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (comments) {
                  return Column(
                    children: [
                      for (final c in comments)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(c.body),
                          subtitle: Text(
                            DateFormat.yMMMd().add_jm().format(c.createdAt),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => boardRepo.deleteComment(c.id),
                          ),
                        ),
                      if (comments.isEmpty)
                        Text(
                          'No comments yet',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              InlineComposerField(
                hint: 'Write a comment…',
                icon: Icons.chat_bubble_outline,
                multiline: true,
                submitLabel: 'Save',
                onSubmit: (body) => boardRepo.addComment(
                  taskId: task.id,
                  body: body,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Attachments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _pickAttachment(context, ref),
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add file'),
                  ),
                ],
              ),
              attachmentsAsync.when(
                skipLoadingOnReload: true,
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (files) {
                  if (files.isEmpty) {
                    return Text(
                      'No attachments',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    );
                  }
                  return Column(
                    children: [
                      for (final f in files)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.insert_drive_file_outlined),
                          title: Text(f.fileName),
                          subtitle: Text(_formatBytes(f.byteSize)),
                          onTap: () => OpenFilex.open(f.filePath),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await boardRepo.deleteAttachment(f.id);
                              try {
                                await File(f.filePath).delete();
                              } catch (_) {}
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              activityAsync.when(
                skipLoadingOnReload: true,
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (events) {
                  if (events.isEmpty) {
                    return Text(
                      'No activity yet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    );
                  }
                  return Column(
                    children: [
                      for (final e in events)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: Icon(_activityIcon(e.type), size: 18),
                          title: Text(_activityLabel(e)),
                          subtitle: Text(
                            DateFormat.MMMd().add_jm().format(e.createdAt),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickAttachment(BuildContext context, WidgetRef ref) async {
    final file = await openFile();
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, 'attachments', task.id));
    await dir.create(recursive: true);
    final destPath = p.join(dir.path, file.name);
    await File(destPath).writeAsBytes(bytes);
    await ref.read(boardRepositoryProvider).addAttachment(
          taskId: task.id,
          fileName: file.name,
          filePath: destPath,
          mimeType: file.mimeType,
          byteSize: bytes.length,
        );
  }
}

/// Inline card title — saves on blur / Enter.
class InlineTaskTitleField extends ConsumerStatefulWidget {
  const InlineTaskTitleField({
    required this.task,
    this.style,
    super.key,
  });

  final TaskItem task;
  final TextStyle? style;

  @override
  ConsumerState<InlineTaskTitleField> createState() =>
      _InlineTaskTitleFieldState();
}

class _InlineTaskTitleFieldState extends ConsumerState<InlineTaskTitleField> {
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.name);
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant InlineTaskTitleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && oldWidget.task.name != widget.task.name) {
      _controller.text = widget.task.name;
    }
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) unawaited(_save());
  }

  Future<void> _save() async {
    final next = _controller.text.trim();
    if (next.isEmpty || next == widget.task.name) {
      if (next.isEmpty) _controller.text = widget.task.name;
      return;
    }
    await ref.read(boardRepositoryProvider).updateCard(
          widget.task.copyWith(name: next),
        );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focus,
      style: widget.style ?? Theme.of(context).textTheme.titleLarge,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: 'Card title',
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _save(),
      onTapOutside: (_) => _focus.unfocus(),
    );
  }
}

class InlineDescriptionField extends ConsumerStatefulWidget {
  const InlineDescriptionField({required this.task, super.key});

  final TaskItem task;

  @override
  ConsumerState<InlineDescriptionField> createState() =>
      _InlineDescriptionFieldState();
}

class _InlineDescriptionFieldState
    extends ConsumerState<InlineDescriptionField> {
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.description ?? '');
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant InlineDescriptionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.task.description ?? '';
    if (!_focus.hasFocus && (oldWidget.task.description ?? '') != incoming) {
      _controller.text = incoming;
    }
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) unawaited(_save());
  }

  Future<void> _save() async {
    final next = _controller.text.trim();
    final current = (widget.task.description ?? '').trim();
    if (next == current) return;
    await ref.read(boardRepositoryProvider).updateCard(
          widget.task.copyWith(description: next),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _controller,
      focusNode: _focus,
      minLines: 3,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: 'Add a more detailed description…',
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onTapOutside: (_) => _focus.unfocus(),
    );
  }
}

/// Composer that clears after a successful submit.
class InlineComposerField extends StatefulWidget {
  const InlineComposerField({
    required this.hint,
    required this.onSubmit,
    this.icon,
    this.multiline = false,
    this.submitLabel,
    super.key,
  });

  final String hint;
  final Future<void> Function(String value) onSubmit;
  final IconData? icon;
  final bool multiline;
  final String? submitLabel;

  @override
  State<InlineComposerField> createState() => _InlineComposerFieldState();
}

class _InlineComposerFieldState extends State<InlineComposerField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  var _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    if (value.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.onSubmit(value);
      _controller.clear();
      _focus.requestFocus();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: widget.multiline
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            minLines: widget.multiline ? 2 : 1,
            maxLines: widget.multiline ? 4 : 1,
            enabled: !_busy,
            decoration: InputDecoration(
              hintText: widget.hint,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            textInputAction: widget.multiline
                ? TextInputAction.newline
                : TextInputAction.done,
            onSubmitted: widget.multiline ? null : (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: widget.submitLabel ?? 'Add',
          onPressed: _busy ? null : _submit,
          icon: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}

class _InlineChecklistBlock extends ConsumerWidget {
  const _InlineChecklistBlock({required this.checklist});

  final TaskChecklist checklist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BoardRepository repo = ref.read(boardRepositoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(checklist.title),
          subtitle: Text('${checklist.doneCount}/${checklist.totalCount}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => repo.deleteChecklist(checklist.id),
          ),
        ),
        for (final item in checklist.items)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: item.done,
            title: Text(item.title),
            controlAffinity: ListTileControlAffinity.leading,
            secondary: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => repo.deleteChecklistItem(item.id),
            ),
            onChanged: (v) => repo.updateChecklistItem(
              item.copyWith(done: v ?? false),
            ),
          ),
        InlineComposerField(
          hint: 'Add an item…',
          onSubmit: (title) => repo.addChecklistItem(
            checklistId: checklist.id,
            title: title,
          ),
        ),
      ],
    );
  }
}

const _coverPalette = [
  Color(0xFF009DFE),
  Color(0xFF22C55E),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF0EA5E9),
  Color(0xFF64748B),
  Color(0xFF14B8A6),
];

String _formatBytes(int n) {
  if (n < 1024) return '$n B';
  if (n < 1024 * 1024) return '${(n / 1024).toStringAsFixed(1)} KB';
  return '${(n / (1024 * 1024)).toStringAsFixed(1)} MB';
}

IconData _activityIcon(String type) => switch (type) {
      TaskActivityType.created => Icons.add_circle_outline,
      TaskActivityType.moved => Icons.swap_horiz_rounded,
      TaskActivityType.commented => Icons.chat_bubble_outline,
      TaskActivityType.checklist => Icons.checklist_rounded,
      TaskActivityType.attachment => Icons.attach_file,
      TaskActivityType.dueChanged => Icons.event_rounded,
      TaskActivityType.archived => Icons.archive_outlined,
      _ => Icons.history,
    };

String _activityLabel(TaskActivityEvent e) {
  final payload = e.payload;
  return switch (e.type) {
    TaskActivityType.created => 'Card created',
    TaskActivityType.moved => 'Moved${payload != null ? ' ($payload)' : ''}',
    TaskActivityType.commented => 'Comment added',
    TaskActivityType.checklist => 'Checklist updated',
    TaskActivityType.attachment =>
      'Attachment${payload != null ? ': $payload' : ''}',
    TaskActivityType.dueChanged => 'Due date changed',
    TaskActivityType.updated => 'Card updated',
    TaskActivityType.archived => 'Archived',
    _ => e.type,
  };
}
