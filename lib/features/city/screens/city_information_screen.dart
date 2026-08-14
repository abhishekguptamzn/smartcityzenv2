import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityInformationScreen extends ConsumerWidget {
  const CityInformationScreen({super.key, this.cityId});

  final String? cityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(cityInformationProvider(cityId: cityId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Smart Cityzen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening City Menu...')),
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: infoAsync.when(
          loading: () => const LoadingIndicator(),
          error: (err, _) => EmptyStateView(
            icon: Icons.error_outline_rounded,
            message: 'Unable to load city hub: $err',
          ),
          data: (info) => _CityHubBody(info: info),
        ),
      ),
    );
  }
}

class _CityHubBody extends StatelessWidget {
  const _CityHubBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final city = info.city;
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    final cityName = city?.name ?? 'Muzaffarnagar';
    final tagline = city?.tagline ?? info.nickname ?? 'A city with rich history, culture and heritage';
    final nickname = info.nickname ?? '$cityName Identity';
    final heroImage = info.heroImageUrl ??
        'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80';

    final navItems = <(IconData, String, String, String)>[
      (
        Icons.account_balance_rounded,
        'About the City',
        '/city/about',
        'Explore city roots & geography',
      ),
      (
        Icons.history_edu_rounded,
        'History & Timeline',
        '/city/timeline',
        'Chronological era milestones',
      ),
      (
        Icons.menu_book_rounded,
        'Origin & Name',
        '/city/origin',
        'Etymology & scriptures',
      ),
      (
        Icons.map_rounded,
        'Geography',
        '/city/geography',
        'Plains, rivers & elevation',
      ),
      (
        Icons.theater_comedy_rounded,
        'Culture & Traditions',
        '/city/culture',
        'Festivals & handicrafts',
      ),
      (
        Icons.fort_rounded,
        'Heritage & Architecture',
        '/city/heritage',
        'Ancient temples & shrines',
      ),
      (
        Icons.stars_rounded,
        'Famous For',
        '/city/famous',
        'Sugarcane & specialties',
      ),
      (
        Icons.people_alt_rounded,
        'Notable Personalities',
        '/city/personalities',
        'Leaders & sportspersons',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Top Hero City Header Card
        Container(
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colors.idCardGlow.withValues(alpha: 0.3),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(heroImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  cityName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  tagline,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Identity Sub-Card
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: scheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore the identity, history and heritage of our city.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2-Column Grid of 8 Navigation Options
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: navItems.length,
          itemBuilder: (context, index) {
            final (icon, title, route, sub) = navItems[index];

            return GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(14),
              onTap: () => context.push(route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: scheme.primary, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
