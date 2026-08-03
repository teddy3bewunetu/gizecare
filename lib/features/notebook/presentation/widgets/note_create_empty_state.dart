import 'package:flutter/material.dart';

import 'package:gizecare/core/theme/app_colors.dart';

/// Calm empty editor when no note is selected.
class NoteCreateEmptyState extends StatelessWidget {
  const NoteCreateEmptyState({
    required this.onNewPage,
    super.key,
  });

  final VoidCallback onNewPage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 48,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
              const SizedBox(height: 20),
              Text(
                'Select a note',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Or create a new one to start writing.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                ),
                onPressed: onNewPage,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
