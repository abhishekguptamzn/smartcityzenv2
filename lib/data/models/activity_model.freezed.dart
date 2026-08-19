// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityModel {

 String get id; String get name; String? get description;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'type_id') String? get typeId;@JsonKey(name: 'category_name') String? get categoryName;@JsonKey(name: 'type_name') String? get typeName;@JsonKey(name: 'category_slug') String? get categorySlug;@JsonKey(name: 'type_slug') String? get typeSlug;@JsonKey(name: 'city_id') String? get cityId;@JsonKey(name: 'city_name') String? get cityName; CityModel? get city; ActivityCategoryModel? get category; ActivityTypeModel? get type; String? get address;@JsonKey(fromJson: _toDouble) double? get latitude;@JsonKey(fromJson: _toDouble) double? get longitude;@JsonKey(name: 'distance_km', fromJson: _toDouble) double? get distanceKm;@JsonKey(name: 'distance_formatted') String? get distanceFormatted;@JsonKey(name: 'contact_phone') String? get contactPhone;@JsonKey(name: 'contact_email') String? get contactEmail; String? get website;@JsonKey(name: 'opening_time') String? get openingTime;@JsonKey(name: 'closing_time') String? get closingTime;@JsonKey(name: 'is_open_now') bool get isOpenNow; String get status;@JsonKey(name: 'verification_status') String get verificationStatus;@JsonKey(name: 'is_featured') bool get isFeatured;@JsonKey(fromJson: _toDouble) double get rating;@JsonKey(name: 'review_count') int get reviewCount;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'media_urls') List<String> get mediaUrls; List<AmenityModel> get amenities;@JsonKey(name: 'fee_plans') List<FeePlanModel> get feePlans; List<ActivityBatchModel> get batches; List<ActivityInstructorModel> get instructors; List<ActivityReviewModel> get reviews; Map<String, dynamic>? get metadata;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.typeName, typeName) || other.typeName == typeName)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.typeSlug, typeSlug) || other.typeSlug == typeSlug)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.city, city) || other.city == city)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.distanceFormatted, distanceFormatted) || other.distanceFormatted == distanceFormatted)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.website, website) || other.website == website)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime)&&(identical(other.isOpenNow, isOpenNow) || other.isOpenNow == isOpenNow)&&(identical(other.status, status) || other.status == status)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.feePlans, feePlans)&&const DeepCollectionEquality().equals(other.batches, batches)&&const DeepCollectionEquality().equals(other.instructors, instructors)&&const DeepCollectionEquality().equals(other.reviews, reviews)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,categoryId,typeId,categoryName,typeName,categorySlug,typeSlug,cityId,cityName,city,category,type,address,latitude,longitude,distanceKm,distanceFormatted,contactPhone,contactEmail,website,openingTime,closingTime,isOpenNow,status,verificationStatus,isFeatured,rating,reviewCount,imageUrl,const DeepCollectionEquality().hash(mediaUrls),const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(feePlans),const DeepCollectionEquality().hash(batches),const DeepCollectionEquality().hash(instructors),const DeepCollectionEquality().hash(reviews),const DeepCollectionEquality().hash(metadata)]);

@override
String toString() {
  return 'ActivityModel(id: $id, name: $name, description: $description, categoryId: $categoryId, typeId: $typeId, categoryName: $categoryName, typeName: $typeName, categorySlug: $categorySlug, typeSlug: $typeSlug, cityId: $cityId, cityName: $cityName, city: $city, category: $category, type: $type, address: $address, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, distanceFormatted: $distanceFormatted, contactPhone: $contactPhone, contactEmail: $contactEmail, website: $website, openingTime: $openingTime, closingTime: $closingTime, isOpenNow: $isOpenNow, status: $status, verificationStatus: $verificationStatus, isFeatured: $isFeatured, rating: $rating, reviewCount: $reviewCount, imageUrl: $imageUrl, mediaUrls: $mediaUrls, amenities: $amenities, feePlans: $feePlans, batches: $batches, instructors: $instructors, reviews: $reviews, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'type_id') String? typeId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'type_name') String? typeName,@JsonKey(name: 'category_slug') String? categorySlug,@JsonKey(name: 'type_slug') String? typeSlug,@JsonKey(name: 'city_id') String? cityId,@JsonKey(name: 'city_name') String? cityName, CityModel? city, ActivityCategoryModel? category, ActivityTypeModel? type, String? address,@JsonKey(fromJson: _toDouble) double? latitude,@JsonKey(fromJson: _toDouble) double? longitude,@JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,@JsonKey(name: 'distance_formatted') String? distanceFormatted,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'contact_email') String? contactEmail, String? website,@JsonKey(name: 'opening_time') String? openingTime,@JsonKey(name: 'closing_time') String? closingTime,@JsonKey(name: 'is_open_now') bool isOpenNow, String status,@JsonKey(name: 'verification_status') String verificationStatus,@JsonKey(name: 'is_featured') bool isFeatured,@JsonKey(fromJson: _toDouble) double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'media_urls') List<String> mediaUrls, List<AmenityModel> amenities,@JsonKey(name: 'fee_plans') List<FeePlanModel> feePlans, List<ActivityBatchModel> batches, List<ActivityInstructorModel> instructors, List<ActivityReviewModel> reviews, Map<String, dynamic>? metadata
});


