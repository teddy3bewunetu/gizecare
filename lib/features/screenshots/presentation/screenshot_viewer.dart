import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

/// Opens a screenshot in an in-app viewer (pinch / scroll to zoom).
Future<void> openScreenshotViewer(
  BuildContext context, {
  required String filePath,
  DateTime? takenAt,
}) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    if (context.mounted) {
      AppSnackBar.show(context, 'Screenshot file is missing');
    }
    return;
  }

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.85),
    builder: (context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Center(
                    child: Image.file(file, fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    if (takenAt != null)
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().add_jm().format(takenAt.toLocal()),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                    else
                      const Spacer(),
                    IconButton(
                      tooltip: 'Open with system viewer',
                      onPressed: () => openScreenshotExternally(filePath),
                      icon: const Icon(Icons.open_in_new_rounded,
                          color: Colors.white),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens the image with the OS default app (`xdg-open` / `open` / mobile).
Future<void> openScreenshotExternally(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return;

  if (Platform.isAndroid || Platform.isIOS) {
    await OpenFilex.open(filePath);
    return;
  }
  if (Platform.isLinux) {
    await Process.run('xdg-open', [filePath]);
  } else if (Platform.isMacOS) {
    await Process.run('open', [filePath]);
  } else if (Platform.isWindows) {
    await Process.run('cmd', ['/c', 'start', '', filePath]);
  }
}
