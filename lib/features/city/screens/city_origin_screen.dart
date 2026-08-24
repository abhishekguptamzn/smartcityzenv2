import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/utils/share_helper.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/city_skeletons.dart';

class CityOriginScreen extends ConsumerWidget {
  const CityOriginScreen({super.key, this.cityId});

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
        title: const Text('Origin & Name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final city = infoAsync.value?.city;
              AppShareHelper.shareContent(
                context: context,
                title: city != null ? '${city.name} Origin & Name' : 'City Origin & Name',
                path: cityId != null ? '/city/origin?city_id=$cityId' : '/city/origin',
                subtitle: city?.state,
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: infoAsync.when(
          loading: () => const CityOriginSkeleton(),
          error: (err, _) => EmptyStateView(
            icon: Icons.error_outline_rounded,
            message: 'Unable to load origin information: $err',
          ),
          data: (info) => _OriginBody(info: info),
        ),
      ),
    );
  }
}

class _OriginBody extends StatelessWidget {
  const _OriginBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final origin = info.originAndName;
    final city = info.city;
    final scheme = Theme.of(context).colorScheme;
    final cityName = city?.name ?? 'Muzaffarnagar';

    final names = origin?.historicalNames.isNotEmpty == true
        ? origin!.historicalNames
        : [info.ancientName ?? 'Sarwat', cityName, '$cityName Nagar'];

    final etymologyText = origin?.etymology ??
        'The city is named after "Muzaffar Khan", a loyal chief in the service of Emperor Shah Jahan. He was granted the title Muzaffar Khan and the area was later known as Muzaffarnagar.';

    final meaningText = origin?.meaning ?? 'The city of $cityName';

    final didYouKnow = origin?.didYouKnow ??
        '$cityName was an important stop on the Delhi-Haridwar road during the Mughal period.';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Archival Signboard / Heritage Photo Box
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Etymology & History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                etymologyText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Historical Names Card
        GlassContainer(
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
                child: Icon(Icons.history_edu_rounded, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historical Names',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: names.map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Meaning Card
        GlassContainer(
          level: GlassLevel.card,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.search_rounded, color: scheme.secondary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meaning',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meaningText,
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
        const SizedBox(height: 16),

        // Did You Know Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: scheme.tertiaryContainer.withValues(alpha: 0.2),
            border: Border.all(color: scheme.tertiary.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_rounded, color: scheme.tertiary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Did You Know?',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.tertiary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      didYouKnow,
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
      ],
    );
  }
}
