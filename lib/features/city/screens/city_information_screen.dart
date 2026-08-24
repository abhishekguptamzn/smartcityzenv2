import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/city_skeletons.dart';

class CityInformationScreen extends ConsumerWidget {
  const CityInformationScreen({super.key, this.cityId});

  final String? cityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(cityInformationProvider(cityId: cityId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'City Hub & Heritage',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(cityInformationProvider(cityId: cityId)),
          ),
        ],
      ),
      body: AmbientBackground(
        child: infoAsync.when(
          loading: () => const CityInformationSkeleton(),
          error: (err, _) => EmptyStateView(
            icon: Icons.error_outline_rounded,
            message: 'Unable to load city hub: $err',
            action: FilledButton.tonal(
              onPressed: () => ref.invalidate(cityInformationProvider(cityId: cityId)),
              child: const Text('Try Again'),
            ),
          ),
          data: (info) => _CityHubBody(info: info, cityId: cityId),
        ),
      ),
    );
  }
}

class _CityHubBody extends StatelessWidget {
  const _CityHubBody({required this.info, this.cityId});

  final CityInformationModel info;
  final String? cityId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final city = info.city;
    final colors = context.appColors;
    final scheme = theme.colorScheme;

    final cityName = city?.name ?? 'Muzaffarnagar';
    final tagline = city?.tagline ?? info.nickname ?? 'A city with rich history, culture and heritage';
    final nickname = info.nickname ?? '$cityName Identity';
    final heroImage = info.heroImageUrl ??
        'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80';

    final navItems = <(IconData, String, String, String, Color, Color)>[
      (
        Icons.account_balance_rounded,
        'About the City',
        '/city/about',
        'Explore city roots & profile',
        const Color(0xFF2563EB),
        const Color(0xFF1D4ED8),
      ),
      (
        Icons.history_edu_rounded,
        'History & Timeline',
        '/city/timeline',
        'Chronological era milestones',
        const Color(0xFFD97706),
        const Color(0xFFB45309),
      ),
      (
        Icons.menu_book_rounded,
        'Origin & Name',
        '/city/origin',
        'Etymology & scriptures',
        const Color(0xFF7C3AED),
        const Color(0xFF6D28D9),
      ),
      (
        Icons.map_rounded,
        'Geography',
        '/city/geography',
        'Plains, rivers & elevation',
        const Color(0xFF059669),
        const Color(0xFF047857),
      ),
      (
        Icons.theater_comedy_rounded,
        'Culture & Traditions',
        '/city/culture',
        'Festivals & handicrafts',
        const Color(0xFFE11D48),
        const Color(0xFFBE123C),
      ),
      (
        Icons.fort_rounded,
        'Heritage & Architecture',
        '/city/heritage',
        'Ancient temples & shrines',
        const Color(0xFF0891B2),
        const Color(0xFF0E7490),
      ),
      (
        Icons.stars_rounded,
        'Famous For',
        '/city/famous',
        'Sugarcane & specialties',
        const Color(0xFFEA580C),
        const Color(0xFFC2410C),
      ),
      (
        Icons.people_alt_rounded,
        'Notable Personalities',
        '/city/personalities',
        'Leaders & sportspersons',
        const Color(0xFF4F46E5),
        const Color(0xFF3730A3),
      ),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final crossCount = width > 900 ? 4 : (width > 600 ? 3 : 2);
    final cardAspectRatio = width > 900 ? 1.5 : (width > 600 ? 1.4 : 1.3);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
      children: [
        // 1. Top Hero City Header Card
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.idCardGlow.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(heroImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white30, width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Verified City Profile',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cityName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Identity Sub-Card (Styled matching Services Explorer header box)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF0F172A),
                      const Color(0xFF1E293B),
                    ]
                  : [
                      const Color(0xFFF0FDF4),
                      const Color(0xFFECFDF5),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFA7F3D0),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                        color: isDark ? Colors.white : const Color(0xFF065F46),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore the identity, history and heritage of our city.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : const Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. Section Title with Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'City Chapters & Heritage',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${navItems.length} Chapters',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 4. Responsive Grid of 8 Navigation Options (Matching Services category card layout)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cardAspectRatio,
          ),
          itemCount: navItems.length,
          itemBuilder: (context, index) {
            final (icon, title, route, sub, color1, color2) = navItems[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(route);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? theme.cardColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? scheme.outlineVariant.withValues(alpha: 0.25)
                          : const Color(0xFFE5E7EB),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.25)
                            : const Color(0x08000000),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color1, color2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: color1.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(icon, color: Colors.white, size: 22),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: isDark ? Colors.white38 : Colors.grey.shade400,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF111827),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sub,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
