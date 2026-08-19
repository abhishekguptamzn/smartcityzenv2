import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'activities_api.g.dart';

class ActivitiesApi {
  ActivitiesApi(this._dio);

  final Dio _dio;

  /// GET /api/v1/activity-categories
  Future<Response<dynamic>> categories() => _dio.get('/activity-categories');

  /// GET /api/v1/activities
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
      '/activities',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
        if (type != null && type.isNotEmpty) 'type': type,
        if (typeId != null && typeId.isNotEmpty) 'type_id': typeId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
        if (featured != null) 'featured': featured ? 1 : 0,
        if (minRating != null) 'min_rating': minRating,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (radius != null) 'radius': radius,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortDir != null) 'sort_dir': sortDir,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  /// GET /api/v1/activities/{id}
  Future<Response<dynamic>> getById(String id) => _dio.get('/activities/$id');

  /// GET /api/v1/activities/{id}/batches
  Future<Response<dynamic>> batches(String activityId) =>
      _dio.get('/activities/$activityId/batches');

  /// GET /api/v1/activities/{id}/instructors
  Future<Response<dynamic>> instructors(String activityId) =>
      _dio.get('/activities/$activityId/instructors');

  /// GET /api/v1/activities/{id}/fee-plans
  Future<Response<dynamic>> feePlans(String activityId) =>
      _dio.get('/activities/$activityId/fee-plans');

  /// GET /api/v1/activities/{id}/reviews
  Future<Response<dynamic>> reviews(String activityId, {int page = 1, int perPage = 20}) =>
      _dio.get('/activities/$activityId/reviews', queryParameters: {'page': page, 'per_page': perPage});

  /// POST /api/v1/activities/{id}/reviews
  Future<Response<dynamic>> submitReview(String activityId, {required int rating, String? comment, String? title}) =>
      _dio.post('/activities/$activityId/reviews', data: {'rating': rating, if (comment != null) 'comment': comment, if (title != null) 'title': title});

  /// POST /api/v1/activities/{id}/enrollments
  Future<Response<dynamic>> enroll(String activityId, Map<String, dynamic> data) =>
      _dio.post('/activities/$activityId/enrollments', data: data);

  /// GET /api/v1/user/activity-enrollments
  Future<Response<dynamic>> myEnrollments({int page = 1, int perPage = 20}) =>
      _dio.get('/user/activity-enrollments', queryParameters: {'page': page, 'per_page': perPage});

  /// POST /api/v1/activities/{id}/attendance/check-in
  Future<Response<dynamic>> checkIn(String activityId, {required String enrollmentId, String? batchId}) =>
      _dio.post('/activities/$activityId/attendance/check-in', data: {'enrollment_id': enrollmentId, if (batchId != null) 'batch_id': batchId});

  /// POST /api/v1/activities/{id}/attendance/check-out
  Future<Response<dynamic>> checkOut(String activityId, {required String attendanceId}) =>
      _dio.post('/activities/$activityId/attendance/check-out', data: {'attendance_id': attendanceId});
}

@Riverpod(keepAlive: true)
ActivitiesApi activitiesApi(Ref ref) => ActivitiesApi(ref.watch(dioProvider));
