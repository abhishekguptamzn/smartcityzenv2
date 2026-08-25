import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'activities_api.g.dart';

class ActivitiesApi {
  ActivitiesApi(this._dio);

  final Dio _dio;

  /// GET /api/v1/facility-categories
  Future<Response<dynamic>> categories() => _dio.get('/facility-categories');

  /// GET /api/v1/facilities
  Future<Response<dynamic>> list({
    String? category,
    String? categoryId,
    String? type,
    String? typeId,
    String? search,
    String? cityId,
    bool? featured,
    double? minRating,
    double? latitude,
    double? longitude,
    double? radius,
    String? sortBy,
    String? sortDir,
    int perPage = 15,
    int page = 1,
  }) {
    return _dio.get(
      '/facilities',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category_slug': category,
        if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
        if (type != null && type.isNotEmpty) 'type_slug': type,
        if (typeId != null && typeId.isNotEmpty) 'type_id': typeId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
        if (featured != null) 'is_featured': featured ? 1 : 0,
        if (minRating != null) 'min_rating': minRating,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (radius != null) 'max_distance_km': radius,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortDir != null) 'sort_dir': sortDir,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  /// GET /api/v1/facilities/{id}
  Future<Response<dynamic>> getById(String id) => _dio.get('/facilities/$id');

  /// GET /api/v1/facilities/{id}/batches
  Future<Response<dynamic>> batches(String activityId) =>
      _dio.get('/facilities/$activityId/batches');

  /// GET /api/v1/facilities/{id}/instructors
  Future<Response<dynamic>> instructors(String activityId) =>
      _dio.get('/facilities/$activityId/instructors');

  /// GET /api/v1/facilities/{id}/fee-plans
  Future<Response<dynamic>> feePlans(String activityId) =>
      _dio.get('/facilities/$activityId/fee-plans');

  /// GET /api/v1/facilities/{id}/reviews
  Future<Response<dynamic>> reviews(String activityId, {int page = 1, int perPage = 20}) =>
      _dio.get('/facilities/$activityId/reviews', queryParameters: {'page': page, 'per_page': perPage});

  /// POST /api/v1/facilities/{id}/reviews
  Future<Response<dynamic>> submitReview(String activityId, {required int rating, String? comment, String? title}) =>
      _dio.post('/facilities/$activityId/reviews', data: {'rating': rating, if (comment != null) 'comment': comment, if (title != null) 'title': title});

  /// POST /api/v1/facilities/{id}/members
  Future<Response<dynamic>> enroll(String activityId, Map<String, dynamic> data) =>
      _dio.post('/facilities/$activityId/members', data: data);

  /// GET /api/v1/user/activity-enrollments
  Future<Response<dynamic>> myEnrollments({int page = 1, int perPage = 20}) =>
      _dio.get('/user/memberships', queryParameters: {'page': page, 'per_page': perPage});

  /// POST /api/v1/facilities/{id}/attendance/check-in
  Future<Response<dynamic>> checkIn(String activityId, {required String enrollmentId, String? batchId}) =>
      _dio.post('/facilities/$activityId/attendance/check-in', data: {'enrollment_id': enrollmentId, if (batchId != null) 'batch_id': batchId});

  /// POST /api/v1/facilities/{id}/attendance/check-out
  Future<Response<dynamic>> checkOut(String activityId, {required String attendanceId}) =>
      _dio.post('/facilities/$activityId/attendance/check-out', data: {'attendance_id': attendanceId});
}

@Riverpod(keepAlive: true)
ActivitiesApi activitiesApi(Ref ref) => ActivitiesApi(ref.watch(dioProvider));
