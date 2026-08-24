// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

 String get id;@JsonKey(name: 'user_id') String get userId; String get type; String get title; String get message; String get priority;@JsonKey(name: 'action_type') String? get actionType;@JsonKey(name: 'action_route') String? get actionRoute;@JsonKey(name: 'action_label') String? get actionLabel;@JsonKey(name: 'secondary_action_label') String? get secondaryActionLabel;@JsonKey(name: 'secondary_action_route') String? get secondaryActionRoute; Map<String, dynamic>? get data;@JsonKey(name: 'read_at') String? get readAt;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'action_taken_at') String? get actionTakenAt;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'created_at_formatted') String? get createdAtFormatted;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.actionRoute, actionRoute) || other.actionRoute == actionRoute)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.secondaryActionLabel, secondaryActionLabel) || other.secondaryActionLabel == secondaryActionLabel)&&(identical(other.secondaryActionRoute, secondaryActionRoute) || other.secondaryActionRoute == secondaryActionRoute)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.actionTakenAt, actionTakenAt) || other.actionTakenAt == actionTakenAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdAtFormatted, createdAtFormatted) || other.createdAtFormatted == createdAtFormatted)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,message,priority,actionType,actionRoute,actionLabel,secondaryActionLabel,secondaryActionRoute,const DeepCollectionEquality().hash(data),readAt,isRead,actionTakenAt,createdAt,createdAtFormatted,updatedAt);

@override
String toString() {
  return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, priority: $priority, actionType: $actionType, actionRoute: $actionRoute, actionLabel: $actionLabel, secondaryActionLabel: $secondaryActionLabel, secondaryActionRoute: $secondaryActionRoute, data: $data, readAt: $readAt, isRead: $isRead, actionTakenAt: $actionTakenAt, createdAt: $createdAt, createdAtFormatted: $createdAtFormatted, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String type, String title, String message, String priority,@JsonKey(name: 'action_type') String? actionType,@JsonKey(name: 'action_route') String? actionRoute,@JsonKey(name: 'action_label') String? actionLabel,@JsonKey(name: 'secondary_action_label') String? secondaryActionLabel,@JsonKey(name: 'secondary_action_route') String? secondaryActionRoute, Map<String, dynamic>? data,@JsonKey(name: 'read_at') String? readAt,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'action_taken_at') String? actionTakenAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'created_at_formatted') String? createdAtFormatted,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? priority = null,Object? actionType = freezed,Object? actionRoute = freezed,Object? actionLabel = freezed,Object? secondaryActionLabel = freezed,Object? secondaryActionRoute = freezed,Object? data = freezed,Object? readAt = freezed,Object? isRead = null,Object? actionTakenAt = freezed,Object? createdAt = freezed,Object? createdAtFormatted = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,actionRoute: freezed == actionRoute ? _self.actionRoute : actionRoute // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,secondaryActionLabel: freezed == secondaryActionLabel ? _self.secondaryActionLabel : secondaryActionLabel // ignore: cast_nullable_to_non_nullable