$CityModelCopyWith<$Res>? get city;$ActivityCategoryModelCopyWith<$Res>? get category;$ActivityTypeModelCopyWith<$Res>? get type;

}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? categoryId = freezed,Object? typeId = freezed,Object? categoryName = freezed,Object? typeName = freezed,Object? categorySlug = freezed,Object? typeSlug = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? city = freezed,Object? category = freezed,Object? type = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distanceKm = freezed,Object? distanceFormatted = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? website = freezed,Object? openingTime = freezed,Object? closingTime = freezed,Object? isOpenNow = null,Object? status = null,Object? verificationStatus = null,Object? isFeatured = null,Object? rating = null,Object? reviewCount = null,Object? imageUrl = freezed,Object? mediaUrls = null,Object? amenities = null,Object? feePlans = null,Object? batches = null,Object? instructors = null,Object? reviews = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,typeId: freezed == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,typeSlug: freezed == typeSlug ? _self.typeSlug : typeSlug // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ActivityCategoryModel?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityTypeModel?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,distanceFormatted: freezed == distanceFormatted ? _self.distanceFormatted : distanceFormatted // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,isOpenNow: null == isOpenNow ? _self.isOpenNow : isOpenNow // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<AmenityModel>,feePlans: null == feePlans ? _self.feePlans : feePlans // ignore: cast_nullable_to_non_nullable
as List<FeePlanModel>,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<ActivityBatchModel>,instructors: null == instructors ? _self.instructors : instructors // ignore: cast_nullable_to_non_nullable
as List<ActivityInstructorModel>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ActivityReviewModel>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of ActivityModel
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
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ActivityCategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityTypeModelCopyWith<$Res>? get type {
    if (_self.type == null) {
    return null;
  }

  return $ActivityTypeModelCopyWith<$Res>(_self.type!, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityModel].
extension ActivityModelPatterns on ActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'type_id')  String? typeId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'category_slug')  String? categorySlug, @JsonKey(name: 'type_slug')  String? typeSlug, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'city_name')  String? cityName,  CityModel? city,  ActivityCategoryModel? category,  ActivityTypeModel? type,  String? address, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail,  String? website, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime, @JsonKey(name: 'is_open_now')  bool isOpenNow,  String status, @JsonKey(name: 'verification_status')  String verificationStatus, @JsonKey(name: 'is_featured')  bool isFeatured, @JsonKey(fromJson: _toDouble)  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'media_urls')  List<String> mediaUrls,  List<AmenityModel> amenities, @JsonKey(name: 'fee_plans')  List<FeePlanModel> feePlans,  List<ActivityBatchModel> batches,  List<ActivityInstructorModel> instructors,  List<ActivityReviewModel> reviews,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.typeId,_that.categoryName,_that.typeName,_that.categorySlug,_that.typeSlug,_that.cityId,_that.cityName,_that.city,_that.category,_that.type,_that.address,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.contactPhone,_that.contactEmail,_that.website,_that.openingTime,_that.closingTime,_that.isOpenNow,_that.status,_that.verificationStatus,_that.isFeatured,_that.rating,_that.reviewCount,_that.imageUrl,_that.mediaUrls,_that.amenities,_that.feePlans,_that.batches,_that.instructors,_that.reviews,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'type_id')  String? typeId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'category_slug')  String? categorySlug, @JsonKey(name: 'type_slug')  String? typeSlug, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'city_name')  String? cityName,  CityModel? city,  ActivityCategoryModel? category,  ActivityTypeModel? type,  String? address, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail,  String? website, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime, @JsonKey(name: 'is_open_now')  bool isOpenNow,  String status, @JsonKey(name: 'verification_status')  String verificationStatus, @JsonKey(name: 'is_featured')  bool isFeatured, @JsonKey(fromJson: _toDouble)  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'media_urls')  List<String> mediaUrls,  List<AmenityModel> amenities, @JsonKey(name: 'fee_plans')  List<FeePlanModel> feePlans,  List<ActivityBatchModel> batches,  List<ActivityInstructorModel> instructors,  List<ActivityReviewModel> reviews,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.typeId,_that.categoryName,_that.typeName,_that.categorySlug,_that.typeSlug,_that.cityId,_that.cityName,_that.city,_that.category,_that.type,_that.address,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.contactPhone,_that.contactEmail,_that.website,_that.openingTime,_that.closingTime,_that.isOpenNow,_that.status,_that.verificationStatus,_that.isFeatured,_that.rating,_that.reviewCount,_that.imageUrl,_that.mediaUrls,_that.amenities,_that.feePlans,_that.batches,_that.instructors,_that.reviews,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'type_id')  String? typeId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'category_slug')  String? categorySlug, @JsonKey(name: 'type_slug')  String? typeSlug, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'city_name')  String? cityName,  CityModel? city,  ActivityCategoryModel? category,  ActivityTypeModel? type,  String? address, @JsonKey(fromJson: _toDouble)  double? latitude, @JsonKey(fromJson: _toDouble)  double? longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble)  double? distanceKm, @JsonKey(name: 'distance_formatted')  String? distanceFormatted, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'contact_email')  String? contactEmail,  String? website, @JsonKey(name: 'opening_time')  String? openingTime, @JsonKey(name: 'closing_time')  String? closingTime, @JsonKey(name: 'is_open_now')  bool isOpenNow,  String status, @JsonKey(name: 'verification_status')  String verificationStatus, @JsonKey(name: 'is_featured')  bool isFeatured, @JsonKey(fromJson: _toDouble)  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'media_urls')  List<String> mediaUrls,  List<AmenityModel> amenities, @JsonKey(name: 'fee_plans')  List<FeePlanModel> feePlans,  List<ActivityBatchModel> batches,  List<ActivityInstructorModel> instructors,  List<ActivityReviewModel> reviews,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.typeId,_that.categoryName,_that.typeName,_that.categorySlug,_that.typeSlug,_that.cityId,_that.cityName,_that.city,_that.category,_that.type,_that.address,_that.latitude,_that.longitude,_that.distanceKm,_that.distanceFormatted,_that.contactPhone,_that.contactEmail,_that.website,_that.openingTime,_that.closingTime,_that.isOpenNow,_that.status,_that.verificationStatus,_that.isFeatured,_that.rating,_that.reviewCount,_that.imageUrl,_that.mediaUrls,_that.amenities,_that.feePlans,_that.batches,_that.instructors,_that.reviews,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityModel extends ActivityModel {
  const _ActivityModel({required this.id, required this.name, this.description, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'type_id') this.typeId, @JsonKey(name: 'category_name') this.categoryName, @JsonKey(name: 'type_name') this.typeName, @JsonKey(name: 'category_slug') this.categorySlug, @JsonKey(name: 'type_slug') this.typeSlug, @JsonKey(name: 'city_id') this.cityId, @JsonKey(name: 'city_name') this.cityName, this.city, this.category, this.type, this.address, @JsonKey(fromJson: _toDouble) this.latitude, @JsonKey(fromJson: _toDouble) this.longitude, @JsonKey(name: 'distance_km', fromJson: _toDouble) this.distanceKm, @JsonKey(name: 'distance_formatted') this.distanceFormatted, @JsonKey(name: 'contact_phone') this.contactPhone, @JsonKey(name: 'contact_email') this.contactEmail, this.website, @JsonKey(name: 'opening_time') this.openingTime, @JsonKey(name: 'closing_time') this.closingTime, @JsonKey(name: 'is_open_now') this.isOpenNow = false, this.status = 'active', @JsonKey(name: 'verification_status') this.verificationStatus = 'pending', @JsonKey(name: 'is_featured') this.isFeatured = false, @JsonKey(fromJson: _toDouble) this.rating = 0.0, @JsonKey(name: 'review_count') this.reviewCount = 0, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'media_urls') final  List<String> mediaUrls = const [], final  List<AmenityModel> amenities = const [], @JsonKey(name: 'fee_plans') final  List<FeePlanModel> feePlans = const [], final  List<ActivityBatchModel> batches = const [], final  List<ActivityInstructorModel> instructors = const [], final  List<ActivityReviewModel> reviews = const [], final  Map<String, dynamic>? metadata}): _mediaUrls = mediaUrls,_amenities = amenities,_feePlans = feePlans,_batches = batches,_instructors = instructors,_reviews = reviews,_metadata = metadata,super._();
  factory _ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'type_id') final  String? typeId;
