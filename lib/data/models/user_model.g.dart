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
  cityId: json['city_id'] as String?,
  city: json['city'] == null
      ? null
      : CityModel.fromJson(json['city'] as Map<String, dynamic>),
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
      'city_id': instance.cityId,
      'city': instance.city,
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
