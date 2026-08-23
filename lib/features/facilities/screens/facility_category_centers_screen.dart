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
import '../widgets/categories/facility_type_chips.dart';
import '../widgets/facility_search_bar.dart';
import '../widgets/listings/facility_center_card.dart';
import '../widgets/listings/facility_filter_bar.dart';
import '../widgets/send_enquiry_sheet.dart';

class FacilityCategoryCentersScreen extends ConsumerStatefulWidget {
  const FacilityCategoryCentersScreen({
    super.key,
    required this.category,
    this.initialType,
    this.initialSearch,
  });

  final FacilityCategoryItem category;
  final FacilityTypeItem? initialType;
  final String? initialSearch;

  @override
  ConsumerState<FacilityCategoryCentersScreen> createState() =>
      _FacilityCategoryCentersScreenState();
}

class _FacilityCategoryCentersScreenState
    extends ConsumerState<FacilityCategoryCentersScreen> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  late String _search;
  FacilityTypeItem? _selectedType;
  FacilitySortFilter _selectedFilter = FacilitySortFilter.nearest;
  final Set<String> _favoriteIds = {};
  UserCoordinates? _userCoords;

  @override
  void initState() {
    super.initState();
    _search = widget.initialSearch ?? '';
    _selectedType = widget.initialType;
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final user = ref.read(authControllerProvider).value;
      final query = FacilityExplorerQuery(
        categoryId: widget.category.id,
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
      final geoUri = Uri.parse(
          'geo:${facility.latitude},${facility.longitude}?q=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return;
      }
      final webMapUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(webMapUri)) {
        await launchUrl(webMapUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (facility.address != null && facility.address!.isNotEmpty) {
      final queryUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(facility.address!)}');
      if (await canLaunchUrl(queryUri)) {
        await launchUrl(queryUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _navigateToDetail(FacilityModel center) {
    if (widget.category.isActivity) {
      context.push('/activities/${center.id}');
    } else {
      final kindSegment = widget.category.facilityKind?.name ??
          (widget.category.id == 'gyms' ? 'gym' : 'library');
      context.push('/services/$kindSegment/${center.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final cityName = user?.city?.name ?? 'Your City';
    final types = widget.category.types;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1.5,
        titleSpacing: 8,
        toolbarHeight: 64,
        leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.category.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.category.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.category.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category.name,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF0D9488)),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          cityName,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.tune_rounded, size: 18),
                onPressed: () {
                  // Focus search or trigger sort filter
                  setState(() {
                    if (_selectedFilter == FacilitySortFilter.nearest) {
                      _selectedFilter = FacilitySortFilter.openNow;
                    } else {
                      _selectedFilter = FacilitySortFilter.nearest;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: FacilitySearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                setState(() => _search = '');
              },
              hintText: 'Search ${widget.category.name.toLowerCase()} in $cityName...',
            ),
          ),

          // Sub-types / Filter Chips
          if (types.isNotEmpty) ...[
            FacilityTypeChips(
              types: types,
              selectedType: _selectedType,
              activeColor: widget.category.gradientColors.first,
              onSelectType: (t) => setState(() => _selectedType = t),
            ),
            const SizedBox(height: 6),
          ],

          // Facility Centers Listing
          Expanded(
            child: _buildCentersList(cityName, user?.cityId),
          ),
        ],
      ),
    );
  }

  Widget _buildCentersList(String cityName, String? userCityId) {
    if (widget.category.id == 'healthcare' ||
        widget.category.id == 'emergency' ||
        widget.category.id == 'attractions') {
      return _buildCivicStaticList(cityName);
    }

    final query = FacilityExplorerQuery(
      categoryId: widget.category.id,
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
            break;
        }

        return Column(
          children: [
            // Filter bar with dynamic item count
            FacilityFilterBar(
              itemCount: items.length,
              cityName: cityName,
              selectedFilter: _selectedFilter,
              onSelectFilter: (filter) => setState(() => _selectedFilter = filter),
              hasActiveGps: _userCoords != null,
            ),

            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: widget.category.gradientColors.first
                                    .withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.category.icon,
                                size: 44,
                                color: widget.category.gradientColors.first,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No ${widget.category.name} found in $cityName',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _search.isNotEmpty
                                  ? 'Try adjusting your search "$_search"'
                                  : 'No centers registered under this category yet.',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            if (_search.isNotEmpty) ...[
                              const SizedBox(height: 14),
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
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(facilityExplorerListProvider(query));
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final center = items[idx];
                          final isFav = _favoriteIds.contains(center.id);

                          return FacilityCenterCard(
                            facility: center,
                            isFavorite: isFav,
                            onToggleFavorite: () {
                              setState(() {
                                if (isFav) {
                                  _favoriteIds.remove(center.id);
                                } else {
                                  _favoriteIds.add(center.id);
                                }
                              });
                            },
                            onTap: () => _navigateToDetail(center),
                            onViewDetails: () => _navigateToDetail(center),
                            onCall: center.contactPhone != null && center.contactPhone!.isNotEmpty
                                ? () => _makeCall(center.contactPhone!)
                                : null,
                            onDirections: () => _openDirections(center),
                            onSendEnquiry: () => SendEnquirySheet.show(
                              context,
                              facilityTitle: center.name,
                              facilityId: center.id,
                              facilityPhone: center.contactPhone,
                              facilityEmail: center.contactEmail,
                              facilityKind: widget.category.facilityKind ??
                                  (widget.category.id == 'gyms'
                                      ? FacilityKind.gym
                                      : FacilityKind.library),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCivicStaticList(String cityName) {
    final civicItems = kCivicServicesCatalog
        .where((s) => s.category.name.toLowerCase() == widget.category.id.toLowerCase())
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: civicItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final item = civicItems[idx];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: item.gradientColors),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          Text(
                            item.subtitle,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 13, height: 1.35),
                ),
                if (item.phone != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF0D9488)),
                      const SizedBox(width: 4),
                      Text(
                        'Helpline: ${item.phone}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _makeCall(item.phone!),
                        icon: const Icon(Icons.call_rounded, size: 14),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
