// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacilityMemberModel _$FacilityMemberModelFromJson(Map<String, dynamic> json) =>
    _FacilityMemberModel(
      id: json['id'] as String,
      facilityId: json['facility_id'] as String?,
      userId: json['user_id'] as String?,
      membershipType: json['membership_type'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      status: json['status'] as String? ?? 'active',
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FacilityMemberModelToJson(
  _FacilityMemberModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'facility_id': instance.facilityId,
  'user_id': instance.userId,
  'membership_type': instance.membershipType,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'status': instance.status,
  'user': instance.user,
};
