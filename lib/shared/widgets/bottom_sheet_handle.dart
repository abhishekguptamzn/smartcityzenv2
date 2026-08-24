import 'package:flutter/material.dart';

/// Reusable drag handle for bottom sheets matching the design language.
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({
    super.key,
    this.width = 40,
    this.height = 4,
    this.borderRadius = 2,
    this.color,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade400,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
