import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart' show Offset, Size;
import 'package:window_manager/window_manager.dart';

import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Compact vs full desktop window modes.
enum WindowMode { compact, full }

/// Switches between Upwork-style compact tracker and the full app shell.
class WindowModeService {
  WindowModeService({
    required SettingsRepository settings,
    required AppLogger logger,
  })  : _settings = settings,
        _logger = logger;

  static const compactSize = Size(380, 720);
  static const compactMinSize = Size(320, 560);
  /// Hard ceiling so a corrupted/saved full-size state cannot widen compact.
  static const compactMaxSize = Size(480, 900);
  static const fullSize = Size(1280, 800);
  static const fullMinSize = Size(960, 640);

  final SettingsRepository _settings;
  final AppLogger _logger;

  WindowMode _mode = WindowMode.compact;

  WindowMode get mode => _mode;

  /// Reads preferred launch mode (defaults to compact).
  Future<WindowMode> preferredLaunchMode() async {
    final raw = await _settings.get(SettingKeys.launchCompact);
    final launchCompact = raw.when(
      onSuccess: (v) => v == null ? true : v == 'true',
      onFailure: (_) => true,
    );
    return launchCompact ? WindowMode.compact : WindowMode.full;
  }

  Future<void> applyLaunchMode() async {
    final preferred = await preferredLaunchMode();
    if (preferred == WindowMode.compact) {
      await enterCompact(saveCurrentAsFull: false);
    } else {
      await enterFull(saveCurrentAsCompact: false);
    }
  }

  Future<void> enterCompact({bool saveCurrentAsFull = true}) async {
    try {
      if (AppDesktopBrowser.isAvailable) {
        await AppDesktopBrowser.hide();
      }
      if (saveCurrentAsFull && _mode == WindowMode.full) {
        await _saveGeometry(SettingKeys.fullWindowState);
      }
      _mode = WindowMode.compact;
      await _settings.set(SettingKeys.windowMode, WindowMode.compact.name);

      if (await windowManager.isMaximized()) {
        await windowManager.unmaximize();
      }
      if (await windowManager.isFullScreen()) {
        await windowManager.setFullScreen(false);
      }

      await windowManager.setMinimumSize(compactMinSize);
      await windowManager.setMaximumSize(compactMaxSize);
      await windowManager.setTitle(AppConstants.displayName);

      final restored = await _restoreGeometry(
        SettingKeys.compactWindowState,
        clampToCompact: true,
      );
      if (!restored) {
        await windowManager.setSize(compactSize);
        await windowManager.center();
      } else {
        // Guarantee we never stay at a full-app footprint.
        final size = await windowManager.getSize();
        if (size.width > compactMaxSize.width ||
            size.height > compactMaxSize.height) {
          await windowManager.setSize(compactSize);
          await windowManager.center();
        }
      }
      await windowManager.show();
      await windowManager.focus();
    } catch (e, st) {
      _logger.warning('Failed to enter compact mode', e, st);
    }
  }

  Future<void> enterFull({bool saveCurrentAsCompact = true}) async {
    try {
      if (saveCurrentAsCompact && _mode == WindowMode.compact) {
        await _saveGeometry(SettingKeys.compactWindowState);
      }
      _mode = WindowMode.full;
      await _settings.set(SettingKeys.windowMode, WindowMode.full.name);

      // Lift compact max-size lock so the full shell can grow.
      await windowManager.setMaximumSize(const Size(10000, 10000));
      await windowManager.setMinimumSize(fullMinSize);
      await windowManager.setTitle(AppConstants.displayName);

      final restored = await _restoreGeometry(SettingKeys.fullWindowState);
      if (!restored) {
        await windowManager.setSize(fullSize);
        await windowManager.center();
      }
      await windowManager.show();
      await windowManager.focus();
    } catch (e, st) {
      _logger.warning('Failed to enter full mode', e, st);
    }
  }

  Future<void> saveCurrentGeometry() async {
    final key = _mode == WindowMode.compact
        ? SettingKeys.compactWindowState
        : SettingKeys.fullWindowState;
    await _saveGeometry(key);
  }

  Future<void> showAndFocus() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> hideToTray() async {
    if (AppDesktopBrowser.isAvailable) {
      await AppDesktopBrowser.hide();
    }
    await saveCurrentGeometry();
    await windowManager.hide();
  }

  Future<void> _saveGeometry(String key) async {
    try {
      final size = await windowManager.getSize();
      final position = await windowManager.getPosition();
      final maximized = await windowManager.isMaximized();
      // Never persist oversized dimensions as "compact".
      final isCompactKey = key == SettingKeys.compactWindowState;
      final width = isCompactKey
          ? math.min(size.width, compactMaxSize.width)
          : size.width;
      final height = isCompactKey
          ? math.min(size.height, compactMaxSize.height)
          : size.height;
      await _settings.set(
        key,
        jsonEncode({
          'width': width,
          'height': height,
          'x': position.dx,
          'y': position.dy,
          'maximized': isCompactKey ? false : maximized,
        }),
      );
    } catch (e, st) {
      _logger.warning('Failed to save window geometry', e, st);
    }
  }

  Future<bool> _restoreGeometry(
    String key, {
    bool clampToCompact = false,
  }) async {
    try {
      final raw = await _settings.get(key);
      final value = raw.when(onSuccess: (v) => v, onFailure: (_) => null);
      if (value == null) return false;
      final map = jsonDecode(value) as Map<String, dynamic>;
      var width = (map['width'] as num?)?.toDouble();
      var height = (map['height'] as num?)?.toDouble();
      final x = (map['x'] as num?)?.toDouble();
      final y = (map['y'] as num?)?.toDouble();
      final maximized = map['maximized'] as bool? ?? false;

      if (clampToCompact) {
        if (width == null ||
            height == null ||
            width > compactMaxSize.width ||
            height > compactMaxSize.height ||
            width < compactMinSize.width ||
            height < compactMinSize.height) {
          // Corrupt / full-size snapshot — fall back to defaults.
          return false;
        }
        width = width.clamp(compactMinSize.width, compactMaxSize.width);
        height = height.clamp(compactMinSize.height, compactMaxSize.height);
      }

      if (width != null && height != null) {
        await windowManager.setSize(Size(width, height));
      }
      if (x != null && y != null) {
        await windowManager.setPosition(Offset(x, y));
      }
      if (maximized && key == SettingKeys.fullWindowState) {
        await windowManager.maximize();
      }
      return width != null && height != null;
    } catch (e, st) {
      _logger.warning('Failed to restore window geometry', e, st);
      return false;
    }
  }
}
