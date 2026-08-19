import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_category_model.freezed.dart';
part 'activity_category_model.g.dart';

@freezed
abstract class ActivityCategoryModel with _$ActivityCategoryModel {
  const factory ActivityCategoryModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? icon,
    String? color,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'types_count') @Default(0) int typesCount,
    @JsonKey(name: 'activities_count') @Default(0) int activitiesCount,
    @Default([]) List<ActivityTypeSummaryModel> types,
  }) = _ActivityCategoryModel;

  factory ActivityCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityCategoryModelFromJson(json);
}

@freezed
abstract class ActivityTypeSummaryModel with _$ActivityTypeSummaryModel {
  const factory ActivityTypeSummaryModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    required String slug,
    String? icon,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'activities_count') @Default(0) int activitiesCount,
  }) = _ActivityTypeSummaryModel;

  factory ActivityTypeSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityTypeSummaryModelFromJson(json);
}
