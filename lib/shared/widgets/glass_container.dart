import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/ui_tier.dart';

enum GlassLevel { card, largeCard, navigation, floating }

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.level = GlassLevel.card,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity,
    this.blur,
    this.borderColor,
    this.width,
    this.height,
    this.onTap,
    this.alignment,
    this.gradientOverlay,
    this.showShadow = true,
  });

  final Widget child;
  final GlassLevel level;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double? opacity;
  final double? blur;
  final Color? borderColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final AlignmentGeometry? alignment;
  final Gradient? gradientOverlay;
  final bool showShadow;

  double get _defaultBlur => switch (level) {
    GlassLevel.card => 16,
    GlassLevel.largeCard => 20,
    GlassLevel.navigation => 24,
    GlassLevel.floating => 24,
  };

  double _defaultOpacity(bool isDark) => switch (level) {
    GlassLevel.card => isDark ? 0.80 : 0.72,
    GlassLevel.largeCard => isDark ? 0.82 : 0.75,
    GlassLevel.navigation => isDark ? 0.85 : 0.70,
    GlassLevel.floating => isDark ? 0.88 : 0.82,
  };

  BorderRadiusGeometry get _defaultRadius => switch (level) {
    GlassLevel.card => BorderRadius.circular(16),
    GlassLevel.largeCard => BorderRadius.circular(24),
    GlassLevel.navigation => BorderRadius.circular(24),
    GlassLevel.floating => BorderRadius.circular(24),
  };

  EdgeInsetsGeometry get _defaultPadding => switch (level) {
    GlassLevel.card => const EdgeInsets.all(16),
    GlassLevel.largeCard => const EdgeInsets.all(24),
    GlassLevel.navigation => const EdgeInsets.symmetric(horizontal: 8),
    GlassLevel.floating => const EdgeInsets.all(24),
  };

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.appColors;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final BorderRadiusGeometry radius = borderRadius ?? _defaultRadius;
    final BorderRadius resolved = radius.resolve(Directionality.of(context));
    final double resolvedOpacity = opacity ?? _defaultOpacity(isDark);
    final double resolvedBlur = blur ?? _defaultBlur;

    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding ?? _defaultPadding,
      decoration: BoxDecoration(
        color: colors.glassTint.withValues(alpha: resolvedOpacity),
        borderRadius: resolved,
        gradient: gradientOverlay,
        border: Border.all(color: borderColor ?? colors.glassBorder, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      content = Stack(
        children: <Widget>[
          content,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: resolved,
                splashColor: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.08),
                highlightColor: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.04),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: resolved,
        boxShadow: showShadow
            ? <BoxShadow>[
                BoxShadow(
                  color: colors.glassShadow,
                  blurRadius: level == GlassLevel.card ? 20 : 32,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: UiTierDetector.current == UiTier.full
          ? ClipRRect(
              borderRadius: resolved,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: resolvedBlur, sigmaY: resolvedBlur),
                child: content,
              ),
            )
          : ClipRRect(
              borderRadius: resolved,
              child: content,
            ),
    );
  }
}

/// Soft radial washes that sit behind the whole app, per the mockups'
/// "ambient light" background layers.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.appColors;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        Positioned.fill(child: ColoredBox(color: scheme.surface)),
        Positioned(
          top: -160,
          right: -120,
          child: _Blob(color: colors.ambientOne.withValues(alpha: 0.16)),
        ),
        Positioned(
          bottom: -200,
          left: -140,
          child: _Blob(color: colors.ambientTwo.withValues(alpha: 0.20)),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 380,
        height: 380,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
