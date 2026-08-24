import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [OnboardHomeScreen].
class OnboardHomeSkeleton extends StatelessWidget {
  const OnboardHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonHeroCard(height: 180, imageHeight: 110),
          SizedBox(height: 16),
          SkeletonText(width: 140, height: 18),
          SizedBox(height: 12),
          SkeletonCard(height: 110),
          SizedBox(height: 10),
          SkeletonCard(height: 110),
        ],
      ),
    );
  }
}

/// Skeleton for [OnboardSelectTypeScreen].
class OnboardSelectTypeSkeleton extends StatelessWidget {
  const OnboardSelectTypeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonText(width: 160, height: 22),
          SizedBox(height: 8),
          SkeletonText(width: 220, height: 13),
          SizedBox(height: 24),
          SkeletonCard(height: 100),
          SizedBox(height: 12),
          SkeletonCard(height: 100),
          SizedBox(height: 12),
          SkeletonCard(height: 100),
        ],
      ),
    );
  }
}

/// Skeleton for [OnboardUserFormScreen] & [OnboardFacilityFormScreen].
class OnboardFormSkeleton extends StatelessWidget {
  const OnboardFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonText(width: 160, height: 20),
          SizedBox(height: 6),
          SkeletonText(width: 220, height: 12),
          SizedBox(height: 20),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 24),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}

/// Skeleton for [OnboardReviewScreen].
class OnboardReviewSkeleton extends StatelessWidget {
  const OnboardReviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonText(width: 180, height: 20),
          SizedBox(height: 8),
          SkeletonText(width: 220, height: 12),
          SizedBox(height: 20),
          SkeletonCard(height: 140),
          SizedBox(height: 12),
          SkeletonCard(height: 140),
          SizedBox(height: 24),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}

/// Branded token verification state for [OnboardCompleteScreen].
class OnboardVerificationState extends StatefulWidget {
  const OnboardVerificationState({super.key, this.message = 'Verifying onboarding invitation securely...'});

  final String message;

  @override
  State<OnboardVerificationState> createState() => _OnboardVerificationStateState();
}

class _OnboardVerificationStateState extends State<OnboardVerificationState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 44,
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Security Verification',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
