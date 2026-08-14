// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GymAttendanceModel _$GymAttendanceModelFromJson(
  Map<String, dynamic> json,
) => _GymAttendanceModel(
  id: json['id'] as String,
  gymId: json['gym_id'] as String?,
  memberId: json['member_id'] as String?,
  checkInAt: json['check_in_at'] == null
      ? null
      : DateTime.parse(json['check_in_at'] as String),
  checkOutAt: json['check_out_at'] == null
      ? null
      : DateTime.parse(json['check_out_at'] as String),
  duration: (json['duration'] as num?)?.toInt(),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  gym: json['gym'] == null
      ? null
      : FacilityModel.fromJson(json['gym'] as Map<String, dynamic>),
  member: json['member'] == null
      ? null
      : FacilityMemberModel.fromJson(json['member'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GymAttendanceModelToJson(_GymAttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gym_id': instance.gymId,
      'member_id': instance.memberId,
      'check_in_at': instance.checkInAt?.toIso8601String(),
      'check_out_at': instance.checkOutAt?.toIso8601String(),
      'duration': instance.duration,
      'date': instance.date?.toIso8601String(),
      'gym': instance.gym,
      'member': instance.member,
    };
