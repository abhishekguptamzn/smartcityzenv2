import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/models/user_model.dart';
import '../widgets/citizen_qr_modal.dart';
import '../widgets/home_skeleton.dart';

class IdCardScreen extends ConsumerWidget {
  const IdCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: userAsync.when(
          loading: () => const IdCardSkeleton(),
          error: (_, _) => const Center(
            child: Text(
              'Unable to load Citizen Identity. Please check your connection.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          data: (user) {
            if (user == null) {
              return const Center(
                child: Text('Please log in to view your Citizen ID.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  // 1. Header matching screenshot
                  _IdentityHeader(
                    onMenuTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    onNotificationTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Your Citizen ID is active and verified.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 2. Main Hero ID Card (Flippable)
                  _FlippableIdentityCard(user: user),
                  const SizedBox(height: 24),

                  // 3. Four Feature Badges (Secure, Verified, Smart Access, Go Digital)
                  const _FeatureBadgesBar(),
                  const SizedBox(height: 24),

                  // 4. Quick Actions (Show QR, Copy ID, Share Pass)
                  _QuickActionsRow(user: user),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({
    required this.onMenuTap,
    required this.onNotificationTap,
  });

  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left menu button
            _HeaderCircleButton(
              icon: Icons.menu_rounded,
              onTap: onMenuTap,
            ),

            // Center Title with blue shield check badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Color(0xFF1E3A8A), // Deep Royal Blue
                    ),
                    children: [
                      TextSpan(text: 'Cityzen '),
                      TextSpan(
                        text: 'Identity',
                        style: TextStyle(
                          color: Color(0xFF0F172A), // Slate 900
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF0284C7),
                    size: 19,
                  ),
                ),
              ],
            ),

            // Right Notification Bell with green unread dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                _HeaderCircleButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: onNotificationTap,
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Your Digital ID. Your City. Your Pride.',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Center(
            child: Icon(icon, color: const Color(0xFF1E293B), size: 22),
          ),
        ),
      ),
    );
  }
}

class _FlippableIdentityCard extends StatefulWidget {
  const _FlippableIdentityCard({required this.user});

  final UserModel user;

  @override
  State<_FlippableIdentityCard> createState() => _FlippableIdentityCardState();
}

