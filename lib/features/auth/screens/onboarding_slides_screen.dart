import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/glass_container.dart';

class OnboardingSlidesScreen extends StatefulWidget {
  const OnboardingSlidesScreen({super.key});

  @override
  State<OnboardingSlidesScreen> createState() => _OnboardingSlidesScreenState();
}

class _OnboardingSlidesScreenState extends State<OnboardingSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlideData> _slides = const [
    _OnboardingSlideData(
      badge: '🏛️ CITY SERVICES & HUBS',
      title: 'Discover Verified\nMunicipal Facilities',
      subtitle:
          'Explore top-rated public libraries, modern fitness centers, sports academies, and civic amenities across your city with live operating hours.',
      icon: Icons.location_city_rounded,
      accentColor: Color(0xFF0D9488),
      secondaryColor: Color(0xFF14B8A6),
      featurePills: ['Public Libraries', 'Gyms & Wellness', 'Sports & Academies'],
    ),
    _OnboardingSlideData(
      badge: '⚡ INSTANT QR ACCESS',
      title: 'Smart Digital Passes\n& Contactless Check-In',
      subtitle:
          'Scan QR codes at any city facility desk for instant check-in. Track your daily attendance, workout duration, and study sessions in real-time.',
      icon: Icons.qr_code_scanner_rounded,
      accentColor: Color(0xFF2563EB),
      secondaryColor: Color(0xFF38BDF8),
      featurePills: ['Instant Check-In', 'Session Tracker', 'Live Attendance'],
    ),
    _OnboardingSlideData(
      badge: '💳 SECURE & TRANSPARENT',
      title: 'Transparent Invoices\n& Citizen Passes',
      subtitle:
          'Renew memberships with flexible plans, manage municipal payments with digital invoices, and access your verified citizen ID card anytime.',
      icon: Icons.verified_user_rounded,
      accentColor: Color(0xFF7C3AED),
      secondaryColor: Color(0xFFA78BFA),
      featurePills: ['Digital Receipts', 'Verified Pass', 'Instant Renewals'],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    HapticFeedback.lightImpact();
    context.go('/login');
  }

  void _onNext() {
    HapticFeedback.selectionClick();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentSlide = _slides[_currentPage];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 1. TOP BAR with Logo & SKIP BUTTON (Always visible on all 3 slides)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo_mark.png',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Smart Cityzen',
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _onSkip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. PAGE VIEW CAROUSEL (3 SLIDES)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hero Illustration Graphic with Glowing Ambient Card
                          Container(
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  slide.accentColor.withValues(alpha: isDark ? 0.22 : 0.12),
                                  slide.secondaryColor.withValues(alpha: isDark ? 0.08 : 0.04),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: slide.accentColor.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: slide.accentColor.withValues(alpha: 0.15),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: slide.accentColor.withValues(alpha: 0.12),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: slide.accentColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: slide.accentColor.withValues(alpha: 0.4),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        slide.icon,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Wrap(
                                      spacing: 8,
                                      children: slide.featurePills
                                          .map(
                                            (pill) => Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.black.withValues(alpha: 0.3)
                                                    : Colors.white.withValues(alpha: 0.8),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: slide.accentColor.withValues(alpha: 0.2),
                                                ),
                                              ),
                                              child: Text(
                                                pill,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Category Badge Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: slide.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              slide.badge,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: slide.accentColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Title
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sora(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              letterSpacing: -0.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            slide.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 3. BOTTOM CONTROLS (Dots Indicator & Continue Button)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dot Indicators
                    Row(
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? currentSlide.accentColor
                                : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Continue / Process Button
                    ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentSlide.accentColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: currentSlide.accentColor.withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            _currentPage == _slides.length - 1
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.secondaryColor,
    required this.featurePills,
  });

  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color secondaryColor;
  final List<String> featurePills;
}
