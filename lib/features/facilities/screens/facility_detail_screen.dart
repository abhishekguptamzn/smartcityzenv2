import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/activities_providers.dart';
import '../../../core/providers/facilities_providers.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/details/facility_amenities_grid.dart';
import '../widgets/details/facility_fee_plans_card.dart';
import '../widgets/details/facility_hero_gallery.dart';
import '../widgets/details/facility_location_map_card.dart';
import '../widgets/details/facility_quick_actions_row.dart';
import '../widgets/details/facility_sticky_cta_bar.dart';
import '../widgets/details/facility_timings_card.dart';
import '../widgets/send_enquiry_sheet.dart';

class FacilityDetailScreen extends ConsumerStatefulWidget {
  const FacilityDetailScreen({
    super.key,
    required this.kind,
    required this.id,
  });

  final FacilityKind kind;
  final String id;

  @override
  ConsumerState<FacilityDetailScreen> createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends ConsumerState<FacilityDetailScreen> {
  bool _isFavorite = false;

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openDirections(FacilityModel facility) async {
    if (facility.latitude != null && facility.longitude != null) {
      final uri = Uri.parse('geo:${facility.latitude},${facility.longitude}?q=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
      final webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (facility.address != null && facility.address!.isNotEmpty) {
      final query = Uri.encodeComponent(facility.address!);
      final webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _shareFacility(FacilityModel facility) {
    Clipboard.setData(ClipboardData(text: 'Check out ${facility.name} on Smart CityZen!'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Facility details copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch details based on kind
    final AsyncValue<FacilityModel> detailAsync;
    if (widget.kind == FacilityKind.activity) {
      final actAsync = ref.watch(activityDetailsProvider(widget.id));
      detailAsync = actAsync.whenData((act) {
        return FacilityModel(
          id: act.id,
          name: act.name,
          description: act.description,
          address: act.address,
          cityId: act.cityId,
          city: act.city,
          latitude: act.latitude,
          longitude: act.longitude,
          imageUrl: act.imageUrl,
          images: act.mediaUrls.map((u) => <String, dynamic>{'url': u}).toList(),
          amenities: act.amenities,
          contactPhone: act.contactPhone,
          contactEmail: act.contactEmail,
          openingTime: act.openingTime,
          closingTime: act.closingTime,
          status: act.status,
          kind: FacilityKind.activity,
        );
      });
    } else {
      detailAsync = ref.watch(facilityDetailProvider(widget.kind, widget.id));
    }

    final feePlansAsync = ref.watch(facilityFeePlansProvider(widget.kind, widget.id));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/services');
            }
          },
        ),
        title: Text(
          widget.kind.displayName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? const Color(0xFFE11D48) : null,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              final val = detailAsync.value;
              if (val != null) _shareFacility(val);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => ErrorStateView(
          error: error,
          onRetry: () {
            if (widget.kind == FacilityKind.activity) {
              ref.invalidate(activityDetailsProvider(widget.id));
            } else {
              ref.invalidate(facilityDetailProvider(widget.kind, widget.id));
            }
          },
        ),
        data: (facility) {
          final gallery = facility.galleryImageUrls;
          final isOpen = facility.isOpenNow;
          final activeAmenities = facility.activeAmenities;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    // 1. Hero Photo Gallery Carousel & Status Badges
                    FacilityHeroGallery(
                      facility: facility,
                      galleryUrls: gallery,
                      isOpen: isOpen,
                      isFavorite: _isFavorite,
                      onToggleFavorite: () => setState(() => _isFavorite = !_isFavorite),
                    ),
                    const SizedBox(height: 16),

                    // 2. Title & City / Address Header
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 15,
                                    color: Color(0xFF0F766E),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      facility.address ?? 'Registered Center',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 3. Quick Action Buttons Row
                    FacilityQuickActionsRow(
                      phone: facility.contactPhone,
                      onCall: facility.contactPhone != null
                          ? () => _makeCall(facility.contactPhone!)
                          : null,
                      onDirections: () => _openDirections(facility),
                      onShare: () => _shareFacility(facility),
                      onSendEnquiry: () => _openEnquirySheet(facility),
                    ),
                    const SizedBox(height: 22),

                    // 4. About Section & Description
                    _buildSectionHeader(
                      icon: Icons.info_outline_rounded,
                      title: 'About Facility',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (facility.description != null && facility.description!.trim().isNotEmpty)
                          ? facility.description!
                          : (widget.kind == FacilityKind.library
                              ? 'Modern public study hub featuring quiet reading rooms, high-speed digital Wi-Fi, reference collections, and discussion lounges.'
                              : (widget.kind == FacilityKind.gym
                                  ? 'State-of-the-art gym and fitness center equipped with certified trainers, strength machines, cardio stations, and locker facilities.'
                                  : 'Premier civic academy offering structured batch coaching, modern equipment, and certified instructors.')),
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 5. Operating Hours Schedule
                    _buildSectionHeader(
                      icon: Icons.schedule_rounded,
                      title: 'Operating Hours',
                    ),
                    const SizedBox(height: 10),
                    FacilityTimingsCard(
                      facility: facility,
                      isOpen: isOpen,
                    ),
                    const SizedBox(height: 22),

                    // 6. Amenities & Features Grid
                    _buildSectionHeader(
                      icon: Icons.stars_rounded,
                      title: 'Amenities & Features',
                    ),
                    const SizedBox(height: 10),
                    FacilityAmenitiesGrid(amenities: activeAmenities),
                    const SizedBox(height: 22),

                    // 7. Fee Plans & Membership Packages
                    _buildSectionHeader(
                      icon: Icons.card_membership_rounded,
                      title: 'Membership & Pricing Plans',
                    ),
                    const SizedBox(height: 10),
                    feePlansAsync.when(
                      loading: () => const Center(child: LoadingIndicator()),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (plans) => FacilityFeePlansCard(
                        feePlans: plans,
                        onSelectPlan: (p) => _openEnquirySheet(facility),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 8. Location & Navigation Map
                    _buildSectionHeader(
                      icon: Icons.map_rounded,
                      title: 'Location & Directions',
                    ),
                    const SizedBox(height: 10),
                    FacilityLocationMapCard(
                      facility: facility,
                      onOpenDirections: () => _openDirections(facility),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // 9. Sticky CTA Bar
              FacilityStickyCtaBar(
                facility: facility,
                onSendEnquiry: () => _openEnquirySheet(facility),
                onPrimaryAction: widget.kind == FacilityKind.gym
                    ? () => context.push('/checkin')
                    : () => _openEnquirySheet(facility),
                primaryActionLabel: widget.kind == FacilityKind.gym
                    ? 'Quick QR Check-in'
                    : 'Enroll / Join',
                primaryActionIcon: widget.kind == FacilityKind.gym
                    ? Icons.qr_code_scanner_rounded
                    : Icons.how_to_reg_rounded,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F766E).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF0F766E)),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  void _openEnquirySheet(FacilityModel facility) {
    SendEnquirySheet.show(
      context,
      facilityId: facility.id,
      facilityKind: facility.kind,
      facilityTitle: facility.name,
      facilitySubtitle: facility.address,
      categoryName: facility.kind.displayName,
      facilityPhone: facility.contactPhone,
      facilityEmail: facility.contactEmail,
    );
  }
}
