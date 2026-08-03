import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';
import 'package:gizecare/features/screenshots/presentation/screenshot_viewer.dart';

/// Local screenshot gallery.
class ScreenshotsPage extends ConsumerWidget {
  const ScreenshotsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(screenshotRepositoryProvider).watchAll();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Screenshots',
          subtitle: 'Tap a capture to open it — stored locally',
        ),
        Expanded(
          child: StreamBuilder<List<ScreenshotItem>>(
            stream: stream,
            builder: (context, snapshot) {
              final items = snapshot.data ?? const <ScreenshotItem>[];
              if (items.isEmpty) {
                return const Center(
                  child: Text('No screenshots yet'),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final file = File(item.filePath);
                  return AppPanel(
                    padding: EdgeInsets.zero,
                    onTap: () => openScreenshotViewer(
                      context,
                      filePath: item.filePath,
                      takenAt: item.takenAt,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: file.existsSync()
                                ? Image.file(file, fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            item.takenAt.toLocal().toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
