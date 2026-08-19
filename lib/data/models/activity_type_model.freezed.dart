// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityTypeModel {

 String get id;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'category_name') String? get categoryName;@JsonKey(name: 'category_slug') String? get categorySlug; String get name; String get slug; String? get description; String? get icon;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'activities_count') int get activitiesCount;
/// Create a copy of ActivityTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityTypeModelCopyWith<ActivityTypeModel> get copyWith => _$ActivityTypeModelCopyWithImpl<ActivityTypeModel>(this as ActivityTypeModel, _$identity);

  /// Serializes this ActivityTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,categorySlug,name,slug,description,icon,sortOrder,isActive,activitiesCount);

@override
String toString() {
  return 'ActivityTypeModel(id: $id, categoryId: $categoryId, categoryName: $categoryName, categorySlug: $categorySlug, name: $name, slug: $slug, description: $description, icon: $icon, sortOrder: $sortOrder, isActive: $isActive, activitiesCount: $activitiesCount)';
}


}

/// @nodoc
abstract mixin class $ActivityTypeModelCopyWith<$Res>  {
  factory $ActivityTypeModelCopyWith(ActivityTypeModel value, $Res Function(ActivityTypeModel) _then) = _$ActivityTypeModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'category_slug') String? categorySlug, String name, String slug, String? description, String? icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'activities_count') int activitiesCount
});




}
/// @nodoc
class _$ActivityTypeModelCopyWithImpl<$Res>
    implements $ActivityTypeModelCopyWith<$Res> {
  _$ActivityTypeModelCopyWithImpl(this._self, this._then);

  final ActivityTypeModel _self;
  final $Res Function(ActivityTypeModel) _then;

/// Create a copy of ActivityTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? categorySlug = freezed,Object? name = null,Object? slug = null,Object? description = freezed,Object? icon = freezed,Object? sortOrder = null,Object? isActive = null,Object? activitiesCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityTypeModel].
extension ActivityTypeModelPatterns on ActivityTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_slug')  String? categorySlug,  String name,  String slug,  String? description,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityTypeModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.categorySlug,_that.name,_that.slug,_that.description,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_slug')  String? categorySlug,  String name,  String slug,  String? description,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)  $default,) {final _that = this;
switch (_that) {
case _ActivityTypeModel():
return $default(_that.id,_that.categoryId,_that.categoryName,_that.categorySlug,_that.name,_that.slug,_that.description,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_slug')  String? categorySlug,  String name,  String slug,  String? description,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)?  $default,) {final _that = this;
switch (_that) {
case _ActivityTypeModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.categorySlug,_that.name,_that.slug,_that.description,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityTypeModel implements ActivityTypeModel {
  const _ActivityTypeModel({required this.id, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_name') this.categoryName, @JsonKey(name: 'category_slug') this.categorySlug, required this.name, required this.slug, this.description, this.icon, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'activities_count') this.activitiesCount = 0});
  factory _ActivityTypeModel.fromJson(Map<String, dynamic> json) => _$ActivityTypeModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'category_name') final  String? categoryName;
@override@JsonKey(name: 'category_slug') final  String? categorySlug;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? icon;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'activities_count') final  int activitiesCount;

/// Create a copy of ActivityTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityTypeModelCopyWith<_ActivityTypeModel> get copyWith => __$ActivityTypeModelCopyWithImpl<_ActivityTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,categorySlug,name,slug,description,icon,sortOrder,isActive,activitiesCount);

@override
String toString() {
  return 'ActivityTypeModel(id: $id, categoryId: $categoryId, categoryName: $categoryName, categorySlug: $categorySlug, name: $name, slug: $slug, description: $description, icon: $icon, sortOrder: $sortOrder, isActive: $isActive, activitiesCount: $activitiesCount)';
}


}

/// @nodoc
abstract mixin class _$ActivityTypeModelCopyWith<$Res> implements $ActivityTypeModelCopyWith<$Res> {
  factory _$ActivityTypeModelCopyWith(_ActivityTypeModel value, $Res Function(_ActivityTypeModel) _then) = __$ActivityTypeModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'category_slug') String? categorySlug, String name, String slug, String? description, String? icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'activities_count') int activitiesCount
});




}
/// @nodoc
class __$ActivityTypeModelCopyWithImpl<$Res>
    implements _$ActivityTypeModelCopyWith<$Res> {
  __$ActivityTypeModelCopyWithImpl(this._self, this._then);

  final _ActivityTypeModel _self;
  final $Res Function(_ActivityTypeModel) _then;

/// Create a copy of ActivityTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? categorySlug = freezed,Object? name = null,Object? slug = null,Object? description = freezed,Object? icon = freezed,Object? sortOrder = null,Object? isActive = null,Object? activitiesCount = null,}) {
  return _then(_ActivityTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
