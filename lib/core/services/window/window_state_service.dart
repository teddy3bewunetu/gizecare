import 'dart:convert';

import 'package:flutter/material.dart' show Offset, Size;
import 'package:window_manager/window_manager.dart';

import 'package:gizecare/core/services/app_logger.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Persists and restores window geometry.
class WindowStateService {
  WindowStateService({
    required SettingsRepository settings,
    required AppLogger logger,
  })  : _settings = settings,
        _logger = logger;

  static const _key = 'window_state';

  final SettingsRepository _settings;
  final AppLogger _logger;

  Future<void> restore() async {
    try {
      final raw = await _settings.get(_key);
      final value = raw.when(onSuccess: (v) => v, onFailure: (_) => null);
      if (value == null) return;
      final map = jsonDecode(value) as Map<String, dynamic>;
      final width = (map['width'] as num?)?.toDouble();
      final height = (map['height'] as num?)?.toDouble();
      final x = (map['x'] as num?)?.toDouble();
      final y = (map['y'] as num?)?.toDouble();
      final maximized = map['maximized'] as bool? ?? false;

      if (width != null && height != null) {
        await windowManager.setSize(Size(width, height));
      }
      if (x != null && y != null) {
        await windowManager.setPosition(Offset(x, y));
      }
      if (maximized) {
        await windowManager.maximize();
      }
    } catch (e, st) {
      _logger.warning('Failed to restore window state', e, st);
    }
  }

  Future<void> save() async {
    try {
      final size = await windowManager.getSize();
      final position = await windowManager.getPosition();
      final maximized = await windowManager.isMaximized();
      final payload = jsonEncode({
        'width': size.width,
        'height': size.height,
        'x': position.dx,
        'y': position.dy,
        'maximized': maximized,
      });
      await _settings.set(_key, payload);
    } catch (e, st) {
      _logger.warning('Failed to save window state', e, st);
    }
  }
}
