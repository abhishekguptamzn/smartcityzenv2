// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityCategoryModel _$ActivityCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ActivityCategoryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  typesCount: (json['types_count'] as num?)?.toInt() ?? 0,
  activitiesCount: (json['activities_count'] as num?)?.toInt() ?? 0,
  types:
      (json['types'] as List<dynamic>?)
          ?.map(
            (e) => ActivityTypeSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ActivityCategoryModelToJson(
  _ActivityCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'icon': instance.icon,
  'color': instance.color,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'types_count': instance.typesCount,
  'activities_count': instance.activitiesCount,
  'types': instance.types,
};

_ActivityTypeSummaryModel _$ActivityTypeSummaryModelFromJson(
  Map<String, dynamic> json,
) => _ActivityTypeSummaryModel(
  id: json['id'] as String,
  categoryId: json['category_id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  icon: json['icon'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  activitiesCount: (json['activities_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ActivityTypeSummaryModelToJson(
  _ActivityTypeSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'category_id': instance.categoryId,
  'name': instance.name,
  'slug': instance.slug,
  'icon': instance.icon,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'activities_count': instance.activitiesCount,
};
