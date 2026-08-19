// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityBatchModel _$ActivityBatchModelFromJson(Map<String, dynamic> json) =>
    _ActivityBatchModel(
      id: json['id'] as String,
      activityId: json['activity_id'] as String,
      instructorId: json['instructor_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      ageGroup: json['age_group'] as String?,
      skillLevel: json['skill_level'] as String?,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      activeEnrollmentsCount:
          (json['active_enrollments_count'] as num?)?.toInt() ?? 0,
      availableSpots: (json['available_spots'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'active',
      instructor: json['instructor'] == null
          ? null
          : ActivityInstructorModel.fromJson(
              json['instructor'] as Map<String, dynamic>,
            ),
      schedules:
          (json['schedules'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ActivityScheduleModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ActivityBatchModelToJson(_ActivityBatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activity_id': instance.activityId,
      'instructor_id': instance.instructorId,
      'name': instance.name,
      'description': instance.description,
      'age_group': instance.ageGroup,
      'skill_level': instance.skillLevel,
      'capacity': instance.capacity,
      'active_enrollments_count': instance.activeEnrollmentsCount,
      'available_spots': instance.availableSpots,
      'status': instance.status,
      'instructor': instance.instructor,
      'schedules': instance.schedules,
    };
