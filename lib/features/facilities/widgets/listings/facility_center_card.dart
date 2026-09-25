import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_controller.dart';
import '../../../../core/providers/cities_providers.dart';
import '../../../../core/services/location_service.dart';
import '../../../../data/models/city_model.dart';
import '../../../../data/models/facility_model.dart';
import '../../../../shared/widgets/app_network_image.dart';

class FacilityCenterCard extends ConsumerWidget {
  const FacilityCenterCard({
    super.key,
    required this.facility,
    required this.onTap,
    required this.onViewDetails,
    required this.onSendEnquiry,
    this.onCall,
    this.onDirections,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  final FacilityModel facility;
  final VoidCallback onTap;
  final VoidCallback onViewDetails;
  final VoidCallback onSendEnquiry;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = facility.isOpenNow;
    final cover = facility.coverImageUrl;
    final amenities = facility.activeAmenities;

    // Dynamic distance calculated directly from user's live GPS location
    final locSvc = ref.read(locationServiceProvider);
    final userCoords = ref.watch(currentUserCoordinatesProvider).value ?? locSvc.cachedCoordinates;
    final selectedCity = ref.watch(selectedCityProvider);
    final currentUser = ref.watch(authControllerProvider).value;
    final effectiveCity = selectedCity ?? currentUser?.city;
    final cities = ref.watch(citiesListProvider).value ?? const [];

    // Resolve facility coordinates
    double? facilityLat = facility.effectiveLatitude;
    double? facilityLng = facility.effectiveLongitude;

    if (facilityLat == null || facilityLng == null) {
      if (facility.cityId != null && cities.isNotEmpty) {
        final matched = cities.firstWhere(
          (c) => c.id == facility.cityId,
          orElse: () => const CityModel(id: '', name: '', state: ''),
        );
        facilityLat = matched.latitude;
        facilityLng = matched.longitude;
      }
    }

    facilityLat ??= effectiveCity?.latitude ?? 29.4727;
    facilityLng ??= effectiveCity?.longitude ?? 77.7085;

    // Resolve user coordinates: live hardware GPS first, then cached GPS, then city, then default
    double? userLat = userCoords?.latitude ?? locSvc.cachedCoordinates?.latitude;
    double? userLng = userCoords?.longitude ?? locSvc.cachedCoordinates?.longitude;

    if (userLat == null || userLng == null) {
      userLat = effectiveCity?.latitude ?? 28.611033;
      userLng = effectiveCity?.longitude ?? 77.442592;
    }

    String? distance = facility.distanceFormatted;
    final distKm = locSvc.calculateDistanceKm(
      startLat: userLat,
      startLng: userLng,
      endLat: facilityLat,
      endLng: facilityLng,
    );
    if (distKm != null) {
      distance = locSvc.formatDistance(distKm);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cover Image with Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: cover != null
                          ? AppNetworkImage(
                              imageUrl: cover,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE0F2FE),
                              child: Icon(
                                facility.kind == FacilityKind.library
                                    ? Icons.local_library_rounded
                                    : (facility.kind == FacilityKind.gym
                                        ? Icons.fitness_center_rounded
                                        : Icons.sports_kabaddi_rounded),
                                size: 48,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                    ),
                  ),

                  // Gradient Scrim for readable badges
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x55000000),
                            Colors.transparent,
                            Color(0x77000000),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top Left: Live Open / Closed Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: (isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626))
                            .withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
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
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isOpen ? 'OPEN NOW' : 'CLOSED',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top Right: Favorite Action
                  if (onToggleFavorite != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onToggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 18,
                              color: isFavorite ? const Color(0xFFFB7185) : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Bottom Left: Distance Badge (Live GPS)
                  if (distance != null && distance.isNotEmpty)
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xE60F172A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0x6638BDF8),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x55000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              size: 12,
                              color: Color(0xFF38BDF8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // 2. Card Content & Details
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            facility.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            facility.kind.displayName,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Address & Distance
                    if (facility.address != null && facility.address!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              facility.address!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (distance != null && distance.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7).withValues(alpha: isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF38BDF8).withValues(alpha: isDark ? 0.4 : 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    size: 11,
                                    color: Color(0xFF0284C7),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    distance,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    const SizedBox(height: 4),

                    // Operating Hours
                    if (facility.openingTime != null && facility.closingTime != null)
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${facility.openingTimeShort ?? facility.openingTime} - ${facility.closingTimeShort ?? facility.closingTime}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),

                    // Amenities Tags Preview
                    if (amenities.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          ...amenities.take(3).map(
                                (a) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    a.name,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? const Color(0xFFE2E8F0)
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ),
                          if (amenities.length > 3)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '+${amenities.length - 3} more',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // 3. Bottom Action Buttons
                    Row(
                      children: [
                        if (onCall != null && facility.contactPhone != null) ...[
                          _CircleAction(
                            icon: Icons.phone_rounded,
                            tooltip: 'Call Center',
                            onTap: onCall!,
                            color: const Color(0xFF059669),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (onDirections != null) ...[
                          _CircleAction(
                            icon: Icons.directions_rounded,
                            tooltip: 'Directions',
                            onTap: onDirections!,
                            color: const Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 8),
                        ],
                        _CircleAction(
                          icon: Icons.contact_mail_outlined,
                          tooltip: 'Send Enquiry',
                          onTap: onSendEnquiry,
                          color: const Color(0xFFD97706),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: onViewDetails,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.visibility_rounded, size: 15),
                          label: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
