import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/activities_providers.dart';
import '../../../core/providers/auth_controller.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../widgets/activity_card.dart';
import '../widgets/facilities_skeletons.dart';

class ActivitiesExplorerScreen extends ConsumerStatefulWidget {
  const ActivitiesExplorerScreen({
    super.key,
    this.initialCategorySlug,
    this.initialSearch,
  });

  final String? initialCategorySlug;
  final String? initialSearch;

  static const Color _primary = Color(0xFF1565D8);

  @override
  ConsumerState<ActivitiesExplorerScreen> createState() => _ActivitiesExplorerScreenState();
}

class _ActivitiesExplorerScreenState extends ConsumerState<ActivitiesExplorerScreen> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  String _search = '';
  String? _selectedCategorySlug;
  String? _selectedTypeId;
  bool _verifiedOnly = false;
  bool _featuredOnly = false;
  String _sortBy = 'rating';
  String _sortDir = 'desc';

  @override
  void initState() {
    super.initState();
    _search = widget.initialSearch ?? '';
    _searchController = TextEditingController(text: _search);
    _selectedCategorySlug = widget.initialCategorySlug;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final params = _buildParams();
      ref.read(activityListProvider(params).notifier).loadMore();
    }
  }

  ActivityListParams _buildParams() {
    final user = ref.watch(authControllerProvider).value;
    return ActivityListParams(
      search: _search.isNotEmpty ? _search : null,
      category: _selectedCategorySlug,
      typeId: _selectedTypeId,
      cityId: user?.cityId,
      featured: _featuredOnly ? true : null,
      sortBy: _sortBy,
      sortDir: _sortDir,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categoriesAsync = ref.watch(activityCategoriesProvider);
    final params = _buildParams();
    final activitiesAsync = ref.watch(activityListProvider(params));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Activities & Academies',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF181B26) : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Options',
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? const Color(0xFF181B26) : Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _search = val.trim());
              },
              decoration: InputDecoration(
                hintText: 'Search academies, yoga, dance, cricket...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: ActivitiesExplorerScreen._primary),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF232736) : const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories Horizontal Carousel
          Container(
            height: 48,
            color: isDark ? const Color(0xFF181B26) : Colors.white,
            child: categoriesAsync.when(
              data: (categories) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: [
                    // "All" Chip
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('✨ All Activities'),
                        selected: _selectedCategorySlug == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategorySlug = null;
                              _selectedTypeId = null;
                            });
                          }
                        },
                        selectedColor: ActivitiesExplorerScreen._primary,
                        backgroundColor: isDark ? const Color(0xFF232736) : const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedCategorySlug == null
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    // Categories
                    ...categories.map((c) {
                      final isSelected = _selectedCategorySlug == c.slug;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconHelper.buildIcon(
                                c.icon,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : Colors.black87),
                                defaultEmoji: '🎯',
                              ),
                              const SizedBox(width: 5),
                              Text(c.name),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategorySlug = selected ? c.slug : null;
                              _selectedTypeId = null;
                            });
                          },
                          selectedColor: ActivitiesExplorerScreen._primary,
                          backgroundColor: isDark ? const Color(0xFF232736) : const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),

          // Sub-filters bar (Verified, Featured, Types)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131620) : const Color(0xFFF1F5F9),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF232736) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    avatar: Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: _verifiedOnly ? Colors.white : const Color(0xFF10B981),
                    ),
                    label: const Text('Verified Academies'),
                    selected: _verifiedOnly,
                    onSelected: (val) => setState(() => _verifiedOnly = val),
                    selectedColor: const Color(0xFF10B981),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _verifiedOnly ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    avatar: Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: _featuredOnly ? Colors.white : const Color(0xFFF59E0B),
                    ),
                    label: const Text('Featured Studios'),
                    selected: _featuredOnly,
                    onSelected: (val) => setState(() => _featuredOnly = val),
                    selectedColor: const Color(0xFFF59E0B),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _featuredOnly ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ],
              ),
            ),
          ),

          // Activities List View
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(activityListProvider(params));
              },
              child: activitiesAsync.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 60),
                        EmptyStateView(
                          icon: Icons.sports_kabaddi_rounded,
                          message: _search.isNotEmpty
                              ? 'No academies or classes match "$_search". Try a different keyword.'
                              : 'No activity academies available in this category yet.',
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: activities.length + 1,
                    itemBuilder: (context, index) {
                      if (index == activities.length) {
                        final notifier = ref.watch(activityListProvider(params).notifier);
                        if (notifier.isLoadingMore) {
                          return const BottomPaginationSkeleton();
                        }
                        return const SizedBox(height: 24);
                      }

                      final activity = activities[index];
                      return ActivityCard(activity: activity);
                    },
                  );
                },
                loading: () => const ActivitiesExplorerSkeleton(),
                error: (error, _) => ListView(
                  children: [
                    const SizedBox(height: 60),
                    ErrorStateView(
                      error: error,
                      onRetry: () => ref.invalidate(activityListProvider(params)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF181B26) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Activities By',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _sortTile('rating', 'desc', 'Highest Rated', Icons.star_rounded),
            _sortTile('name', 'asc', 'Name (A to Z)', Icons.sort_by_alpha_rounded),
            _sortTile('created_at', 'desc', 'Newly Added', Icons.new_releases_rounded),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String sortBy, String sortDir, String label, IconData icon) {
    final isSelected = _sortBy == sortBy && _sortDir == sortDir;
    return ListTile(
      leading: Icon(icon, color: isSelected ? ActivitiesExplorerScreen._primary : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? ActivitiesExplorerScreen._primary : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_rounded, color: ActivitiesExplorerScreen._primary) : null,
      onTap: () {
        setState(() {
          _sortBy = sortBy;
          _sortDir = sortDir;
        });
        Navigator.of(context).pop();
      },
    );
  }
}
