// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacilityModel _$FacilityModelFromJson(
  Map<String, dynamic> json,
) => _FacilityModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  address: json['address'] as String?,
  cityId: json['city_id'] as String?,
  city: json['city'] == null
      ? null
      : CityModel.fromJson(json['city'] as Map<String, dynamic>),
  latitude: _toDouble(json['latitude']),
  longitude: _toDouble(json['longitude']),
  distanceKm: _toDouble(json['distance_km']),
  distanceFormatted: json['distance_formatted'] as String?,
  imageUrl: json['image_url'] as String?,
  image: json['image'] as Map<String, dynamic>?,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  logoUrl: json['logo_url'] as String?,
  logo: json['logo'] as Map<String, dynamic>?,
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  location: json['location'] as Map<String, dynamic>?,
  contactPhone: json['contact_phone'] as String?,
  contactEmail: json['contact_email'] as String?,
  openingTime: json['opening_time'] as String?,
  closingTime: json['closing_time'] as String?,
  status: json['status'] as String? ?? 'active',
  checkoutEnabled: json['checkout_enabled'] as bool? ?? true,
  defaultCheckoutTime: json['default_checkout_time'] as String?,
  defaultCheckoutDurationMinutes:
      (json['default_checkout_duration_minutes'] as num?)?.toInt() ?? 120,
  batchManagementEnabled: json['batch_management_enabled'] as bool? ?? false,
  attendanceManagementEnabled:
      json['attendance_management_enabled'] as bool? ?? false,
  bleVerificationEnabled: json['ble_verification_enabled'] as bool? ?? false,
  bleStrictMode: json['ble_strict_mode'] as bool? ?? false,
  bleServiceUuid: json['ble_service_uuid'] as String?,
  bleSecretKey: json['ble_secret_key'] as String?,
  bleProximitySensitivity:
      json['ble_proximity_sensitivity'] as String? ?? 'high',
  qrRotationInterval: (json['qr_rotation_interval'] as num?)?.toInt() ?? 15,
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdBy: json['created_by'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$FacilityModelToJson(
  _FacilityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'city_id': instance.cityId,
  'city': instance.city,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'distance_km': instance.distanceKm,
  'distance_formatted': instance.distanceFormatted,
  'image_url': instance.imageUrl,
  'image': instance.image,
  'images': instance.images,
  'logo_url': instance.logoUrl,
  'logo': instance.logo,
  'amenities': instance.amenities,
  'location': instance.location,
  'contact_phone': instance.contactPhone,
  'contact_email': instance.contactEmail,
  'opening_time': instance.openingTime,
  'closing_time': instance.closingTime,
  'status': instance.status,
  'checkout_enabled': instance.checkoutEnabled,
  'default_checkout_time': instance.defaultCheckoutTime,
  'default_checkout_duration_minutes': instance.defaultCheckoutDurationMinutes,
  'batch_management_enabled': instance.batchManagementEnabled,
  'attendance_management_enabled': instance.attendanceManagementEnabled,
  'ble_verification_enabled': instance.bleVerificationEnabled,
  'ble_strict_mode': instance.bleStrictMode,
  'ble_service_uuid': instance.bleServiceUuid,
  'ble_secret_key': instance.bleSecretKey,
  'ble_proximity_sensitivity': instance.bleProximitySensitivity,
  'qr_rotation_interval': instance.qrRotationInterval,
  'metadata': instance.metadata,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
