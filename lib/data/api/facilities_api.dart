import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/facility_model.dart';
import 'dio_client.dart';

part 'facilities_api.g.dart';

class FacilitiesApi {
  FacilitiesApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> list({
    required FacilityKind kind,
    String? search,
    String? cityId,
    String? location,
    String? status,
    String? sortBy,
    String? sortDir,
    int perPage = 15,
    int page = 1,
  }) {
    return _dio.get(
      '/facilities',
      queryParameters: {
        'category_slug': kind.pathSegment,
        if (search != null && search.isNotEmpty) 'search': search,
        if (cityId != null) 'city_id': cityId,
        if (location != null) 'location': location,
        if (status != null) 'status': status,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortDir != null) 'sort_dir': sortDir,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> nearbyLibraries({
    double? latitude,
    double? longitude,
    String? cityId,
    String? search,
    double? maxDistanceKm,
    int perPage = 15,
    int page = 1,
  }) {
    return _dio.get(
      '/facilities',
      queryParameters: {
        'category_slug': 'libraries',
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (maxDistanceKm != null) 'max_distance_km': maxDistanceKm,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> getById(FacilityKind kind, String id) =>
      _dio.get('/facilities/$id');

  /// Returns a plain JSON array, not the standard paginated envelope.
  Future<Response<dynamic>> feePlans(FacilityKind kind, String facilityId) =>
      _dio.get('/facilities/$facilityId/fee-plans');

  /// Returns active & enrolled memberships for current user across gyms, libraries, and activities.
  Future<Response<dynamic>> myMemberships() => _dio.get('/user/memberships');
}

@Riverpod(keepAlive: true)
FacilitiesApi facilitiesApi(Ref ref) => FacilitiesApi(ref.watch(dioProvider));
