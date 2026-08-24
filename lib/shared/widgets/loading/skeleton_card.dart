import 'package:flutter/material.dart';

import 'skeleton_primitives.dart';

/// Generic skeleton container matching standard card elevation & radius.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.child,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.7) : Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155).withValues(alpha: 0.6)
              : const Color(0xFFEDF2F7),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }
}

/// Hero style card with media thumbnail, headline and tag chips.
class SkeletonHeroCard extends StatelessWidget {
  const SkeletonHeroCard({
    super.key,
    this.height = 200,
    this.imageHeight = 120,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final double height;
  final double imageHeight;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      margin: margin,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            height: imageHeight,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonText(width: 180, height: 16),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    SkeletonChip(width: 60, height: 20),
                    SizedBox(width: 8),
                    SkeletonChip(width: 80, height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// KPI Metric card with icon box, large value and label.
class SkeletonMetricCard extends StatelessWidget {
  const SkeletonMetricCard({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      width: width,
      height: height,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          SkeletonBox(
            width: 36,
            height: 36,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          SizedBox(height: 12),
          SkeletonText(width: 70, height: 20),
          SizedBox(height: 6),
          SkeletonText(width: 100, height: 12),
        ],
      ),
    );
  }
}
