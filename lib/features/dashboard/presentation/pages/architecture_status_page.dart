import 'package:flutter/material.dart';
import 'package:gizecare/core/constants/app_constants.dart';

/// Temporary status page confirming the Clean Architecture layout.
///
/// Replaced by the real Dashboard once that feature is implemented.
class ArchitectureStatusPage extends StatelessWidget {
  const ArchitectureStatusPage({super.key});

  static const _features = <String>[
    'dashboard',
    'projects',
    'tasks',
    'tracker',
    'activity',
    'screenshots',
    'reports',
    'settings',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.displayName,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Clean Architecture scaffold ready',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Features',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final feature in _features)
                      Chip(
                        label: Text(feature),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Each feature: data / domain / presentation',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
