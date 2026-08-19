// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityScheduleModel _$ActivityScheduleModelFromJson(
  Map<String, dynamic> json,
) => _ActivityScheduleModel(
  id: json['id'] as String,
  batchId: json['batch_id'] as String,
  dayOfWeek: (json['day_of_week'] as num).toInt(),
  dayName: json['day_name'] as String?,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  formattedTime: json['formatted_time'] as String?,
  room: json['room'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ActivityScheduleModelToJson(
  _ActivityScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'batch_id': instance.batchId,
  'day_of_week': instance.dayOfWeek,
  'day_name': instance.dayName,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'formatted_time': instance.formattedTime,
  'room': instance.room,
  'is_active': instance.isActive,
};
