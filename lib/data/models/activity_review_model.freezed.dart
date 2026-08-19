// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityReviewModel {

 String get id;@JsonKey(name: 'activity_id') String get activityId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'user_name') String? get userName;@JsonKey(name: 'user_avatar') String? get userAvatar;@JsonKey(fromJson: _toDouble) double get rating; String? get title; String? get comment;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'time_ago') String? get timeAgo;
/// Create a copy of ActivityReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityReviewModelCopyWith<ActivityReviewModel> get copyWith => _$ActivityReviewModelCopyWithImpl<ActivityReviewModel>(this as ActivityReviewModel, _$identity);

  /// Serializes this ActivityReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,userId,userName,userAvatar,rating,title,comment,createdAt,timeAgo);

@override
String toString() {
  return 'ActivityReviewModel(id: $id, activityId: $activityId, userId: $userId, userName: $userName, userAvatar: $userAvatar, rating: $rating, title: $title, comment: $comment, createdAt: $createdAt, timeAgo: $timeAgo)';
}


}

/// @nodoc
abstract mixin class $ActivityReviewModelCopyWith<$Res>  {
  factory $ActivityReviewModelCopyWith(ActivityReviewModel value, $Res Function(ActivityReviewModel) _then) = _$ActivityReviewModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_avatar') String? userAvatar,@JsonKey(fromJson: _toDouble) double rating, String? title, String? comment,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'time_ago') String? timeAgo
});




}
/// @nodoc
class _$ActivityReviewModelCopyWithImpl<$Res>
    implements $ActivityReviewModelCopyWith<$Res> {
  _$ActivityReviewModelCopyWithImpl(this._self, this._then);

  final ActivityReviewModel _self;
  final $Res Function(ActivityReviewModel) _then;

/// Create a copy of ActivityReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? activityId = null,Object? userId = null,Object? userName = freezed,Object? userAvatar = freezed,Object? rating = null,Object? title = freezed,Object? comment = freezed,Object? createdAt = freezed,Object? timeAgo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatar: freezed == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,timeAgo: freezed == timeAgo ? _self.timeAgo : timeAgo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityReviewModel].
extension ActivityReviewModelPatterns on ActivityReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_avatar')  String? userAvatar, @JsonKey(fromJson: _toDouble)  double rating,  String? title,  String? comment, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'time_ago')  String? timeAgo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityReviewModel() when $default != null:
return $default(_that.id,_that.activityId,_that.userId,_that.userName,_that.userAvatar,_that.rating,_that.title,_that.comment,_that.createdAt,_that.timeAgo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_avatar')  String? userAvatar, @JsonKey(fromJson: _toDouble)  double rating,  String? title,  String? comment, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'time_ago')  String? timeAgo)  $default,) {final _that = this;
switch (_that) {
case _ActivityReviewModel():
return $default(_that.id,_that.activityId,_that.userId,_that.userName,_that.userAvatar,_that.rating,_that.title,_that.comment,_that.createdAt,_that.timeAgo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_avatar')  String? userAvatar, @JsonKey(fromJson: _toDouble)  double rating,  String? title,  String? comment, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'time_ago')  String? timeAgo)?  $default,) {final _that = this;
switch (_that) {
case _ActivityReviewModel() when $default != null:
return $default(_that.id,_that.activityId,_that.userId,_that.userName,_that.userAvatar,_that.rating,_that.title,_that.comment,_that.createdAt,_that.timeAgo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityReviewModel implements ActivityReviewModel {
  const _ActivityReviewModel({required this.id, @JsonKey(name: 'activity_id') required this.activityId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'user_name') this.userName, @JsonKey(name: 'user_avatar') this.userAvatar, @JsonKey(fromJson: _toDouble) this.rating = 5.0, this.title, this.comment, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'time_ago') this.timeAgo});
  factory _ActivityReviewModel.fromJson(Map<String, dynamic> json) => _$ActivityReviewModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'activity_id') final  String activityId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'user_name') final  String? userName;
@override@JsonKey(name: 'user_avatar') final  String? userAvatar;
@override@JsonKey(fromJson: _toDouble) final  double rating;
@override final  String? title;
@override final  String? comment;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'time_ago') final  String? timeAgo;

/// Create a copy of ActivityReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityReviewModelCopyWith<_ActivityReviewModel> get copyWith => __$ActivityReviewModelCopyWithImpl<_ActivityReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,userId,userName,userAvatar,rating,title,comment,createdAt,timeAgo);

@override
String toString() {
  return 'ActivityReviewModel(id: $id, activityId: $activityId, userId: $userId, userName: $userName, userAvatar: $userAvatar, rating: $rating, title: $title, comment: $comment, createdAt: $createdAt, timeAgo: $timeAgo)';
}


}

/// @nodoc
abstract mixin class _$ActivityReviewModelCopyWith<$Res> implements $ActivityReviewModelCopyWith<$Res> {
  factory _$ActivityReviewModelCopyWith(_ActivityReviewModel value, $Res Function(_ActivityReviewModel) _then) = __$ActivityReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_avatar') String? userAvatar,@JsonKey(fromJson: _toDouble) double rating, String? title, String? comment,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'time_ago') String? timeAgo
});




}
/// @nodoc
class __$ActivityReviewModelCopyWithImpl<$Res>
    implements _$ActivityReviewModelCopyWith<$Res> {
  __$ActivityReviewModelCopyWithImpl(this._self, this._then);

  final _ActivityReviewModel _self;
  final $Res Function(_ActivityReviewModel) _then;

/// Create a copy of ActivityReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? activityId = null,Object? userId = null,Object? userName = freezed,Object? userAvatar = freezed,Object? rating = null,Object? title = freezed,Object? comment = freezed,Object? createdAt = freezed,Object? timeAgo = freezed,}) {
  return _then(_ActivityReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatar: freezed == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,timeAgo: freezed == timeAgo ? _self.timeAgo : timeAgo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
