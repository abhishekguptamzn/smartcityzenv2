import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/facilities_providers.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../models/civic_service_item.dart';
import '../widgets/send_enquiry_sheet.dart';

enum _FacilitySortOption {
  distance('Nearest', Icons.near_me_rounded),
  name('A-Z', Icons.sort_by_alpha_rounded),
  status('Open First', Icons.schedule_rounded);

  const _FacilitySortOption(this.label, this.icon);
  final String label;
  final IconData icon;
}

class ServicesExplorerScreen extends ConsumerStatefulWidget {
  const ServicesExplorerScreen({
    super.key,
    this.initialSearch,
    this.initialKind,
  });

  final String? initialSearch;
  final String? initialKind;

  @override
  ConsumerState<ServicesExplorerScreen> createState() =>
      _ServicesExplorerScreenState();
}

class _ServicesExplorerScreenState
    extends ConsumerState<ServicesExplorerScreen> {
  late final TextEditingController _searchController;
  String _search = '';
  CivicCategory _selectedCategory = CivicCategory.all;

  // Live facility listings state (for Libraries & Gyms)
  FacilityKind _liveFacilityKind = FacilityKind.library;
  bool _openNowOnly = false;
  bool _favoritesOnly = false;
  final Set<String> _favoriteIds = {};
  _FacilitySortOption _sortOption = _FacilitySortOption.distance;
  final ScrollController _liveScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _search = widget.initialSearch ?? '';
    _searchController = TextEditingController(text: _search);

    if (widget.initialKind == 'gym' || widget.initialKind == 'gyms') {
      _selectedCategory = CivicCategory.gyms;
      _liveFacilityKind = FacilityKind.gym;
    } else if (widget.initialKind == 'library' ||
        widget.initialKind == 'libraries') {
      _selectedCategory = CivicCategory.libraries;
      _liveFacilityKind = FacilityKind.library;
    }

    _liveScrollController.addListener(_onLiveScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _liveScrollController.dispose();
    super.dispose();
  }

  void _onLiveScroll() {
    if (_liveScrollController.position.pixels >=
        _liveScrollController.position.maxScrollExtent - 200) {
      final user = ref.read(authControllerProvider).value;
      ref
          .read(
            facilityListProvider(
              FacilityListParams(
                kind: _liveFacilityKind,
                cityId: user?.cityId,
                search: _search.isEmpty ? null : _search,
              ),
            ).notifier,
          )
          .loadMore();
    }
  }

  void _handleBack() {
    if (_selectedCategory != CivicCategory.all || _search.isNotEmpty) {
      setState(() {
        _selectedCategory = CivicCategory.all;
        _search = '';
        _searchController.clear();
      });
      return;
    }
    if (Navigator.of(context).canPop()) {
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

  Future<void> _openDirections(
    String locationQuery, {
    double? lat,
    double? lng,
  }) async {
    if (lat != null && lng != null) {
      final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return;
      }
      final webMapUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      if (await canLaunchUrl(webMapUri)) {
        await launchUrl(webMapUri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    final queryUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(locationQuery)}',
    );
    if (await canLaunchUrl(queryUri)) {
      await launchUrl(queryUri, mode: LaunchMode.externalApplication);
    }
  }

  List<CivicServiceItem> _getFilteredServices(String cityName) {
    return kCivicServicesCatalog.where((item) {
      if (_selectedCategory != CivicCategory.all &&
          item.category != _selectedCategory) {
        return false;
      }

      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchSubtitle = item.subtitle.toLowerCase().contains(q);
        final matchDesc = item.description.toLowerCase().contains(q);
        final matchLocation = item.location.toLowerCase().contains(q);
        final matchAmenities = item.amenities.any(
          (a) => a.toLowerCase().contains(q),
        );
        final matchBadges = item.badges.any(
          (b) => b.toLowerCase().contains(q),
        );
        return matchTitle ||
            matchSubtitle ||
            matchDesc ||
            matchLocation ||
            matchAmenities ||
            matchBadges;
      }

      return true;
    }).toList();
  }

  void _showServiceDetailModal(CivicServiceItem item, String cityName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizedLocation = item.location.replaceAll('City', cityName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: item.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: item.gradientColors.first
                                  .withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.badges.map((b) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: item.gradientColors.first
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: item.gradientColors.first
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          b,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: item.gradientColors.first,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: Color(0xFF0F766E),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                localizedLocation,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_filled_rounded,
                              size: 18,
                              color: Color(0xFF0F766E),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.timings,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'About Service',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(modalContext);
                            SendEnquirySheet.show(
                              context,
                              facilityTitle: item.title,
                              facilitySubtitle: localizedLocation,
                              categoryName: item.title,
                              facilityPhone: item.phone,
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text(
                            'Send Enquiry',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (item.phone != null) ...[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(modalContext);
                            _makeCall(item.phone!);
                          },
                          child: const Icon(Icons.call_rounded, size: 20),
                        ),
                        const SizedBox(width: 10),
                      ],
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(modalContext);
                          _openDirections(localizedLocation);
                        },
                        child: const Icon(Icons.directions_rounded, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFacilityDetailsModal(FacilityModel facility, String cityName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = facility.isOpenNow;
    final addressLine = facility.address ?? cityName;
    final isLibrary = facility.kind == FacilityKind.library;
    final cover = facility.coverImageUrl;
    final activeAmenities = facility.activeAmenities;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (cover != null && cover.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AppNetworkImage(
                        imageUrl: cover,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isLibrary
                              ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
                              : [const Color(0xFFEA580C), const Color(0xFFF97316)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          isLibrary
                              ? Icons.local_library_rounded
                              : Icons.fitness_center_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facility.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isLibrary
                                  ? 'Public Library • $cityName'
                                  : 'Gym & Fitness Center • $cityName',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isOpen
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: isOpen
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF64748B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isOpen ? 'Open Now' : 'Closed',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isOpen
                                    ? const Color(0xFF166534)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: Color(0xFF0F766E),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                addressLine,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (facility.openingTime != null) ...[
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled_rounded,
                                size: 18,
                                color: Color(0xFF0F766E),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${facility.openingTimeShort ?? facility.openingTime} - ${facility.closingTimeShort ?? facility.closingTime}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (facility.distanceKm != null) ...[
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.near_me_rounded,
                                size: 18,
                                color: Color(0xFF0F766E),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${facility.distanceKm!.toStringAsFixed(1)} km from your location',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (activeAmenities.isNotEmpty) ...[
                    const Text(
                      'Amenities & Facilities',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: activeAmenities.map((a) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Color(0xFF0F766E),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                a.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],

                  if (facility.description != null &&
                      facility.description!.trim().isNotEmpty) ...[
                    const Text(
                      'About Facility',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      facility.description!,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(modalContext);
                            context.push(
                              '/services/${facility.kind.name}/${facility.id}',
                            );
                          },
                          icon: const Icon(Icons.explore_rounded, size: 18),
                          label: const Text(
                            'Full Page Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(modalContext);
                          SendEnquirySheet.show(
                            context,
                            facilityTitle: facility.name,
                            facilitySubtitle: addressLine,
                            categoryName: isLibrary
                                ? 'Public Library'
                                : 'Gym & Fitness Center',
                            facilityPhone: facility.contactPhone,
                            facilityEmail: facility.contactEmail,
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text(
                          'Enquiry',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final cityName = user?.city?.name ?? 'Your City';

    final isFacilityCategory =
        _selectedCategory == CivicCategory.libraries ||
        _selectedCategory == CivicCategory.gyms;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Header with Back, Title, City Indicator & Onboard
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
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
                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCategory == CivicCategory.all
                                    ? 'Civic Services Directory'
                                    : _categoryTitle(_selectedCategory),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
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
                                    size: 11,
                                    color: Color(0xFF0D9488),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Serving $cityName',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        Material(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => context.push('/onboard'),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.rocket_launch_rounded,
                                    size: 14,
                                    color: isDark
                                        ? const Color(0xFF2DD4BF)
                                        : const Color(0xFF0F766E),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Onboard',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF2DD4BF)
                                          : const Color(0xFF0F766E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Search Input
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: scheme.outlineVariant.withValues(
                            alpha: isDark ? 0.25 : 0.45,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _search = v.trim()),
                        decoration: InputDecoration(
                          hintText: 'Search services in $cityName...',
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Color(0xFF0D9488),
                          ),
                          suffixIcon: _search.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _search = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Active Category Banner (when drilled down)
              if (_selectedCategory != CivicCategory.all || _search.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(
                          Icons.arrow_back_rounded,
                          size: 15,
                        ),
                        label: const Text('All Service Categories'),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = CivicCategory.all;
                            _search = '';
                            _searchController.clear();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _search.isNotEmpty
                              ? 'Results for "$_search"'
                              : 'Showing $cityName Listings',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // 3. Body: Either Icons-Only Hub OR Drill-Down Category Listings
              Expanded(
                child: (_selectedCategory == CivicCategory.all &&
                        _search.isEmpty)
                    ? _buildIconsOnlyGrid(cityName)
                    : (isFacilityCategory
                        ? _buildLiveFacilitiesView(cityName)
                        : _buildServicesCatalogView(cityName)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryTitle(CivicCategory category) {
    switch (category) {
      case CivicCategory.all:
        return 'All Services';
      case CivicCategory.healthcare:
        return 'Hospitals & Healthcare';
      case CivicCategory.libraries:
        return 'Public Libraries';
      case CivicCategory.gyms:
        return 'Gyms & Fitness';
      case CivicCategory.yoga:
        return 'Yoga & Wellness';
      case CivicCategory.dance:
        return 'Dance & Music';
      case CivicCategory.coaching:
        return 'Coaching & Skills';
      case CivicCategory.aquatics:
        return 'Swimming Pools';
      case CivicCategory.heritage:
        return 'City Attractions';
      case CivicCategory.transit:
        return 'Public Transit';
      case CivicCategory.emergency:
        return 'Emergency 112';
      case CivicCategory.civicOffices:
        return 'Civic Offices';
    }
  }

  // 1. ALL ICONS-ONLY HUB (Category Navigation Grid)
  Widget _buildIconsOnlyGrid(String cityName) {
    final categories = <(CivicCategory, String, String, IconData, Color, Color)>[
      (
        CivicCategory.healthcare,
        'Hospitals & Health',
        'Emergency, OPDs & Clinics',
        Icons.local_hospital_rounded,
        const Color(0xFFE11D48),
        const Color(0xFFFB7185),
      ),
      (
        CivicCategory.libraries,
        'Public Libraries',
        'Study Hubs & Books',
        Icons.local_library_rounded,
        const Color(0xFF0F766E),
        const Color(0xFF14B8A6),
      ),
      (
        CivicCategory.gyms,
        'Gyms & Fitness',
        'Gymnasiums & Trainers',
        Icons.fitness_center_rounded,
        const Color(0xFF0284C7),
        const Color(0xFF38BDF8),
      ),
      (
        CivicCategory.yoga,
        'Yoga & Wellness',
        'Centers & Meditation',
        Icons.self_improvement_rounded,
        const Color(0xFF059669),
        const Color(0xFF34D399),
      ),
      (
        CivicCategory.dance,
        'Dance & Music',
        'Classical & Modern Arts',
        Icons.theater_comedy_rounded,
        const Color(0xFF7C3AED),
        const Color(0xFFA78BFA),
      ),
      (
        CivicCategory.coaching,
        'Coaching & Skills',
        'Exam Prep & Libraries',
        Icons.school_rounded,
        const Color(0xFFEA580C),
        const Color(0xFFFB923C),
      ),
      (
        CivicCategory.aquatics,
        'Swimming Pools',
        'Municipal & Club Pools',
        Icons.pool_rounded,
        const Color(0xFF0284C7),
        const Color(0xFF60A5FA),
      ),
      (
        CivicCategory.heritage,
        'City Attractions',
        'Monuments & Heritage',
        Icons.museum_rounded,
        const Color(0xFFD97706),
        const Color(0xFFFBBF24),
      ),
      (
        CivicCategory.transit,
        'Public Transit',
        'Metro, Bus & Smart Mobility',
        Icons.directions_bus_rounded,
        const Color(0xFF4F46E5),
        const Color(0xFF818CF8),
      ),
      (
        CivicCategory.emergency,
        'Emergency 112',
        'Police, Fire & Ambulance',
        Icons.local_police_rounded,
        const Color(0xFFDC2626),
        const Color(0xFFF87171),
      ),
      (
        CivicCategory.civicOffices,
        'Civic Offices',
        'Ward & Municipal Desks',
        Icons.domain_rounded,
        const Color(0xFF0F766E),
        const Color(0xFF2DD4BF),
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF0D9488).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.travel_explore_rounded,
                  color: Color(0xFF0F766E),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Select a service category to view verified centers and providers in $cityName.',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < categories.length; i += 2) ...[
            Row(
              children: [
                Expanded(
                  child: _buildCategoryCard(
                    categories[i],
                  ),
                ),
                const SizedBox(width: 12),
                if (i + 1 < categories.length)
                  Expanded(
                    child: _buildCategoryCard(
                      categories[i + 1],
                    ),
                  )
                else
                  const Expanded(child: SizedBox.shrink()),
              ],
            ),
            if (i + 2 < categories.length) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    (CivicCategory, String, String, IconData, Color, Color) item,
  ) {
    final (cat, title, subtitle, icon, color1, color2) = item;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedCategory = cat;
            if (cat == CivicCategory.libraries) {
              _liveFacilityKind = FacilityKind.library;
            } else if (cat == CivicCategory.gyms) {
              _liveFacilityKind = FacilityKind.gym;
            }
          });
        },
        child: Container(
          height: 135,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color1, color2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: color1.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. DRILL-DOWN SERVICES CATALOG VIEW (Filtered to selected category & City)
  Widget _buildServicesCatalogView(String cityName) {
    final services = _getFilteredServices(cityName);
    final scheme = Theme.of(context).colorScheme;

    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No services matching in $cityName',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try changing your search keywords or clear filters',
              style: TextStyle(fontSize: 12.5, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _search = '';
                  _searchController.clear();
                  _selectedCategory = CivicCategory.all;
                });
              },
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: services.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = services[i];
        final localizedLocation = item.location.replaceAll('City', cityName);

        return _CivicServiceCard(
          item: item,
          cityName: cityName,
          onTap: () => _showServiceDetailModal(item, cityName),
          onSendEnquiry: () => SendEnquirySheet.show(
            context,
            facilityTitle: item.title,
            facilitySubtitle: localizedLocation,
            categoryName: item.title,
            facilityPhone: item.phone,
          ),
          onCall: item.phone != null ? () => _makeCall(item.phone!) : null,
          onDirections: () => _openDirections(localizedLocation),
        );
      },
    );
  }

  // 3. LIVE FACILITIES LISTINGS (Libraries & Gyms from Backend API scoped to City)
  Widget _buildLiveFacilitiesView(String cityName) {
    final kind = _liveFacilityKind;
    final user = ref.watch(authControllerProvider).value;
    final isLibrary = kind == FacilityKind.library;

    Widget buildContent() {
      final listAsync = ref.watch(
        facilityListProvider(
          FacilityListParams(
            kind: kind,
            cityId: user?.cityId,
            search: _search.isEmpty ? null : _search,
          ),
        ),
      );

      return listAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => ErrorStateView(
          error: error,
          onRetry: () => ref.invalidate(
            facilityListProvider(
              FacilityListParams(
                kind: kind,
                cityId: user?.cityId,
                search: _search.isEmpty ? null : _search,
              ),
            ),
          ),
        ),
        data: (facilities) {
          var items = facilities.where((f) {
            if (_openNowOnly && !f.isOpenNow) return false;
            if (_favoritesOnly && !_favoriteIds.contains(f.id)) return false;
            return true;
          }).toList();

          switch (_sortOption) {
            case _FacilitySortOption.distance:
              items.sort(
                (a, b) =>
                    (a.distanceKm ?? 9999).compareTo(b.distanceKm ?? 9999),
              );
              break;
            case _FacilitySortOption.name:
              items.sort((a, b) => a.name.compareTo(b.name));
              break;
            case _FacilitySortOption.status:
              items.sort(
                (a, b) => (b.isOpenNow ? 1 : 0).compareTo(a.isOpenNow ? 1 : 0),
              );
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isLibrary
                            ? const Color(0xFF0284C7).withValues(alpha: 0.1)
                            : const Color(0xFFEA580C).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLibrary
                            ? Icons.local_library_outlined
                            : Icons.fitness_center_outlined,
                        size: 48,
                        color: isLibrary
                            ? const Color(0xFF0284C7)
                            : const Color(0xFFEA580C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No ${isLibrary ? 'Libraries' : 'Gyms'} found in $cityName',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _openNowOnly || _favoritesOnly || _search.isNotEmpty
                          ? 'Try clearing your active filters to see all facilities'
                          : 'No active facilities registered in $cityName yet',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    if (_openNowOnly || _favoritesOnly || _search.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _openNowOnly = false;
                            _favoritesOnly = false;
                            _search = '';
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear_all_rounded, size: 18),
                        label: const Text('Reset Filters'),
                      )
                    else
                      OutlinedButton(
                        onPressed: () => setState(
                          () => _selectedCategory = CivicCategory.all,
                        ),
                        child: const Text('Back to Categories'),
                      ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                facilityListProvider(
                  FacilityListParams(
                    kind: kind,
                    cityId: user?.cityId,
                    search: _search.isEmpty ? null : _search,
                  ),
                ),
              );
            },
            child: ListView.separated(
              controller: _liveScrollController,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final facility = items[i];
                final isFav = _favoriteIds.contains(facility.id);

                return _FacilityCard(
                  facility: facility,
                  isLibrary: isLibrary,
                  isFavorite: isFav,
                  cityName: cityName,
                  onToggleFavorite: () {
                    setState(() {
                      if (isFav) {
                        _favoriteIds.remove(facility.id);
                      } else {
                        _favoriteIds.add(facility.id);
                      }
                    });
                  },
                  onTap: () => _showFacilityDetailsModal(facility, cityName),
                  onViewDetails: () {
                    context.push(
                      '/services/${facility.kind.name}/${facility.id}',
                    );
                  },
                  onSendEnquiry: () {
                    SendEnquirySheet.show(
                      context,
                      facilityTitle: facility.name,
                      facilitySubtitle: facility.address ?? cityName,
                      categoryName: isLibrary
                          ? 'Public Library'
                          : 'Gym & Fitness Center',
                      facilityPhone: facility.contactPhone,
                      facilityEmail: facility.contactEmail,
                    );
                  },
                  onCall: facility.contactPhone != null
                      ? () => _makeCall(facility.contactPhone!)
                      : null,
                  onDirections: () => _openDirections(
                    facility.address ?? cityName,
                    lat: facility.latitude,
                    lng: facility.longitude,
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Column(
      children: [
        // Filter toolbar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  avatar: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  label: const Text(
                    'Open Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: _openNowOnly,
                  onSelected: (v) => setState(() => _openNowOnly = v),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  avatar: const Icon(Icons.favorite_rounded, size: 14),
                  label: const Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: _favoritesOnly,
                  onSelected: (v) => setState(() => _favoritesOnly = v),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<_FacilitySortOption>(
                  initialValue: _sortOption,
                  onSelected: (opt) => setState(() => _sortOption = opt),
                  child: Chip(
                    avatar: Icon(_sortOption.icon, size: 14),
                    label: Text(
                      'Sort: ${_sortOption.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  itemBuilder: (context) => _FacilitySortOption.values.map((opt) {
                    return PopupMenuItem(
                      value: opt,
                      child: Row(
                        children: [
                          Icon(opt.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(opt.label),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: buildContent()),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CIVIC SERVICE CARD (Curated Service Directory with Send Enquiry & Actions)
// -----------------------------------------------------------------------------
class _CivicServiceCard extends StatelessWidget {
  const _CivicServiceCard({
    required this.item,
    required this.cityName,
    required this.onTap,
    required this.onSendEnquiry,
    this.onCall,
    this.onDirections,
  });

  final CivicServiceItem item;
  final String cityName;
  final VoidCallback onTap;
  final VoidCallback onSendEnquiry;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final localizedLocation = item.location.replaceAll('City', cityName);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: item.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              item.gradientColors.first.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: item.badges.take(3).map((badge) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.gradientColors.first.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            item.gradientColors.first.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: item.gradientColors.first,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: Color(0xFF0F766E),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      localizedLocation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _CardActionButton(
                      label: 'Send Enquiry',
                      icon: Icons.send_rounded,
                      isPrimary: true,
                      onTap: onSendEnquiry,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (onCall != null) ...[
                    _CardIconButton(
                      icon: Icons.call_rounded,
                      onTap: onCall!,
                      tooltip: 'Call',
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (onDirections != null)
                    _CardIconButton(
                      icon: Icons.directions_rounded,
                      onTap: onDirections!,
                      tooltip: 'Directions',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LIVE FACILITY CARD (Libraries / Gyms from backend with dynamic status & images)
// -----------------------------------------------------------------------------
class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
    required this.facility,
    required this.isLibrary,
    required this.isFavorite,
    required this.cityName,
    required this.onToggleFavorite,
    required this.onTap,
    required this.onSendEnquiry,
    required this.onViewDetails,
    this.onCall,
    this.onDirections,
  });

  final FacilityModel facility;
  final bool isLibrary;
  final bool isFavorite;
  final String cityName;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;
  final VoidCallback onSendEnquiry;
  final VoidCallback onViewDetails;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final isOpen = facility.isOpenNow;
    final addressLine = facility.address ?? cityName;
    final cover = facility.coverImageUrl;
    final activeAmenities = facility.activeAmenities;
    final gradientColors = isLibrary
        ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
        : [const Color(0xFFEA580C), const Color(0xFFF97316)];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Cover Image or Gradient Header
              if (cover != null && cover.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(19)),
                      child: AppNetworkImage(
                        imageUrl: cover,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isOpen ? 'Open Now' : 'Closed',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (facility.distanceKm != null)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.near_me_rounded,
                                size: 11,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${facility.distanceKm!.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cover == null || cover.isEmpty)
                          Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors.first
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              isLibrary
                                  ? Icons.local_library_rounded
                                  : Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                facility.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isLibrary
                                    ? 'Public Library • $cityName'
                                    : 'Fitness & Gym • $cityName',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onToggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 22,
                              color: isFavorite
                                  ? const Color(0xFFE11D48)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Badges (Open/Closed if no cover, and kind)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (cover == null || cover.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isOpen
                                    ? const Color(0xFF86EFAC)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              isOpen ? 'Open Now' : 'Closed',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isOpen
                                    ? const Color(0xFF166534)
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        if (facility.openingTime != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 11,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${facility.openingTimeShort ?? facility.openingTime} - ${facility.closingTimeShort ?? facility.closingTime}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ...activeAmenities.take(2).map((a) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: gradientColors.first
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: gradientColors.first
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              a.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: gradientColors.first,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Address
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Color(0xFF0F766E),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            addressLine,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: _CardActionButton(
                            label: 'View Details',
                            icon: Icons.visibility_rounded,
                            isPrimary: true,
                            onTap: onViewDetails,
                          ),
                        ),
                        const SizedBox(width: 8),

                        _CardActionButton(
                          label: 'Enquiry',
                          icon: Icons.send_rounded,
                          isPrimary: false,
                          onTap: onSendEnquiry,
                        ),
                        const SizedBox(width: 8),

                        if (onCall != null) ...[
                          _CardIconButton(
                            icon: Icons.call_rounded,
                            onTap: onCall!,
                            tooltip: 'Call',
                          ),
                          const SizedBox(width: 8),
                        ],

                        if (onDirections != null)
                          _CardIconButton(
                            icon: Icons.directions_rounded,
                            onTap: onDirections!,
                            tooltip: 'Directions',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActionButton extends StatelessWidget {
  const _CardActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? const Color(0xFF0F766E) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isPrimary ? null : Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isPrimary ? Colors.white : const Color(0xFF374151),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isPrimary ? Colors.white : const Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  const _CardIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: Icon(
            icon,
            size: 15,
            color: const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}
