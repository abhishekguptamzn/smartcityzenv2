import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/cities_providers.dart';

import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityHeritageScreen extends ConsumerWidget {
  const CityHeritageScreen({super.key, this.cityId});

  final String? cityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(cityInformationProvider(cityId: cityId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heritage & Architecture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing heritage monuments...')),
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
            message: 'Unable to load heritage: $err',
          ),
          data: (info) => _HeritageBody(info: info),
        ),
      ),
    );
  }
}

class _HeritageBody extends StatelessWidget {
  const _HeritageBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final monuments = info.heritageAndArchitecture;
    final scheme = Theme.of(context).colorScheme;

    final defaultMonuments = [
      HeritageItemModel(
        name: 'Shukratal',
        architecturalStyle: 'Ancient Pilgrimage Site',
        constructionYear: 'Vedic Era',
        unescoHeritage: false,
        description: 'An ancient lake with mythological importance where Sage Suka recited Bhagavat Purana.',
        imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=600&q=80',
      ),
      HeritageItemModel(
        name: 'Baba Kali Kambal Wale Dargah',
        architecturalStyle: 'Spiritual Sufi Shrine',
        constructionYear: '19th Century',
        unescoHeritage: false,
        description: 'A revered spiritual place visited by pilgrims across all faiths.',
        imageUrl: 'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=600&q=80',
      ),
      HeritageItemModel(
        name: 'Ancient Temples',
        architecturalStyle: 'Nagara Temple Architecture',
        constructionYear: 'Classical Era',
        unescoHeritage: false,
        description: 'Temples with historical significance across the district.',
        imageUrl: 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=600&q=80',
      ),
    ];

    final displayMonuments = monuments.isNotEmpty ? monuments : defaultMonuments;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Architectural Hero Photo
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1200&q=80',
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
            'The city is home to historical buildings, mosques, temples and ancient architectural wonders.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 16),

        // Monument Cards List
        ...displayMonuments.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      m.imageUrl ??
                          'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=300&q=80',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 80,
                        height: 80,
                        color: scheme.surfaceContainerHighest,
                        child: const Icon(Icons.account_balance_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (m.unescoHeritage)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'UNESCO',
                                  style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // View All Places Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viewing all heritage monuments...')),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('View All Places'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
