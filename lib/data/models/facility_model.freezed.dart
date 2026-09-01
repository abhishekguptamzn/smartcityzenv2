// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacilityModel {

 String get id; String get name; String? get description; String? get address;@JsonKey(name: 'city_id') String? get cityId; CityModel? get city;@JsonKey(fromJson: _toDouble) double? get latitude;@JsonKey(fromJson: _toDouble) double? get longitude;@JsonKey(name: 'distance_km', fromJson: _toDouble) double? get distanceKm;@JsonKey(name: 'distance_formatted') String? get distanceFormatted;@JsonKey(name: 'image_url') String? get imageUrl; Map<String, dynamic>? get image; List<Map<String, dynamic>>? get images;@JsonKey(name: 'logo_url') String? get logoUrl; Map<String, dynamic>? get logo; List<AmenityModel>? get amenities; Map<String, dynamic>? get location;@JsonKey(name: 'contact_phone') String? get contactPhone;@JsonKey(name: 'contact_email') String? get contactEmail;@JsonKey(name: 'opening_time') String? get openingTime;@JsonKey(name: 'closing_time') String? get closingTime; String get status;@JsonKey(name: 'checkout_enabled') bool get checkoutEnabled;@JsonKey(name: 'default_checkout_time') String? get defaultCheckoutTime;@JsonKey(name: 'default_checkout_duration_minutes') int get defaultCheckoutDurationMinutes;@JsonKey(name: 'batch_management_enabled') bool get batchManagementEnabled;@JsonKey(name: 'ble_verification_enabled') bool get bleVerificationEnabled;@JsonKey(name: 'ble_strict_mode') bool get bleStrictMode;@JsonKey(name: 'ble_service_uuid') String? get bleServiceUuid;@JsonKey(name: 'ble_secret_key') String? get bleSecretKey;@JsonKey(name: 'ble_proximity_sensitivity') String get bleProximitySensitivity;@JsonKey(name: 'qr_rotation_interval') int get qrRotationInterval; Map<String, dynamic>? get metadata;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind get kind;
/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityModelCopyWith<FacilityModel> get copyWith => _$FacilityModelCopyWithImpl<FacilityModel>(this as FacilityModel, _$identity);

  /// Serializes this FacilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.distanceFormatted, distanceFormatted) || other.distanceFormatted == distanceFormatted)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.image, image)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other.logo, logo)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.location, location)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkoutEnabled, checkoutEnabled) || other.checkoutEnabled == checkoutEnabled)&&(identical(other.defaultCheckoutTime, defaultCheckoutTime) || other.defaultCheckoutTime == defaultCheckoutTime)&&(identical(other.defaultCheckoutDurationMinutes, defaultCheckoutDurationMinutes) || other.defaultCheckoutDurationMinutes == defaultCheckoutDurationMinutes)&&(identical(other.batchManagementEnabled, batchManagementEnabled) || other.batchManagementEnabled == batchManagementEnabled)&&(identical(other.bleVerificationEnabled, bleVerificationEnabled) || other.bleVerificationEnabled == bleVerificationEnabled)&&(identical(other.bleStrictMode, bleStrictMode) || other.bleStrictMode == bleStrictMode)&&(identical(other.bleServiceUuid, bleServiceUuid) || other.bleServiceUuid == bleServiceUuid)&&(identical(other.bleSecretKey, bleSecretKey) || other.bleSecretKey == bleSecretKey)&&(identical(other.bleProximitySensitivity, bleProximitySensitivity) || other.bleProximitySensitivity == bleProximitySensitivity)&&(identical(other.qrRotationInterval, qrRotationInterval) || other.qrRotationInterval == qrRotationInterval)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,address,cityId,city,latitude,longitude,distanceKm,distanceFormatted,imageUrl,const DeepCollectionEquality().hash(image),const DeepCollectionEquality().hash(images),logoUrl,const DeepCollectionEquality().hash(logo),const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(location),contactPhone,contactEmail,openingTime,closingTime,status,checkoutEnabled,defaultCheckoutTime,defaultCheckoutDurationMinutes,batchManagementEnabled,bleVerificationEnabled,bleStrictMode,bleServiceUuid,bleSecretKey,bleProximitySensitivity,qrRotationInterval,const DeepCollectionEquality().hash(metadata),createdBy,createdAt,updatedAt,kind]);

