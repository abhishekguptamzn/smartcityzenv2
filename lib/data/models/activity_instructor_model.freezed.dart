// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_instructor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityInstructorModel {

 String get id;@JsonKey(name: 'activity_id') String get activityId; String get name; String? get title; String? get bio; String? get specialization;@JsonKey(name: 'photo_url') String? get photoUrl; String? get phone; String? get email; String get status;
/// Create a copy of ActivityInstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityInstructorModelCopyWith<ActivityInstructorModel> get copyWith => _$ActivityInstructorModelCopyWithImpl<ActivityInstructorModel>(this as ActivityInstructorModel, _$identity);

  /// Serializes this ActivityInstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityInstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,name,title,bio,specialization,photoUrl,phone,email,status);

@override
String toString() {
  return 'ActivityInstructorModel(id: $id, activityId: $activityId, name: $name, title: $title, bio: $bio, specialization: $specialization, photoUrl: $photoUrl, phone: $phone, email: $email, status: $status)';
}


}

/// @nodoc
abstract mixin class $ActivityInstructorModelCopyWith<$Res>  {
  factory $ActivityInstructorModelCopyWith(ActivityInstructorModel value, $Res Function(ActivityInstructorModel) _then) = _$ActivityInstructorModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId, String name, String? title, String? bio, String? specialization,@JsonKey(name: 'photo_url') String? photoUrl, String? phone, String? email, String status
});




}
/// @nodoc
class _$ActivityInstructorModelCopyWithImpl<$Res>
    implements $ActivityInstructorModelCopyWith<$Res> {
  _$ActivityInstructorModelCopyWithImpl(this._self, this._then);

  final ActivityInstructorModel _self;
  final $Res Function(ActivityInstructorModel) _then;

/// Create a copy of ActivityInstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? activityId = null,Object? name = null,Object? title = freezed,Object? bio = freezed,Object? specialization = freezed,Object? photoUrl = freezed,Object? phone = freezed,Object? email = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityInstructorModel].
extension ActivityInstructorModelPatterns on ActivityInstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityInstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityInstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityInstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityInstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityInstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityInstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId,  String name,  String? title,  String? bio,  String? specialization, @JsonKey(name: 'photo_url')  String? photoUrl,  String? phone,  String? email,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityInstructorModel() when $default != null:
return $default(_that.id,_that.activityId,_that.name,_that.title,_that.bio,_that.specialization,_that.photoUrl,_that.phone,_that.email,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId,  String name,  String? title,  String? bio,  String? specialization, @JsonKey(name: 'photo_url')  String? photoUrl,  String? phone,  String? email,  String status)  $default,) {final _that = this;
switch (_that) {
case _ActivityInstructorModel():
return $default(_that.id,_that.activityId,_that.name,_that.title,_that.bio,_that.specialization,_that.photoUrl,_that.phone,_that.email,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'activity_id')  String activityId,  String name,  String? title,  String? bio,  String? specialization, @JsonKey(name: 'photo_url')  String? photoUrl,  String? phone,  String? email,  String status)?  $default,) {final _that = this;
switch (_that) {
case _ActivityInstructorModel() when $default != null:
return $default(_that.id,_that.activityId,_that.name,_that.title,_that.bio,_that.specialization,_that.photoUrl,_that.phone,_that.email,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityInstructorModel implements ActivityInstructorModel {
  const _ActivityInstructorModel({required this.id, @JsonKey(name: 'activity_id') required this.activityId, required this.name, this.title, this.bio, this.specialization, @JsonKey(name: 'photo_url') this.photoUrl, this.phone, this.email, this.status = 'active'});
  factory _ActivityInstructorModel.fromJson(Map<String, dynamic> json) => _$ActivityInstructorModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'activity_id') final  String activityId;
@override final  String name;
@override final  String? title;
@override final  String? bio;
@override final  String? specialization;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override final  String? phone;
@override final  String? email;
@override@JsonKey() final  String status;

/// Create a copy of ActivityInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityInstructorModelCopyWith<_ActivityInstructorModel> get copyWith => __$ActivityInstructorModelCopyWithImpl<_ActivityInstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityInstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityInstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,name,title,bio,specialization,photoUrl,phone,email,status);

@override
String toString() {
  return 'ActivityInstructorModel(id: $id, activityId: $activityId, name: $name, title: $title, bio: $bio, specialization: $specialization, photoUrl: $photoUrl, phone: $phone, email: $email, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ActivityInstructorModelCopyWith<$Res> implements $ActivityInstructorModelCopyWith<$Res> {
  factory _$ActivityInstructorModelCopyWith(_ActivityInstructorModel value, $Res Function(_ActivityInstructorModel) _then) = __$ActivityInstructorModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId, String name, String? title, String? bio, String? specialization,@JsonKey(name: 'photo_url') String? photoUrl, String? phone, String? email, String status
});




}
/// @nodoc
class __$ActivityInstructorModelCopyWithImpl<$Res>
    implements _$ActivityInstructorModelCopyWith<$Res> {
  __$ActivityInstructorModelCopyWithImpl(this._self, this._then);

  final _ActivityInstructorModel _self;
  final $Res Function(_ActivityInstructorModel) _then;

/// Create a copy of ActivityInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? activityId = null,Object? name = null,Object? title = freezed,Object? bio = freezed,Object? specialization = freezed,Object? photoUrl = freezed,Object? phone = freezed,Object? email = freezed,Object? status = null,}) {
  return _then(_ActivityInstructorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
