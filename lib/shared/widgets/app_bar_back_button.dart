import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App bar back button that safely pops when possible or navigates to a fallback route.
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
    this.fallbackPath = '/home',
    this.color,
    this.icon = Icons.arrow_back_rounded,
  });

  final String fallbackPath;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallbackPath);
        }
      },
    );
  }
}
