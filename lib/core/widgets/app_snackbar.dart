import 'dart:async';

import 'package:flutter/material.dart';

/// Top-right floating notifications (app-wide snackbar replacement).
abstract final class AppSnackBar {
  static final List<_AppToastEntry> _stack = [];

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
        ),
      );
      return;
    }

    late final _AppToastEntry entry;
    entry = _AppToastEntry(
      message: message,
      onDismiss: () {
        entry.timer?.cancel();
        if (!_stack.contains(entry)) return;
        entry.entry.remove();
        _stack.remove(entry);
        _relayout();
      },
    );

    entry.entry = OverlayEntry(
      builder: (ctx) {
        final top = MediaQuery.paddingOf(ctx).top + 16 + entry.offsetTop;
        return Positioned(
          top: top,
          right: 16,
          child: _AppToastCard(
            message: message,
            onClose: entry.onDismiss,
          ),
        );
      },
    );

    _stack.add(entry);
    _relayout();
    overlay.insert(entry.entry);

    entry.timer = Timer(duration, entry.onDismiss);
  }

  static void _relayout() {
    var offset = 0.0;
    for (final item in _stack) {
      item.offsetTop = offset;
      offset += 64;
      item.entry.markNeedsBuild();
    }
  }
}

class _AppToastEntry {
  _AppToastEntry({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;
  late OverlayEntry entry;
  Timer? timer;
  double offsetTop = 0;
}

class _AppToastCard extends StatelessWidget {
  const _AppToastCard({
    required this.message,
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: scheme.inverseSurface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onInverseSurface,
                      ),
                ),
              ),
              IconButton(
                tooltip: 'Dismiss',
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: scheme.onInverseSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
