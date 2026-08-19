// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityCategoryModel {

 String get id; String get name; String get slug; String? get description; String? get icon; String? get color;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'types_count') int get typesCount;@JsonKey(name: 'activities_count') int get activitiesCount; List<ActivityTypeSummaryModel> get types;
/// Create a copy of ActivityCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCategoryModelCopyWith<ActivityCategoryModel> get copyWith => _$ActivityCategoryModelCopyWithImpl<ActivityCategoryModel>(this as ActivityCategoryModel, _$identity);

  /// Serializes this ActivityCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.typesCount, typesCount) || other.typesCount == typesCount)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount)&&const DeepCollectionEquality().equals(other.types, types));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,icon,color,sortOrder,isActive,typesCount,activitiesCount,const DeepCollectionEquality().hash(types));

@override
String toString() {
  return 'ActivityCategoryModel(id: $id, name: $name, slug: $slug, description: $description, icon: $icon, color: $color, sortOrder: $sortOrder, isActive: $isActive, typesCount: $typesCount, activitiesCount: $activitiesCount, types: $types)';
}


}

/// @nodoc
abstract mixin class $ActivityCategoryModelCopyWith<$Res>  {
  factory $ActivityCategoryModelCopyWith(ActivityCategoryModel value, $Res Function(ActivityCategoryModel) _then) = _$ActivityCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description, String? icon, String? color,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'types_count') int typesCount,@JsonKey(name: 'activities_count') int activitiesCount, List<ActivityTypeSummaryModel> types
});




}
/// @nodoc
class _$ActivityCategoryModelCopyWithImpl<$Res>
    implements $ActivityCategoryModelCopyWith<$Res> {
  _$ActivityCategoryModelCopyWithImpl(this._self, this._then);

  final ActivityCategoryModel _self;
  final $Res Function(ActivityCategoryModel) _then;

/// Create a copy of ActivityCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? isActive = null,Object? typesCount = null,Object? activitiesCount = null,Object? types = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,typesCount: null == typesCount ? _self.typesCount : typesCount // ignore: cast_nullable_to_non_nullable
as int,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<ActivityTypeSummaryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityCategoryModel].
extension ActivityCategoryModelPatterns on ActivityCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? icon,  String? color, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'types_count')  int typesCount, @JsonKey(name: 'activities_count')  int activitiesCount,  List<ActivityTypeSummaryModel> types)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.icon,_that.color,_that.sortOrder,_that.isActive,_that.typesCount,_that.activitiesCount,_that.types);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? icon,  String? color, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'types_count')  int typesCount, @JsonKey(name: 'activities_count')  int activitiesCount,  List<ActivityTypeSummaryModel> types)  $default,) {final _that = this;
switch (_that) {
case _ActivityCategoryModel():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.icon,_that.color,_that.sortOrder,_that.isActive,_that.typesCount,_that.activitiesCount,_that.types);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description,  String? icon,  String? color, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'types_count')  int typesCount, @JsonKey(name: 'activities_count')  int activitiesCount,  List<ActivityTypeSummaryModel> types)?  $default,) {final _that = this;
switch (_that) {
case _ActivityCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.icon,_that.color,_that.sortOrder,_that.isActive,_that.typesCount,_that.activitiesCount,_that.types);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityCategoryModel implements ActivityCategoryModel {
  const _ActivityCategoryModel({required this.id, required this.name, required this.slug, this.description, this.icon, this.color, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'types_count') this.typesCount = 0, @JsonKey(name: 'activities_count') this.activitiesCount = 0, final  List<ActivityTypeSummaryModel> types = const []}): _types = types;
  factory _ActivityCategoryModel.fromJson(Map<String, dynamic> json) => _$ActivityCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? icon;
@override final  String? color;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'types_count') final  int typesCount;
@override@JsonKey(name: 'activities_count') final  int activitiesCount;
 final  List<ActivityTypeSummaryModel> _types;
@override@JsonKey() List<ActivityTypeSummaryModel> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}


/// Create a copy of ActivityCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCategoryModelCopyWith<_ActivityCategoryModel> get copyWith => __$ActivityCategoryModelCopyWithImpl<_ActivityCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.typesCount, typesCount) || other.typesCount == typesCount)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount)&&const DeepCollectionEquality().equals(other._types, _types));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,icon,color,sortOrder,isActive,typesCount,activitiesCount,const DeepCollectionEquality().hash(_types));

@override
String toString() {
  return 'ActivityCategoryModel(id: $id, name: $name, slug: $slug, description: $description, icon: $icon, color: $color, sortOrder: $sortOrder, isActive: $isActive, typesCount: $typesCount, activitiesCount: $activitiesCount, types: $types)';
}


}

