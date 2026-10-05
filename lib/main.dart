import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizecare/app/app.dart';
import 'package:gizecare/app/router/app_router.dart';
import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/core/di/service_providers.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/services/window/window_mode_service.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';
import 'package:gizecare/features/tracker/presentation/providers/timer_controller.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  await bootstrap();

  runApp(
    const ProviderScope(
      child: _AppBootstrap(),
    ),
  );
}

class _AppBootstrap extends ConsumerStatefulWidget {
  const _AppBootstrap();

  @override
  ConsumerState<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<_AppBootstrap>
    with WindowListener {
  bool _closeToTray = true;
  bool _quitting = false;

  @override
  void initState() {
    super.initState();
    if (AppPlatform.isDesktop) {
      windowManager.addListener(this);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _initializeDesktopShell();
      });
    }
  }

  Future<void> _initializeDesktopShell() async {
    final settings = ref.read(settingsRepositoryProvider);
    final closeRaw = await settings.get(SettingKeys.closeToTray);
    _closeToTray = closeRaw.when(
      onSuccess: (v) => v == null ? true : v == 'true',
      onFailure: (_) => true,
    );

    final modeService = ref.read(windowModeServiceProvider);
    await modeService.applyLaunchMode();

    final preferred = await modeService.preferredLaunchMode();
    if (preferred == WindowMode.compact) {
      // Re-assert compact size after first frame — some WMs ignore the
      // pre-show size and expand to the last maximized footprint.
      await modeService.enterCompact(saveCurrentAsFull: false);
      appRouter.go(AppRoutes.compact);
    } else {
      appRouter.go(AppRoutes.dashboard);
    }

    await windowManager.setPreventClose(true);

    final tray = ref.read(trayServiceProvider);
    final timerRunning = ref.read(timerControllerProvider).isRunning;
    await tray.init(
      trackingActive: timerRunning,
      onOpenCompact: () async {
        await modeService.enterCompact();
        appRouter.go(AppRoutes.compact);
      },
      onOpenFull: () async {
        await modeService.enterFull();
        appRouter.go(AppRoutes.dashboard);
      },
      onStart: () async {
        // Requires a previously selected project + activity.
        final settings = ref.read(settingsRepositoryProvider);
        final projectRaw = await settings.get(SettingKeys.lastProjectId);
        final taskRaw = await settings.get(SettingKeys.lastTaskId);
        final projectId =
            projectRaw.when(onSuccess: (v) => v, onFailure: (_) => null);
        final taskId =
            taskRaw.when(onSuccess: (v) => v, onFailure: (_) => null);
        if (projectId == null || taskId == null) return;

        final projects =
            await ref.read(projectRepositoryProvider).getProjects();
        if (projects.isFailure) return;
        final project = projects.requireValue
            .where((p) => p.id == projectId)
            .firstOrNull;
        if (project == null) return;

        final tasks = await ref
            .read(taskRepositoryProvider)
            .getTasks(projectId: projectId);
        if (tasks.isFailure) return;
        final task =
            tasks.requireValue.where((t) => t.id == taskId).firstOrNull;
        if (task == null) return;

        await ref
            .read(timerControllerProvider.notifier)
            .start(project: project, task: task);
      },
      onPause: () async {
        ref.read(timerControllerProvider.notifier).pause();
      },
      onStop: () async {
        await ref.read(timerControllerProvider.notifier).stop();
      },
      onQuit: () async {
        _quitting = true;
        if (AppDesktopBrowser.isAvailable) {
          await AppDesktopBrowser.closeAll();
        }
        await windowManager.setPreventClose(false);
        await windowManager.destroy();
        exit(0);
      },
    );
    ref.read(trayReadyProvider.notifier).state = tray.isReady;
  }

  @override
  void dispose() {
    if (AppPlatform.isDesktop) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload keeps native WebKit windows alive while the Flutter window
    // may reset size/position — hide orphans so they don't float on the desktop.
    if (AppPlatform.isDesktop && AppDesktopBrowser.isAvailable) {
      unawaited(AppDesktopBrowser.hide());
    }
  }

  @override
  void onWindowMinimize() {
    if (AppDesktopBrowser.isAvailable) {
      unawaited(AppDesktopBrowser.hide());
    }
  }

  @override
  void onWindowMoved() => _persistWindow();

  @override
  void onWindowResized() => _persistWindow();

  @override
  void onWindowMaximize() => _persistWindow();

  @override
  void onWindowUnmaximize() => _persistWindow();

  @override
  Future<void> onWindowClose() async {
    if (_quitting) return;
    if (await _shouldHideToTray()) {
      if (AppDesktopBrowser.isAvailable) {
        await AppDesktopBrowser.hide();
      }
      await ref.read(windowModeServiceProvider).hideToTray();
    } else {
      _quitting = true;
      if (AppDesktopBrowser.isAvailable) {
        await AppDesktopBrowser.closeAll();
      }
      await windowManager.setPreventClose(false);
      await windowManager.destroy();
    }
  }

  Future<bool> _shouldHideToTray() async {
    final trayReady = ref.read(trayReadyProvider);
    if (!trayReady) return false;
    final raw =
        await ref.read(settingsRepositoryProvider).get(SettingKeys.closeToTray);
    return raw.when(
      onSuccess: (v) => v == null ? true : v == 'true',
      onFailure: (_) => _closeToTray,
    );
  }

  void _persistWindow() {
    unawaited(ref.read(windowModeServiceProvider).saveCurrentGeometry());
  }

  @override
  Widget build(BuildContext context) {
    // Colored tray while running; B&W when idle / paused / stopped.
    ref.listen(timerControllerProvider, (prev, next) {
      final wasRunning = prev?.isRunning ?? false;
      if (wasRunning == next.isRunning) return;
      unawaited(
        ref.read(trayServiceProvider).setTrackingActive(next.isRunning),
      );
    });
    return const GizeCareApp();
  }
}