@override@JsonKey(name: 'category_name') final  String? categoryName;
@override@JsonKey(name: 'type_name') final  String? typeName;
@override@JsonKey(name: 'category_slug') final  String? categorySlug;
@override@JsonKey(name: 'type_slug') final  String? typeSlug;
@override@JsonKey(name: 'city_id') final  String? cityId;
@override@JsonKey(name: 'city_name') final  String? cityName;
@override final  CityModel? city;
@override final  ActivityCategoryModel? category;
@override final  ActivityTypeModel? type;
@override final  String? address;
@override@JsonKey(fromJson: _toDouble) final  double? latitude;
@override@JsonKey(fromJson: _toDouble) final  double? longitude;
@override@JsonKey(name: 'distance_km', fromJson: _toDouble) final  double? distanceKm;
@override@JsonKey(name: 'distance_formatted') final  String? distanceFormatted;
@override@JsonKey(name: 'contact_phone') final  String? contactPhone;
@override@JsonKey(name: 'contact_email') final  String? contactEmail;
@override final  String? website;
@override@JsonKey(name: 'opening_time') final  String? openingTime;
@override@JsonKey(name: 'closing_time') final  String? closingTime;
@override@JsonKey(name: 'is_open_now') final  bool isOpenNow;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'verification_status') final  String verificationStatus;
@override@JsonKey(name: 'is_featured') final  bool isFeatured;
@override@JsonKey(fromJson: _toDouble) final  double rating;
@override@JsonKey(name: 'review_count') final  int reviewCount;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
 final  List<String> _mediaUrls;