@override
String toString() {
  return 'FacilityModel(id: $id, name: $name, description: $description, address: $address, cityId: $cityId, city: $city, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, distanceFormatted: $distanceFormatted, imageUrl: $imageUrl, image: $image, images: $images, logoUrl: $logoUrl, logo: $logo, amenities: $amenities, location: $location, contactPhone: $contactPhone, contactEmail: $contactEmail, openingTime: $openingTime, closingTime: $closingTime, status: $status, checkoutEnabled: $checkoutEnabled, defaultCheckoutTime: $defaultCheckoutTime, defaultCheckoutDurationMinutes: $defaultCheckoutDurationMinutes, batchManagementEnabled: $batchManagementEnabled, bleVerificationEnabled: $bleVerificationEnabled, bleStrictMode: $bleStrictMode, bleServiceUuid: $bleServiceUuid, bleSecretKey: $bleSecretKey, bleProximitySensitivity: $bleProximitySensitivity, qrRotationInterval: $qrRotationInterval, metadata: $metadata, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $FacilityModelCopyWith<$Res>  {
  factory $FacilityModelCopyWith(FacilityModel value, $Res Function(FacilityModel) _then) = _$FacilityModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? address,@JsonKey(name: 'city_id') String? cityId, CityModel? city,@JsonKey(fromJson: _toDouble) double? latitude,@JsonKey(fromJson: _toDouble) double? longitude,@JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,@JsonKey(name: 'distance_formatted') String? distanceFormatted,@JsonKey(name: 'image_url') String? imageUrl, Map<String, dynamic>? image, List<Map<String, dynamic>>? images,@JsonKey(name: 'logo_url') String? logoUrl, Map<String, dynamic>? logo, List<AmenityModel>? amenities, Map<String, dynamic>? location,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'opening_time') String? openingTime,@JsonKey(name: 'closing_time') String? closingTime, String status,@JsonKey(name: 'checkout_enabled') bool checkoutEnabled,@JsonKey(name: 'default_checkout_time') String? defaultCheckoutTime,@JsonKey(name: 'default_checkout_duration_minutes') int defaultCheckoutDurationMinutes,@JsonKey(name: 'batch_management_enabled') bool batchManagementEnabled,@JsonKey(name: 'ble_verification_enabled') bool bleVerificationEnabled,@JsonKey(name: 'ble_strict_mode') bool bleStrictMode,@JsonKey(name: 'ble_service_uuid') String? bleServiceUuid,@JsonKey(name: 'ble_secret_key') String? bleSecretKey,@JsonKey(name: 'ble_proximity_sensitivity') String bleProximitySensitivity,@JsonKey(name: 'qr_rotation_interval') int qrRotationInterval, Map<String, dynamic>? metadata,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind kind
});


