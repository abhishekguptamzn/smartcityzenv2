import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Basic rectangular/rounded skeleton container.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color,
    this.margin,
    this.padding,
    this.child,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.appColors.shimmerBase;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// Text line placeholders with realistic varying line widths.
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.lines = 1,
    this.height = 14,
    this.spacing = 8,
    this.width,
    this.lastLineWidthRatio = 0.65,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  final int lines;
  final double height;
  final double spacing;
  final double? width;
  final double lastLineWidthRatio;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    if (lines == 1) {
      return SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        final lineWidth = isLast && width != null
            ? width! * lastLineWidthRatio
            : (isLast ? null : width);

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: FractionallySizedBox(
            widthFactor: isLast ? lastLineWidthRatio : 1.0,
            alignment: Alignment.centerLeft,
            child: SkeletonBox(
              width: lineWidth,
              height: height,
              borderRadius: borderRadius,
            ),
          ),
        );
      }),
    );
  }
}

/// Circular skeleton placeholder.
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    required this.size,
    this.color,
    this.margin,
  });

  final double size;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.appColors.shimmerBase;

    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Avatar skeleton placeholder with radius.
class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    super.key,
    this.radius = 20,
    this.margin,
  });

  final double radius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonCircle(
      size: radius * 2,
      margin: margin,
    );
  }
}

/// Chip / Pill skeleton placeholder.
class SkeletonChip extends StatelessWidget {
  const SkeletonChip({
    super.key,
    this.width = 80,
    this.height = 32,
    this.margin,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(999),
    );
  }
}

/// Button-shaped skeleton placeholder.
class SkeletonButton extends StatelessWidget {
  const SkeletonButton({
    super.key,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.margin,
  });

  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      margin: margin,
      borderRadius: borderRadius,
    );
  }
}

/// Text input skeleton placeholder.
class SkeletonInput extends StatelessWidget {
  const SkeletonInput({
    super.key,
    this.width = double.infinity,
    this.height = 52,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin,
  });

  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      margin: margin,
      borderRadius: borderRadius,
    );
  }
}

/// Image / Media placeholder skeleton with aspect ratio or explicit size.
class SkeletonImage extends StatelessWidget {
  const SkeletonImage({
    super.key,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin,
  });

  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    Widget box = SkeletonBox(
      width: width,
      height: height,
      margin: margin,
      borderRadius: borderRadius,
    );

    if (aspectRatio != null) {
      box = AspectRatio(
        aspectRatio: aspectRatio!,
        child: box,
      );
    }

    return box;
  }
}