@override@JsonKey(name: 'media_urls') List<String> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}

 final  List<AmenityModel> _amenities;
@override@JsonKey() List<AmenityModel> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

 final  List<FeePlanModel> _feePlans;
@override@JsonKey(name: 'fee_plans') List<FeePlanModel> get feePlans {
  if (_feePlans is EqualUnmodifiableListView) return _feePlans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feePlans);
}

 final  List<ActivityBatchModel> _batches;
@override@JsonKey() List<ActivityBatchModel> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

 final  List<ActivityInstructorModel> _instructors;
@override@JsonKey() List<ActivityInstructorModel> get instructors {
  if (_instructors is EqualUnmodifiableListView) return _instructors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructors);
}

 final  List<ActivityReviewModel> _reviews;
@override@JsonKey() List<ActivityReviewModel> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}

 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityModelCopyWith<_ActivityModel> get copyWith => __$ActivityModelCopyWithImpl<_ActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.typeName, typeName) || other.typeName == typeName)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.typeSlug, typeSlug) || other.typeSlug == typeSlug)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.city, city) || other.city == city)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.distanceFormatted, distanceFormatted) || other.distanceFormatted == distanceFormatted)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.website, website) || other.website == website)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime)&&(identical(other.isOpenNow, isOpenNow) || other.isOpenNow == isOpenNow)&&(identical(other.status, status) || other.status == status)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._feePlans, _feePlans)&&const DeepCollectionEquality().equals(other._batches, _batches)&&const DeepCollectionEquality().equals(other._instructors, _instructors)&&const DeepCollectionEquality().equals(other._reviews, _reviews)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,categoryId,typeId,categoryName,typeName,categorySlug,typeSlug,cityId,cityName,city,category,type,address,latitude,longitude,distanceKm,distanceFormatted,contactPhone,contactEmail,website,openingTime,closingTime,isOpenNow,status,verificationStatus,isFeatured,rating,reviewCount,imageUrl,const DeepCollectionEquality().hash(_mediaUrls),const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_feePlans),const DeepCollectionEquality().hash(_batches),const DeepCollectionEquality().hash(_instructors),const DeepCollectionEquality().hash(_reviews),const DeepCollectionEquality().hash(_metadata)]);

