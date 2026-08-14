// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_renewal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipRenewalModel _$MembershipRenewalModelFromJson(
  Map<String, dynamic> json,
) => _MembershipRenewalModel(
  id: json['id'] as String,
  userId: json['user_id'] as String?,
  membershipType: json['membership_type'] as String?,
  membershipId: json['membership_id'] as String?,
  feePlanId: json['fee_plan_id'] as String?,
  paymentId: json['payment_id'] as String?,
  previousEndDate: json['previous_end_date'] == null
      ? null
      : DateTime.parse(json['previous_end_date'] as String),
  newEndDate: json['new_end_date'] == null
      ? null
      : DateTime.parse(json['new_end_date'] as String),
  extendedInterval: json['extended_interval'] as String?,
  extendedCount: (json['extended_count'] as num?)?.toInt() ?? 1,
  amountPaid: json['amount_paid'] == null ? 0 : _toDouble(json['amount_paid']),
  currency: json['currency'] as String? ?? 'INR',
  notes: json['notes'] as String?,
  feePlan: json['fee_plan'] == null
      ? null
      : FeePlanModel.fromJson(json['fee_plan'] as Map<String, dynamic>),
  payment: json['payment'] == null
      ? null
      : PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MembershipRenewalModelToJson(
  _MembershipRenewalModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'membership_type': instance.membershipType,
  'membership_id': instance.membershipId,
  'fee_plan_id': instance.feePlanId,
  'payment_id': instance.paymentId,
  'previous_end_date': instance.previousEndDate?.toIso8601String(),
  'new_end_date': instance.newEndDate?.toIso8601String(),
  'extended_interval': instance.extendedInterval,
  'extended_count': instance.extendedCount,
  'amount_paid': instance.amountPaid,
  'currency': instance.currency,
  'notes': instance.notes,
  'fee_plan': instance.feePlan,
  'payment': instance.payment,
  'created_at': instance.createdAt?.toIso8601String(),
};
