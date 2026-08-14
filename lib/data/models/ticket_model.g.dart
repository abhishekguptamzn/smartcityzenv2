// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => _TicketModel(
  id: (json['id'] as num).toInt(),
  ticketNumber: json['ticket_number'] as String,
  userId: json['user_id'] as String,
  subject: json['subject'] as String,
  category: json['category'] as String? ?? 'general',
  priority: json['priority'] as String? ?? 'medium',
  status: json['status'] as String? ?? 'open',
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => TicketMessageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  latestMessage: json['latest_message'] == null
      ? null
      : TicketMessageModel.fromJson(
          json['latest_message'] as Map<String, dynamic>,
        ),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$TicketModelToJson(_TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_number': instance.ticketNumber,
      'user_id': instance.userId,
      'subject': instance.subject,
      'category': instance.category,
      'priority': instance.priority,
      'status': instance.status,
      'messages': instance.messages,
      'latest_message': instance.latestMessage,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_TicketMessageModel _$TicketMessageModelFromJson(Map<String, dynamic> json) =>
    _TicketMessageModel(
      id: (json['id'] as num).toInt(),
      ticketId: (json['ticket_id'] as num).toInt(),
      userId: json['user_id'] as String?,
      senderType: json['sender_type'] as String? ?? 'citizen',
      message: json['message'] as String,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$TicketMessageModelToJson(_TicketMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_id': instance.ticketId,
      'user_id': instance.userId,
      'sender_type': instance.senderType,
      'message': instance.message,
      'user': instance.user,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