$CityModelCopyWith<$Res>? get city;

}
/// @nodoc
class _$FacilityModelCopyWithImpl<$Res>
    implements $FacilityModelCopyWith<$Res> {
  _$FacilityModelCopyWithImpl(this._self, this._then);

  final FacilityModel _self;
  final $Res Function(FacilityModel) _then;

/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? address = freezed,Object? cityId = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distanceKm = freezed,Object? distanceFormatted = freezed,Object? imageUrl = freezed,Object? image = freezed,Object? images = freezed,Object? logoUrl = freezed,Object? logo = freezed,Object? amenities = freezed,Object? location = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? openingTime = freezed,Object? closingTime = freezed,Object? status = null,Object? checkoutEnabled = null,Object? defaultCheckoutTime = freezed,Object? defaultCheckoutDurationMinutes = null,Object? batchManagementEnabled = null,Object? bleVerificationEnabled = null,Object? bleStrictMode = null,Object? bleServiceUuid = freezed,Object? bleSecretKey = freezed,Object? bleProximitySensitivity = null,Object? qrRotationInterval = null,Object? metadata = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? kind = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,distanceFormatted: freezed == distanceFormatted ? _self.distanceFormatted : distanceFormatted // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,amenities: freezed == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<AmenityModel>?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkoutEnabled: null == checkoutEnabled ? _self.checkoutEnabled : checkoutEnabled // ignore: cast_nullable_to_non_nullable
as bool,defaultCheckoutTime: freezed == defaultCheckoutTime ? _self.defaultCheckoutTime : defaultCheckoutTime // ignore: cast_nullable_to_non_nullable
as String?,defaultCheckoutDurationMinutes: null == defaultCheckoutDurationMinutes ? _self.defaultCheckoutDurationMinutes : defaultCheckoutDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,batchManagementEnabled: null == batchManagementEnabled ? _self.batchManagementEnabled : batchManagementEnabled // ignore: cast_nullable_to_non_nullable
as bool,bleVerificationEnabled: null == bleVerificationEnabled ? _self.bleVerificationEnabled : bleVerificationEnabled // ignore: cast_nullable_to_non_nullable
as bool,bleStrictMode: null == bleStrictMode ? _self.bleStrictMode : bleStrictMode // ignore: cast_nullable_to_non_nullable
as bool,bleServiceUuid: freezed == bleServiceUuid ? _self.bleServiceUuid : bleServiceUuid // ignore: cast_nullable_to_non_nullable
as String?,bleSecretKey: freezed == bleSecretKey ? _self.bleSecretKey : bleSecretKey // ignore: cast_nullable_to_non_nullable
as String?,bleProximitySensitivity: null == bleProximitySensitivity ? _self.bleProximitySensitivity : bleProximitySensitivity // ignore: cast_nullable_to_non_nullable
as String,qrRotationInterval: null == qrRotationInterval ? _self.qrRotationInterval : qrRotationInterval // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,
  ));
}
/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityModelCopyWith<$Res>? get city {
    if (_self.city == null) {
    return null;
  }

  return $CityModelCopyWith<$Res>(_self.city!, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [FacilityModel].
extension FacilityModelPatterns on FacilityModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacilityModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacilityModel value)  $default,){
final _that = this;
switch (_that) {
case _FacilityModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacilityModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? address, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, dynamic>? image,  List<Map<String, dynamic>>? images, @JsonKey(name: 'logo_url')  String? logoUrl,  Map<String, dynamic>? logo,  List<AmenityModel>? amenities,  Map<String, dynamic>? location, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime,  String status, @JsonKey(name: 'checkout_enabled')  bool checkoutEnabled, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'default_checkout_duration_minutes')  int defaultCheckoutDurationMinutes, @JsonKey(name: 'batch_management_enabled')  bool batchManagementEnabled, @JsonKey(name: 'ble_verification_enabled')  bool bleVerificationEnabled, @JsonKey(name: 'ble_strict_mode')  bool bleStrictMode, @JsonKey(name: 'ble_service_uuid')  String? bleServiceUuid, @JsonKey(name: 'ble_secret_key')  String? bleSecretKey, @JsonKey(name: 'ble_proximity_sensitivity')  String bleProximitySensitivity, @JsonKey(name: 'qr_rotation_interval')  int qrRotationInterval,  Map<String, dynamic>? metadata, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacilityModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.address,_that.cityId,_that.city,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.imageUrl,_that.image,_that.images,_that.logoUrl,_that.logo,_that.amenities,_that.location,_that.contactPhone,_that.contactEmail,_that.openingTime,_that.closingTime,_that.status,_that.checkoutEnabled,_that.defaultCheckoutTime,_that.defaultCheckoutDurationMinutes,_that.batchManagementEnabled,_that.bleVerificationEnabled,_that.bleStrictMode,_that.bleServiceUuid,_that.bleSecretKey,_that.bleProximitySensitivity,_that.qrRotationInterval,_that.metadata,_that.createdBy,_that.createdAt,_that.updatedAt,_that.kind);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? address, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, dynamic>? image,  List<Map<String, dynamic>>? images, @JsonKey(name: 'logo_url')  String? logoUrl,  Map<String, dynamic>? logo,  List<AmenityModel>? amenities,  Map<String, dynamic>? location, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime,  String status, @JsonKey(name: 'checkout_enabled')  bool checkoutEnabled, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'default_checkout_duration_minutes')  int defaultCheckoutDurationMinutes, @JsonKey(name: 'batch_management_enabled')  bool batchManagementEnabled, @JsonKey(name: 'ble_verification_enabled')  bool bleVerificationEnabled, @JsonKey(name: 'ble_strict_mode')  bool bleStrictMode, @JsonKey(name: 'ble_service_uuid')  String? bleServiceUuid, @JsonKey(name: 'ble_secret_key')  String? bleSecretKey, @JsonKey(name: 'ble_proximity_sensitivity')  String bleProximitySensitivity, @JsonKey(name: 'qr_rotation_interval')  int qrRotationInterval,  Map<String, dynamic>? metadata, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind kind)  $default,) {final _that = this;
switch (_that) {
case _FacilityModel():
return $default(_that.id,_that.name,_that.description,_that.address,_that.cityId,_that.city,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.imageUrl,_that.image,_that.images,_that.logoUrl,_that.logo,_that.amenities,_that.location,_that.contactPhone,_that.contactEmail,_that.openingTime,_that.closingTime,_that.status,_that.checkoutEnabled,_that.defaultCheckoutTime,_that.defaultCheckoutDurationMinutes,_that.batchManagementEnabled,_that.bleVerificationEnabled,_that.bleStrictMode,_that.bleServiceUuid,_that.bleSecretKey,_that.bleProximitySensitivity,_that.qrRotationInterval,_that.metadata,_that.createdBy,_that.createdAt,_that.updatedAt,_that.kind);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? address, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, dynamic>? image,  List<Map<String, dynamic>>? images, @JsonKey(name: 'logo_url')  String? logoUrl,  Map<String, dynamic>? logo,  List<AmenityModel>? amenities,  Map<String, dynamic>? location, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime,  String status, @JsonKey(name: 'checkout_enabled')  bool checkoutEnabled, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'default_checkout_duration_minutes')  int defaultCheckoutDurationMinutes, @JsonKey(name: 'batch_management_enabled')  bool batchManagementEnabled, @JsonKey(name: 'ble_verification_enabled')  bool bleVerificationEnabled, @JsonKey(name: 'ble_strict_mode')  bool bleStrictMode, @JsonKey(name: 'ble_service_uuid')  String? bleServiceUuid, @JsonKey(name: 'ble_secret_key')  String? bleSecretKey, @JsonKey(name: 'ble_proximity_sensitivity')  String bleProximitySensitivity, @JsonKey(name: 'qr_rotation_interval')  int qrRotationInterval,  Map<String, dynamic>? metadata, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind kind)?  $default,) {final _that = this;
switch (_that) {
case _FacilityModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.address,_that.cityId,_that.city,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.imageUrl,_that.image,_that.images,_that.logoUrl,_that.logo,_that.amenities,_that.location,_that.contactPhone,_that.contactEmail,_that.openingTime,_that.closingTime,_that.status,_that.checkoutEnabled,_that.defaultCheckoutTime,_that.defaultCheckoutDurationMinutes,_that.batchManagementEnabled,_that.bleVerificationEnabled,_that.bleStrictMode,_that.bleServiceUuid,_that.bleSecretKey,_that.bleProximitySensitivity,_that.qrRotationInterval,_that.metadata,_that.createdBy,_that.createdAt,_that.updatedAt,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacilityModel extends FacilityModel {
  const _FacilityModel({required this.id, required this.name, this.description, this.address, @JsonKey(name: 'city_id') this.cityId, this.city, @JsonKey(fromJson: _toDouble) this.latitude, @JsonKey(fromJson: _toDouble) this.longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble) this.distanceKm, @JsonKey(name: 'distance_formatted') this.distanceFormatted, @JsonKey(name: 'image_url') this.imageUrl, final  Map<String, dynamic>? image, final  List<Map<String, dynamic>>? images, @JsonKey(name: 'logo_url') this.logoUrl, final  Map<String, dynamic>? logo, final  List<AmenityModel>? amenities, final  Map<String, dynamic>? location, @JsonKey(name: 'contact_phone') this.contactPhone, @JsonKey(name: 'contact_email') this.contactEmail, @JsonKey(name: 'opening_time') this.openingTime, @JsonKey(name: 'closing_time') this.closingTime, this.status = 'active', @JsonKey(name: 'checkout_enabled') this.checkoutEnabled = true, @JsonKey(name: 'default_checkout_time') this.defaultCheckoutTime, @JsonKey(name: 'default_checkout_duration_minutes') this.defaultCheckoutDurationMinutes = 120, @JsonKey(name: 'batch_management_enabled') this.batchManagementEnabled = false, @JsonKey(name: 'ble_verification_enabled') this.bleVerificationEnabled = false, @JsonKey(name: 'ble_strict_mode') this.bleStrictMode = false, @JsonKey(name: 'ble_service_uuid') this.bleServiceUuid, @JsonKey(name: 'ble_secret_key') this.bleSecretKey, @JsonKey(name: 'ble_proximity_sensitivity') this.bleProximitySensitivity = 'high', @JsonKey(name: 'qr_rotation_interval') this.qrRotationInterval = 15, final  Map<String, dynamic>? metadata, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(includeFromJson: false, includeToJson: false) this.kind = FacilityKind.library}): _image = image,_images = images,_logo = logo,_amenities = amenities,_location = location,_metadata = metadata,super._();
  factory _FacilityModel.fromJson(Map<String, dynamic> json) => _$FacilityModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? address;
@override@JsonKey(name: 'city_id') final  String? cityId;
@override final  CityModel? city;
@override@JsonKey(fromJson: _toDouble) final  double? latitude;
@override@JsonKey(fromJson: _toDouble) final  double? longitude;
@override@JsonKey(name: 'distance_km', fromJson: _toDouble) final  double? distanceKm;
@override@JsonKey(name: 'distance_formatted') final  String? distanceFormatted;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
 final  Map<String, dynamic>? _image;
@override Map<String, dynamic>? get image {
  final value = _image;
  if (value == null) return null;
  if (_image is EqualUnmodifiableMapView) return _image;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Map<String, dynamic>>? _images;
@override List<Map<String, dynamic>>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'logo_url') final  String? logoUrl;
 final  Map<String, dynamic>? _logo;
@override Map<String, dynamic>? get logo {
  final value = _logo;
  if (value == null) return null;
  if (_logo is EqualUnmodifiableMapView) return _logo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<AmenityModel>? _amenities;
@override List<AmenityModel>? get amenities {
  final value = _amenities;
  if (value == null) return null;
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _location;
@override Map<String, dynamic>? get location {
  final value = _location;
  if (value == null) return null;
  if (_location is EqualUnmodifiableMapView) return _location;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'contact_phone') final  String? contactPhone;
@override@JsonKey(name: 'contact_email') final  String? contactEmail;
@override@JsonKey(name: 'opening_time') final  String? openingTime;
@override@JsonKey(name: 'closing_time') final  String? closingTime;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'checkout_enabled') final  bool checkoutEnabled;
@override@JsonKey(name: 'default_checkout_time') final  String? defaultCheckoutTime;
@override@JsonKey(name: 'default_checkout_duration_minutes') final  int defaultCheckoutDurationMinutes;
@override@JsonKey(name: 'batch_management_enabled') final  bool batchManagementEnabled;
@override@JsonKey(name: 'ble_verification_enabled') final  bool bleVerificationEnabled;
@override@JsonKey(name: 'ble_strict_mode') final  bool bleStrictMode;
@override@JsonKey(name: 'ble_service_uuid') final  String? bleServiceUuid;
@override@JsonKey(name: 'ble_secret_key') final  String? bleSecretKey;
@override@JsonKey(name: 'ble_proximity_sensitivity') final  String bleProximitySensitivity;
@override@JsonKey(name: 'qr_rotation_interval') final  int qrRotationInterval;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  FacilityKind kind;

/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityModelCopyWith<_FacilityModel> get copyWith => __$FacilityModelCopyWithImpl<_FacilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.distanceFormatted, distanceFormatted) || other.distanceFormatted == distanceFormatted)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._image, _image)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other._logo, _logo)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._location, _location)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkoutEnabled, checkoutEnabled) || other.checkoutEnabled == checkoutEnabled)&&(identical(other.defaultCheckoutTime, defaultCheckoutTime) || other.defaultCheckoutTime == defaultCheckoutTime)&&(identical(other.defaultCheckoutDurationMinutes, defaultCheckoutDurationMinutes) || other.defaultCheckoutDurationMinutes == defaultCheckoutDurationMinutes)&&(identical(other.batchManagementEnabled, batchManagementEnabled) || other.batchManagementEnabled == batchManagementEnabled)&&(identical(other.bleVerificationEnabled, bleVerificationEnabled) || other.bleVerificationEnabled == bleVerificationEnabled)&&(identical(other.bleStrictMode, bleStrictMode) || other.bleStrictMode == bleStrictMode)&&(identical(other.bleServiceUuid, bleServiceUuid) || other.bleServiceUuid == bleServiceUuid)&&(identical(other.bleSecretKey, bleSecretKey) || other.bleSecretKey == bleSecretKey)&&(identical(other.bleProximitySensitivity, bleProximitySensitivity) || other.bleProximitySensitivity == bleProximitySensitivity)&&(identical(other.qrRotationInterval, qrRotationInterval) || other.qrRotationInterval == qrRotationInterval)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,address,cityId,city,latitude,longitude,distanceKm,distanceFormatted,imageUrl,const DeepCollectionEquality().hash(_image),const DeepCollectionEquality().hash(_images),logoUrl,const DeepCollectionEquality().hash(_logo),const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_location),contactPhone,contactEmail,openingTime,closingTime,status,checkoutEnabled,defaultCheckoutTime,defaultCheckoutDurationMinutes,batchManagementEnabled,bleVerificationEnabled,bleStrictMode,bleServiceUuid,bleSecretKey,bleProximitySensitivity,qrRotationInterval,const DeepCollectionEquality().hash(_metadata),createdBy,createdAt,updatedAt,kind]);

