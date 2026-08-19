import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/activities_api.dart';
import '../models/activity_batch_model.dart';
import '../models/activity_category_model.dart';
import '../models/activity_enrollment_model.dart';
import '../models/activity_instructor_model.dart';
import '../models/activity_model.dart';
import '../models/activity_review_model.dart';
import '../models/fee_plan_model.dart';
import '../models/pagination_meta.dart';

part 'activities_repository.g.dart';

class ActivitiesRepository {
  ActivitiesRepository(this._api);

  final ActivitiesApi _api;

  /// Fetch all activity categories with sub-types
  Future<List<ActivityCategoryModel>> categories() async {
    final response = await _api.categories();
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ActivityCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Paginated activity directory listing
  Future<Paginated<ActivityModel>> list({
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
  }) async {
    final response = await _api.list(
      category: category,
      categoryId: categoryId,
      type: type,
      typeId: typeId,
      search: search,
      cityId: cityId,
      featured: featured,
      minRating: minRating,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      sortBy: sortBy,
      sortDir: sortDir,
      perPage: perPage,
      page: page,
    );

    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      (json) => ActivityModel.fromJson(json),
    );
  }

  /// Single activity deep details
  Future<ActivityModel> getById(String id) async {
    final response = await _api.getById(id);
    final data = response.data['data'] as Map<String, dynamic>;
    return ActivityModel.fromJson(data);
  }

  /// Batches for an activity
  Future<List<ActivityBatchModel>> batches(String activityId) async {
    final response = await _api.batches(activityId);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ActivityBatchModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Instructors for an activity
  Future<List<ActivityInstructorModel>> instructors(String activityId) async {
    final response = await _api.instructors(activityId);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ActivityInstructorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fee plans for an activity
  Future<List<FeePlanModel>> feePlans(String activityId) async {
    final response = await _api.feePlans(activityId);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => FeePlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Paginated reviews for an activity
  Future<Paginated<ActivityReviewModel>> reviews(String activityId, {int page = 1, int perPage = 20}) async {
    final response = await _api.reviews(activityId, page: page, perPage: perPage);
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      (json) => ActivityReviewModel.fromJson(json),
    );
  }

  /// Submit review
  Future<ActivityReviewModel> submitReview(
    String activityId, {
    required int rating,
    String? comment,
    String? title,
  }) async {
    final response = await _api.submitReview(
      activityId,
      rating: rating,
      comment: comment,
      title: title,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ActivityReviewModel.fromJson(data);
  }

  /// Enroll in an activity batch
  Future<ActivityEnrollmentModel> enroll(String activityId, Map<String, dynamic> data) async {
    final response = await _api.enroll(activityId, data);
    final resData = response.data['data'] as Map<String, dynamic>;
    return ActivityEnrollmentModel.fromJson(resData);
  }

  /// Get citizen's active activity passes & enrollments
  Future<Paginated<ActivityEnrollmentModel>> myEnrollments({int page = 1, int perPage = 20}) async {
    final response = await _api.myEnrollments(page: page, perPage: perPage);
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      (json) => ActivityEnrollmentModel.fromJson(json),
    );
  }

  /// Attendance turnstile check-in
  Future<dynamic> checkIn(String activityId, {required String enrollmentId, String? batchId}) async {
    final response = await _api.checkIn(activityId, enrollmentId: enrollmentId, batchId: batchId);
    return response.data['data'];
  }

  /// Attendance turnstile check-out
  Future<dynamic> checkOut(String activityId, {required String attendanceId}) async {
    final response = await _api.checkOut(activityId, attendanceId: attendanceId);
    return response.data['data'];
  }
}

@Riverpod(keepAlive: true)
ActivitiesRepository activitiesRepository(Ref ref) =>
    ActivitiesRepository(ref.watch(activitiesApiProvider));
