import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_instructor_model.dart';
import 'activity_schedule_model.dart';
import 'fee_plan_model.dart';

part 'facility_batch_model.freezed.dart';
part 'facility_batch_model.g.dart';

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@freezed
abstract class FacilityBatchModel with _$FacilityBatchModel {
  const FacilityBatchModel._();

  const factory FacilityBatchModel({
    required String id,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'instructor_id') String? instructorId,
    required String name,
    String? category,
    String? room,
    String? description,
    @Default(30) int capacity,
    @JsonKey(name: 'enrolled_count') @Default(0) int enrolledCount,
    @JsonKey(name: 'available_spots') @Default(0) int availableSpots,
    @JsonKey(name: 'is_full') @Default(false) bool isFull,
    @JsonKey(fromJson: _toDouble) double? fee,
    @JsonKey(name: 'fee_plan_id') String? feePlanId,
    @JsonKey(name: 'fee_plan') FeePlanModel? feePlan,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'days_of_week') @Default([]) List<int> daysOfWeek,
    @JsonKey(name: 'recurring_days_formatted') String? recurringDaysFormatted,
    @JsonKey(name: 'default_checkout_time') String? defaultCheckoutTime,
    @JsonKey(name: 'auto_checkout_buffer_minutes') @Default(15) int autoCheckoutBufferMinutes,
    @Default('active') String status,
    @JsonKey(name: 'enrollment_rules') String? enrollmentRules,
    @JsonKey(name: 'allow_waitlist') @Default(false) bool allowWaitlist,
    ActivityInstructorModel? instructor,
    @Default([]) List<ActivityScheduleModel> schedules,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FacilityBatchModel;

  factory FacilityBatchModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityBatchModelFromJson(json);

  String get timingDisplay {
    if (startTime != null && endTime != null) {
      final s = startTime!.length >= 5 ? startTime!.substring(0, 5) : startTime!;
      final e = endTime!.length >= 5 ? endTime!.substring(0, 5) : endTime!;
      return '$s - $e';
    }
    return 'Flexible Timings';
  }

  String get feeDisplay {
    if (fee != null && fee! > 0) {
      return '₹${fee!.toStringAsFixed(0)}';
    }
    if (feePlan != null) {
      return '₹${feePlan!.amount.toStringAsFixed(0)}';
    }
    return 'Free / Included';
  }
}
