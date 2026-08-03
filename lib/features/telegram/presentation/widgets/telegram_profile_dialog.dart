import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';

Future<void> showTelegramProfileDialog(
  BuildContext context, {
  required String telegramChatId,
  VoidCallback? onMessage,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (context) => TelegramProfileDialog(
      telegramChatId: telegramChatId,
      onMessage: onMessage,
    ),
  );
}

class TelegramProfileDialog extends ConsumerStatefulWidget {
  const TelegramProfileDialog({
    required this.telegramChatId,
    this.onMessage,
    super.key,
  });

  final String telegramChatId;
  final VoidCallback? onMessage;

  @override
  ConsumerState<TelegramProfileDialog> createState() =>
      _TelegramProfileDialogState();
}

class _TelegramProfileDialogState extends ConsumerState<TelegramProfileDialog> {
  TelegramProfile? _profile;
  Object? _error;
  var _loading = true;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(telegramRepositoryProvider)
        .getChatProfile(widget.telegramChatId);
    if (!mounted) return;
    result.when(
      onSuccess: (p) => setState(() {
        _profile = p;
        _loading = false;
      }),
      onFailure: (f) => setState(() {
        _error = f.message;
        _loading = false;
      }),
    );
  }

  Future<void> _run(
    Future<Result<Unit>> Function() action, {
    String? successMessage,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {
        if (successMessage != null) {
          AppSnackBar.show(context, successMessage);
        }
        _load();
      },
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _call() async {
    await _run(
      () => ref
          .read(telegramRepositoryProvider)
          .startCall(widget.telegramChatId),
      successMessage: 'Opening call…',
    );
  }

  Future<void> _toggleMute() async {
    final profile = _profile;
    if (profile == null) return;
    final muted = !profile.isMuted;
    await _run(
      () => ref.read(telegramRepositoryProvider).setChatMuted(
            telegramChatId: widget.telegramChatId,
            muted: muted,
          ),
      successMessage: muted ? 'Chat muted' : 'Chat unmuted',
    );
  }

  Future<void> _copyUsername(String username) async {
    await Clipboard.setData(ClipboardData(text: '@$username'));
    if (mounted) AppSnackBar.show(context, 'Username copied');
  }

  Future<void> _shareContact() async {
    final profile = _profile;
    if (profile == null) return;
    final text = [
      profile.title,
      if (profile.username != null) '@${profile.username}',
      if (profile.phoneNumber != null) profile.phoneNumber,
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) AppSnackBar.show(context, 'Contact copied');
  }

  Future<void> _openInTelegram() async {
    await _run(
      () => ref
          .read(telegramRepositoryProvider)
          .openInTelegram(widget.telegramChatId),
      successMessage: 'Opening Telegram…',
    );
  }

  Future<void> _editContact() async {
    final profile = _profile;
    if (profile == null || !profile.isPrivate) return;

    var first = profile.firstName ?? '';
    var last = profile.lastName ?? '';
    if (first.isEmpty && profile.title.trim().isNotEmpty) {
      final parts = profile.title.trim().split(RegExp(r'\s+'));
      first = parts.first;
      last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    final firstCtrl = TextEditingController(text: first);
    final lastCtrl = TextEditingController(text: last);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(profile.isContact ? 'Edit contact' : 'Add contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'First name'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastCtrl,
              decoration: const InputDecoration(labelText: 'Last name'),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true || !mounted) {
      firstCtrl.dispose();
      lastCtrl.dispose();
      return;
    }
    final f = firstCtrl.text;
    final l = lastCtrl.text;
    firstCtrl.dispose();
    lastCtrl.dispose();
    await _run(
      () => ref.read(telegramRepositoryProvider).editContact(
            telegramChatId: widget.telegramChatId,
            firstName: f,
            lastName: l,
          ),
      successMessage: 'Contact saved',
    );
  }

  Future<void> _deleteContact() async {
    final profile = _profile;
    if (profile == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete contact?'),
        content: Text(
          'Remove ${profile.title} from your Telegram contacts? '
          'The chat will remain.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await _run(
      () => ref
          .read(telegramRepositoryProvider)
          .deleteContact(widget.telegramChatId),
      successMessage: 'Contact deleted',
    );
  }

  Future<void> _toggleBlock() async {
    final profile = _profile;
    if (profile == null) return;
    final block = !profile.isBlocked;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(block ? 'Block user?' : 'Unblock user?'),
        content: Text(
          block
              ? '${profile.title} will no longer be able to message you.'
              : 'Allow ${profile.title} to message you again?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: block
                ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(block ? 'Block' : 'Unblock'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await _run(
      () => ref.read(telegramRepositoryProvider).setUserBlocked(
            telegramChatId: widget.telegramChatId,
            blocked: block,
          ),
      successMessage: block ? 'User blocked' : 'User unblocked',
    );
  }

  void _showMoreMenu() {
    final profile = _profile;
    if (profile == null) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: const Text('Open in Telegram'),
              onTap: () {
                Navigator.pop(ctx);
                _openInTelegram();
              },
            ),
            if (profile.username != null)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy username'),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyUsername(profile.username!);
                },
              ),
            if (profile.phoneNumber != null)
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Copy phone'),
                onTap: () {
                  Navigator.pop(ctx);
                  Clipboard.setData(
                    ClipboardData(text: profile.phoneNumber!),
                  );
                  AppSnackBar.show(context, 'Phone copied');
                },
              ),
            if (profile.isPrivate)
              ListTile(
                leading: const Icon(Icons.ios_share_rounded),
                title: const Text('Share contact'),
                onTap: () {
                  Navigator.pop(ctx);
                  _shareContact();
                },
              ),
            ListTile(
              leading: Icon(
                profile.isMuted
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
              ),
              title: Text(profile.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(ctx);
                _toggleMute();
              },
            ),
            if (profile.isPrivate)
              ListTile(
                leading: Icon(
                  profile.isBlocked
                      ? Icons.check_circle_outline
                      : Icons.front_hand_outlined,
                  color: profile.isBlocked ? null : AppColors.danger,
                ),
                title: Text(
                  profile.isBlocked ? 'Unblock user' : 'Block user',
                  style: TextStyle(
                    color: profile.isBlocked ? null : AppColors.danger,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _toggleBlock();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheet = isDark ? const Color(0xFF1C2733) : Colors.white;
    final muted = isDark ? const Color(0xFF8B9AAB) : Colors.black54;
    final label = isDark ? const Color(0xFF6B9FD4) : AppColors.brand;

    return Dialog(
      backgroundColor: sheet,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 420,
        height: 640,
        child: Stack(
          children: [
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$_error', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _load,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              _ProfileBody(
                profile: _profile!,
                muted: muted,
                label: label,
                onClose: () => Navigator.pop(context),
                onMessage: () {
                  Navigator.pop(context);
                  widget.onMessage?.call();
                },
                onCall: _call,
                onMute: _toggleMute,
                onMore: _showMoreMenu,
                onCopyUsername: _copyUsername,
                onShare: _shareContact,
                onEdit: _editContact,
                onDelete: _deleteContact,
                onBlock: _toggleBlock,
              ),
            if (_busy)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.profile,
    required this.muted,
    required this.label,
    required this.onClose,
    required this.onMessage,
    required this.onCall,
    required this.onMute,
    required this.onMore,
    required this.onCopyUsername,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
    required this.onBlock,
  });

  final TelegramProfile profile;
  final Color muted;
  final Color label;
  final VoidCallback onClose;
  final VoidCallback onMessage;
  final VoidCallback onCall;
  final VoidCallback onMute;
  final VoidCallback onMore;
  final ValueChanged<String> onCopyUsername;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final photoOk =
        profile.photoPath != null && File(profile.photoPath!).existsSync();

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            tooltip: 'Close',
            onPressed: onClose,
            icon: const Icon(Icons.close),
          ),
        ),
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.brand.withValues(alpha: 0.25),
          backgroundImage: photoOk ? FileImage(File(profile.photoPath!)) : null,
          child: photoOk
              ? null
              : Text(
                  profile.title.trim().isEmpty
                      ? '?'
                      : profile.title.trim().characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.statusText ??
              switch (profile.chatType) {
                TelegramChatType.private => 'personal chat',
                TelegramChatType.group => 'group',
                TelegramChatType.channel => 'channel',
                TelegramChatType.secret => 'secret chat',
                TelegramChatType.unknown => 'chat',
              },
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: muted),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Message',
                  onTap: onMessage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAction(
                  icon: profile.isMuted
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_none_rounded,
                  label: profile.isMuted ? 'Unmute' : 'Mute',
                  onTap: onMute,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAction(
                  icon: Icons.call_outlined,
                  label: 'Call',
                  onTap: profile.isPrivate ? onCall : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAction(
                  icon: Icons.more_horiz_rounded,
                  label: 'More',
                  onTap: onMore,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            children: [
              if (profile.phoneNumber != null)
                _InfoTile(
                  value: _formatPhone(profile.phoneNumber!),
                  caption: 'Mobile',
                  captionColor: label,
                ),
              if (profile.bio != null)
                _InfoTile(
                  value: profile.bio!,
                  caption: 'Bio',
                  captionColor: label,
                ),
              if (profile.username != null)
                _InfoTile(
                  value: '@${profile.username}',
                  caption: 'Username',
                  captionColor: label,
                  trailing: IconButton(
                    tooltip: 'Copy',
                    onPressed: () => onCopyUsername(profile.username!),
                    icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                  ),
                ),
              const SizedBox(height: 8),
              _MediaRow(
                icon: Icons.photo_outlined,
                label: '${profile.photoCount} photos',
              ),
              _MediaRow(
                icon: Icons.videocam_outlined,
                label: '${profile.videoCount} videos',
              ),
              _MediaRow(
                icon: Icons.insert_drive_file_outlined,
                label: '${profile.fileCount} files',
              ),
              _MediaRow(
                icon: Icons.link_rounded,
                label: '${profile.linkCount} shared links',
              ),
              _MediaRow(
                icon: Icons.mic_none_rounded,
                label: '${profile.voiceCount} voice messages',
              ),
              _MediaRow(
                icon: Icons.gif_box_outlined,
                label: '${profile.gifCount} GIFs',
              ),
              const Divider(height: 28),
              if (profile.isPrivate) ...[
                _ActionRow(
                  icon: Icons.ios_share_rounded,
                  label: 'Share this contact',
                  onTap: onShare,
                ),
                _ActionRow(
                  icon: Icons.edit_outlined,
                  label: profile.isContact ? 'Edit contact' : 'Add contact',
                  onTap: onEdit,
                ),
                if (profile.isContact)
                  _ActionRow(
                    icon: Icons.delete_outline,
                    label: 'Delete contact',
                    onTap: onDelete,
                  ),
                _ActionRow(
                  icon: Icons.front_hand_outlined,
                  label: profile.isBlocked ? 'Unblock user' : 'Block user',
                  danger: !profile.isBlocked,
                  onTap: onBlock,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.startsWith('+') && digits.length > 4) return digits;
    if (digits.length >= 9) return '+$digits';
    return raw;
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF242F3D)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Icon(icon, size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.value,
    required this.caption,
    required this.captionColor,
    this.trailing,
  });

  final String value;
  final String caption;
  final Color captionColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(value),
      subtitle: Text(
        caption,
        style: TextStyle(color: captionColor, fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}

class _MediaRow extends StatelessWidget {
  const _MediaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22),
      title: Text(label),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : null;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
