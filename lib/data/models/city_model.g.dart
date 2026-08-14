// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CityModel _$CityModelFromJson(Map<String, dynamic> json) => _CityModel(
  id: json['id'] as String,
  name: json['name'] as String,
  state: json['state'] as String,
  tagline: json['tagline'] as String?,
  description: json['description'] as String?,
  latitude: _toDouble(json['latitude']),
  longitude: _toDouble(json['longitude']),
  isCapital: json['is_capital'] as bool? ?? false,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$CityModelToJson(_CityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'state': instance.state,
      'tagline': instance.tagline,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_capital': instance.isCapital,
      'timezone': instance.timezone,
    };
