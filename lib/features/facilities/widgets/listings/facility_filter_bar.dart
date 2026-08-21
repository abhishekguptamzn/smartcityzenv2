import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/providers/facility_explorer_providers.dart';

class FacilityFilterBar extends StatelessWidget {
  const FacilityFilterBar({
    super.key,
    required this.itemCount,
    required this.cityName,
    required this.selectedFilter,
    required this.onSelectFilter,
    required this.hasActiveGps,
  });

  final int itemCount;
  final String cityName;
  final FacilitySortFilter selectedFilter;
  final ValueChanged<FacilitySortFilter> onSelectFilter;
  final bool hasActiveGps;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F766E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasActiveGps ? Icons.gps_fixed_rounded : Icons.location_on_rounded,
                            size: 13,
                            color: const Color(0xFF0F766E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cityName,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$itemCount ${itemCount == 1 ? 'center' : 'centers'} found',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FacilitySortFilter.values.map((filter) {
                final isSelected = selectedFilter == filter;
                final icon = switch (filter) {
                  FacilitySortFilter.nearest => Icons.near_me_rounded,
                  FacilitySortFilter.openNow => Icons.access_time_filled_rounded,
                  FacilitySortFilter.topRated => Icons.star_rounded,
                  FacilitySortFilter.az => Icons.sort_by_alpha_rounded,
                };

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(
                      icon,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                    ),
                    label: Text(filter.label),
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0F766E),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF0F766E)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      onSelectFilter(filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
