import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/cities_providers.dart';
import '../../../core/providers/facility_explorer_providers.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../models/facility_hierarchy_models.dart';
import 'facility_category_centers_screen.dart';

class ServicesExplorerScreen extends ConsumerStatefulWidget {
  const ServicesExplorerScreen({
    super.key,
    this.initialSearch,
    this.initialKind,
  });

  final String? initialSearch;
  final String? initialKind;

  @override
  ConsumerState<ServicesExplorerScreen> createState() => _ServicesExplorerScreenState();
}

class _ServicesExplorerScreenState extends ConsumerState<ServicesExplorerScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategory({
    required BuildContext context,
    required List<FacilityCategoryItem> allCategories,
    required String categorySlug,
    String? typeSlug,
    String? initialSearch,
  }) {
    // Locate the matching category item or build a fallback
    final matchedCat = allCategories.firstWhere(
      (c) => c.slug == categorySlug || c.id == categorySlug,
      orElse: () => FacilityCategoryItem(
        id: categorySlug,
        name: categorySlug.replaceAll('-', ' ').toUpperCase(),
        slug: categorySlug,
        icon: Icons.category_rounded,
        gradientColors: [const Color(0xFF0D9488), const Color(0xFF0284C7)],
        description: 'Municipal Services',
      ),
    );

    FacilityTypeItem? matchedType;
    if (typeSlug != null) {
      matchedType = matchedCat.types.firstWhere(
        (t) => t.slug == typeSlug || t.id == typeSlug,
        orElse: () => FacilityTypeItem(
          id: typeSlug,
          categoryId: matchedCat.id,
          name: typeSlug.replaceAll('-', ' '),
          slug: typeSlug,
          icon: Icons.circle,
        ),
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FacilityCategoryCentersScreen(
          category: matchedCat,
          initialType: matchedType,
          initialSearch: initialSearch,
        ),
      ),
    );
  }

  void _showCitySelectorSheet(BuildContext context, String currentCity) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select City',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Browse civic centers and amenities by city',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final citiesAsync = ref.watch(citiesListProvider);
                  return citiesAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: LoadingIndicator(),
                      ),
                    ),
                    error: (error, stackTrace) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Current city: $currentCity',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    data: (cities) {
                      if (cities.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'Current city: $currentCity',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cities.length,
                        separatorBuilder: (ctx, idx) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final c = cities[i];
                          final isSelected = c.name.toLowerCase() == currentCity.toLowerCase();
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0D9488).withValues(alpha: 0.15)
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_city_rounded,
                                size: 18,
                                color: isSelected ? const Color(0xFF0D9488) : Colors.grey,
                              ),
                            ),
                            title: Text(
                              c.name,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF0D9488) : null,
                              ),
                            ),
                            subtitle: c.state.isNotEmpty
                                ? Text(c.state, style: const TextStyle(fontSize: 12))
                                : null,
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0D9488))
                                : null,
                            onTap: () => Navigator.of(ctx).pop(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final cityName = user?.city?.name ?? 'Muzaffarnagar';
    final firstName = user?.name.split(' ').first ?? 'Citizen';

    final categoriesAsync = ref.watch(unifiedFacilityCategoriesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: categoriesAsync.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, _) => ErrorStateView(
            error: error,
            onRetry: () => ref.invalidate(unifiedFacilityCategoriesProvider),
          ),
          data: (allCategories) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HEADER: Greeting, City Dropdown, Notification Bell
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $firstName 👋',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          GestureDetector(
                            onTap: () => _showCitySelectorSheet(context, cityName),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 15,
                                  color: Color(0xFF475569),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  cityName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Notification Bell with Green Badge Dot
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                              onPressed: () => context.push('/support'),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 9,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2. SEARCH BAR with Cross-Category Query Support
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 22,
                          color: Color(0xFF0D9488),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search all facilities & activities in $cityName...',
                              hintStyle: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (query) {
                              if (query.trim().isNotEmpty && allCategories.isNotEmpty) {
                                _openCategory(
                                  context: context,
                                  allCategories: allCategories,
                                  categorySlug: allCategories.first.slug,
                                  initialSearch: query.trim(),
                                );
                              }
                            },
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                        Container(
                          height: 24,
                          width: 1,
                          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                          onPressed: () {
                            if (allCategories.isNotEmpty) {
                              _openCategory(
                                context: context,
                                allCategories: allCategories,
                                categorySlug: allCategories.first.slug,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. DYNAMIC FACILITY & ACTIVITY CATEGORIES
                  ...allCategories.map((category) {
                    final types = category.types;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(category.name, isDark),
                          const SizedBox(height: 12),
                          if (types.isNotEmpty)
                            Wrap(
                              spacing: 10,
                              runSpacing: 12,
                              children: types.map((type) {
                                final cardWidth = (MediaQuery.of(context).size.width - 36 - 30) / 4;
                                return SizedBox(
                                  width: cardWidth.clamp(74.0, 95.0),
                                  child: _buildSquircleServiceCard(
                                    icon: type.icon,
                                    iconColor: type.color ?? category.primaryColor,
                                    title: type.name,
                                    isDark: isDark,
                                    onTap: () => _openCategory(
                                      context: context,
                                      allCategories: allCategories,
                                      categorySlug: category.slug,
                                      typeSlug: type.slug,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSquircleServiceCard(
                                    icon: category.icon,
                                    iconColor: category.primaryColor,
                                    title: 'Explore ${category.name}',
                                    isDark: isDark,
                                    onTap: () => _openCategory(
                                      context: context,
                                      allCategories: allCategories,
                                      categorySlug: category.slug,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }),

                  // 4. CIVIC & EMERGENCY SERVICES
                  _buildSectionHeader('🏙️ Civic & Emergency Services', isDark),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 86,
                          child: _buildSquircleServiceCard(
                            icon: Icons.local_hospital_rounded,
                            iconColor: const Color(0xFFE11D48),
                            title: 'Hospitals & Clinics',
                            isDark: isDark,
                            onTap: () => _openCategory(
                              context: context,
                              allCategories: allCategories,
                              categorySlug: 'healthcare',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 86,
                          child: _buildSquircleServiceCard(
                            icon: Icons.restaurant_rounded,
                            iconColor: const Color(0xFFF97316),
                            title: 'Dining & Cafes',
                            isDark: isDark,
                            onTap: () => _openCategory(
                              context: context,
                              allCategories: allCategories,
                              categorySlug: 'attractions',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 86,
                          child: _buildSquircleServiceCard(
                            icon: Icons.shield_rounded,
                            iconColor: const Color(0xFF059669),
                            title: 'Emergency Helpline',
                            isDark: isDark,
                            onTap: () => _openCategory(
                              context: context,
                              allCategories: allCategories,
                              categorySlug: 'emergency',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 86,
                          child: _buildSquircleServiceCard(
                            icon: Icons.confirmation_num_rounded,
                            iconColor: const Color(0xFF2563EB),
                            title: 'Citizen Support',
                            isDark: isDark,
                            onTap: () => context.push('/support'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF1E293B),
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildSquircleServiceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
