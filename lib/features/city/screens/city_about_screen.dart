import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityAboutScreen extends ConsumerWidget {
  const CityAboutScreen({super.key, this.cityId});

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
        title: const Text('About the City'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing city details...')),
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
            message: 'Unable to load city details: $err',
          ),
          data: (info) => _AboutCityBody(info: info),
        ),
      ),
    );
  }
}

class _AboutCityBody extends StatefulWidget {
  const _AboutCityBody({required this.info});

  final CityInformationModel info;

  @override
  State<_AboutCityBody> createState() => _AboutCityBodyState();
}

class _AboutCityBodyState extends State<_AboutCityBody> {
  int _activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final city = info.city;
    final scheme = Theme.of(context).colorScheme;
    final cityName = city?.name ?? 'City';
    final stateName = city?.state ?? 'India';

    final images = <String>[
      if (info.heroImageUrl != null && info.heroImageUrl!.isNotEmpty) info.heroImageUrl!,
      'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=1200&q=80',
    ];

    final details = [
      (Icons.map_rounded, 'State', stateName),
      (Icons.location_city_rounded, 'District', cityName),
      (Icons.calendar_today_rounded, 'Established', info.foundedYear ?? '1825'),
      (Icons.square_foot_rounded, 'Area', info.geography?.area ?? '2,548 sq. km.'),
      (Icons.people_alt_rounded, 'Population', '4,501,000+'),
      (Icons.translate_rounded, 'Languages', info.originAndName?.linguisticRoot ?? 'Hindi, Urdu'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Image Carousel Box
        Stack(
          children: [
            Container(
              height: 220,
              decoration: BorderRadius.circular(24).toBoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) => setState(() => _activeImageIndex = index),
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: scheme.surfaceContainerHighest,
                        child: const Icon(Icons.image_not_supported_rounded, size: 48),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < images.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _activeImageIndex ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _activeImageIndex ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // About Heading and Story Card
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About $cityName',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                info.about ??
                    '$cityName is a historic city in the state of $stateName, known for its rich cultural heritage, agricultural prosperity and traditional craftsmanship.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Key Attributes List Grid
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (var i = 0; i < details.length; i++) ...[
                if (i > 0) const Divider(height: 20, indent: 48),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(details[i].$1, color: scheme.primary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        details[i].$2,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    Text(
                      details[i].$3,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
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

extension _RadiusToBoxDecoration on BorderRadius {
  BoxDecoration toBoxDecoration() => BoxDecoration(borderRadius: this);
}
