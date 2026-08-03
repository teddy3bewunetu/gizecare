import 'package:flutter/material.dart';

import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';

class EventDraft {
  const EventDraft({
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.allDay,
    this.description,
  });

  final String title;
  final DateTime startAt;
  final DateTime endAt;
  final bool allDay;
  final String? description;
}

/// Create dialog (empty form for [initialDay]).
Future<EventDraft?> showNewEventDialog(
  BuildContext context, {
  required DateTime initialDay,
}) {
  return showDialog<EventDraft>(
    context: context,
    builder: (context) => _EventEditorDialog(initialDay: initialDay),
  );
}

/// Edit dialog prefilled from an existing [CalendarItem].
Future<EventDraft?> showEditEventDialog(
  BuildContext context, {
  required CalendarItem item,
}) {
  return showDialog<EventDraft>(
    context: context,
    builder: (context) => _EventEditorDialog(
      initialDay: item.startAt,
      initial: item,
    ),
  );
}

class _EventEditorDialog extends StatefulWidget {
  const _EventEditorDialog({
    required this.initialDay,
    this.initial,
  });

  final DateTime initialDay;
  final CalendarItem? initial;

  @override
  State<_EventEditorDialog> createState() => _EventEditorDialogState();
}

class _EventEditorDialogState extends State<_EventEditorDialog> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late DateTime _day;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late bool _allDay;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _title = TextEditingController(text: initial.title);
      _description = TextEditingController(text: initial.description ?? '');
      _day = DateTime(
        initial.startAt.year,
        initial.startAt.month,
        initial.startAt.day,
      );
      _allDay = initial.allDay;
      _start = TimeOfDay(
        hour: initial.startAt.hour,
        minute: initial.startAt.minute,
      );
      final endSource = initial.allDay
          ? initial.startAt.add(const Duration(hours: 1))
          : initial.endAt;
      _end = TimeOfDay(hour: endSource.hour, minute: endSource.minute);
    } else {
      _title = TextEditingController();
      _description = TextEditingController();
      _day = DateTime(
        widget.initialDay.year,
        widget.initialDay.month,
        widget.initialDay.day,
      );
      _allDay = false;
      final now = TimeOfDay.now();
      _start = TimeOfDay(hour: now.hour, minute: 0);
      _end = TimeOfDay(hour: (now.hour + 1).clamp(1, 23), minute: 0);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Event' : 'New Event'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('All day'),
              value: _allDay,
              onChanged: (v) => setState(() => _allDay = v),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                '${_day.year}-${_day.month.toString().padLeft(2, '0')}-${_day.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _day,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _day = picked);
              },
            ),
            if (!_allDay) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start'),
                subtitle: Text(_start.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _start,
                  );
                  if (picked != null) setState(() => _start = picked);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('End'),
                subtitle: Text(_end.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _end,
                  );
                  if (picked != null) setState(() => _end = picked);
                },
              ),
            ],
            TextField(
              controller: _description,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _title.text.trim();
            if (title.isEmpty) return;
            late DateTime startAt;
            late DateTime endAt;
            if (_allDay) {
              startAt = DateTime(_day.year, _day.month, _day.day);
              endAt = startAt.add(const Duration(days: 1));
            } else {
              startAt = DateTime(
                _day.year,
                _day.month,
                _day.day,
                _start.hour,
                _start.minute,
              );
              endAt = DateTime(
                _day.year,
                _day.month,
                _day.day,
                _end.hour,
                _end.minute,
              );
              if (!endAt.isAfter(startAt)) {
                endAt = startAt.add(const Duration(hours: 1));
              }
            }
            Navigator.pop(
              context,
              EventDraft(
                title: title,
                startAt: startAt,
                endAt: endAt,
                allDay: _allDay,
                description: _description.text.trim().isEmpty
                    ? null
                    : _description.text.trim(),
              ),
            );
          },
          child: Text(_isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
