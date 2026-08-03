import 'package:flutter/material.dart';

/// Brand and semantic colors for ጊዜCare.
///
/// Soft Evernote-inspired chrome with GizeCare cyan for selection/links
/// and a green primary CTA for “New note” actions.
abstract final class AppColors {
  /// Primary logo cyan (`#009DFE`) — selection, links, share-style actions.
  static const Color brand = Color(0xFF009DFE);

  /// Slightly deeper cyan for light-theme contrast.
  static const Color brandDark = Color(0xFF0086D9);

  /// Soft cyan for accents / muted highlights.
  static const Color brandMuted = Color(0xFF4DB8FF);

  /// Soft blue for secondary actions (share / selected card rim).
  static const Color softBlue = Color(0xFF5B8DEF);

  /// Logo ink background.
  static const Color brandInk = Color(0xFF000000);

  // Soft Evernote-like dark surfaces
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceContainer = Color(0xFF1C1C1C);
  static const Color darkSurfaceHigh = Color(0xFF262626);
  static const Color darkSidebar = Color(0xFF1A1A1A);
  static const Color darkListPane = Color(0xFF1F1F1F);
  static const Color darkOutline = Color(0xFF333333);

  static const Color lightSurface = Color(0xFFF3F6F9);
  static const Color lightSurfaceContainer = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFE6EDF3);
  static const Color lightOutline = Color(0xFFC2CDD8);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const List<Color> projectPalette = [
    Color(0xFF009DFE),
    Color(0xFF14B8A6),
    Color(0xFF3B82F6),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
    Color(0xFF64748B),
  ];
}
