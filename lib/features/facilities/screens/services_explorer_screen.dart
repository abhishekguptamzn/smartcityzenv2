import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/facility_explorer_providers.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../models/facility_hierarchy_models.dart';
import '../widgets/facilities_skeletons.dart';

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
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryFilterSheet({
    required BuildContext context,
    required List<FacilityCategoryItem> allCategories,
    required bool isDark,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Explore by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.grid_view_rounded, color: Color(0xFF0D9488)),
                    title: const Text('All Categories', style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _searchController.clear();
                    },
                  ),
                  ...allCategories.map((cat) {
                    return ListTile(
                      leading: Icon(cat.icon, color: cat.primaryColor),
                      title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${cat.types.length} service types',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        _openCategory(
                          context: context,
                          allCategories: allCategories,
                          categorySlug: cat.slug,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
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

    context.push(
      '/services/category/${matchedCat.id}',
      extra: {
        'category': matchedCat,
        'initialType': matchedType,
        'initialSearch': initialSearch,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final firstName = user?.name.split(' ').first ?? 'Citizen';

    final categoriesAsync = ref.watch(unifiedFacilityCategoriesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.go('/home');
      },
      child: Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: categoriesAsync.when(
          loading: () => const ServicesExplorerSkeleton(),
          error: (error, _) => ErrorStateView(
            error: error,
            onRetry: () => ref.invalidate(unifiedFacilityCategoriesProvider),
          ),
          data: (allCategories) {
            final query = _searchController.text.trim().toLowerCase();

            // Filter categories & service types based on query and initialKind
            final filteredCategories = <({FacilityCategoryItem category, List<FacilityTypeItem> types})>[];
            for (final category in allCategories) {
              if (widget.initialKind != null && query.isEmpty) {
                final kindMatches = category.slug.toLowerCase().contains(widget.initialKind!.toLowerCase()) ||
                    category.id.toLowerCase().contains(widget.initialKind!.toLowerCase());
                if (!kindMatches) continue;
              }

              if (query.isEmpty) {
                filteredCategories.add((category: category, types: category.types));
                continue;
              }

              final categoryNameMatches = category.name.toLowerCase().contains(query) ||
                  category.slug.toLowerCase().contains(query) ||
                  category.description.toLowerCase().contains(query);

              final matchingTypes = category.types.where((t) {
                return t.name.toLowerCase().contains(query) ||
                    t.slug.toLowerCase().contains(query);
              }).toList();

              if (categoryNameMatches) {
                filteredCategories.add((category: category, types: category.types));
              } else if (matchingTypes.isNotEmpty) {
                filteredCategories.add((category: category, types: matchingTypes));
              }
            }

            final allCivicServices = [
              (
                icon: Icons.local_hospital_rounded,
                color: const Color(0xFFE11D48),
                title: 'Hospitals & Clinics',
                slug: 'healthcare',
                keywords: ['hospital', 'clinic', 'health', 'medical', 'doctor'],
                onTap: () => _openCategory(
                  context: context,
                  allCategories: allCategories,
                  categorySlug: 'healthcare',
                ),
              ),
              (
                icon: Icons.restaurant_rounded,
                color: const Color(0xFFF97316),
                title: 'Dining & Cafes',
                slug: 'attractions',
                keywords: ['dining', 'cafe', 'food', 'restaurant', 'coffee', 'eat'],
                onTap: () => _openCategory(
                  context: context,
                  allCategories: allCategories,
                  categorySlug: 'attractions',
                ),
              ),
              (
                icon: Icons.local_police_rounded,
                color: const Color(0xFFDC2626),
                title: 'Emergency 112',
                slug: 'emergency',
                keywords: ['emergency', 'police', '112', 'fire', 'ambulance', 'sos'],
                onTap: () => _openCategory(
                  context: context,
                  allCategories: allCategories,
                  categorySlug: 'emergency',
                ),
              ),
              (
                icon: Icons.support_agent_rounded,
                color: const Color(0xFF2563EB),
                title: 'Citizen Support',
                slug: 'support',
                keywords: ['support', 'citizen', 'help', 'ticket', 'contact'],
                onTap: () => context.push('/support'),
              ),
            ];

            final filteredCivicServices = allCivicServices.where((civic) {
              if (query.isEmpty) return true;
              return civic.title.toLowerCase().contains(query) ||
                  civic.keywords.any((kw) => kw.contains(query) || query.contains(kw));
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HEADER: Back Button, Greeting & Support Shortcut
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top Left Back Button to Home Screen
                        Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
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
                            tooltip: 'Back to Home',
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              size: 20,
                              color: isDark ? Colors.white70 : const Color(0xFF334155),
                            ),
                            onPressed: () => context.go('/home'),
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Hello, $firstName',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('👋', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Explore Municipal Services & Hubs',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Support & Notification Shortcut
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.support_agent_rounded,
                                  size: 22,
                                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                                ),
                                onPressed: () => context.push('/support'),
                              ),
                              Positioned(
                                top: 9,
                                right: 9,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

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
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search all facilities & activities...',
                              hintStyle: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (searchQuery) {
                              final trimmed = searchQuery.trim();
                              if (trimmed.isEmpty) return;
                              FocusScope.of(context).unfocus();

                              FacilityCategoryItem? matchedCategory;
                              FacilityTypeItem? matchedType;

                              for (final cat in allCategories) {
                                if (cat.name.toLowerCase().contains(trimmed.toLowerCase()) ||
                                    cat.slug.toLowerCase().contains(trimmed.toLowerCase())) {
                                  matchedCategory = cat;
                                  break;
                                }
                                final t = cat.types
                                    .where((t) => t.name.toLowerCase().contains(trimmed.toLowerCase()))
                                    .firstOrNull;
                                if (t != null) {
                                  matchedCategory = cat;
                                  matchedType = t;
                                  break;
                                }
                              }

                              final matchedCivic = allCivicServices.where((c) =>
                                  c.title.toLowerCase().contains(trimmed.toLowerCase()) ||
                                  c.keywords.any((kw) => kw.contains(trimmed.toLowerCase()))).firstOrNull;
                              if (matchedCivic != null && matchedCategory == null) {
                                matchedCivic.onTap();
                                return;
                              }

                              matchedCategory ??= filteredCategories.isNotEmpty
                                  ? filteredCategories.first.category
                                  : (allCategories.isNotEmpty ? allCategories.first : null);

                              if (matchedCategory != null) {
                                _openCategory(
                                  context: context,
                                  allCategories: allCategories,
                                  categorySlug: matchedCategory.slug,
                                  typeSlug: matchedType?.slug,
                                  initialSearch: trimmed,
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
                              _showCategoryFilterSheet(
                                context: context,
                                allCategories: allCategories,
                                isDark: isDark,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (query.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing results for "$query"',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Clear', style: TextStyle(fontSize: 12.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (filteredCategories.isEmpty && filteredCivicServices.isEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No services found for "$query"',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Search for facilities named "$query" directly in our major hubs:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: allCategories.take(3).map((cat) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cat.primaryColor.withValues(alpha: 0.15),
                                  foregroundColor: cat.primaryColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () => _openCategory(
                                  context: context,
                                  allCategories: allCategories,
                                  categorySlug: cat.slug,
                                  initialSearch: query,
                                ),
                                icon: Icon(cat.icon, size: 16),
                                label: Text('Search in ${cat.name}'),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Reset and show all services'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // 3. DYNAMIC FACILITY & ACTIVITY CATEGORIES
                    ...filteredCategories.map((item) {
                      final category = item.category;
                      final types = item.types;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeaderWithIcon(
                              title: category.name,
                              icon: category.icon,
                              color: category.primaryColor,
                              isDark: isDark,
                              onViewAll: () => _openCategory(
                                context: context,
                                allCategories: allCategories,
                                categorySlug: category.slug,
                                initialSearch: query.isNotEmpty ? query : null,
                              ),
                            ),
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
                                        initialSearch: query.isNotEmpty ? query : null,
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
                                        initialSearch: query.isNotEmpty ? query : null,
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
                    if (filteredCivicServices.isNotEmpty) ...[
                      _buildSectionHeaderWithIcon(
                        title: 'Civic & Emergency Services',
                        icon: Icons.shield_rounded,
                        color: const Color(0xFF0D9488),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            for (var i = 0; i < filteredCivicServices.length; i++) ...[
                              if (i > 0) const SizedBox(width: 10),
                              SizedBox(
                                width: 88,
                                child: _buildSquircleServiceCard(
                                  icon: filteredCivicServices[i].icon,
                                  iconColor: filteredCivicServices[i].color,
                                  title: filteredCivicServices[i].title,
                                  isDark: isDark,
                                  onTap: filteredCivicServices[i].onTap,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
  }

  Widget _buildSectionHeaderWithIcon({
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        if (onViewAll != null)
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 16, color: color),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSquircleServiceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
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
                color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
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
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
