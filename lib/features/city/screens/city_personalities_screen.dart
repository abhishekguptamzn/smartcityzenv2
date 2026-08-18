import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../data/models/city_information_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CityPersonalitiesScreen extends ConsumerWidget {
  const CityPersonalitiesScreen({super.key, this.cityId});

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
        title: const Text('Notable Personalities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing notable figures...')),
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
            message: 'Unable to load personalities: $err',
          ),
          data: (info) => _PersonalitiesBody(info: info),
        ),
      ),
    );
  }
}

class _PersonalitiesBody extends StatelessWidget {
  const _PersonalitiesBody({required this.info});

  final CityInformationModel info;

  @override
  Widget build(BuildContext context) {
    final figures = info.notablePersonalities;
    final scheme = Theme.of(context).colorScheme;

    final defaultFigures = [
      PersonalityItemModel(
        name: 'Dr. Sanjeev Balyan',
        era: 'Modern Era',
        title: 'Politician and former Union Minister of State',
        contribution: 'Represented constituency in Parliament and held ministerial portfolios.',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      ),
      PersonalityItemModel(
        name: 'Vijay Kumar',
        era: 'Modern Era',
        title: 'Indian cricketer who played for India',
        contribution: 'Represented national cricket team in international fixtures.',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      ),
      PersonalityItemModel(
        name: 'Mahavir Singh Phogat',
        era: 'Modern Era',
        title: 'Dronacharya Awardee wrestling coach',
        contribution: 'Coached world champions and Commonwealth Games medalists.',
        photoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
      ),
      PersonalityItemModel(
        name: 'Nirupama Dutt',
        era: 'Modern Era',
        title: 'Indian author known for her notable work',
        contribution: 'Acclaimed biographer, journalist and literary figure.',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      ),
    ];

    final displayList = figures.isNotEmpty ? figures : defaultFigures;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        ...displayList.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    backgroundImage: p.photoUrl != null && p.photoUrl!.isNotEmpty
                        ? NetworkImage(p.photoUrl!)
                        : null,
                    child: p.photoUrl == null || p.photoUrl!.isEmpty
                        ? Text(
                            p.name.isNotEmpty ? p.name[0] : '?',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: scheme.primary,
                                ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.title,
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
          );
        }),

        const SizedBox(height: 12),

        // View All Personalities Action Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viewing all historical figures...')),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('View All Personalities'),
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
