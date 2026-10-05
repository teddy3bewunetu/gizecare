import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/app/router/root_navigator.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';

/// Telegram Desktop–style bottom-right message notifications.
abstract final class TelegramDesktopToast {
  static final List<_ToastSlot> _stack = [];

  static void show(
    TelegramIncomingNotice notice, {
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onOpen,
  }) {
    final overlay = rootNavigatorKey.currentState?.overlay ??
        (rootNavigatorKey.currentContext != null
            ? Overlay.maybeOf(
                rootNavigatorKey.currentContext!,
                rootOverlay: true,
              )
            : null);
    if (overlay == null) return;

    late final _ToastSlot slot;
    slot = _ToastSlot(
      notice: notice,
      onDismiss: () => _dismiss(slot),
      onOpen: () {
        _dismiss(slot);
        onOpen?.call();
      },
    );

    slot.entry = OverlayEntry(
      builder: (ctx) {
        final bottomPad = MediaQuery.paddingOf(ctx).bottom + 20;
        return Positioned(
          right: 20,
          bottom: bottomPad + slot.offsetBottom,
          child: _TelegramToastCard(
            notice: notice,
            visible: slot.visible,
            onClose: slot.onDismiss,
            onTap: slot.onOpen,
          ),
        );
      },
    );

    _stack.add(slot);
    _relayout();
    overlay.insert(slot.entry);

    // Slide in on next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      slot.visible = true;
      slot.entry.markNeedsBuild();
    });

    slot.timer = Timer(duration, () {
      slot.visible = false;
      slot.entry.markNeedsBuild();
      Future<void>.delayed(const Duration(milliseconds: 220), () {
        if (_stack.contains(slot)) _dismiss(slot);
      });
    });
  }

  static void _dismiss(_ToastSlot slot) {
    slot.timer?.cancel();
    if (!_stack.contains(slot)) return;
    slot.entry.remove();
    _stack.remove(slot);
    _relayout();
  }

  static void _relayout() {
    var offset = 0.0;
    for (var i = _stack.length - 1; i >= 0; i--) {
      final item = _stack[i];
      item.offsetBottom = offset;
      offset += 108;
      item.entry.markNeedsBuild();
    }
  }

  /// Default open action: go to Telegram and select the chat.
  static void openChat(
    BuildContext? context,
    String chatId, {
    required void Function(String chatId) selectChat,
  }) {
    selectChat(chatId);
    final ctx = context ?? rootNavigatorKey.currentContext;
    if (ctx == null) return;
    ctx.go(AppRoutes.telegram);
  }
}

class _ToastSlot {
  _ToastSlot({
    required this.notice,
    required this.onDismiss,
    required this.onOpen,
  });

  final TelegramIncomingNotice notice;
  final VoidCallback onDismiss;
  final VoidCallback onOpen;
  late OverlayEntry entry;
  Timer? timer;
  double offsetBottom = 0;
  var visible = false;
}

class _TelegramToastCard extends StatelessWidget {
  const _TelegramToastCard({
    required this.notice,
    required this.visible,
    required this.onClose,
    required this.onTap,
  });

  final TelegramIncomingNotice notice;
  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeLabel = DateFormat.jm().format(notice.receivedAt.toLocal());
    final initial = notice.chatTitle.trim().isEmpty
        ? '?'
        : notice.chatTitle.trim().characters.first.toUpperCase();
    final photoOk =
        notice.photoPath != null && File(notice.photoPath!).existsSync();
    final body = notice.isGroupLike &&
            notice.senderName != null &&
            notice.senderName!.trim().isNotEmpty
        ? '${notice.senderName}: ${notice.preview}'
        : notice.preview;
    final contentIcon = switch (notice.contentType) {
      'photo' => Icons.image_outlined,
      'voice' => Icons.mic_none_rounded,
      'video' => Icons.videocam_outlined,
      'document' => Icons.attach_file_rounded,
      'sticker' => Icons.emoji_emotions_outlined,
      _ => null,
    };

    // Telegram Desktop–like dark frosted card (works in light theme too).
    final cardBg = isDark
        ? const Color(0xE6181820)
        : const Color(0xF2FFFFFF);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final bodyColor =
        isDark ? const Color(0xFFB8BCC8) : const Color(0xFF5C6370);
    final metaColor =
        isDark ? const Color(0xFF8B91A0) : const Color(0xFF8A93A2);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0.18, 0.12),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: visible ? 1 : 0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                AppColors.brand.withValues(alpha: 0.22),
                            backgroundImage:
                                photoOk ? FileImage(File(notice.photoPath!)) : null,
                            child: photoOk
                                ? null
                                : Text(
                                    initial,
                                    style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2AABEE),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cardBg,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                size: 9,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notice.chatTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  timeLabel,
                                  style: TextStyle(
                                    color: metaColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                InkWell(
                                  onTap: onClose,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: metaColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (contentIcon != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Icon(
                                      contentIcon,
                                      size: 14,
                                      color: const Color(0xFF2AABEE),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Expanded(
                                  child: Text(
                                    body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: bodyColor,
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Telegram · GizeCare',
                              style: TextStyle(
                                color: metaColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
