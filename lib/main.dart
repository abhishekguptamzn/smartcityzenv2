import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'core/providers/locale_controller.dart';
import 'core/providers/theme_mode_controller.dart';
import 'core/router/app_router.dart';
import 'core/services/incident_reporter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/url_strategy_helper.dart';
import 'core/widgets/responsive_web_shell.dart';
import 'l10n/gen/app_localizations.dart';

final Logger appLogger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setAppPathUrlStrategy();
  await IncidentReporter.initialize();

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

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    appLogger.e('Uncaught platform error', error: error, stackTrace: stackTrace);
    IncidentReporter.reportError(
      error: error,
      stackTrace: stackTrace,
      exceptionClass: error.runtimeType.toString(),
      message: error.toString(),
      severity: 'critical',
      url: 'flutter://platform/uncaught',
    );
    return true;
  };

  runApp(const ProviderScope(child: MyApp()));
}

/// Custom scroll behavior enabling seamless touch, trackpad, and mouse drag scrolling across web and mobile.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
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
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => ResponsiveWebShell(
        child: child ?? const SizedBox(),
      ),
    );
  }
}
