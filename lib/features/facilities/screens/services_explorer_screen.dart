import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/facility_explorer_providers.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../models/civic_service_item.dart';
import '../models/facility_hierarchy_models.dart';
import '../widgets/categories/facility_category_row.dart';
import '../widgets/categories/facility_type_chips.dart';
import '../widgets/facility_search_bar.dart';
import '../widgets/listings/facility_center_card.dart';
import '../widgets/listings/facility_filter_bar.dart';
import '../widgets/send_enquiry_sheet.dart';

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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  String _search = '';
  FacilityCategoryItem? _selectedCategory;
  FacilityTypeItem? _selectedType;
  FacilitySortFilter _selectedFilter = FacilitySortFilter.nearest;
  final Set<String> _favoriteIds = {};
  UserCoordinates? _userCoords;

  @override
  void initState() {
    super.initState();
    _search = widget.initialSearch ?? '';
    _searchController = TextEditingController(text: _search);
    _scrollController.addListener(_onScroll);
    _fetchGpsLocation();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchGpsLocation() async {
    final locationSvc = ref.read(locationServiceProvider);
    final coords = await locationSvc.getCurrentLocation();
    if (mounted && coords != null) {
      setState(() => _userCoords = coords);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final user = ref.read(authControllerProvider).value;
      if (_selectedCategory == null) return;

      final query = FacilityExplorerQuery(
        categoryId: _selectedCategory!.id,
        typeId: _selectedType?.id,
        search: _search.isEmpty ? null : _search,
        cityId: user?.cityId,
        userLat: _userCoords?.latitude,
        userLng: _userCoords?.longitude,
      );

      ref.read(facilityExplorerListProvider(query).notifier).loadMore();
    }
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _search = val.trim());
      }
    });
  }

  void _handleBack() {
    if (_selectedType != null && _selectedType!.id != 'all') {
      setState(() => _selectedType = null);
      return;
    }
    if (_selectedCategory != null || _search.isNotEmpty) {
      setState(() {
        _selectedCategory = null;
        _selectedType = null;
        _search = '';
        _searchController.clear();
      });
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open dialer for $phoneNumber'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openDirections(FacilityModel facility) async {
    if (facility.latitude != null && facility.longitude != null) {
      final geoUri = Uri.parse('geo:${facility.latitude},${facility.longitude}?q=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return;
      }
      final webMapUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(webMapUri)) {
        await launchUrl(webMapUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (facility.address != null && facility.address!.isNotEmpty) {
      final queryUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(facility.address!)}');
      if (await canLaunchUrl(queryUri)) {
        await launchUrl(queryUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final cityName = user?.city?.name ?? 'Your City';

    final categoriesAsync = ref.watch(unifiedFacilityCategoriesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: SafeArea(
          child: categoriesAsync.when(
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, _) => ErrorStateView(
              error: error,
              onRetry: () => ref.invalidate(unifiedFacilityCategoriesProvider),
            ),
            data: (categories) {
              // Handle initial kind/slug navigation if provided
              if (_selectedCategory == null && widget.initialKind != null) {
                final match = categories.firstWhere(
                  (c) => c.slug == widget.initialKind || c.id == widget.initialKind,
                  orElse: () => categories.first,
                );
                _selectedCategory = match;
              }

              // Active category defaults to the first category (Libraries) if none selected
              final activeCategory = _selectedCategory ?? categories.first;
              final types = activeCategory.types;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Header: Back, Title, City Indicator & Onboard button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 16, 6),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _handleBack,
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.grid_view_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                activeCategory.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    size: 11.5,
                                    color: Color(0xFF0D9488),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Serving $cityName',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (user?.isOnboardingUser == true) ...[
                          const SizedBox(width: 8),
                          Material(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCCFBF1),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () => context.push('/onboard'),
                              borderRadius: BorderRadius.circular(10),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      size: 14,
                                      color: Color(0xFF0F766E),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Onboard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F766E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 2. Global Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                    child: FacilitySearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: () {
                        _searchController.clear();
                        setState(() => _search = '');
                      },
                      hintText: 'Search centers in $cityName...',
                    ),
                  ),

                  // 3. Level 1: Facility Categories (Horizontal Row of Icons & Names)
                  FacilityCategoryRow(
                    categories: categories,
                    selectedCategory: activeCategory,
                    onSelectCategory: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                        _selectedType = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // 4. Level 2: Facility Types inside Selected Category (Icons & Names)
                  if (types.isNotEmpty) ...[
                    FacilityTypeChips(
                      types: types,
                      selectedType: _selectedType,
                      activeColor: activeCategory.gradientColors.first,
                      onSelectType: (t) {
                        setState(() => _selectedType = t);
                      },
                    ),
                    const SizedBox(height: 8),
                  ],

                  // 5. Level 3: City-Scoped Facility Centers Listing
                  Expanded(
                    child: _buildFacilityCentersList(
                      activeCategory: activeCategory,
                      cityName: cityName,
                      userCityId: user?.cityId,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityCentersList({
    required FacilityCategoryItem activeCategory,
    required String cityName,
    required String? userCityId,
  }) {
    // If it's a static non-directory category (Healthcare, Emergency), show civic items
    if (activeCategory.id == 'healthcare' ||
        activeCategory.id == 'emergency' ||
        activeCategory.id == 'attractions') {
      return _buildCivicStaticList(activeCategory, cityName);
    }

    final query = FacilityExplorerQuery(
      categoryId: activeCategory.id,
      typeId: _selectedType?.id,
      search: _search.isEmpty ? null : _search,
      cityId: userCityId,
      userLat: _userCoords?.latitude,
      userLng: _userCoords?.longitude,
    );

    final facilitiesAsync = ref.watch(facilityExplorerListProvider(query));

    return facilitiesAsync.when(
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, _) => ErrorStateView(
        error: error,
        onRetry: () => ref.invalidate(facilityExplorerListProvider(query)),
      ),
      data: (facilities) {
        // Filter & Sort
        var items = facilities.where((f) {
          if (_selectedFilter == FacilitySortFilter.openNow && !f.isOpenNow) return false;
          return true;
        }).toList();

        switch (_selectedFilter) {
          case FacilitySortFilter.nearest:
            items.sort((a, b) => (a.distanceKm ?? 99999).compareTo(b.distanceKm ?? 99999));
            break;
          case FacilitySortFilter.openNow:
            items.sort((a, b) => (b.isOpenNow ? 1 : 0).compareTo(a.isOpenNow ? 1 : 0));
            break;
          case FacilitySortFilter.az:
            items.sort((a, b) => a.name.compareTo(b.name));
            break;
          case FacilitySortFilter.topRated:
            // Keep current order or sort by status
            break;
        }

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: activeCategory.gradientColors.first.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activeCategory.icon,
                      size: 48,
                      color: activeCategory.gradientColors.first,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${activeCategory.name} found in $cityName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _search.isNotEmpty
                        ? 'Try clearing your search query "$_search"'
                        : 'No active centers registered in $cityName yet.',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (_search.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _search = '');
                      },
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      label: const Text('Clear Search'),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        final isWide = MediaQuery.sizeOf(context).width > 700;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(facilityExplorerListProvider(query));
            await ref.read(facilityExplorerListProvider(query).future);
          },
          child: Column(
            children: [
              FacilityFilterBar(
                itemCount: items.length,
                cityName: cityName,
                selectedFilter: _selectedFilter,
                hasActiveGps: _userCoords?.isExactGps == true,
                onSelectFilter: (f) => setState(() => _selectedFilter = f),
              ),
              Expanded(
                child: isWide
                    ? GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 460,
                          mainAxisExtent: 380,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) => _buildCard(items[index], cityName),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) => _buildCard(items[index], cityName),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(FacilityModel facility, String cityName) {
    final isFav = _favoriteIds.contains(facility.id);

    return FacilityCenterCard(
      facility: facility,
      isFavorite: isFav,
      onToggleFavorite: () {
        setState(() {
          if (isFav) {
            _favoriteIds.remove(facility.id);
          } else {
            _favoriteIds.add(facility.id);
          }
        });
      },
      onTap: () => _navigateToDetail(facility),
      onViewDetails: () => _navigateToDetail(facility),
      onSendEnquiry: () => SendEnquirySheet.show(
        context,
        facilityId: facility.id,
        facilityKind: facility.kind,
        facilityTitle: facility.name,
        facilitySubtitle: facility.address ?? cityName,
        categoryName: facility.kind.displayName,
        facilityPhone: facility.contactPhone,
        facilityEmail: facility.contactEmail,
      ),
      onCall: facility.contactPhone != null ? () => _makeCall(facility.contactPhone!) : null,
      onDirections: () => _openDirections(facility),
    );
  }

  void _navigateToDetail(FacilityModel facility) {
    context.push('/services/${facility.kind.name}/${facility.id}');
  }

  Widget _buildCivicStaticList(FacilityCategoryItem cat, String cityName) {
    final civicCat = switch (cat.id) {
      'healthcare' => CivicCategory.healthcare,
      'emergency' => CivicCategory.emergency,
      'attractions' => CivicCategory.heritage,
      _ => CivicCategory.all,
    };

    final filtered = kCivicServicesCatalog.where((s) {
      if (s.category != civicCat) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return s.title.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q) ||
            s.location.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = filtered[i];
        final loc = item.location.replaceAll('City', cityName);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.gradientColors),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      loc,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (item.phone != null)
                IconButton(
                  icon: const Icon(Icons.phone_rounded, color: Color(0xFF059669)),
                  onPressed: () => _makeCall(item.phone!),
                ),
            ],
          ),
        );
      },
    );
  }
}
