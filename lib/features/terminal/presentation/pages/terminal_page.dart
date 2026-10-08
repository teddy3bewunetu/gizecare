import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/widgets/app_panel.dart';

/// In-app terminal (PTY + xterm) for desktop Apps.
///
/// Spawns the user shell on Linux/macOS (`$SHELL`) or `powershell`/`cmd` on
/// Windows. Also offers opening the OS terminal as a separate window.
class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final _terminal = Terminal(maxLines: 10000);
  final _controller = TerminalController();

  Pty? _pty;
  var _starting = false;
  String? _error;

  static bool get _ptySupported =>
      !kIsWeb &&
      (Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isWindows ||
          Platform.isAndroid);

  @override
  void initState() {
    super.initState();
    if (_ptySupported) {
      WidgetsBinding.instance.endOfFrame.then((_) {
        if (mounted) _startPty();
      });
    }
  }

  @override
  void dispose() {
    _killPty();
    super.dispose();
  }

  void _killPty() {
    try {
      _pty?.kill();
    } catch (_) {}
    _pty = null;
  }

  Future<void> _startPty() async {
    if (!_ptySupported || _starting) return;
    setState(() {
      _starting = true;
      _error = null;
    });
    _killPty();
    try {
      _terminal.buffer.clearScrollback();
    } catch (_) {}
    _terminal.setCursor(0, 0);

    try {
      final cols = _terminal.viewWidth.clamp(40, 300);
      final rows = _terminal.viewHeight.clamp(10, 120);
      final pty = Pty.start(
        _shellExecutable,
        arguments: _shellArguments,
        columns: cols,
        rows: rows,
        environment: {
          'TERM': 'xterm-256color',
          'COLORTERM': 'truecolor',
          if (Platform.environment['LANG'] != null)
            'LANG': Platform.environment['LANG']!,
          if (Platform.environment['LC_ALL'] != null)
            'LC_ALL': Platform.environment['LC_ALL']!,
          // Strict snaps block many host /usr/bin tools; prefer core /bin.
          if ((Platform.environment['SNAP'] ?? '').isNotEmpty)
            'PATH': _snapTerminalPath,
        },
      );

      pty.output
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(_terminal.write);

      unawaited(
        pty.exitCode.then((code) {
          if (!mounted) return;
          _terminal.write('\r\n[process exited with code $code]\r\n');
          setState(() => _pty = null);
        }),
      );

      _terminal.onOutput = (data) {
        pty.write(const Utf8Encoder().convert(data));
      };
      _terminal.onResize = (w, h, pw, ph) {
        try {
          pty.resize(h, w);
        } catch (_) {}
      };

      if (!mounted) {
        pty.kill();
        return;
      }
      setState(() {
        _pty = pty;
        _starting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _error = 'Could not start shell: $e';
      });
    }
  }

  Future<void> _openSystemTerminal() async {
    try {
      final launched = await launchSystemTerminal();
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No system terminal found')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open terminal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Terminal',
          subtitle: AppPlatform.isLinux
              ? 'Local shell ($_shellExecutable)'
              : 'Local shell',
          actions: [
            if (_ptySupported)
              IconButton(
                tooltip: 'Restart session',
                onPressed: _starting ? null : _startPty,
                icon: const Icon(Icons.refresh_rounded),
              ),
            if (AppPlatform.isDesktop)
              IconButton(
                tooltip: 'Open system terminal',
                onPressed: _openSystemTerminal,
                icon: const Icon(Icons.open_in_new_rounded),
              ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Material(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: !_ptySupported
                  ? const _MessagePane(
                      icon: Icons.terminal_rounded,
                      title: 'Terminal needs a desktop shell',
                      body:
                          'In-app terminal runs on Linux, macOS, and Windows.',
                    )
                  : _error != null
                      ? _MessagePane(
                          icon: Icons.error_outline_rounded,
                          title: 'Shell failed to start',
                          body: _error!,
                          actionLabel: 'Retry',
                          onAction: _startPty,
                        )
                      : _starting && _pty == null
                          ? const Center(child: CircularProgressIndicator())
                          : TerminalView(
                              _terminal,
                              controller: _controller,
                              autofocus: true,
                              backgroundOpacity: 0,
                              theme: TerminalThemes.defaultTheme,
                              textStyle: TerminalStyle(
                                fontSize: 13,
                                fontFamily: _monoFont,
                              ),
                              onSecondaryTapDown: (details, offset) async {
                                final selection = _controller.selection;
                                if (selection != null) {
                                  final text =
                                      _terminal.buffer.getText(selection);
                                  _controller.clearSelection();
                                  await Clipboard.setData(
                                    ClipboardData(text: text),
                                  );
                                } else {
                                  final data =
                                      await Clipboard.getData('text/plain');
                                  final text = data?.text;
                                  if (text != null) _terminal.paste(text);
                                }
                              },
                            ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessagePane extends StatelessWidget {
  const _MessagePane({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

String get _shellExecutable {
  if (Platform.isWindows) {
    final comspec = Platform.environment['ComSpec'];
    if (comspec != null && comspec.trim().isNotEmpty) return comspec;
    return 'powershell.exe';
  }
  if (Platform.isMacOS || Platform.isLinux || Platform.isAndroid) {
    // Inside a Snap, host $SHELL may point at blocked host paths; use core bash.
    if ((Platform.environment['SNAP'] ?? '').isNotEmpty) {
      for (final candidate in const ['/bin/bash', '/bin/sh']) {
        if (File(candidate).existsSync()) return candidate;
      }
    }
    return Platform.environment['SHELL'] ?? 'bash';
  }
  return 'sh';
}

/// PATH for in-app PTY under Snap (coreutils in /bin work; many /usr/bin host
/// tools return Permission denied).
String get _snapTerminalPath {
  final snap = Platform.environment['SNAP'] ?? '';
  final parts = <String>[
    if (snap.isNotEmpty) '$snap/usr/bin',
    if (snap.isNotEmpty) '$snap/bin',
    '/bin',
    '/usr/bin',
    '/sbin',
    '/usr/sbin',
  ];
  return parts.join(':');
}

List<String> get _shellArguments {
  if (Platform.isWindows &&
      _shellExecutable.toLowerCase().contains('powershell')) {
    return const ['-NoLogo'];
  }
  return const [];
}

String get _monoFont {
  if (Platform.isLinux) return 'monospace';
  if (Platform.isMacOS) return 'Menlo';
  if (Platform.isWindows) return 'Consolas';
  return 'monospace';
}

/// Launches the desktop’s preferred terminal emulator in a new window.
Future<bool> launchSystemTerminal() async {
  if (kIsWeb) return false;

  if (Platform.isMacOS) {
    await Process.start(
      'open',
      ['-a', 'Terminal'],
      mode: ProcessStartMode.detached,
    );
    return true;
  }

  if (Platform.isWindows) {
    for (final cmd in [
      ['wt.exe'],
      ['powershell.exe'],
      ['cmd.exe'],
    ]) {
      try {
        await Process.start(
          cmd.first,
          cmd.skip(1).toList(),
          mode: ProcessStartMode.detached,
        );
        return true;
      } catch (_) {}
    }
    return false;
  }

  if (Platform.isLinux) {
    for (final cmd in [
      ['x-terminal-emulator'],
      ['gnome-terminal'],
      ['kgx'],
      ['konsole'],
      ['xfce4-terminal'],
      ['tilix'],
      ['alacritty'],
      ['kitty'],
      ['xterm'],
    ]) {
      try {
        await Process.start(
          cmd.first,
          cmd.skip(1).toList(),
          mode: ProcessStartMode.detached,
        );
        return true;
      } catch (_) {}
    }
  }

  return false;
}
