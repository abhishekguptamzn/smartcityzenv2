// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String? ?? 'system',
      title: json['title'] as String,
      message: json['message'] as String,
      priority: json['priority'] as String? ?? 'normal',
      actionType: json['action_type'] as String?,
      actionRoute: json['action_route'] as String?,
      actionLabel: json['action_label'] as String?,
      secondaryActionLabel: json['secondary_action_label'] as String?,
      secondaryActionRoute: json['secondary_action_route'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      readAt: json['read_at'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      actionTakenAt: json['action_taken_at'] as String?,
      createdAt: json['created_at'] as String?,
      createdAtFormatted: json['created_at_formatted'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'priority': instance.priority,
      'action_type': instance.actionType,
      'action_route': instance.actionRoute,
      'action_label': instance.actionLabel,
      'secondary_action_label': instance.secondaryActionLabel,
      'secondary_action_route': instance.secondaryActionRoute,
      'data': instance.data,
      'read_at': instance.readAt,
      'is_read': instance.isRead,
      'action_taken_at': instance.actionTakenAt,
      'created_at': instance.createdAt,
      'created_at_formatted': instance.createdAtFormatted,
      'updated_at': instance.updatedAt,
    };
