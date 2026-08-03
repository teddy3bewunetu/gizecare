import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/app/router/app_router.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/services/activity/keystroke_capture.dart';
import 'package:gizecare/core/theme/app_theme.dart';
import 'package:gizecare/core/theme/theme_mode_controller.dart';
import 'package:gizecare/features/clock/presentation/providers/alarm_monitor.dart';
import 'package:gizecare/features/settings/presentation/providers/settings_controller.dart';

/// Root widget for ጊዜCare.
class GizeCareApp extends ConsumerWidget {
  const GizeCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    ref.watch(alarmMonitorProvider);
    // Keep global keystroke capture alive for the process lifetime.
    ref.watch(keystrokeCaptureProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.displayName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}
