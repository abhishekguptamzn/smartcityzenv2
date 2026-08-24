import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/utils/share_helper.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/city_skeletons.dart';

class CityHistoryScreen extends ConsumerStatefulWidget {
  const CityHistoryScreen({super.key, this.cityId});

  final String? cityId;

  @override
  ConsumerState<CityHistoryScreen> createState() => _CityHistoryScreenState();
}

class _CityHistoryScreenState extends ConsumerState<CityHistoryScreen> {
  String _selectedEra = 'Timeline';

  @override
  Widget build(BuildContext context) {
    final infoAsync = ref.watch(cityInformationProvider(cityId: widget.cityId));
    final scheme = Theme.of(context).colorScheme;

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
        title: const Text('History & Timeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final city = infoAsync.value?.city;
              AppShareHelper.shareContent(
                context: context,
                title: city != null ? '${city.name} History & Timeline' : 'City History & Timeline',
                path: widget.cityId != null ? '/city/history?city_id=${widget.cityId}' : '/city/history',
                subtitle: city?.state,
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: infoAsync.when(
          loading: () => const CityTimelineSkeleton(),
          error: (err, _) => EmptyStateView(
            icon: Icons.error_outline_rounded,
            message: 'Unable to load timeline: $err',
          ),
          data: (info) {
            final timeline = info.timeline;
            final eras = ['Timeline', 'Ancient', 'Medieval', 'Colonial', 'Modern'];

            final filteredList = timeline.where((item) {
              if (_selectedEra == 'Timeline') return true;
              return item.era.toLowerCase().contains(_selectedEra.toLowerCase()) ||
                  item.period.toLowerCase().contains(_selectedEra.toLowerCase());
            }).toList();

            return Column(
              children: [
                // Filter Pills Bar
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: eras.map((era) {
                      final isSelected = era == _selectedEra;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(era),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedEra = era),
                          selectedColor: scheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Vertical Interconnected Timeline List
                Expanded(
                  child: filteredList.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.history_edu_rounded,
                          message: 'No milestone events recorded for this era.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            final isFirst = index == 0;
                            final isLast = index == filteredList.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Timeline Node & Line Column
                                  SizedBox(
                                    width: 40,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 2,
                                          height: 16,
                                          color: isFirst ? Colors.transparent : scheme.primary.withValues(alpha: 0.4),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: scheme.surface,
                                            border: Border.all(color: scheme.primary, width: 3),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: scheme.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: isLast ? Colors.transparent : scheme.primary.withValues(alpha: 0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Timeline Card Content
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: GlassContainer(
                                        level: GlassLevel.card,
                                        borderRadius: BorderRadius.circular(20),
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.era,
                                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: scheme.primary,
                                                        ),
                                                  ),
                                                  if (item.period.isNotEmpty) ...[
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      item.period,
                                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                            color: scheme.onSurfaceVariant,
                                                          ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    item.description,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          height: 1.4,
                                                          color: scheme.onSurfaceVariant,
                                                        ),
                                                    maxLines: 4,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                                              const SizedBox(width: 12),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  item.imageUrl!,
                                                  width: 72,
                                                  height: 72,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