@override
String toString() {
  return 'FacilityModel(id: $id, name: $name, description: $description, address: $address, cityId: $cityId, city: $city, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, distanceFormatted: $distanceFormatted, imageUrl: $imageUrl, image: $image, images: $images, logoUrl: $logoUrl, logo: $logo, amenities: $amenities, location: $location, contactPhone: $contactPhone, contactEmail: $contactEmail, openingTime: $openingTime, closingTime: $closingTime, status: $status, checkoutEnabled: $checkoutEnabled, defaultCheckoutTime: $defaultCheckoutTime, defaultCheckoutDurationMinutes: $defaultCheckoutDurationMinutes, batchManagementEnabled: $batchManagementEnabled, bleVerificationEnabled: $bleVerificationEnabled, bleStrictMode: $bleStrictMode, bleServiceUuid: $bleServiceUuid, bleSecretKey: $bleSecretKey, bleProximitySensitivity: $bleProximitySensitivity, qrRotationInterval: $qrRotationInterval, metadata: $metadata, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$FacilityModelCopyWith<$Res> implements $FacilityModelCopyWith<$Res> {
  factory _$FacilityModelCopyWith(_FacilityModel value, $Res Function(_FacilityModel) _then) = __$FacilityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? address,@JsonKey(name: 'city_id') String? cityId, CityModel? city,@JsonKey(fromJson: _toDouble) double? latitude,@JsonKey(fromJson: _toDouble) double? longitude,@JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,@JsonKey(name: 'distance_formatted') String? distanceFormatted,@JsonKey(name: 'image_url') String? imageUrl, Map<String, dynamic>? image, List<Map<String, dynamic>>? images,@JsonKey(name: 'logo_url') String? logoUrl, Map<String, dynamic>? logo, List<AmenityModel>? amenities, Map<String, dynamic>? location,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'opening_time') String? openingTime,@JsonKey(name: 'closing_time') String? closingTime, String status,@JsonKey(name: 'checkout_enabled') bool checkoutEnabled,@JsonKey(name: 'default_checkout_time') String? defaultCheckoutTime,@JsonKey(name: 'default_checkout_duration_minutes') int defaultCheckoutDurationMinutes,@JsonKey(name: 'batch_management_enabled') bool batchManagementEnabled,@JsonKey(name: 'ble_verification_enabled') bool bleVerificationEnabled,@JsonKey(name: 'ble_strict_mode') bool bleStrictMode,@JsonKey(name: 'ble_service_uuid') String? bleServiceUuid,@JsonKey(name: 'ble_secret_key') String? bleSecretKey,@JsonKey(name: 'ble_proximity_sensitivity') String bleProximitySensitivity,@JsonKey(name: 'qr_rotation_interval') int qrRotationInterval, Map<String, dynamic>? metadata,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind kind
});