@override
String toString() {
  return 'ActivityModel(id: $id, name: $name, description: $description, categoryId: $categoryId, typeId: $typeId, categoryName: $categoryName, typeName: $typeName, categorySlug: $categorySlug, typeSlug: $typeSlug, cityId: $cityId, cityName: $cityName, city: $city, category: $category, type: $type, address: $address, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, distanceFormatted: $distanceFormatted, contactPhone: $contactPhone, contactEmail: $contactEmail, website: $website, openingTime: $openingTime, closingTime: $closingTime, isOpenNow: $isOpenNow, status: $status, verificationStatus: $verificationStatus, isFeatured: $isFeatured, rating: $rating, reviewCount: $reviewCount, imageUrl: $imageUrl, mediaUrls: $mediaUrls, amenities: $amenities, feePlans: $feePlans, batches: $batches, instructors: $instructors, reviews: $reviews, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'type_id') String? typeId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'type_name') String? typeName,@JsonKey(name: 'category_slug') String? categorySlug,@JsonKey(name: 'type_slug') String? typeSlug,@JsonKey(name: 'city_id') String? cityId,@JsonKey(name: 'city_name') String? cityName, CityModel? city, ActivityCategoryModel? category, ActivityTypeModel? type, String? address,@JsonKey(fromJson: _toDouble) double? latitude,@JsonKey(fromJson: _toDouble) double? longitude,@JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,@JsonKey(name: 'distance_formatted') String? distanceFormatted,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'contact_email') String? contactEmail, String? website,@JsonKey(name: 'opening_time') String? openingTime,@JsonKey(name: 'closing_time') String? closingTime,@JsonKey(name: 'is_open_now') bool isOpenNow, String status,@JsonKey(name: 'verification_status') String verificationStatus,@JsonKey(name: 'is_featured') bool isFeatured,@JsonKey(fromJson: _toDouble) double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'media_urls') List<String> mediaUrls, List<AmenityModel> amenities,@JsonKey(name: 'fee_plans') List<FeePlanModel> feePlans, List<ActivityBatchModel> batches, List<ActivityInstructorModel> instructors, List<ActivityReviewModel> reviews, Map<String, dynamic>? metadata
});


@override $CityModelCopyWith<$Res>? get city;@override $ActivityCategoryModelCopyWith<$Res>? get category;@override $ActivityTypeModelCopyWith<$Res>? get type;

}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? categoryId = freezed,Object? typeId = freezed,Object? categoryName = freezed,Object? typeName = freezed,Object? categorySlug = freezed,Object? typeSlug = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? city = freezed,Object? category = freezed,Object? type = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distanceKm = freezed,Object? distanceFormatted = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? website = freezed,Object? openingTime = freezed,Object? closingTime = freezed,Object? isOpenNow = null,Object? status = null,Object? verificationStatus = null,Object? isFeatured = null,Object? rating = null,Object? reviewCount = null,Object? imageUrl = freezed,Object? mediaUrls = null,Object? amenities = null,Object? feePlans = null,Object? batches = null,Object? instructors = null,Object? reviews = null,Object? metadata = freezed,}) {
  return _then(_ActivityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,typeId: freezed == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,typeSlug: freezed == typeSlug ? _self.typeSlug : typeSlug // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ActivityCategoryModel?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityTypeModel?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,distanceFormatted: freezed == distanceFormatted ? _self.distanceFormatted : distanceFormatted // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,isOpenNow: null == isOpenNow ? _self.isOpenNow : isOpenNow // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<AmenityModel>,feePlans: null == feePlans ? _self._feePlans : feePlans // ignore: cast_nullable_to_non_nullable
as List<FeePlanModel>,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<ActivityBatchModel>,instructors: null == instructors ? _self._instructors : instructors // ignore: cast_nullable_to_non_nullable
as List<ActivityInstructorModel>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ActivityReviewModel>,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of ActivityModel
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
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ActivityCategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityTypeModelCopyWith<$Res>? get type {
    if (_self.type == null) {
    return null;
  }

  return $ActivityTypeModelCopyWith<$Res>(_self.type!, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}

// dart format on
