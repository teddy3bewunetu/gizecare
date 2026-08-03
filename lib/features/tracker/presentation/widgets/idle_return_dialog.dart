import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';

/// Asks how to treat idle time when the user returns.
Future<void> showIdleReturnDialog(BuildContext context, WidgetRef ref) async {
  final timer = ref.read(timerControllerProvider);
  final action = await showDialog<IdleReturnAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Welcome back'),
        content: Text(
          'You were idle for ${timer.idleDuration.inMinutes} min '
          '${timer.idleDuration.inSeconds.remainder(60)} sec.\n\n'
          'What should we do with that idle time?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, IdleReturnAction.discardIdle),
            child: const Text('Discard Idle Time'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, IdleReturnAction.keepIdle),
            child: const Text('Keep Idle Time'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, IdleReturnAction.resume),
            child: const Text('Resume Timer'),
          ),
        ],
      );
    },
  );

  if (action != null) {
    await ref
        .read(timerControllerProvider.notifier)
        .handleIdleReturn(action: action);
  }
}
