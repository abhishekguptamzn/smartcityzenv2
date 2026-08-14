// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginHistoryModel _$LoginHistoryModelFromJson(Map<String, dynamic> json) =>
    _LoginHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      email: json['email'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      deviceType: json['device_type'] as String?,
      browser: json['browser'] as String?,
      platform: json['platform'] as String?,
      location: json['location'] as String?,
      status: json['status'] as String? ?? 'success',
      failureReason: json['failure_reason'] as String?,
      isSuspicious: json['is_suspicious'] as bool? ?? false,
      flaggedReason: json['flagged_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginHistoryModelToJson(_LoginHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'email': instance.email,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'device_type': instance.deviceType,
      'browser': instance.browser,
      'platform': instance.platform,
      'location': instance.location,
      'status': instance.status,
      'failure_reason': instance.failureReason,
      'is_suspicious': instance.isSuspicious,
      'flagged_reason': instance.flaggedReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'user': instance.user,
    };
