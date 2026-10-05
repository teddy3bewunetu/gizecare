import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/brand_mark.dart';
import 'package:gizecare/features/tracker/domain/entities/timer_state.dart';

/// Soft Evernote-style left navigation for desktop.
class EvernoteAppSidebar extends ConsumerStatefulWidget {
  const EvernoteAppSidebar({
    required this.destinations,
    required this.selectedPath,
    required this.timer,
    required this.onSearch,
    super.key,
  });

  final List<EvernoteNavItem> destinations;
  final String selectedPath;
  final TimerState timer;
  final ValueChanged<String> onSearch;

  static const double expandedWidth = 248;
  static const double collapsedWidth = 72;

  @override
  ConsumerState<EvernoteAppSidebar> createState() => _EvernoteAppSidebarState();
}

class _EvernoteAppSidebarState extends ConsumerState<EvernoteAppSidebar> {
  final _searchController = TextEditingController();

  /// Explicit expand overrides per group path. Null = use default (open when
  /// a child route is selected).
  final _groupExpandedOverride = <String, bool>{};

  var _collapsed = false;

  @override
  void didUpdateWidget(covariant EvernoteAppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Navigating into Messages / Apps from elsewhere should open the group.
    void syncGroup(String root) {
      final wasIn = oldWidget.selectedPath.startsWith(root);
      final nowIn = widget.selectedPath.startsWith(root);
      if (nowIn && !wasIn) {
        _groupExpandedOverride[root] = true;
      }
    }

    syncGroup(AppRoutes.messages);
    syncGroup(AppRoutes.apps);
  }

  bool _isGroupExpanded(EvernoteNavItem item) {
    final override = _groupExpandedOverride[item.path];
    if (override != null) return override;
    return item.children.any(
      (c) => _pathMatches(widget.selectedPath, c.path),
    );
  }

  void _toggleGroup(EvernoteNavItem item) {
    setState(() {
      _groupExpandedOverride[item.path] = !_isGroupExpanded(item);
    });
  }

