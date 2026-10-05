import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';

/// Fullscreen photo viewer for chat images.
Future<void> showTelegramImageViewer(BuildContext context, String path) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.92),
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 64,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      );
    },
  );
}

enum TelegramMessageAction {
  reply,
  copy,
  openFile,
  downloadFile,
  edit,
  delete,
}

/// Choice after tapping a document attachment.
enum TelegramDocumentFileAction { open, download }

/// Asks whether to open or download a chat file.
Future<TelegramDocumentFileAction?> showTelegramDocumentFileActions(
  BuildContext context, {
  required String fileName,
}) {
  return showDialog<TelegramDocumentFileAction>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          fileName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        content: const Text('Open with the viewer, or save a copy to Downloads.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, TelegramDocumentFileAction.download),
            child: const Text('Download'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, TelegramDocumentFileAction.open),
            child: const Text('Open'),
          ),
        ],
      );
    },
  );
}

/// Desktop-style context menu at the click position (not a bottom sheet).
Future<TelegramMessageAction?> showTelegramMessageActions(
  BuildContext context, {
  required TelegramMessage message,
  required Offset globalPosition,
}) {
  final box = Overlay.of(context).context.findRenderObject() as RenderBox;
  final overlaySize = box.size;
  return showMenu<TelegramMessageAction>(
    context: context,
    position: RelativeRect.fromRect(
      globalPosition & const Size(1, 1),
      Offset.zero & overlaySize,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    items: [
      const PopupMenuItem(
        value: TelegramMessageAction.reply,
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.reply_rounded),
          title: Text('Reply'),
        ),
      ),
      const PopupMenuItem(
        value: TelegramMessageAction.copy,
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.copy_rounded),
          title: Text('Copy'),
        ),
      ),
      if (message.hasDocument) ...[
        const PopupMenuItem(
          value: TelegramMessageAction.openFile,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.open_in_new_rounded),
            title: Text('Open file'),
          ),
        ),
        const PopupMenuItem(
          value: TelegramMessageAction.downloadFile,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.download_rounded),
            title: Text('Download'),
          ),
        ),
      ],
      if (message.isOutgoing && message.contentType == 'text')
        const PopupMenuItem(
          value: TelegramMessageAction.edit,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
      if (message.isOutgoing)
        const PopupMenuItem(
          value: TelegramMessageAction.delete,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: AppColors.danger),
            title: Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ),
    ],
  );
}

Future<void> copyTelegramMessage(TelegramMessage message) async {
  final raw = message.text.trim();
  final text = raw.isEmpty
      ? (message.hasPhoto ? 'Photo' : message.contentType)
      : raw.split('|').first;
  await Clipboard.setData(ClipboardData(text: text));
}
