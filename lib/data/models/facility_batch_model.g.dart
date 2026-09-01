// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacilityBatchModel _$FacilityBatchModelFromJson(Map<String, dynamic> json) =>
    _FacilityBatchModel(
      id: json['id'] as String,
      facilityId: json['facility_id'] as String,
      instructorId: json['instructor_id'] as String?,
      name: json['name'] as String,
      category: json['category'] as String?,
      room: json['room'] as String?,
      description: json['description'] as String?,
      capacity: (json['capacity'] as num?)?.toInt() ?? 30,
      enrolledCount: (json['enrolled_count'] as num?)?.toInt() ?? 0,
      availableSpots: (json['available_spots'] as num?)?.toInt() ?? 0,
      isFull: json['is_full'] as bool? ?? false,
      fee: _toDouble(json['fee']),
      feePlanId: json['fee_plan_id'] as String?,
      feePlan: json['fee_plan'] == null
          ? null
          : FeePlanModel.fromJson(json['fee_plan'] as Map<String, dynamic>),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      daysOfWeek:
          (json['days_of_week'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      recurringDaysFormatted: json['recurring_days_formatted'] as String?,
      defaultCheckoutTime: json['default_checkout_time'] as String?,
      autoCheckoutBufferMinutes:
          (json['auto_checkout_buffer_minutes'] as num?)?.toInt() ?? 15,
      status: json['status'] as String? ?? 'active',
      enrollmentRules: json['enrollment_rules'] as String?,
      allowWaitlist: json['allow_waitlist'] as bool? ?? false,
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FacilityBatchModelToJson(_FacilityBatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facility_id': instance.facilityId,
      'instructor_id': instance.instructorId,
      'name': instance.name,
      'category': instance.category,
      'room': instance.room,
      'description': instance.description,
      'capacity': instance.capacity,
      'enrolled_count': instance.enrolledCount,
      'available_spots': instance.availableSpots,
      'is_full': instance.isFull,
      'fee': instance.fee,
      'fee_plan_id': instance.feePlanId,
      'fee_plan': instance.feePlan,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'days_of_week': instance.daysOfWeek,
      'recurring_days_formatted': instance.recurringDaysFormatted,
      'default_checkout_time': instance.defaultCheckoutTime,
      'auto_checkout_buffer_minutes': instance.autoCheckoutBufferMinutes,
      'status': instance.status,
      'enrollment_rules': instance.enrollmentRules,
      'allow_waitlist': instance.allowWaitlist,
      'instructor': instance.instructor,
      'schedules': instance.schedules,
      'created_at': instance.createdAt?.toIso8601String(),
    };
