// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amenity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AmenityModel {

 String get id; String get name; String? get icon;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'facility_is_active') bool get facilityIsActive;
/// Create a copy of AmenityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmenityModelCopyWith<AmenityModel> get copyWith => _$AmenityModelCopyWithImpl<AmenityModel>(this as AmenityModel, _$identity);

  /// Serializes this AmenityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AmenityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.facilityIsActive, facilityIsActive) || other.facilityIsActive == facilityIsActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,isActive,facilityIsActive);

@override
String toString() {
  return 'AmenityModel(id: $id, name: $name, icon: $icon, isActive: $isActive, facilityIsActive: $facilityIsActive)';
}


}

/// @nodoc
abstract mixin class $AmenityModelCopyWith<$Res>  {
  factory $AmenityModelCopyWith(AmenityModel value, $Res Function(AmenityModel) _then) = _$AmenityModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? icon,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'facility_is_active') bool facilityIsActive
});




}
/// @nodoc
class _$AmenityModelCopyWithImpl<$Res>
    implements $AmenityModelCopyWith<$Res> {
  _$AmenityModelCopyWithImpl(this._self, this._then);

  final AmenityModel _self;
  final $Res Function(AmenityModel) _then;

/// Create a copy of AmenityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? isActive = null,Object? facilityIsActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,facilityIsActive: null == facilityIsActive ? _self.facilityIsActive : facilityIsActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AmenityModel].
extension AmenityModelPatterns on AmenityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AmenityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AmenityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AmenityModel value)  $default,){
final _that = this;
switch (_that) {
case _AmenityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AmenityModel value)?  $default,){
final _that = this;
switch (_that) {
case _AmenityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? icon, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'facility_is_active')  bool facilityIsActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AmenityModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.isActive,_that.facilityIsActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? icon, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'facility_is_active')  bool facilityIsActive)  $default,) {final _that = this;
switch (_that) {
case _AmenityModel():
return $default(_that.id,_that.name,_that.icon,_that.isActive,_that.facilityIsActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? icon, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'facility_is_active')  bool facilityIsActive)?  $default,) {final _that = this;
switch (_that) {
case _AmenityModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.isActive,_that.facilityIsActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AmenityModel extends AmenityModel {
  const _AmenityModel({required this.id, required this.name, this.icon, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'facility_is_active') this.facilityIsActive = true}): super._();
  factory _AmenityModel.fromJson(Map<String, dynamic> json) => _$AmenityModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? icon;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'facility_is_active') final  bool facilityIsActive;

/// Create a copy of AmenityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmenityModelCopyWith<_AmenityModel> get copyWith => __$AmenityModelCopyWithImpl<_AmenityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AmenityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmenityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.facilityIsActive, facilityIsActive) || other.facilityIsActive == facilityIsActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,isActive,facilityIsActive);

@override
String toString() {
  return 'AmenityModel(id: $id, name: $name, icon: $icon, isActive: $isActive, facilityIsActive: $facilityIsActive)';
}


}

/// @nodoc
abstract mixin class _$AmenityModelCopyWith<$Res> implements $AmenityModelCopyWith<$Res> {
  factory _$AmenityModelCopyWith(_AmenityModel value, $Res Function(_AmenityModel) _then) = __$AmenityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? icon,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'facility_is_active') bool facilityIsActive
});




}
/// @nodoc
class __$AmenityModelCopyWithImpl<$Res>
    implements _$AmenityModelCopyWith<$Res> {
  __$AmenityModelCopyWithImpl(this._self, this._then);

  final _AmenityModel _self;
  final $Res Function(_AmenityModel) _then;

/// Create a copy of AmenityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? isActive = null,Object? facilityIsActive = null,}) {
  return _then(_AmenityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,facilityIsActive: null == facilityIsActive ? _self.facilityIsActive : facilityIsActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
