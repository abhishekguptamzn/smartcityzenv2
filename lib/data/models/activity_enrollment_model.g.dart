// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_enrollment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityEnrollmentModel _$ActivityEnrollmentModelFromJson(
  Map<String, dynamic> json,
) => _ActivityEnrollmentModel(
  id: json['id'] as String,
  activityId: json['activity_id'] as String,
  activityName: json['activity_name'] as String?,
  activityAddress: json['activity_address'] as String?,
  activityImageUrl: json['activity_image_url'] as String?,
  userId: json['user_id'] as String,
  userName: json['user_name'] as String?,
  userEmail: json['user_email'] as String?,
  userPhone: json['user_phone'] as String?,
  batchId: json['batch_id'] as String?,
  batchName: json['batch_name'] as String?,
  feePlanId: json['fee_plan_id'] as String?,
  feePlanName: json['fee_plan_name'] as String?,
  enrollmentType: json['enrollment_type'] as String? ?? 'monthly',
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  daysRemaining: (json['days_remaining'] as num?)?.toInt(),
  isActiveNow: json['is_active_now'] as bool? ?? true,
  status: json['status'] as String? ?? 'active',
  qrCodeToken: json['qr_code_token'] as String?,
  batch: json['batch'] == null
      ? null
      : ActivityBatchModel.fromJson(json['batch'] as Map<String, dynamic>),
  feePlan: json['feePlan'] == null
      ? null
      : FeePlanModel.fromJson(json['feePlan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ActivityEnrollmentModelToJson(
  _ActivityEnrollmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'activity_id': instance.activityId,
  'activity_name': instance.activityName,
  'activity_address': instance.activityAddress,
  'activity_image_url': instance.activityImageUrl,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'user_email': instance.userEmail,
  'user_phone': instance.userPhone,
  'batch_id': instance.batchId,
  'batch_name': instance.batchName,
  'fee_plan_id': instance.feePlanId,
  'fee_plan_name': instance.feePlanName,
  'enrollment_type': instance.enrollmentType,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'days_remaining': instance.daysRemaining,
  'is_active_now': instance.isActiveNow,
  'status': instance.status,
  'qr_code_token': instance.qrCodeToken,
  'batch': instance.batch,
  'feePlan': instance.feePlan,
};