  void _toggleCollapsed() {
    setState(() => _collapsed = !_collapsed);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final collapsed = _collapsed;

    return Material(
      color: scheme.surfaceContainerLowest,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: collapsed
            ? EvernoteAppSidebar.collapsedWidth
            : EvernoteAppSidebar.expandedWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                collapsed ? 8 : 12,
                10,
                collapsed ? 8 : 8,
                6,
              ),
              child: collapsed
                  ? Column(
                      children: [
                        const BrandMark(compact: true, logoSize: 22),
                        const SizedBox(height: 6),
                        _CollapseToggle(
                          collapsed: true,
                          onPressed: _toggleCollapsed,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Expanded(
                          child: BrandMark(logoSize: 22),
                        ),
                        _CollapseToggle(
                          collapsed: false,
                          onPressed: _toggleCollapsed,
                        ),
                      ],
                    ),
            ),
            if (!collapsed) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: widget.onSearch,
                  onSubmitted: (q) {
                    if (q.trim().isEmpty) return;
                    context.go(AppRoutes.notebook);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _RoundIconButton(
                      icon: Icons.note_add_outlined,
                      tooltip: 'New note',
                      onPressed: () => context.go(
                        AppRoutes.notebookCreatePath(),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _RoundIconButton(
                      icon: Icons.checklist_rounded,
                      tooltip: 'Tasks',
                      onPressed: () => context.go(AppRoutes.tasks),
                    ),
                    const SizedBox(width: 6),
                    _RoundIconButton(
                      icon: Icons.timer_outlined,
                      tooltip: 'Tracker',
                      onPressed: () => context.go(AppRoutes.tracker),
                    ),
                    const SizedBox(width: 6),
                    _RoundIconButton(
                      icon: Icons.more_horiz_rounded,
                      tooltip: 'More',
                      onPressed: () => _showMoreMenu(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (final item in widget.destinations) ...[
                    if (item.isGroup)
                      _GroupNav(
                        item: item,
                        selectedPath: widget.selectedPath,
                        expanded: !collapsed && _isGroupExpanded(item),
                        collapsed: collapsed,
                        onToggle: () => _toggleGroup(item),
                        onChildTap: (path) {
                          setState(() {
                            _groupExpandedOverride[item.path] = true;
                          });
                          context.go(path);
                        },
                      )
                    else
                      _NavTile(
                        item: item,
                        selected: _pathMatches(widget.selectedPath, item.path),
                        collapsed: collapsed,
                        onTap: () => context.go(item.path),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                collapsed ? 8 : 12,
                8,
                collapsed ? 8 : 12,
                16,
              ),
              child: collapsed
                  ? Column(
                      children: [
                        Tooltip(
                          message: 'GizeCare',
                          waitDuration: const Duration(milliseconds: 400),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: scheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (widget.timer.hasSession) ...[
                          const SizedBox(height: 8),
                          Tooltip(
                            message: widget.timer.isRunning
                                ? 'Timer running'
                                : 'Timer paused',
                            child: Icon(
                              widget.timer.isRunning
                                  ? Icons.play_circle_filled_rounded
                                  : Icons.pause_circle_filled_rounded,
                              color: widget.timer.isRunning
                                  ? AppColors.brand
                                  : scheme.tertiary,
                              size: 22,
                            ),
                          ),
                        ],
                        if (AppPlatform.supportsWindowModes)
                          IconButton(
                            tooltip: 'Compact tracker',
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              await ref
                                  .read(windowModeServiceProvider)
                                  .enterCompact();
                              if (context.mounted) {
                                context.go(AppRoutes.compact);
                              }
                            },
                            icon: const Icon(
                              Icons.picture_in_picture_alt_outlined,
                            ),
                          ),
                      ],
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: scheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'GizeCare',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (widget.timer.hasSession)
                          Icon(
                            widget.timer.isRunning
                                ? Icons.play_circle_filled_rounded
                                : Icons.pause_circle_filled_rounded,
                            color: widget.timer.isRunning
                                ? AppColors.brand
                                : scheme.tertiary,
                            size: 22,
                          ),
                        if (AppPlatform.supportsWindowModes)
                          IconButton(
                            tooltip: 'Compact tracker',
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              await ref
                                  .read(windowModeServiceProvider)
                                  .enterCompact();
                              if (context.mounted) {
                                context.go(AppRoutes.compact);
                              }
                            },
                            icon: const Icon(
                              Icons.picture_in_picture_alt_outlined,
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMoreMenu(BuildContext context) async {
    final path = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Screenshots'),
              onTap: () => Navigator.pop(context, AppRoutes.screenshots),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context, AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
    if (path != null && context.mounted) context.go(path);
  }
}

bool _pathMatches(String current, String itemPath) {
  if (itemPath.isEmpty) return false;
  if (itemPath == '/') return current == '/';
  return current == itemPath || current.startsWith('$itemPath/');
}

class EvernoteNavItem {
  const EvernoteNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.path = '',
    this.badgeCount = 0,
    this.children = const [],
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
  final int badgeCount;
  final List<EvernoteNavItem> children;

  bool get isGroup => children.isNotEmpty;
}

class _CollapseToggle extends StatelessWidget {
  const _CollapseToggle({
    required this.collapsed,
    required this.onPressed,
  });

  final bool collapsed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: onPressed,
      icon: Icon(
        collapsed
            ? Icons.keyboard_double_arrow_right_rounded
            : Icons.keyboard_double_arrow_left_rounded,
        size: 20,
      ),
    );
  }
}

class _GroupNav extends StatelessWidget {
  const _GroupNav({
    required this.item,
    required this.selectedPath,
    required this.expanded,
    required this.collapsed,
    required this.onToggle,
    required this.onChildTap,
  });

  final EvernoteNavItem item;
  final String selectedPath;
  final bool expanded;
  final bool collapsed;
  final VoidCallback onToggle;
  final ValueChanged<String> onChildTap;

  @override
  Widget build(BuildContext context) {
    final childSelected =
        item.children.any((c) => _pathMatches(selectedPath, c.path));

    if (collapsed) {
      return _CollapsedGroupNav(
        item: item,
        selected: childSelected,
        selectedPath: selectedPath,
        onChildTap: onChildTap,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NavTile(
          item: item,
          selected: childSelected,
          collapsed: false,
          trailing: Icon(
            expanded
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded,
            size: 20,
          ),
          onTap: onToggle,
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: [
                for (final child in item.children)
                  _NavTile(
                    item: child,
                    selected: _pathMatches(selectedPath, child.path),
                    collapsed: false,
                    dense: true,
                    onTap: () => onChildTap(child.path),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CollapsedGroupNav extends StatelessWidget {
  const _CollapsedGroupNav({
    required this.item,
    required this.selected,
    required this.selectedPath,
    required this.onChildTap,
  });

  final EvernoteNavItem item;
  final bool selected;
  final String selectedPath;
  final ValueChanged<String> onChildTap;

  void _onMenuOpen() {
    // Companion WebKit windows paint above Flutter overlays and would clip
    // this flyout — hide them while the menu is open.
    if (AppDesktopBrowser.isAvailable) {
      unawaited(AppDesktopBrowser.hide());
    }
  }

  void _onMenuClose() {
    if (!AppDesktopBrowser.isAvailable) return;
    // Defer so a menu navigation can dispose/hide the browser first.
    // Only restore when a BrowserPage is still mounted (owns callbacks).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppDesktopBrowser.onUrlChanged != null &&
          AppDesktopBrowser.activeTabId != null) {
        unawaited(AppDesktopBrowser.show());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Tooltip(
        message: item.label,
        waitDuration: const Duration(milliseconds: 400),
        child: MenuAnchor(
          alignmentOffset: const Offset(8, 0),
          onOpen: _onMenuOpen,
          onClose: _onMenuClose,
          builder: (context, controller, child) {
            return Material(
              color: selected
                  ? scheme.onSurface.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        selected ? item.selectedIcon : item.icon,
                        size: 20,
                        color: selected
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                      ),
                      if (item.badgeCount > 0)
                        Positioned(
                          top: 4,
                          right: 8,
                          child: _BadgeDot(count: item.badgeCount),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          menuChildren: [
            for (final child in item.children)
              MenuItemButton(
                leadingIcon: Icon(
                  _pathMatches(selectedPath, child.path)
                      ? child.selectedIcon
                      : child.icon,
                  size: 18,
                ),
                trailingIcon: child.badgeCount > 0
                    ? _BadgeChip(count: child.badgeCount)
                    : null,
                onPressed: () => onChildTap(child.path),
                child: Text(child.label),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.collapsed = false,
    this.trailing,
    this.dense = false,
  });

  final EvernoteNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool collapsed;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = Icon(
      selected ? item.selectedIcon : item.icon,
      size: dense ? 18 : 20,
      color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
    );

    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected
            ? scheme.onSurface.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: collapsed
              ? SizedBox(
                  height: dense ? 36 : 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      icon,
                      if (item.badgeCount > 0)
                        Positioned(
                          top: 4,
                          right: 8,
                          child: _BadgeDot(count: item.badgeCount),
                        ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: dense ? 8 : 10,
                  ),
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    fontSize: dense ? 13 : null,
                                    color: selected
                                        ? scheme.onSurface
                                        : scheme.onSurfaceVariant,
                                  ),
                        ),
                      ),
                      if (item.badgeCount > 0) _BadgeChip(count: item.badgeCount),
                      if (trailing != null) ...[
                        const SizedBox(width: 4),
                        trailing!,
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );

    if (!collapsed) return tile;

    return Tooltip(
      message: item.label,
      waitDuration: const Duration(milliseconds: 400),
      child: tile,
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        color: scheme.surfaceContainerHighest,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
