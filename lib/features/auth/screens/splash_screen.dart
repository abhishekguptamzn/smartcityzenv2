import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/api/health_api.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/auth_skeletons.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    // Health check is best-effort diagnostics only — never blocks navigation.
    unawaited(_pingHealth());

    await ref.read(authControllerProvider.future).catchError((_) => null);
    if (!mounted) return;

    final session = ref.read(authControllerProvider).value;
    context.go(session != null ? '/home' : '/onboarding');
  }

  Future<void> _pingHealth() async {
    try {
      await ref.read(healthApiProvider).check();
    } catch (e) {
      _logger.w('Health check failed at splash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AmbientBackground(
        child: SplashStartupAnimation(
          appName: l10n.appName,
          tagline: l10n.appTagline,
        ),
      ),
    );
  }
}

