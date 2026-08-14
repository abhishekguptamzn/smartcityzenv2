// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeePlanModel _$FeePlanModelFromJson(Map<String, dynamic> json) =>
    _FeePlanModel(
      id: json['id'] as String,
      facilityType: json['facility_type'] as String?,
      facilityId: json['facility_id'] as String?,
      name: json['name'] as String,
      interval: json['interval'] as String? ?? 'month',
      intervalCount: (json['interval_count'] as num?)?.toInt() ?? 1,
      amount: json['amount'] == null ? 0 : _toDouble(json['amount']),
      currency: json['currency'] as String? ?? 'INR',
      isActive: json['is_active'] as bool? ?? true,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$FeePlanModelToJson(_FeePlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facility_type': instance.facilityType,
      'facility_id': instance.facilityId,
      'name': instance.name,
      'interval': instance.interval,
      'interval_count': instance.intervalCount,
      'amount': instance.amount,
      'currency': instance.currency,
      'is_active': instance.isActive,
      'description': instance.description,
    };
