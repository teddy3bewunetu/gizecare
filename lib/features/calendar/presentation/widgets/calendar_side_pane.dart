import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';

/// Mini month, layer toggles, and Google connect panel.
class CalendarSidePane extends StatelessWidget {
  const CalendarSidePane({
    required this.focusDay,
    required this.showGoogle,
    required this.showTasks,
    required this.showTimeEntries,
    required this.onSelectDay,
    required this.onToggleGoogle,
    required this.onToggleTasks,
    required this.onToggleTimeEntries,
    required this.onConnect,
    required this.onDisconnect,
    required this.onSync,
    this.account,
    super.key,
  });

  final DateTime focusDay;
  final bool showGoogle;
  final bool showTasks;
  final bool showTimeEntries;
  final CalendarAccount? account;
  final ValueChanged<DateTime> onSelectDay;
  final VoidCallback onToggleGoogle;
  final VoidCallback onToggleTasks;
  final VoidCallback onToggleTimeEntries;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        _MiniMonth(
          focusDay: focusDay,
          onSelectDay: onSelectDay,
        ),
        const SizedBox(height: 20),
        Text(
          'Show',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        _LayerTile(
          label: 'Events',
          color: const Color(0xFF34A853),
          selected: showGoogle,
          onTap: onToggleGoogle,
        ),
        _LayerTile(
          label: 'Tasks',
          color: const Color(0xFFA855F7),
          selected: showTasks,
          onTap: onToggleTasks,
        ),
        _LayerTile(
          label: 'Tracked time',
          color: AppColors.brand,
          selected: showTimeEntries,
          onTap: onToggleTimeEntries,
        ),
        const SizedBox(height: 24),
        Text(
          'Google Calendar',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        if (account != null) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.brand.withValues(alpha: 0.2),
              child: const Icon(Icons.g_mobiledata, color: AppColors.brand),
            ),
            title: Text(
              account!.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              account!.lastSyncAt == null
                  ? 'Connected'
                  : 'Synced ${DateFormat.jm().format(account!.lastSyncAt!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          Row(
            children: [
              TextButton(onPressed: onSync, child: const Text('Sync')),
              TextButton(
                onPressed: onDisconnect,
                child: const Text('Disconnect'),
              ),
            ],
          ),
        ] else ...[
          Text(
            AppPlatform.isLinux
                ? (GoogleCalendarConfig.hasCredentials
                    ? 'Connect your Google account to sync events.'
                    : 'Add OAuth dart-defines to enable Connect. See docs/google_calendar_setup.md')
                : 'Google connect is available on Linux desktop.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: AppPlatform.isLinux && GoogleCalendarConfig.hasCredentials
                ? onConnect
                : null,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Connect Google'),
          ),
        ],
      ],
    );
  }
}

class _LayerTile extends StatelessWidget {
  const _LayerTile({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: color,
        size: 20,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _MiniMonth extends StatefulWidget {
  const _MiniMonth({required this.focusDay, required this.onSelectDay});

  final DateTime focusDay;
  final ValueChanged<DateTime> onSelectDay;

  @override
  State<_MiniMonth> createState() => _MiniMonthState();
}

class _MiniMonthState extends State<_MiniMonth> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(widget.focusDay.year, widget.focusDay.month);
  }

  @override
  void didUpdateWidget(covariant _MiniMonth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusDay.year != widget.focusDay.year ||
        oldWidget.focusDay.month != widget.focusDay.month) {
      _visibleMonth = DateTime(widget.focusDay.year, widget.focusDay.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final startWeekday = first.weekday; // Mon=1
    final leading = startWeekday - 1;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() {
                _visibleMonth =
                    DateTime(_visibleMonth.year, _visibleMonth.month - 1);
              }),
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
            ),
            Expanded(
              child: Text(
                DateFormat('MMMM y').format(_visibleMonth),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() {
                _visibleMonth =
                    DateTime(_visibleMonth.year, _visibleMonth.month + 1);
              }),
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
            ),
          ],
        ),
        Row(
          children: [
            for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leading + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            if (index < leading) return const SizedBox.shrink();
            final day = index - leading + 1;
            final date =
                DateTime(_visibleMonth.year, _visibleMonth.month, day);
            final selected = date.year == widget.focusDay.year &&
                date.month == widget.focusDay.month &&
                date.day == widget.focusDay.day;
            final isToday = _isToday(date);
            return InkWell(
              onTap: () => widget.onSelectDay(date),
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? AppColors.brand
                        : isToday
                            ? AppColors.brand.withValues(alpha: 0.2)
                            : null,
                  ),
                  child: Text(
                    '$day',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: selected
                              ? Colors.white
                              : scheme.onSurface,
                          fontWeight:
                              selected || isToday ? FontWeight.w700 : null,
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }
}
