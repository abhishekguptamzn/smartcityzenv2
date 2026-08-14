// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AmenityModel _$AmenityModelFromJson(Map<String, dynamic> json) =>
    _AmenityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      facilityIsActive: json['facility_is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$AmenityModelToJson(_AmenityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'is_active': instance.isActive,
      'facility_is_active': instance.facilityIsActive,
    };
