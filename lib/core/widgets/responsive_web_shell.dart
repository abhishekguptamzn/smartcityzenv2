import 'package:flutter/material.dart';

/// Responsive shell wrapper that allows full fluid responsiveness across
/// Mobile phones, Tablets, Laptops, and Desktop browsers.
class ResponsiveWebShell extends StatelessWidget {
  const ResponsiveWebShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
