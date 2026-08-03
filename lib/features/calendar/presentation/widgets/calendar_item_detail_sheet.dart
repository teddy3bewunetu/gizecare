import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';

enum CalendarItemDetailResult { edit, delete }

/// In-app details for a calendar item (Google event, task, or tracked time).
Future<CalendarItemDetailResult?> showCalendarItemDetails(
  BuildContext context, {
  required CalendarItem item,
  VoidCallback? onOpenTask,
}) {
  return showDialog<CalendarItemDetailResult>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _CalendarItemDetails(
          item: item,
          onOpenTask: onOpenTask,
        ),
      ),
    ),
  );
}

class _CalendarItemDetails extends StatelessWidget {
  const _CalendarItemDetails({
    required this.item,
    this.onOpenTask,
  });

  final CalendarItem item;
  final VoidCallback? onOpenTask;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = item.color ?? AppColors.brand;
    final isGoogle = item.source == CalendarItemSource.google;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _sourceLabel(item.source),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.schedule_rounded,
            label: _whenLabel(item),
          ),
          if (item.description != null && item.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.notes_rounded,
              label: item.description!.trim(),
              multiLine: true,
            ),
          ],
          const SizedBox(height: 20),
          if (isGoogle) ...[
            FilledButton.tonalIcon(
              onPressed: () =>
                  Navigator.pop(context, CalendarItemDetailResult.edit),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pop(context, CalendarItemDetailResult.delete),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error.withValues(alpha: 0.5)),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Delete'),
            ),
            if (item.htmlLink != null && item.htmlLink!.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(item.htmlLink!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Open in Google Calendar'),
              ),
            ],
          ],
          if (item.source == CalendarItemSource.task && onOpenTask != null)
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.pop(context);
                onOpenTask!();
              },
              icon: const Icon(Icons.checklist_rounded, size: 18),
              label: const Text('Open task'),
            ),
        ],
      ),
    );
  }

  String _sourceLabel(CalendarItemSource source) {
    return switch (source) {
      CalendarItemSource.google => 'Google event',
      CalendarItemSource.task => 'Task due',
      CalendarItemSource.timeEntry => 'Tracked time',
    };
  }

  String _whenLabel(CalendarItem item) {
    if (item.allDay) {
      final day = DateFormat('EEEE, MMM d, y').format(item.startAt);
      return 'All day · $day';
    }
    final sameDay = item.startAt.year == item.endAt.year &&
        item.startAt.month == item.endAt.month &&
        item.startAt.day == item.endAt.day;
    final date = DateFormat('EEEE, MMM d, y').format(item.startAt);
    final start = DateFormat.jm().format(item.startAt);
    final end = DateFormat.jm().format(item.endAt);
    if (sameDay) return '$date · $start – $end';
    final endDate = DateFormat('MMM d, y').format(item.endAt);
    return '$date $start – $endDate $end';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    this.multiLine = false,
  });

  final IconData icon;
  final String label;
  final bool multiLine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment:
          multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface,
                  height: multiLine ? 1.4 : null,
                ),
          ),
        ),
      ],
    );
  }
}
