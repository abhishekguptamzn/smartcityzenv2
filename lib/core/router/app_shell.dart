import 'package:flutter/material.dart';

import '../../shared/widgets/glass_bottom_nav.dart';
import '../../shared/widgets/glass_sidebar.dart';
import '../../shared/widgets/no_connection_banner.dart';

const double kWideBreakpoint = 800;

/// The persistent authenticated-area scaffold: a left [GlassSidebar] on wide
/// viewports, a [GlassBottomNav] below the breakpoint, and a centered
/// max-width column for [body] so cards don't stretch edge-to-edge on very
/// wide screens.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= kWideBreakpoint;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 1200 ? 1200.0 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: body,
          ),
        );
      },
    );

    return Scaffold(
      body: NoConnectionBanner(
        child: isWide
            ? Row(
                children: [
                  GlassSidebar(currentIndex: currentIndex, onTap: onTap),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
      bottomNavigationBar: isWide
          ? null
          : GlassBottomNav(currentIndex: currentIndex, onTap: onTap),
    );
  }
}
