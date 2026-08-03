import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/calendar/domain/entities/calendar_item.dart';
import 'package:gizecare/features/calendar/domain/google_calendar_config.dart';
import 'package:gizecare/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:gizecare/features/calendar/presentation/widgets/calendar_day_grid.dart';
import 'package:gizecare/features/calendar/presentation/widgets/calendar_item_detail_sheet.dart';
import 'package:gizecare/features/calendar/presentation/widgets/calendar_side_pane.dart';
import 'package:gizecare/features/calendar/presentation/widgets/new_event_dialog.dart';

/// Hybrid Google + local calendar page.
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final ui = ref.watch(calendarUiProvider);
    final accountAsync = ref.watch(calendarAccountProvider);
    final feedAsync = ref.watch(calendarFeedProvider);
    final dateLabel = ui.viewMode == CalendarViewMode.day
        ? DateFormat('EEEE, MMMM d, y').format(ui.focusDay)
        : '${DateFormat('MMM d').format(ui.rangeStart)} – ${DateFormat('MMM d, y').format(ui.rangeEnd.subtract(const Duration(days: 1)))}';

    return ColoredBox(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () => _onNewEvent(context, ref),
                  icon: const Icon(Icons.event_available_outlined, size: 18),
                  label: const Text('New Event'),
                ),
                const SizedBox(width: 8),
                SegmentedButton<CalendarViewMode>(
                  segments: const [
                    ButtonSegment(
                      value: CalendarViewMode.day,
                      label: Text('Day'),
                    ),
                    ButtonSegment(
                      value: CalendarViewMode.week,
                      label: Text('Week'),
                    ),
                  ],
                  selected: {ui.viewMode},
                  onSelectionChanged: (s) {
                    ref
                        .read(calendarUiProvider.notifier)
                        .setViewMode(s.first);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 260,
                  child: CalendarSidePane(
                    focusDay: ui.focusDay,
                    showGoogle: ui.showGoogle,
                    showTasks: ui.showTasks,
                    showTimeEntries: ui.showTimeEntries,
                    account: accountAsync.valueOrNull,
                    onSelectDay: (d) =>
                        ref.read(calendarUiProvider.notifier).setFocusDay(d),
                    onToggleGoogle: () =>
                        ref.read(calendarUiProvider.notifier).toggleGoogle(),
                    onToggleTasks: () =>
                        ref.read(calendarUiProvider.notifier).toggleTasks(),
                    onToggleTimeEntries: () => ref
                        .read(calendarUiProvider.notifier)
                        .toggleTimeEntries(),
                    onConnect: () => _connect(context, ref),
                    onDisconnect: () => _disconnect(context, ref),
                    onSync: () => _sync(context, ref),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  color: scheme.outlineVariant.withValues(alpha: 0.4),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              dateLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () => ref
                                  .read(calendarUiProvider.notifier)
                                  .goToday(),
                              child: const Text('Today'),
                            ),
                            IconButton(
                              tooltip: 'Previous',
                              onPressed: () => ref
                                  .read(calendarUiProvider.notifier)
                                  .shift(
                                    ui.viewMode == CalendarViewMode.day
                                        ? -1
                                        : -7,
                                  ),
                              icon: const Icon(Icons.chevron_left_rounded),
                            ),
                            IconButton(
                              tooltip: 'Next',
                              onPressed: () => ref
                                  .read(calendarUiProvider.notifier)
                                  .shift(
                                    ui.viewMode == CalendarViewMode.day
                                        ? 1
                                        : 7,
                                  ),
                              icon: const Icon(Icons.chevron_right_rounded),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: feedAsync.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, _) => Center(
                            child: Text(
                              'Could not load calendar\n$e',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.error),
                            ),
                          ),
                          data: (items) => CalendarDayGrid(
                            focusDay: ui.focusDay,
                            rangeStart: ui.rangeStart,
                            dayCount:
                                ui.viewMode == CalendarViewMode.day ? 1 : 7,
                            items: items,
                            onTapItem: (item) =>
                                _onTapItem(context, ref, item),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    if (!AppPlatform.isLinux) {
      AppSnackBar.show(context, 'Google connect is available on Linux only');
      return;
    }
    if (!GoogleCalendarConfig.hasCredentials) {
      AppSnackBar.show(
        context,
        'Set GOOGLE_CALENDAR_CLIENT_ID / SECRET (see docs/google_calendar_setup.md)',
      );
      return;
    }
    final result =
        await ref.read(googleCalendarRepositoryProvider).connect();
    if (!context.mounted) return;
    result.when(
      onSuccess: (account) {
        AppSnackBar.show(context, 'Connected as ${account.email}');
        ref.invalidate(calendarFeedProvider);
        ref.invalidate(calendarAccountProvider);
      },
      onFailure: (f) => AppSnackBar.show(
        context,
        f.message,
        duration: const Duration(seconds: 8),
      ),
    );
  }

  Future<void> _disconnect(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(googleCalendarRepositoryProvider).disconnect();
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Disconnected Google Calendar');
        ref.invalidate(calendarFeedProvider);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final ui = ref.read(calendarUiProvider);
    final result = await ref.read(googleCalendarRepositoryProvider).sync(
          from: ui.rangeStart.subtract(const Duration(days: 7)),
          to: ui.rangeEnd.add(const Duration(days: 60)),
        );
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Calendar synced');
        ref.invalidate(calendarFeedProvider);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _onNewEvent(BuildContext context, WidgetRef ref) async {
    final account = ref.read(calendarAccountProvider).valueOrNull;
    if (account == null) {
      AppSnackBar.show(context, 'Connect Google to create events');
      return;
    }
    final created = await showNewEventDialog(
      context,
      initialDay: ref.read(calendarUiProvider).focusDay,
    );
    if (created == null || !context.mounted) return;
    final result = await ref.read(googleCalendarRepositoryProvider).createEvent(
          title: created.title,
          startAt: created.startAt,
          endAt: created.endAt,
          allDay: created.allDay,
          description: created.description,
        );
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Event created in Google Calendar');
        ref.invalidate(calendarFeedProvider);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _onTapItem(
    BuildContext context,
    WidgetRef ref,
    CalendarItem item,
  ) async {
    final action = await showCalendarItemDetails(
      context,
      item: item,
      onOpenTask: item.source == CalendarItemSource.task && item.taskId != null
          ? () => context.go(AppRoutes.taskDetailPath(item.taskId!))
          : null,
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case CalendarItemDetailResult.edit:
        await _onEditEvent(context, ref, item);
      case CalendarItemDetailResult.delete:
        await _onDeleteEvent(context, ref, item);
    }
  }

  Future<void> _onEditEvent(
    BuildContext context,
    WidgetRef ref,
    CalendarItem item,
  ) async {
    final draft = await showEditEventDialog(context, item: item);
    if (draft == null || !context.mounted) return;
    final result = await ref.read(googleCalendarRepositoryProvider).updateEvent(
          localEventId: item.id,
          title: draft.title,
          startAt: draft.startAt,
          endAt: draft.endAt,
          allDay: draft.allDay,
          description: draft.description,
        );
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Event updated');
        ref.invalidate(calendarFeedProvider);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _onDeleteEvent(
    BuildContext context,
    WidgetRef ref,
    CalendarItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: Text(
          '“${item.title}” will be removed from Google Calendar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final result = await ref
        .read(googleCalendarRepositoryProvider)
        .deleteEvent(localEventId: item.id);
    if (!context.mounted) return;
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'Event deleted');
        ref.invalidate(calendarFeedProvider);
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }
}
