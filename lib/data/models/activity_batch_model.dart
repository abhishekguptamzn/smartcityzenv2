import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_instructor_model.dart';
import 'activity_schedule_model.dart';

part 'activity_batch_model.freezed.dart';
part 'activity_batch_model.g.dart';

@freezed
abstract class ActivityBatchModel with _$ActivityBatchModel {
  const factory ActivityBatchModel({
    required String id,
    @JsonKey(name: 'activity_id') required String activityId,
    @JsonKey(name: 'instructor_id') String? instructorId,
    required String name,
    String? description,
    @JsonKey(name: 'age_group') String? ageGroup,
    @JsonKey(name: 'skill_level') String? skillLevel,
    @Default(0) int capacity,
    @JsonKey(name: 'active_enrollments_count') @Default(0) int activeEnrollmentsCount,
    @JsonKey(name: 'available_spots') int? availableSpots,
    @Default('active') String status,
    ActivityInstructorModel? instructor,
    @Default([]) List<ActivityScheduleModel> schedules,
  }) = _ActivityBatchModel;

  factory ActivityBatchModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityBatchModelFromJson(json);
}
