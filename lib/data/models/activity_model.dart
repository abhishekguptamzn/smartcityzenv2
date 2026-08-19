import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_batch_model.dart';
import 'activity_category_model.dart';
import 'activity_instructor_model.dart';
import 'activity_review_model.dart';
import 'activity_type_model.dart';
import 'amenity_model.dart';
import 'city_model.dart';
import 'fee_plan_model.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
abstract class ActivityModel with _$ActivityModel {
  const ActivityModel._();

  const factory ActivityModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'type_id') String? typeId,
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'type_name') String? typeName,
    @JsonKey(name: 'category_slug') String? categorySlug,
    @JsonKey(name: 'type_slug') String? typeSlug,
    @JsonKey(name: 'city_id') String? cityId,
    @JsonKey(name: 'city_name') String? cityName,
    CityModel? city,
    ActivityCategoryModel? category,
    ActivityTypeModel? type,
    String? address,
    @JsonKey(fromJson: _toDouble) double? latitude,
    @JsonKey(fromJson: _toDouble) double? longitude,
    @JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,
    @JsonKey(name: 'distance_formatted') String? distanceFormatted,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'contact_email') String? contactEmail,
    String? website,
    @JsonKey(name: 'opening_time') String? openingTime,
    @JsonKey(name: 'closing_time') String? closingTime,
    @JsonKey(name: 'is_open_now') @Default(false) bool isOpenNow,
    @Default('active') String status,
    @JsonKey(name: 'verification_status') @Default('pending') String verificationStatus,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'media_urls') @Default([]) List<String> mediaUrls,
    @Default([]) List<AmenityModel> amenities,
    @JsonKey(name: 'fee_plans') @Default([]) List<FeePlanModel> feePlans,
    @Default([]) List<ActivityBatchModel> batches,
    @Default([]) List<ActivityInstructorModel> instructors,
    @Default([]) List<ActivityReviewModel> reviews,
    Map<String, dynamic>? metadata,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  bool get isVerified => verificationStatus == 'verified';

  String get displayRating => rating > 0 ? rating.toStringAsFixed(1) : 'New';

  String get timeFormatted {
    if (openingTime == null || closingTime == null) return 'Flexible Hours';
    final open = openingTime!.length >= 5 ? openingTime!.substring(0, 5) : openingTime!;
    final close = closingTime!.length >= 5 ? closingTime!.substring(0, 5) : closingTime!;
    return '$open – $close';
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
