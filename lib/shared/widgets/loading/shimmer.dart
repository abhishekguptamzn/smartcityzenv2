import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A 60/120fps high-performance Shimmer effect that sweeps a smooth gradient
/// across its child widgets. Designed to match Flutter's Material 3 theme and
/// the Smart CityZen design tokens in both light and dark modes.
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.enabled = true,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final ShimmerDirection direction;
  final bool enabled;

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  @override
  State<Shimmer> createState() => ShimmerState();
}

enum ShimmerDirection { ltr, rtl }

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Listenable get gradientListener => _controller;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final appColors = context.appColors;
    final base = widget.baseColor ?? appColors.shimmerBase;
    final highlight = widget.highlightColor ?? appColors.shimmerHighlight;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final progress = _controller.value;
        final beginOffset = widget.direction == ShimmerDirection.ltr
            ? -1.0 + (progress * 2.0)
            : 1.0 - (progress * 2.0);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(beginOffset - 1.0, 0),
              end: Alignment(beginOffset + 1.0, 0),
              colors: [
                base,
                highlight,
                base,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