@override $CityModelCopyWith<$Res>? get city;

}
/// @nodoc
class __$FacilityModelCopyWithImpl<$Res>
    implements _$FacilityModelCopyWith<$Res> {
  __$FacilityModelCopyWithImpl(this._self, this._then);

  final _FacilityModel _self;
  final $Res Function(_FacilityModel) _then;

/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? address = freezed,Object? cityId = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distanceKm = freezed,Object? distanceFormatted = freezed,Object? imageUrl = freezed,Object? image = freezed,Object? images = freezed,Object? logoUrl = freezed,Object? logo = freezed,Object? amenities = freezed,Object? location = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? openingTime = freezed,Object? closingTime = freezed,Object? status = null,Object? checkoutEnabled = null,Object? defaultCheckoutTime = freezed,Object? defaultCheckoutDurationMinutes = null,Object? batchManagementEnabled = null,Object? bleVerificationEnabled = null,Object? bleStrictMode = null,Object? bleServiceUuid = freezed,Object? bleSecretKey = freezed,Object? bleProximitySensitivity = null,Object? qrRotationInterval = null,Object? metadata = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? kind = null,}) {
  return _then(_FacilityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,distanceFormatted: freezed == distanceFormatted ? _self.distanceFormatted : distanceFormatted // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self._image : image // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self._logo : logo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,amenities: freezed == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<AmenityModel>?,location: freezed == location ? _self._location : location // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkoutEnabled: null == checkoutEnabled ? _self.checkoutEnabled : checkoutEnabled // ignore: cast_nullable_to_non_nullable
as bool,defaultCheckoutTime: freezed == defaultCheckoutTime ? _self.defaultCheckoutTime : defaultCheckoutTime // ignore: cast_nullable_to_non_nullable
as String?,defaultCheckoutDurationMinutes: null == defaultCheckoutDurationMinutes ? _self.defaultCheckoutDurationMinutes : defaultCheckoutDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,batchManagementEnabled: null == batchManagementEnabled ? _self.batchManagementEnabled : batchManagementEnabled // ignore: cast_nullable_to_non_nullable
as bool,bleVerificationEnabled: null == bleVerificationEnabled ? _self.bleVerificationEnabled : bleVerificationEnabled // ignore: cast_nullable_to_non_nullable
as bool,bleStrictMode: null == bleStrictMode ? _self.bleStrictMode : bleStrictMode // ignore: cast_nullable_to_non_nullable
as bool,bleServiceUuid: freezed == bleServiceUuid ? _self.bleServiceUuid : bleServiceUuid // ignore: cast_nullable_to_non_nullable
as String?,bleSecretKey: freezed == bleSecretKey ? _self.bleSecretKey : bleSecretKey // ignore: cast_nullable_to_non_nullable
as String?,bleProximitySensitivity: null == bleProximitySensitivity ? _self.bleProximitySensitivity : bleProximitySensitivity // ignore: cast_nullable_to_non_nullable
as String,qrRotationInterval: null == qrRotationInterval ? _self.qrRotationInterval : qrRotationInterval // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,
  ));
}

/// Create a copy of FacilityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityModelCopyWith<$Res>? get city {
    if (_self.city == null) {
    return null;
  }

  return $CityModelCopyWith<$Res>(_self.city!, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}

// dart format on
