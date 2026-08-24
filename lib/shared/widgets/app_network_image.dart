import 'package:flutter/material.dart';

import '../../core/utils/image_url_resolver.dart';
import 'loading/shimmer.dart';
import 'loading/skeleton_primitives.dart';

/// Resilient, high-performance network image widget with graceful shimmer loading,
/// smooth fade-in on load, automatic URL resolution for Android emulator & Web, and customizable fallback icons/placeholders.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fallbackIcon = Icons.image_outlined,
    this.isLibrary = false,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final IconData fallbackIcon;
  final bool isLibrary;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ImageUrlResolver.resolve(imageUrl);

    Widget fallback() {
      if (errorWidget != null) return errorWidget!;
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isLibrary
                ? [const Color(0xFFEBF4FF), const Color(0xFFD6E4FF)]
                : [const Color(0xFFE8F7F0), const Color(0xFFC7F0DB)],
          ),
        ),
        child: Center(
          child: Icon(
            fallbackIcon,
            size: (width != null && width! < 60) ? 20 : 28,
            color: isLibrary ? const Color(0xFF2563EB) : const Color(0xFF0D9488),
          ),
        ),
      );
    }

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return fallback();
    }

    final defaultPlaceholder = Shimmer(
      child: SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
    );

    final imageWidget = Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        }
        return placeholder ?? defaultPlaceholder;
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? defaultPlaceholder;
      },
      errorBuilder: (context, error, stackTrace) {
        return fallback();
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

