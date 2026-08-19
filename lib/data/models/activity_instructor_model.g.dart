// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_instructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityInstructorModel _$ActivityInstructorModelFromJson(
  Map<String, dynamic> json,
) => _ActivityInstructorModel(
  id: json['id'] as String,
  activityId: json['activity_id'] as String,
  name: json['name'] as String,
  title: json['title'] as String?,
  bio: json['bio'] as String?,
  specialization: json['specialization'] as String?,
  photoUrl: json['photo_url'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$ActivityInstructorModelToJson(
  _ActivityInstructorModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'activity_id': instance.activityId,
  'name': instance.name,
  'title': instance.title,
  'bio': instance.bio,
  'specialization': instance.specialization,
  'photo_url': instance.photoUrl,
  'phone': instance.phone,
  'email': instance.email,
  'status': instance.status,
};
