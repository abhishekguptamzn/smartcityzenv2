import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityFamousScreen extends ConsumerWidget {
  const CityFamousScreen({super.key, this.cityId});

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
        title: const Text('Famous For'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing city claims to fame...')),
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
            message: 'Unable to load famous attributes: $err',
          ),
          data: (info) => _FamousBody(info: info),
        ),
      ),
    );
  }
}

class _FamousBody extends StatelessWidget {
  const _FamousBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final famousList = info.famousFor;
    final city = info.city;
    final scheme = Theme.of(context).colorScheme;
    final cityName = city?.name ?? 'Muzaffarnagar';

    final defaultFamous = [
      FamousItemModel(
        title: 'Sugarcane Production',
        category: 'Agriculture & Industry',
        description: 'One of the leading sugarcane producing regions in India.',
      ),
      FamousItemModel(
        title: 'Gajak & Rewari',
        category: 'Cuisine Specialty',
        description: 'Famous traditional sweets loved nationwide.',
      ),
      FamousItemModel(
        title: 'Wood Carving',
        category: 'Heritage Craft',
        description: 'High quality wooden handicrafts and furniture.',
      ),
      FamousItemModel(
        title: 'Agriculture',
        category: 'Economy',
        description: 'Prosperous agriculture and allied industries.',
      ),
    ];

    final displayList = famousList.isNotEmpty ? famousList : defaultFamous;

    final icons = [
      Icons.agriculture_rounded,
      Icons.cookie_rounded,
      Icons.carpenter_rounded,
      Icons.eco_rounded,
      Icons.stars_rounded,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Hero Agricultural Photo
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Overview Narrative
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(20),
          child: Text(
            '$cityName is famous across India for its unique products, industries and contributions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 16),

        // Hallmark Cards
        ...displayList.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final icon = icons[idx % icons.length];

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
                    child: Icon(icon, color: scheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
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
        }),
      ],
    );
  }
}
