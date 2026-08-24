import 'package:flutter/material.dart';

enum LoadingButtonVariant { filled, tonal, outlined, text }

/// Premium interactive button that smoothly morphs into a loading state
/// with a customized spinner and status text while preventing duplicate taps.
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.variant = LoadingButtonVariant.filled,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  const LoadingButton.filled({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  }) : variant = LoadingButtonVariant.filled;

  const LoadingButton.tonal({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  }) : variant = LoadingButtonVariant.tonal;

  const LoadingButton.outlined({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  }) : variant = LoadingButtonVariant.outlined;

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final Widget? icon;
  final LoadingButtonVariant variant;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double? width;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color getProgressColor() {
      switch (variant) {
        case LoadingButtonVariant.filled:
          return scheme.onPrimary;
        case LoadingButtonVariant.tonal:
          return scheme.onSecondaryContainer;
        case LoadingButtonVariant.outlined:
        case LoadingButtonVariant.text:
          return scheme.primary;
      }
    }

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget content() {
      if (isLoading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
              ),
            ),
            if (loadingText != null && loadingText!.isNotEmpty) ...[
              const SizedBox(width: 10),
              Text(
                loadingText!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        );
      }

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            const SizedBox(width: 8),
            child,
          ],
        );
      }

      return child;
    }

    final baseShape = RoundedRectangleBorder(borderRadius: borderRadius);
    final defaultStyle = (style ?? const ButtonStyle()).copyWith(
      minimumSize: WidgetStateProperty.all(Size(width ?? 0, height)),
      shape: WidgetStateProperty.all(baseShape),
      backgroundColor: backgroundColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return backgroundColor!.withValues(alpha: 0.5);
              }
              return backgroundColor;
            })
          : null,
      foregroundColor: foregroundColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return foregroundColor!.withValues(alpha: 0.5);
              }
              return foregroundColor;
            })
          : null,
    );

    Widget button;
    switch (variant) {
      case LoadingButtonVariant.filled:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: defaultStyle,
          child: content(),
        );
        break;
      case LoadingButtonVariant.tonal:
        button = FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: defaultStyle,
          child: content(),
        );
        break;
      case LoadingButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: defaultStyle,
          child: content(),
        );
        break;
      case LoadingButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: defaultStyle,
          child: content(),
        );
        break;
    }

    if (width != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}