/// @nodoc
abstract mixin class _$ActivityCategoryModelCopyWith<$Res> implements $ActivityCategoryModelCopyWith<$Res> {
  factory _$ActivityCategoryModelCopyWith(_ActivityCategoryModel value, $Res Function(_ActivityCategoryModel) _then) = __$ActivityCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description, String? icon, String? color,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'types_count') int typesCount,@JsonKey(name: 'activities_count') int activitiesCount, List<ActivityTypeSummaryModel> types
});




}
/// @nodoc
class __$ActivityCategoryModelCopyWithImpl<$Res>
    implements _$ActivityCategoryModelCopyWith<$Res> {
  __$ActivityCategoryModelCopyWithImpl(this._self, this._then);

  final _ActivityCategoryModel _self;
  final $Res Function(_ActivityCategoryModel) _then;

/// Create a copy of ActivityCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? isActive = null,Object? typesCount = null,Object? activitiesCount = null,Object? types = null,}) {
  return _then(_ActivityCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,typesCount: null == typesCount ? _self.typesCount : typesCount // ignore: cast_nullable_to_non_nullable
as int,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<ActivityTypeSummaryModel>,
  ));
}


}


/// @nodoc
mixin _$ActivityTypeSummaryModel {

 String get id;@JsonKey(name: 'category_id') String get categoryId; String get name; String get slug; String? get icon;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'activities_count') int get activitiesCount;
/// Create a copy of ActivityTypeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityTypeSummaryModelCopyWith<ActivityTypeSummaryModel> get copyWith => _$ActivityTypeSummaryModelCopyWithImpl<ActivityTypeSummaryModel>(this as ActivityTypeSummaryModel, _$identity);

  /// Serializes this ActivityTypeSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityTypeSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,slug,icon,sortOrder,isActive,activitiesCount);

@override
String toString() {
  return 'ActivityTypeSummaryModel(id: $id, categoryId: $categoryId, name: $name, slug: $slug, icon: $icon, sortOrder: $sortOrder, isActive: $isActive, activitiesCount: $activitiesCount)';
}


}

/// @nodoc
abstract mixin class $ActivityTypeSummaryModelCopyWith<$Res>  {
  factory $ActivityTypeSummaryModelCopyWith(ActivityTypeSummaryModel value, $Res Function(ActivityTypeSummaryModel) _then) = _$ActivityTypeSummaryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId, String name, String slug, String? icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'activities_count') int activitiesCount
});




}
/// @nodoc
class _$ActivityTypeSummaryModelCopyWithImpl<$Res>
    implements $ActivityTypeSummaryModelCopyWith<$Res> {
  _$ActivityTypeSummaryModelCopyWithImpl(this._self, this._then);

  final ActivityTypeSummaryModel _self;
  final $Res Function(ActivityTypeSummaryModel) _then;

/// Create a copy of ActivityTypeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? slug = null,Object? icon = freezed,Object? sortOrder = null,Object? isActive = null,Object? activitiesCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityTypeSummaryModel].
extension ActivityTypeSummaryModelPatterns on ActivityTypeSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityTypeSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityTypeSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityTypeSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId,  String name,  String slug,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.slug,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId,  String name,  String slug,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)  $default,) {final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel():
return $default(_that.id,_that.categoryId,_that.name,_that.slug,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'category_id')  String categoryId,  String name,  String slug,  String? icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'activities_count')  int activitiesCount)?  $default,) {final _that = this;
switch (_that) {
case _ActivityTypeSummaryModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.slug,_that.icon,_that.sortOrder,_that.isActive,_that.activitiesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityTypeSummaryModel implements ActivityTypeSummaryModel {
  const _ActivityTypeSummaryModel({required this.id, @JsonKey(name: 'category_id') required this.categoryId, required this.name, required this.slug, this.icon, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'activities_count') this.activitiesCount = 0});
  factory _ActivityTypeSummaryModel.fromJson(Map<String, dynamic> json) => _$ActivityTypeSummaryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override final  String name;
@override final  String slug;
@override final  String? icon;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'activities_count') final  int activitiesCount;

/// Create a copy of ActivityTypeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityTypeSummaryModelCopyWith<_ActivityTypeSummaryModel> get copyWith => __$ActivityTypeSummaryModelCopyWithImpl<_ActivityTypeSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityTypeSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityTypeSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activitiesCount, activitiesCount) || other.activitiesCount == activitiesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,slug,icon,sortOrder,isActive,activitiesCount);

@override
String toString() {
  return 'ActivityTypeSummaryModel(id: $id, categoryId: $categoryId, name: $name, slug: $slug, icon: $icon, sortOrder: $sortOrder, isActive: $isActive, activitiesCount: $activitiesCount)';
}


}

/// @nodoc
abstract mixin class _$ActivityTypeSummaryModelCopyWith<$Res> implements $ActivityTypeSummaryModelCopyWith<$Res> {
  factory _$ActivityTypeSummaryModelCopyWith(_ActivityTypeSummaryModel value, $Res Function(_ActivityTypeSummaryModel) _then) = __$ActivityTypeSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId, String name, String slug, String? icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'activities_count') int activitiesCount
});




}
/// @nodoc
class __$ActivityTypeSummaryModelCopyWithImpl<$Res>
    implements _$ActivityTypeSummaryModelCopyWith<$Res> {
  __$ActivityTypeSummaryModelCopyWithImpl(this._self, this._then);

  final _ActivityTypeSummaryModel _self;
  final $Res Function(_ActivityTypeSummaryModel) _then;

/// Create a copy of ActivityTypeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? slug = null,Object? icon = freezed,Object? sortOrder = null,Object? isActive = null,Object? activitiesCount = null,}) {
  return _then(_ActivityTypeSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activitiesCount: null == activitiesCount ? _self.activitiesCount : activitiesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
