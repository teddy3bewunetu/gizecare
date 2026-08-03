import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
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

  @override
  ConsumerState<EvernoteAppSidebar> createState() => _EvernoteAppSidebarState();
}

class _EvernoteAppSidebarState extends ConsumerState<EvernoteAppSidebar> {
  final _searchController = TextEditingController();

  /// Explicit expand overrides per group path. Null = use default (open when
  /// a child route is selected).
  final _groupExpandedOverride = <String, bool>{};

  @override
  void didUpdateWidget(covariant EvernoteAppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Navigating into Messages from elsewhere should open the group again.
    final wasInMessages = oldWidget.selectedPath.startsWith(AppRoutes.messages);
    final nowInMessages = widget.selectedPath.startsWith(AppRoutes.messages);
    if (nowInMessages && !wasInMessages) {
      _groupExpandedOverride[AppRoutes.messages] = true;
    }
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      child: SizedBox(
        width: 248,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: BrandMark(logoSize: 40),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                onSubmitted: (q) {
                  if (q.trim().isEmpty) return;
                  context.go(AppRoutes.notebook);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (final item in widget.destinations) ...[
                    if (item.isGroup)
                      _GroupNav(
                        item: item,
                        selectedPath: widget.selectedPath,
                        expanded: _isGroupExpanded(item),
                        onToggle: () => _toggleGroup(item),
                        onChildTap: (path) {
                          // Opening a child should keep the group open.
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
                        onTap: () => context.go(item.path),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Row(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      icon: const Icon(Icons.picture_in_picture_alt_outlined),
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

class _GroupNav extends StatelessWidget {
  const _GroupNav({
    required this.item,
    required this.selectedPath,
    required this.expanded,
    required this.onToggle,
    required this.onChildTap,
  });

  final EvernoteNavItem item;
  final String selectedPath;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onChildTap;

  @override
  Widget build(BuildContext context) {
    final childSelected =
        item.children.any((c) => _pathMatches(selectedPath, c.path));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NavTile(
          item: item,
          selected: childSelected,
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

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.trailing,
    this.dense = false,
  });

  final EvernoteNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected
            ? scheme.onSurface.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: dense ? 8 : 10,
            ),
            child: Row(
              children: [
                Icon(
                  selected ? item.selectedIcon : item.icon,
                  size: dense ? 18 : 20,
                  color: selected
                      ? scheme.onSurface
                      : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: dense ? 13 : null,
                          color: selected
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                  ),
                ),
                if (item.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badgeCount > 99 ? '99+' : '${item.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
