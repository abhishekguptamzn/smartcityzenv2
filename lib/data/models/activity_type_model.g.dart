// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityTypeModel _$ActivityTypeModelFromJson(Map<String, dynamic> json) =>
    _ActivityTypeModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String?,
      categorySlug: json['category_slug'] as String?,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      activitiesCount: (json['activities_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ActivityTypeModelToJson(_ActivityTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_slug': instance.categorySlug,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon': instance.icon,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'activities_count': instance.activitiesCount,
    };
