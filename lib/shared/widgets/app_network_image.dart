import 'package:flutter/material.dart';

import '../../core/utils/image_url_resolver.dart';

/// Resilient, high-performance network image widget with graceful shimmer loading,
/// automatic URL resolution for Android emulator & Web, and customizable fallback icons/placeholders.
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

    final imageWidget = Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        if (placeholder != null) return placeholder!;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
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
