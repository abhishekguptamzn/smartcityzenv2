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
  LocationService() {
    _initFastLocation();
  }

  static UserCoordinates? _cachedCoordinates;

  void _initFastLocation() {
    Geolocator.getLastKnownPosition().then((last) {
      if (last != null) {
        _cachedCoordinates = UserCoordinates(
          latitude: last.latitude,
          longitude: last.longitude,
          isExactGps: true,
        );
      }
    }).catchError((_) {});
  }

  UserCoordinates? get cachedCoordinates => _cachedCoordinates;

  Future<UserCoordinates?> getCurrentLocation({bool requestPermission = true}) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _cachedCoordinates;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _cachedCoordinates;
      }

      // Fast path: Immediately check last known position from OS (returns in ~5ms)
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          _cachedCoordinates = UserCoordinates(
            latitude: last.latitude,
            longitude: last.longitude,
            isExactGps: true,
          );
        }
      } catch (_) {}

      // If we already have live coordinates, return them immediately and update in background
      if (_cachedCoordinates != null) {
        Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 4),
          ),
        ).then((position) {
          _cachedCoordinates = UserCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            isExactGps: true,
          );
        }).catchError((_) {});

        return _cachedCoordinates;
      }

      // Otherwise await fresh GPS fix
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      _cachedCoordinates = UserCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        isExactGps: true,
      );

      return _cachedCoordinates;
    } catch (e) {
      debugPrint('LocationService getCurrentLocation error: $e');
      return _cachedCoordinates;
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

  /// Live position stream when user moves.
  Stream<UserCoordinates> get positionStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 25,
      ),
    ).map((pos) {
      final coords = UserCoordinates(
        latitude: pos.latitude,
        longitude: pos.longitude,
        isExactGps: true,
      );
      _cachedCoordinates = coords;
      return coords;
    });
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationService();
}

@Riverpod(keepAlive: true)
Future<UserCoordinates?> currentUserCoordinates(Ref ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentLocation();
}
