import 'package:flutter/material.dart';

/// Pastel palette for Zoho-style note cards.
abstract final class NoteColors {
  static const List<Color> palette = [
    Color(0xFFFFF8E7), // cream
    Color(0xFFE8F5E9), // mint
    Color(0xFFE3F2FD), // light blue
    Color(0xFFFFF3E0), // peach
    Color(0xFFF3E5F5), // lilac
    Color(0xFFE0F7FA), // cyan
    Color(0xFFFFEBEE), // soft red
    Color(0xFFF1F8E9), // lime
    Color(0xFFECEFF1), // blue grey
    Color(0xFFFFFDE7), // yellow
  ];

  static Color random([int? seed]) {
    final index = (seed ?? DateTime.now().microsecondsSinceEpoch) % palette.length;
    return palette[index.abs()];
  }
}
