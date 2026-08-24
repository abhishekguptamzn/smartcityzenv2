import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Premium branded startup splash animation with glowing breathing logo and
/// subtle brand pulse instead of a raw spinner.
class SplashStartupAnimation extends StatefulWidget {
  const SplashStartupAnimation({
    super.key,
    required this.appName,
    required this.tagline,
  });

  final String appName;
  final String tagline;

  @override
  State<SplashStartupAnimation> createState() => _SplashStartupAnimationState();
}

class _SplashStartupAnimationState extends State<SplashStartupAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
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
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: _glowAnimation.value),
                      blurRadius: 36,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/logo_mark.png',
                    width: 112,
                    height: 112,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.shield_rounded,
                      size: 96,
                      color: scheme.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          Text(
            widget.appName,
            style: GoogleFonts.sora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.tagline,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 36),
          // Subtle progress line instead of raw circular spinner
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Form input & action skeleton for Auth screens.
class AuthFormSkeleton extends StatelessWidget {
  const AuthFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SkeletonInput(),
          SizedBox(height: 16),
          SkeletonInput(),
          SizedBox(height: 24),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}
