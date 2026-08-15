// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  dob: json['dob'] as String?,
  gender: json['gender'] as String?,
  cityId: json['city_id'] as String?,
  city: json['city'] == null
      ? null
      : CityModel.fromJson(json['city'] as Map<String, dynamic>),
  locality: json['locality'] as String?,
  address: json['address'] as String?,
  pincode: json['pincode'] as String?,
  landmark: json['landmark'] as String?,
  profession: json['profession'] as String?,
  company: json['company'] as String?,
  workExperience: json['work_experience'] as String?,
  education: json['education'] as String?,
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  interests: (json['interests'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  bio: json['bio'] as String?,
  hobbies: (json['hobbies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  profileVisibility: json['profile_visibility'] as String? ?? 'public',
  profileCompletionPercentage:
      (json['profile_completion_percentage'] as num?)?.toInt() ?? 0,
  role: json['role'] as String? ?? 'customer',
  status: json['status'] as String? ?? 'active',
  avatar: json['avatar'] as String?,
  photoUrl: json['photo_url'] as String?,
  customPermissions: (json['custom_permissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isOnboardingUser: json['is_onboarding_user'] as bool? ?? false,
  isClientUser: json['is_client_user'] as bool? ?? false,
  ownedFacilities: json['owned_facilities'] as Map<String, dynamic>?,
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'dob': instance.dob,
      'gender': instance.gender,
      'city_id': instance.cityId,
      'city': instance.city,
      'locality': instance.locality,
      'address': instance.address,
      'pincode': instance.pincode,
      'landmark': instance.landmark,
      'profession': instance.profession,
      'company': instance.company,
      'work_experience': instance.workExperience,
      'education': instance.education,
      'skills': instance.skills,
      'languages': instance.languages,
      'interests': instance.interests,
      'bio': instance.bio,
      'hobbies': instance.hobbies,
      'profile_visibility': instance.profileVisibility,
      'profile_completion_percentage': instance.profileCompletionPercentage,
      'role': instance.role,
      'status': instance.status,
      'avatar': instance.avatar,
      'photo_url': instance.photoUrl,
      'custom_permissions': instance.customPermissions,
      'is_onboarding_user': instance.isOnboardingUser,
      'is_client_user': instance.isClientUser,
      'owned_facilities': instance.ownedFacilities,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
