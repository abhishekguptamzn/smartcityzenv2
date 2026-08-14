import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'core/providers/locale_controller.dart';
import 'core/providers/theme_mode_controller.dart';
import 'core/router/app_router.dart';
import 'core/services/incident_reporter.dart';
import 'core/theme/app_theme.dart';
import 'l10n/gen/app_localizations.dart';

final Logger appLogger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IncidentReporter.initialize();

  runZonedGuarded(
    () {
      FlutterError.onError = (FlutterErrorDetails details) {
        final errStr = details.exception.toString();
        if (errStr.contains('mouse_tracker.dart') || errStr.contains('_debugDuringDeviceUpdate')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
        IncidentReporter.reportError(
          error: details.exception,
          stackTrace: details.stack,
          exceptionClass: details.exception.runtimeType.toString(),
          message: details.summary.toString(),
          severity: 'error',
          url: 'flutter://ui/error',
        );
      };
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stackTrace) {
      appLogger.e('Uncaught zone error', error: error, stackTrace: stackTrace);
      IncidentReporter.reportError(
        error: error,
        stackTrace: stackTrace,
        exceptionClass: error.runtimeType.toString(),
        message: error.toString(),
        severity: 'critical',
        url: 'flutter://zone/uncaught',
      );
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'Smart Cityzen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
