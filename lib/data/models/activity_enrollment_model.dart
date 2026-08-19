import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_batch_model.dart';
import 'fee_plan_model.dart';

part 'activity_enrollment_model.freezed.dart';
part 'activity_enrollment_model.g.dart';

@freezed
abstract class ActivityEnrollmentModel with _$ActivityEnrollmentModel {
  const factory ActivityEnrollmentModel({
    required String id,
    @JsonKey(name: 'activity_id') required String activityId,
    @JsonKey(name: 'activity_name') String? activityName,
    @JsonKey(name: 'activity_address') String? activityAddress,
    @JsonKey(name: 'activity_image_url') String? activityImageUrl,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_phone') String? userPhone,
    @JsonKey(name: 'batch_id') String? batchId,
    @JsonKey(name: 'batch_name') String? batchName,
    @JsonKey(name: 'fee_plan_id') String? feePlanId,
    @JsonKey(name: 'fee_plan_name') String? feePlanName,
    @JsonKey(name: 'enrollment_type') @Default('monthly') String enrollmentType,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    @JsonKey(name: 'days_remaining') int? daysRemaining,
    @JsonKey(name: 'is_active_now') @Default(true) bool isActiveNow,
    @Default('active') String status,
    @JsonKey(name: 'qr_code_token') String? qrCodeToken,
    ActivityBatchModel? batch,
    FeePlanModel? feePlan,
  }) = _ActivityEnrollmentModel;

  factory ActivityEnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityEnrollmentModelFromJson(json);
}
