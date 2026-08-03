import 'package:flutter/services.dart';

/// Maps a [KeyEvent] to a stable ranking label (e.g. `a`, `Enter`, `Shift`).
///
/// On Linux, [KeyDownEvent.character] is often null; [LogicalKeyboardKey.keyLabel]
/// can also be empty — we fall back to debug names (`Key A` → `a`).
String? keystrokeLabel(KeyEvent event) {
  if (event is! KeyDownEvent && event is! KeyRepeatEvent) return null;

  final character = event.character;
  if (character != null && character.isNotEmpty) {
    if (character == ' ') return 'Space';
    if (character == '\n' || character == '\r') return 'Enter';
    if (character == '\t') return 'Tab';
    if (character.length == 1) {
      final code = character.codeUnitAt(0);
      if (code >= 32 && code != 127) {
        return character.toLowerCase();
      }
    }
  }

  final key = event.logicalKey;
  if (key == LogicalKeyboardKey.space) return 'Space';
  if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
    return 'Enter';
  }
  if (key == LogicalKeyboardKey.tab) return 'Tab';
  if (key == LogicalKeyboardKey.backspace) return 'Backspace';
  if (key == LogicalKeyboardKey.delete) return 'Delete';
  if (key == LogicalKeyboardKey.escape) return 'Esc';
  if (key == LogicalKeyboardKey.shiftLeft ||
      key == LogicalKeyboardKey.shiftRight) {
    return 'Shift';
  }
  if (key == LogicalKeyboardKey.controlLeft ||
      key == LogicalKeyboardKey.controlRight) {
    return 'Ctrl';
  }
  if (key == LogicalKeyboardKey.altLeft || key == LogicalKeyboardKey.altRight) {
    return 'Alt';
  }
  if (key == LogicalKeyboardKey.metaLeft || key == LogicalKeyboardKey.metaRight) {
    return 'Meta';
  }
  if (key == LogicalKeyboardKey.arrowUp) return '↑';
  if (key == LogicalKeyboardKey.arrowDown) return '↓';
  if (key == LogicalKeyboardKey.arrowLeft) return '←';
  if (key == LogicalKeyboardKey.arrowRight) return '→';

  final label = key.keyLabel.trim();
  if (label.isNotEmpty) {
    if (label.length == 1) return label.toLowerCase();
    return label;
  }

  final debug = key.debugName;
  if (debug == null || debug.isEmpty) return null;

  // "Key A" / "Digit 1" / "Numpad 1"
  final keyMatch = RegExp(r'^Key ([A-Z])$').firstMatch(debug);
  if (keyMatch != null) return keyMatch.group(1)!.toLowerCase();

  final digitMatch = RegExp(r'^Digit ([0-9])$').firstMatch(debug);
  if (digitMatch != null) return digitMatch.group(1);

  final numpadMatch = RegExp(r'^Numpad ([0-9])$').firstMatch(debug);
  if (numpadMatch != null) return 'Num${numpadMatch.group(1)}';

  if (debug.length > 24) return debug.substring(0, 24);
  return debug;
}
