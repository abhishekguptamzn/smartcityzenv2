// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityModel _$ActivityModelFromJson(
  Map<String, dynamic> json,
) => _ActivityModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  categoryId: json['category_id'] as String?,
  typeId: json['type_id'] as String?,
  categoryName: json['category_name'] as String?,
  typeName: json['type_name'] as String?,
  categorySlug: json['category_slug'] as String?,
  typeSlug: json['type_slug'] as String?,
  cityId: json['city_id'] as String?,
  cityName: json['city_name'] as String?,
  city: json['city'] == null
      ? null
      : CityModel.fromJson(json['city'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : ActivityCategoryModel.fromJson(
          json['category'] as Map<String, dynamic>,
        ),
  type: json['type'] == null
      ? null
      : ActivityTypeModel.fromJson(json['type'] as Map<String, dynamic>),
  address: json['address'] as String?,
  latitude: _toDouble(json['latitude']),
  longitude: _toDouble(json['longitude']),
  distanceKm: _toDouble(json['distance_km']),
  distanceFormatted: json['distance_formatted'] as String?,
  contactPhone: json['contact_phone'] as String?,
  contactEmail: json['contact_email'] as String?,
  website: json['website'] as String?,
  openingTime: json['opening_time'] as String?,
  closingTime: json['closing_time'] as String?,
  isOpenNow: json['is_open_now'] as bool? ?? false,
  status: json['status'] as String? ?? 'active',
  verificationStatus: json['verification_status'] as String? ?? 'pending',
  isFeatured: json['is_featured'] as bool? ?? false,
  rating: json['rating'] == null ? 0.0 : _toDouble(json['rating']),
  reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
  imageUrl: json['image_url'] as String?,
  mediaUrls:
      (json['media_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  amenities:
      (json['amenities'] as List<dynamic>?)
          ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  feePlans:
      (json['fee_plans'] as List<dynamic>?)
          ?.map((e) => FeePlanModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  batches:
      (json['batches'] as List<dynamic>?)
          ?.map((e) => ActivityBatchModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  instructors:
      (json['instructors'] as List<dynamic>?)
          ?.map(
            (e) => ActivityInstructorModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map((e) => ActivityReviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category_id': instance.categoryId,
      'type_id': instance.typeId,
      'category_name': instance.categoryName,
      'type_name': instance.typeName,
      'category_slug': instance.categorySlug,
      'type_slug': instance.typeSlug,
      'city_id': instance.cityId,
      'city_name': instance.cityName,
      'city': instance.city,
      'category': instance.category,
      'type': instance.type,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance_km': instance.distanceKm,
      'distance_formatted': instance.distanceFormatted,
      'contact_phone': instance.contactPhone,
      'contact_email': instance.contactEmail,
      'website': instance.website,
      'opening_time': instance.openingTime,
      'closing_time': instance.closingTime,
      'is_open_now': instance.isOpenNow,
      'status': instance.status,
      'verification_status': instance.verificationStatus,
      'is_featured': instance.isFeatured,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'image_url': instance.imageUrl,
      'media_urls': instance.mediaUrls,
      'amenities': instance.amenities,
      'fee_plans': instance.feePlans,
      'batches': instance.batches,
      'instructors': instance.instructors,
      'reviews': instance.reviews,
      'metadata': instance.metadata,
    };
