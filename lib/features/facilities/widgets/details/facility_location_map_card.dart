import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_controller.dart';
import '../../../../core/providers/cities_providers.dart';
import '../../../../core/services/location_service.dart';
import '../../../../data/models/city_model.dart';
import '../../../../data/models/facility_model.dart';

class FacilityLocationMapCard extends ConsumerWidget {
  const FacilityLocationMapCard({
    super.key,
    required this.facility,
    required this.onOpenDirections,
  });

  final FacilityModel facility;
  final VoidCallback onOpenDirections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final address = facility.address ?? 'Address provided upon booking';

    final locSvc = ref.read(locationServiceProvider);
    final userCoords = ref.watch(currentUserCoordinatesProvider).value ?? locSvc.cachedCoordinates;
    final selectedCity = ref.watch(selectedCityProvider);
    final currentUser = ref.watch(authControllerProvider).value;
    final effectiveCity = selectedCity ?? currentUser?.city;
    final cities = ref.watch(citiesListProvider).value ?? const [];

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

    double? userLat = userCoords?.latitude ?? locSvc.cachedCoordinates?.latitude ?? effectiveCity?.latitude ?? 28.611033;
    double? userLng = userCoords?.longitude ?? locSvc.cachedCoordinates?.longitude ?? effectiveCity?.longitude ?? 77.442592;

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                    if (distance != null && distance.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.near_me_rounded,
                            size: 13,
                            color: Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: const Text('Copy Address', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onOpenDirections,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.directions_rounded, size: 16),
                  label: const Text('Get Directions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