class _FlippableIdentityCardState extends State<_FlippableIdentityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  bool _showFront = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _showFront = !_showFront);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _flip,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = _controller.value * pi;
              final isBackVisible = angle > pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(angle),
                child: isBackVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _CardBackDesign(user: widget.user),
                      )
                    : _CardFrontDesign(user: widget.user),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // Flip button indicator
        GestureDetector(
          onTap: _flip,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.smartphone_rounded,
                  size: 16,
                  color: Color(0xFF10B981),
                ),
                SizedBox(width: 6),
                Text(
                  'Tap card to flip',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CardFrontDesign extends StatelessWidget {
  const _CardFrontDesign({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final cityName = user.city?.name ?? 'Select City';
    final initial = user.name.trim().isNotEmpty
        ? user.name.trim()[0].toUpperCase()
        : 'C';
    final citizenId = user.displayCitizenId.isNotEmpty
        ? user.displayCitizenId
        : 'CID-${user.id.toUpperCase()}';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420, minHeight: 250),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF082236), // Deep Dark Navy Blue
            Color(0xFF0A3C52), // Teal Navy Transition
            Color(0xFF065F53), // Deep Emerald
            Color(0xFF059669), // Emerald 600
            Color(0xFF10B981), // Vibrant Mint/Emerald
          ],
          stops: [0.0, 0.35, 0.65, 0.85, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x350A3C52),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background City Skyline Silhouette
          Positioned(
            right: -10,
            bottom: 25,
            child: Opacity(
              opacity: 0.13,
              child: Image.network(
                'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=600&q=80',
                width: 280,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.location_city_rounded,
                  size: 160,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Geometric card background glows
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1810B981),
              ),
            ),
          ),

          // Main Card Foreground Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Hexagon Logo + "CITYZEN IDENTITY / Official Citizen ID" & Wave NFC Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Hexagon Icon Badge
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF34D399),
                              width: 2.2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.hexagon_outlined,
                              size: 16,
                              color: Color(0xFF34D399),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CITYZEN IDENTITY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Official Citizen ID',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Contactless / NFC Wave Icon
                    const Icon(
                      Icons.contactless_rounded,
                      color: Color(0xFFD1FAE5),
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Middle Section: Glowing Avatar + Name & Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar with glowing teal ring & bold blue letter
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2DD4BF), // Glowing Cyan/Teal
                          width: 3.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x332DD4BF),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: (user.effectiveAvatarUrl != null && user.effectiveAvatarUrl!.isNotEmpty)
                            ? Image.network(
                                user.effectiveAvatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E40AF),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CUSTOMER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  cityName,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bottom Row: Cityzen ID + Active Pill + QR Code White Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left ID Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CITYZEN ID',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          citizenId,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF34D399), // Bright Neon Mint/Cyan
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),

                    // Right Group: ACTIVE Pill + White QR Container
                    Row(
                      children: [
                        // Active Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF042F2E).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFF059669).withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFF34D399),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFE6FFFA),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // White QR Code Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => showCitizenQrModal(context, user),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 46,
                              height: 46,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x25000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.qr_code_2_rounded,
                                color: Color(0xFF0F172A),
                                size: 34,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBackDesign extends StatelessWidget {
  const _CardBackDesign({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final citizenId = user.displayCitizenId.isNotEmpty
        ? user.displayCitizenId
        : 'CID-${user.id.toUpperCase()}';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420, minHeight: 250),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    color: Color(0xFF0D9488),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SECURITY VERIFICATION PASS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'GOV VERIFIED',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _BackInfoRow(label: 'Full Name', value: user.name),
          const SizedBox(height: 8),
          _BackInfoRow(label: 'Registered Email', value: user.email),
          const SizedBox(height: 8),
          _BackInfoRow(label: 'Citizen ID', value: citizenId),
          const SizedBox(height: 8),
          _BackInfoRow(
            label: 'Issue Date',
            value: user.createdAt != null
                ? DateFormat('dd MMM yyyy').format(user.createdAt!)
                : '14 Aug 2026',
          ),
          const SizedBox(height: 8),
          _BackInfoRow(label: 'Validity', value: 'Lifetime / Active'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEEF2F6)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Protected by Municipal Digital Governance Cryptographic Signature.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackInfoRow extends StatelessWidget {
  const _BackInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FeatureBadgesBar extends StatelessWidget {
  const _FeatureBadgesBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEF2F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        children: [
          // 1. Secure / Encrypted Data
          Expanded(
            child: _BadgeItem(
              icon: Icons.verified_user_outlined,
              iconColor: Color(0xFF16A34A), // Green
              badgeBg: Color(0xFFDCFCE7),
              title: 'Secure',
              subtitle: 'Encrypted Data',
            ),
          ),
          _BadgeDivider(),

          // 2. Verified / Trusted Identity
          Expanded(
            child: _BadgeItem(
              icon: Icons.fingerprint_rounded,
              iconColor: Color(0xFF2563EB), // Blue
              badgeBg: Color(0xFFDBEAFE),
              title: 'Verified',
              subtitle: 'Trusted Identity',
            ),
          ),
          _BadgeDivider(),

          // 3. Smart Access / One ID, Many Services
          Expanded(
            child: _BadgeItem(
              icon: Icons.auto_awesome_rounded,
              iconColor: Color(0xFF9333EA), // Purple
              badgeBg: Color(0xFFF3E8FF),
              title: 'Smart Access',
              subtitle: 'One ID, Many Services',
            ),
          ),
          _BadgeDivider(),

          // 4. Go Digital / Paperless Future
          Expanded(
            child: _BadgeItem(
              icon: Icons.eco_outlined,
              iconColor: Color(0xFF10B981), // Emerald
              badgeBg: Color(0xFFD1FAE5),
              title: 'Go Digital',
              subtitle: 'Paperless Future',
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeDivider extends StatelessWidget {
  const _BadgeDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      color: const Color(0xFFF1F5F9),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({
    required this.icon,
    required this.iconColor,
    required this.badgeBg,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color badgeBg;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: badgeBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 8.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final citizenId = user.displayCitizenId.isNotEmpty
        ? user.displayCitizenId
        : 'CID-${user.id.toUpperCase()}';

    return Row(
      children: [
        // Scan QR Button
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0D473B),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => context.push('/checkin'),
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
            label: const Text(
              'Scan QR Code',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Copy ID Button
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Clipboard.setData(ClipboardData(text: citizenId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied $citizenId to clipboard!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.copy_rounded,
                    size: 17,
                    color: Color(0xFF0F766E),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Copy ID',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
