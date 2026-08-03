import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/app/shell/evernote_app_sidebar.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/brand_mark.dart';
import 'package:gizecare/features/clock/presentation/providers/alarm_monitor.dart';
import 'package:gizecare/features/gmail/presentation/providers/gmail_providers.dart';
import 'package:gizecare/features/slack/presentation/providers/slack_providers.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';
import 'package:go_router/go_router.dart';

/// Adaptive shell: Evernote-style sidebar on desktop, drawer + bottom on mobile.
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static List<EvernoteNavItem> _destinations({
    int telegramUnread = 0,
    int gmailUnread = 0,
    int slackUnread = 0,
  }) => [
    const EvernoteNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      path: AppRoutes.dashboard,
    ),
    const EvernoteNavItem(
      label: 'Notes',
      icon: Icons.sticky_note_2_outlined,
      selectedIcon: Icons.sticky_note_2_rounded,
      path: AppRoutes.notebook,
    ),
    const EvernoteNavItem(
      label: 'Tasks',
      icon: Icons.checklist_outlined,
      selectedIcon: Icons.checklist_rounded,
      path: AppRoutes.tasks,
    ),
    const EvernoteNavItem(
      label: 'Calendar',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      path: AppRoutes.calendar,
    ),
    const EvernoteNavItem(
      label: 'Projects',
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder_rounded,
      path: AppRoutes.projects,
    ),
    const EvernoteNavItem(
      label: 'Tracker',
      icon: Icons.timer_outlined,
      selectedIcon: Icons.timer_rounded,
      path: AppRoutes.tracker,
    ),
    const EvernoteNavItem(
      label: 'Clock',
      icon: Icons.access_time_outlined,
      selectedIcon: Icons.access_time_filled_rounded,
      path: AppRoutes.clock,
    ),
    const EvernoteNavItem(
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      path: AppRoutes.reports,
    ),
    const EvernoteNavItem(
      label: 'Documents',
      icon: Icons.description_outlined,
      selectedIcon: Icons.description_rounded,
      path: AppRoutes.documents,
    ),
    EvernoteNavItem(
      label: 'Messages',
      icon: Icons.forum_outlined,
      selectedIcon: Icons.forum_rounded,
      path: AppRoutes.messages,
      badgeCount: gmailUnread + telegramUnread + slackUnread,
      children: [
        EvernoteNavItem(
          label: 'Gmail',
          icon: Icons.mail_outline_rounded,
          selectedIcon: Icons.mail_rounded,
          path: AppRoutes.gmail,
          badgeCount: gmailUnread,
        ),
        EvernoteNavItem(
          label: 'Telegram',
          icon: Icons.send_outlined,
          selectedIcon: Icons.send_rounded,
          path: AppRoutes.telegram,
          badgeCount: telegramUnread,
        ),
        EvernoteNavItem(
          label: 'Slack',
          icon: Icons.tag_outlined,
          selectedIcon: Icons.tag,
          path: AppRoutes.slack,
          badgeCount: slackUnread,
        ),
      ],
    ),
    const EvernoteNavItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      path: AppRoutes.settings,
    ),
  ];

  static const _mobileBottomPaths = <String>[
    AppRoutes.dashboard,
    AppRoutes.notebook,
    AppRoutes.tracker,
    AppRoutes.projects,
    AppRoutes.settings,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final telegramUnread = ref.watch(telegramUnreadTotalProvider);
    final gmailUnread = ref.watch(gmailUnreadTotalProvider);
    final slackUnread = ref.watch(slackUnreadTotalProvider);
    final destinations = _destinations(
      telegramUnread: telegramUnread,
      gmailUnread: gmailUnread,
      slackUnread: slackUnread,
    );
    final selectedIndex = _indexForPath(location, destinations);
    final timer = ref.watch(timerControllerProvider);
    ref.watch(alarmMonitorProvider);

    if (AppPlatform.isMobile) {
      return _MobileShell(
        destinations: destinations,
        bottomPaths: _mobileBottomPaths,
        location: location,
        selectedIndex: selectedIndex,
        timer: timer,
        child: child,
      );
    }

    return CallbackShortcuts(
      bindings: _shortcutBindings(context, ref, timer),
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Row(
            children: [
              EvernoteAppSidebar(
                destinations: destinations,
                selectedPath: location,
                timer: timer,
                onSearch: (_) {},
              ),
              VerticalDivider(
                width: 1,
                color: Theme.of(context).dividerTheme.color,
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> _shortcutBindings(
    BuildContext context,
    WidgetRef ref,
    TimerState timer,
  ) {
    return <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.digit1, control: true): () =>
          context.go(AppRoutes.dashboard),
      const SingleActivator(LogicalKeyboardKey.digit2, control: true): () =>
          context.go(AppRoutes.notebook),
      const SingleActivator(LogicalKeyboardKey.digit3, control: true): () =>
          context.go(AppRoutes.tasks),
      const SingleActivator(LogicalKeyboardKey.digit4, control: true): () =>
          context.go(AppRoutes.projects),
      const SingleActivator(LogicalKeyboardKey.digit5, control: true): () =>
          context.go(AppRoutes.tracker),
      const SingleActivator(LogicalKeyboardKey.digit6, control: true): () =>
          context.go(AppRoutes.clock),
      const SingleActivator(LogicalKeyboardKey.digit7, control: true): () =>
          context.go(AppRoutes.settings),
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
        final notifier = ref.read(timerControllerProvider.notifier);
        if (timer.isRunning) {
          notifier.pause();
        } else if (timer.isPaused) {
          notifier.resume();
        }
      },
    };
  }

  /// Top-level index for mobile drawer; walks into Messages children.
  int _indexForPath(String path, List<EvernoteNavItem> destinations) {
    for (var i = 0; i < destinations.length; i++) {
      final d = destinations[i];
      if (d.isGroup) {
        for (final child in d.children) {
          if (path == child.path || path.startsWith('${child.path}/')) {
            return i;
          }
        }
        if (path == d.path || path.startsWith('${d.path}/')) return i;
        continue;
      }
      if (d.path == '/') {
        if (path == '/') return i;
        continue;
      }
      if (path == d.path || path.startsWith('${d.path}/')) return i;
    }
    return -1;
  }
}

class _MobileShell extends ConsumerWidget {
  const _MobileShell({
    required this.destinations,
    required this.bottomPaths,
    required this.location,
    required this.selectedIndex,
    required this.timer,
    required this.child,
  });

  final List<EvernoteNavItem> destinations;
  final List<String> bottomPaths;
  final String location;
  final int selectedIndex;
  final TimerState timer;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomIndex = _bottomIndexForPath(location);
    final drawerItems = _flattenForDrawer(destinations);

    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(compact: true, logoSize: 28),
        actions: [
          IconButton(
            tooltip: 'New note',
            onPressed: () => context.go(AppRoutes.notebookCreatePath()),
            icon: const Icon(Icons.note_add_outlined),
            color: AppColors.brand,
          ),
          if (timer.hasSession)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                timer.isRunning
                    ? Icons.play_circle_filled_rounded
                    : Icons.pause_circle_filled_rounded,
                color: timer.isRunning
                    ? AppColors.brand
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _drawerSelectedIndex(location, drawerItems),
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          final item = drawerItems[index];
          if (item.path.isNotEmpty) context.go(item.path);
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: BrandMark(logoSize: 40),
          ),
          for (final destination in drawerItems)
            NavigationDrawerDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.label),
            ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Screenshots'),
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.screenshots);
            },
          ),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex < 0 ? 0 : bottomIndex,
        onDestinationSelected: (index) {
          context.go(bottomPaths[index]);
        },
        destinations: [
          for (final path in bottomPaths)
            NavigationDestination(
              icon: Icon(_destinationForPath(path).icon),
              selectedIcon: Icon(_destinationForPath(path).selectedIcon),
              label: _destinationForPath(path).label,
            ),
        ],
      ),
    );
  }

  List<EvernoteNavItem> _flattenForDrawer(List<EvernoteNavItem> items) {
    final out = <EvernoteNavItem>[];
    for (final item in items) {
      if (item.isGroup) {
        out.addAll(item.children);
      } else {
        out.add(item);
      }
    }
    return out;
  }

  int _drawerSelectedIndex(String path, List<EvernoteNavItem> items) {
    for (var i = 0; i < items.length; i++) {
      final p = items[i].path;
      if (p == '/') {
        if (path == '/') return i;
        continue;
      }
      if (path == p || path.startsWith('$p/')) return i;
    }
    return 0;
  }

  EvernoteNavItem _destinationForPath(String path) {
    for (final d in destinations) {
      if (d.path == path) return d;
      for (final c in d.children) {
        if (c.path == path) return c;
      }
    }
    return destinations.first;
  }

  int _bottomIndexForPath(String path) {
    for (var i = 0; i < bottomPaths.length; i++) {
      final p = bottomPaths[i];
      if (path == p || path.startsWith('$p/')) return i;
    }
    if (path.startsWith(AppRoutes.settings) ||
        path.startsWith(AppRoutes.screenshots) ||
        path.startsWith(AppRoutes.documents) ||
        path.startsWith(AppRoutes.messages) ||
        path.startsWith(AppRoutes.reports) ||
        path.startsWith(AppRoutes.tasks) ||
        path.startsWith(AppRoutes.clock)) {
      return bottomPaths.indexOf(AppRoutes.settings);
    }
    return -1;
  }
}
