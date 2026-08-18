import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityGeographyScreen extends ConsumerWidget {
  const CityGeographyScreen({super.key, this.cityId});

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
        title: const Text('Geography'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening geographical map view...')),
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
            message: 'Unable to load geography information: $err',
          ),
          data: (info) => _GeographyBody(info: info),
        ),
      ),
    );
  }
}

class _GeographyBody extends StatelessWidget {
  const _GeographyBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final geo = info.geography;
    final city = info.city;
    final scheme = Theme.of(context).colorScheme;
    final stateName = city?.state ?? 'Uttar Pradesh, India';

    final location = geo?.location ?? 'Western $stateName';
    final area = geo?.area ?? '2,548 sq. km';
    final elevation = geo?.elevation ?? '237 meters above sea level';
    final rivers = geo?.rivers.isNotEmpty == true ? geo!.rivers.join(', ') : 'Hindon, Kali, Krishni';
    final climate = geo?.climate ?? 'Subtropical (Hot summers, Mild winters)';
    final nearby = geo?.nearbyDistricts.isNotEmpty == true
        ? geo!.nearbyDistricts.join(', ')
        : 'Meerut, Saharanpur, Shamli, Baghpat';

    final tiles = [
      (Icons.location_on_rounded, 'Location', location),
      (Icons.crop_free_rounded, 'Area', area),
      (Icons.landscape_rounded, 'Elevation', elevation),
      (Icons.water_rounded, 'Rivers', rivers),
      (Icons.wb_sunny_rounded, 'Climate', climate),
      (Icons.compass_calibration_rounded, 'Nearby Districts', nearby),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Map Container Mockup
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: scheme.surfaceContainerHighest,
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 48),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // List of Cards
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const Divider(height: 24, indent: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(tiles[i].$1, color: scheme.primary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tiles[i].$2,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tiles[i].$3,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
