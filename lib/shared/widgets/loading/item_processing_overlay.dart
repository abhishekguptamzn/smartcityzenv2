import 'dart:ui';
import 'package:flutter/material.dart';

/// Overlay to place over an individual card, list item or row while it is being
/// updated, removed or deleted.
class ItemProcessingOverlay extends StatelessWidget {
  const ItemProcessingOverlay({
    super.key,
    required this.isProcessing,
    required this.child,
    this.message,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  final bool isProcessing;
  final Widget child;
  final String? message;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!isProcessing) return child;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: theme.brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.45)
                    : Colors.white.withValues(alpha: 0.65),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.primary,
                        ),
                      ),
                      if (message != null && message!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          message!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
