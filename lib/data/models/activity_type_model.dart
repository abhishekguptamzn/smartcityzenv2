import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_type_model.freezed.dart';
part 'activity_type_model.g.dart';

@freezed
abstract class ActivityTypeModel with _$ActivityTypeModel {
  const factory ActivityTypeModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'category_slug') String? categorySlug,
    required String name,
    required String slug,
    String? description,
    String? icon,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'activities_count') @Default(0) int activitiesCount,
  }) = _ActivityTypeModel;

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityTypeModelFromJson(json);
}
