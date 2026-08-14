import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';

class CityNewsScreen extends ConsumerWidget {
  const CityNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cityName = ref.watch(authControllerProvider).value?.city?.name;

    final items = _sampleNews(l10n, cityName ?? l10n.myCity);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cityNews)),
      body: AmbientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _PlaceholderBanner(text: l10n.placeholderContentNotice),
            const SizedBox(height: 16),
            for (final item in items) ...[
              _NewsCard(item: item),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlaceholderBanner extends StatelessWidget {
  const _PlaceholderBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: scheme.tertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem {
  const _NewsItem({
    required this.icon,
    required this.category,
    required this.title,
    required this.summary,
    required this.daysAgo,
    required this.accent,
  });

  final IconData icon;
  final String category;
  final String title;
  final String summary;
  final int daysAgo;
  final Color Function(ColorScheme) accent;
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = item.accent(scheme);

    return GlassContainer(
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
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.category.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.daysAgo == 0 ? 'Today' : '${item.daysAgo}d ago',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  item.summary,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<_NewsItem> _sampleNews(AppLocalizations l10n, String cityName) {
  return [
    _NewsItem(
      icon: Icons.local_library_rounded,
      category: 'Libraries',
      title: '$cityName Central Library extends weekend hours',
      summary:
          'Starting this month, all branch libraries will stay open until '
          '8 PM on Saturdays to support student exam season.',
      daysAgo: 1,
      accent: (s) => s.primary,
    ),
    _NewsItem(
      icon: Icons.fitness_center_rounded,
      category: 'Fitness',
      title: 'New community gym equipment installed citywide',
      summary:
          'Ten public gyms received upgraded strength-training equipment '
          'as part of the civic wellness initiative.',
      daysAgo: 3,
      accent: (s) => s.secondary,
    ),
    _NewsItem(
      icon: Icons.wifi_rounded,
      category: 'Infrastructure',
      title: 'Free public WiFi rolled out to city facilities',
      summary:
          'High-speed connectivity is now available at all participating '
          'libraries and recreation centers.',
      daysAgo: 6,
      accent: (s) => s.tertiary,
    ),
    _NewsItem(
      icon: Icons.event_rounded,
      category: 'Events',
      title: 'Annual civic services fair announced',
      summary:
          'Meet facility staff, explore membership plans, and enjoy live '
          'demonstrations at the upcoming community fair.',
      daysAgo: 9,
      accent: (s) => s.primary,
    ),
  ];
}
