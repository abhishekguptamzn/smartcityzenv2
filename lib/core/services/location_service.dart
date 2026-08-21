import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

class UserCoordinates {
  const UserCoordinates({
    required this.latitude,
    required this.longitude,
    this.isExactGps = true,
  });

  final double latitude;
  final double longitude;
  final bool isExactGps;
}

class LocationService {
  LocationService();

  Future<UserCoordinates?> getCurrentLocation({bool requestPermission = true}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 6),
        ),
      );

      return UserCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        isExactGps: true,
      );
    } catch (e) {
      debugPrint('LocationService getCurrentLocation error: $e');
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          return UserCoordinates(
            latitude: last.latitude,
            longitude: last.longitude,
            isExactGps: false,
          );
        }
      } catch (_) {}
      return null;
    }
  }

  /// Calculates distance in kilometers between two GPS coordinates.
  double? calculateDistanceKm({
    required double? startLat,
    required double? startLng,
    required double? endLat,
    required double? endLng,
  }) {
    if (startLat == null || startLng == null || endLat == null || endLng == null) {
      return null;
    }
    final meters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return meters / 1000.0;
  }

  /// Human-friendly distance label (e.g. "450 m away", "1.2 km away").
  String? formatDistance(double? distanceKm) {
    if (distanceKm == null) return null;
    if (distanceKm < 1.0) {
      final meters = (distanceKm * 1000).round();
      return '$meters m away';
    }
    return '${distanceKm.toStringAsFixed(1)} km away';
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationService();
}

@riverpod
Future<UserCoordinates?> currentUserCoordinates(Ref ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentLocation();
}
