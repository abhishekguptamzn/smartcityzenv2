import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/utils/loading_manager.dart';

/// Modal blocking overlay for critical operations (payments, secure verifications).
/// Automatically connects to [LoadingManager] or can be driven by a boolean [isLoading].
class PremiumLoadingOverlay extends StatelessWidget {
  const PremiumLoadingOverlay({
    super.key,
    required this.child,
    this.isLoading,
    this.message,
  });

  final Widget child;
  final bool? isLoading;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LoadingManager.instance,
      child: child,
      builder: (context, child) {
        final active = isLoading ?? LoadingManager.instance.isLoading;
        final currentMessage =
            message ?? LoadingManager.instance.message ?? 'Processing...';

        return Stack(
          children: [
            child!,
            if (active)
              Positioned.fill(
                child: PopScope(
                  canPop: false,
                  child: const _OverlayBackdrop(),
                ),
              ),
            if (active)
              Center(
                child: _LoadingModalContent(message: currentMessage),
              ),
          ],
        );
      },
    );
  }
}

class _OverlayBackdrop extends StatelessWidget {
  const _OverlayBackdrop();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: (isDark ? Colors.black : const Color(0xFF0F172A))
            .withValues(alpha: 0.5),
      ),
    );
  }
}

class _LoadingModalContent extends StatefulWidget {
  const _LoadingModalContent({required this.message});

  final String message;

  @override
  State<_LoadingModalContent> createState() => _LoadingModalContentState();
}

class _LoadingModalContentState extends State<_LoadingModalContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo_mark.png',
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.shield_rounded,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              width: 120,
              height: 3,
              child: LinearProgressIndicator(
                backgroundColor: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
