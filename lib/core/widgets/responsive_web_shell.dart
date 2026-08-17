import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// A responsive shell that provides:
/// - 100% full-bleed edge-to-edge native experience on mobile screens (< 600px).
/// - An ultra-sleek, centered mobile device presentation on desktop/laptop Chrome screens (>= 600px).
class ResponsiveWebShell extends StatelessWidget {
  const ResponsiveWebShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // If not web, just return the child directly
    if (!kIsWeb) {
      return child;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Mobile viewport: edge-to-edge native full-screen experience
    if (screenWidth < 600) {
      return child;
    }

    // Large / Desktop screen: elegant centered mobile presentation
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000814) : const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.4),
                  radius: 1.2,
                  colors: isDark
                      ? const [Color(0xFF001F3F), Color(0xFF000814)]
                      : const [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
              ),
            ),
          ),

          // Top subtle desktop header
          Positioned(
            top: 16,
            left: 24,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.location_city_rounded, color: Color(0xFF38BDF8), size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Cityzen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      'Mobile Web Experience',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Centered Mobile Mockup Container
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 440,
                maxHeight: 920,
              ),
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
