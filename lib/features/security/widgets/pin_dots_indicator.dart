import 'dart:math';
import 'package:flutter/material.dart';

class PinDotsIndicator extends StatefulWidget {
  const PinDotsIndicator({
    super.key,
    required this.pinLength,
    required this.enteredLength,
    this.hasError = false,
    this.isSuccess = false,
    this.activeColor = const Color(0xFF0F766E),
  });

  final int pinLength;
  final int enteredLength;
  final bool hasError;
  final bool isSuccess;
  final Color activeColor;

  @override
  State<PinDotsIndicator> createState() => _PinDotsIndicatorState();
}

class _PinDotsIndicatorState extends State<PinDotsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(PinDotsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final offset = sin(_shakeController.value * pi * 4) * 12;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.pinLength, (index) {
          final isFilled = index < widget.enteredLength;
          Color dotColor;

          if (widget.hasError) {
            dotColor = const Color(0xFFE11D48);
          } else if (widget.isSuccess) {
            dotColor = const Color(0xFF059669);
          } else if (isFilled) {
            dotColor = widget.activeColor;
          } else {
            dotColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: isFilled ? 18 : 14,
            height: isFilled ? 18 : 14,
            decoration: BoxDecoration(
              color: isFilled ? dotColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: dotColor,
                width: isFilled ? 2 : 2.5,
              ),
              boxShadow: isFilled
                  ? [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}