as String?,secondaryActionRoute: freezed == secondaryActionRoute ? _self.secondaryActionRoute : secondaryActionRoute // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,actionTakenAt: freezed == actionTakenAt ? _self.actionTakenAt : actionTakenAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,createdAtFormatted: freezed == createdAtFormatted ? _self.createdAtFormatted : createdAtFormatted // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  String priority, @JsonKey(name: 'action_type')  String? actionType, @JsonKey(name: 'action_route')  String? actionRoute, @JsonKey(name: 'action_label')  String? actionLabel, @JsonKey(name: 'secondary_action_label')  String? secondaryActionLabel, @JsonKey(name: 'secondary_action_route')  String? secondaryActionRoute,  Map<String, dynamic>? data, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'action_taken_at')  String? actionTakenAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'created_at_formatted')  String? createdAtFormatted, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.priority,_that.actionType,_that.actionRoute,_that.actionLabel,_that.secondaryActionLabel,_that.secondaryActionRoute,_that.data,_that.readAt,_that.isRead,_that.actionTakenAt,_that.createdAt,_that.createdAtFormatted,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  String priority, @JsonKey(name: 'action_type')  String? actionType, @JsonKey(name: 'action_route')  String? actionRoute, @JsonKey(name: 'action_label')  String? actionLabel, @JsonKey(name: 'secondary_action_label')  String? secondaryActionLabel, @JsonKey(name: 'secondary_action_route')  String? secondaryActionRoute,  Map<String, dynamic>? data, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'action_taken_at')  String? actionTakenAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'created_at_formatted')  String? createdAtFormatted, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.priority,_that.actionType,_that.actionRoute,_that.actionLabel,_that.secondaryActionLabel,_that.secondaryActionRoute,_that.data,_that.readAt,_that.isRead,_that.actionTakenAt,_that.createdAt,_that.createdAtFormatted,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  String priority, @JsonKey(name: 'action_type')  String? actionType, @JsonKey(name: 'action_route')  String? actionRoute, @JsonKey(name: 'action_label')  String? actionLabel, @JsonKey(name: 'secondary_action_label')  String? secondaryActionLabel, @JsonKey(name: 'secondary_action_route')  String? secondaryActionRoute,  Map<String, dynamic>? data, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'action_taken_at')  String? actionTakenAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'created_at_formatted')  String? createdAtFormatted, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.priority,_that.actionType,_that.actionRoute,_that.actionLabel,_that.secondaryActionLabel,_that.secondaryActionRoute,_that.data,_that.readAt,_that.isRead,_that.actionTakenAt,_that.createdAt,_that.createdAtFormatted,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel extends NotificationModel {
  const _NotificationModel({required this.id, @JsonKey(name: 'user_id') required this.userId, this.type = 'system', required this.title, required this.message, this.priority = 'normal', @JsonKey(name: 'action_type') this.actionType, @JsonKey(name: 'action_route') this.actionRoute, @JsonKey(name: 'action_label') this.actionLabel, @JsonKey(name: 'secondary_action_label') this.secondaryActionLabel, @JsonKey(name: 'secondary_action_route') this.secondaryActionRoute, final  Map<String, dynamic>? data, @JsonKey(name: 'read_at') this.readAt, @JsonKey(name: 'is_read') this.isRead = false, @JsonKey(name: 'action_taken_at') this.actionTakenAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'created_at_formatted') this.createdAtFormatted, @JsonKey(name: 'updated_at') this.updatedAt}): _data = data,super._();
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String type;
@override final  String title;
@override final  String message;
@override@JsonKey() final  String priority;
@override@JsonKey(name: 'action_type') final  String? actionType;
@override@JsonKey(name: 'action_route') final  String? actionRoute;
@override@JsonKey(name: 'action_label') final  String? actionLabel;
@override@JsonKey(name: 'secondary_action_label') final  String? secondaryActionLabel;
@override@JsonKey(name: 'secondary_action_route') final  String? secondaryActionRoute;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'read_at') final  String? readAt;
@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'action_taken_at') final  String? actionTakenAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'created_at_formatted') final  String? createdAtFormatted;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.actionRoute, actionRoute) || other.actionRoute == actionRoute)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.secondaryActionLabel, secondaryActionLabel) || other.secondaryActionLabel == secondaryActionLabel)&&(identical(other.secondaryActionRoute, secondaryActionRoute) || other.secondaryActionRoute == secondaryActionRoute)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.actionTakenAt, actionTakenAt) || other.actionTakenAt == actionTakenAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdAtFormatted, createdAtFormatted) || other.createdAtFormatted == createdAtFormatted)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,message,priority,actionType,actionRoute,actionLabel,secondaryActionLabel,secondaryActionRoute,const DeepCollectionEquality().hash(_data),readAt,isRead,actionTakenAt,createdAt,createdAtFormatted,updatedAt);

@override
String toString() {
  return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, priority: $priority, actionType: $actionType, actionRoute: $actionRoute, actionLabel: $actionLabel, secondaryActionLabel: $secondaryActionLabel, secondaryActionRoute: $secondaryActionRoute, data: $data, readAt: $readAt, isRead: $isRead, actionTakenAt: $actionTakenAt, createdAt: $createdAt, createdAtFormatted: $createdAtFormatted, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String type, String title, String message, String priority,@JsonKey(name: 'action_type') String? actionType,@JsonKey(name: 'action_route') String? actionRoute,@JsonKey(name: 'action_label') String? actionLabel,@JsonKey(name: 'secondary_action_label') String? secondaryActionLabel,@JsonKey(name: 'secondary_action_route') String? secondaryActionRoute, Map<String, dynamic>? data,@JsonKey(name: 'read_at') String? readAt,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'action_taken_at') String? actionTakenAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'created_at_formatted') String? createdAtFormatted,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? priority = null,Object? actionType = freezed,Object? actionRoute = freezed,Object? actionLabel = freezed,Object? secondaryActionLabel = freezed,Object? secondaryActionRoute = freezed,Object? data = freezed,Object? readAt = freezed,Object? isRead = null,Object? actionTakenAt = freezed,Object? createdAt = freezed,Object? createdAtFormatted = freezed,Object? updatedAt = freezed,}) {
  return _then(_NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,actionRoute: freezed == actionRoute ? _self.actionRoute : actionRoute // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,secondaryActionLabel: freezed == secondaryActionLabel ? _self.secondaryActionLabel : secondaryActionLabel // ignore: cast_nullable_to_non_nullable
as String?,secondaryActionRoute: freezed == secondaryActionRoute ? _self.secondaryActionRoute : secondaryActionRoute // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,actionTakenAt: freezed == actionTakenAt ? _self.actionTakenAt : actionTakenAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,createdAtFormatted: freezed == createdAtFormatted ? _self.createdAtFormatted : createdAtFormatted // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
