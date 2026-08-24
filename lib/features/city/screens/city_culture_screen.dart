import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/utils/share_helper.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/city_skeletons.dart';

class CityCultureScreen extends ConsumerWidget {
  const CityCultureScreen({super.key, this.cityId});

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
        title: const Text('Culture & Traditions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final city = infoAsync.value?.city;
              AppShareHelper.shareContent(
                context: context,
                title: city != null ? '${city.name} Culture & Traditions' : 'Culture & Traditions',
                path: cityId != null ? '/city/culture?city_id=$cityId' : '/city/culture',
                subtitle: city?.state,
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: infoAsync.when(
          loading: () => const CityGallerySkeleton(),
          error: (err, _) => EmptyStateView(
            icon: Icons.error_outline_rounded,
            message: 'Unable to load culture details: $err',
          ),
          data: (info) => _CultureBody(info: info),
        ),
      ),
    );
  }
}

class _CultureBody extends StatelessWidget {
  const _CultureBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final cultureList = info.cultureAndTraditions;
    final city = info.city;
    final scheme = Theme.of(context).colorScheme;
    final cityName = city?.name ?? 'Select City';

    final defaultCulture = [
      (
        Icons.festival_rounded,
        'Festivals',
        'National and regional festivals celebrated with unity and fervor',
      ),
      (
        Icons.theater_comedy_rounded,
        'Traditions',
        'Local art forms, folk music, dance and civic celebrations',
      ),
      (
        Icons.brush_rounded,
        'Handicrafts & Arts',
        'Traditional craftsmanship, textiles and regional artwork',
      ),
      (
        Icons.restaurant_rounded,
        'Cuisine & Flavors',
        'Authentic regional delicacies, specialties and traditional sweets',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Hero Folk Dance / Cultural Image
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1608848461950-0fe51dfc41cb?auto=format&fit=crop&w=1200&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Story Card
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(20),
          child: Text(
            '$cityName is a blend of Indian traditions, festivals and cultural values that reflect unity and diversity.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 16),

        // Culture Items
        if (cultureList.isNotEmpty)
          ...cultureList.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                level: GlassLevel.card,
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.celebration_rounded, color: scheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  height: 1.4,
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        else
          ...defaultCulture.map((tile) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                level: GlassLevel.card,
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(tile.$1, color: scheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tile.$2,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tile.$3,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  height: 1.4,
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
