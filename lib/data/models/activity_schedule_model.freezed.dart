// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityScheduleModel {

 String get id;@JsonKey(name: 'batch_id') String get batchId;@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'day_name') String? get dayName;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime;@JsonKey(name: 'formatted_time') String? get formattedTime; String? get room;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ActivityScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityScheduleModelCopyWith<ActivityScheduleModel> get copyWith => _$ActivityScheduleModelCopyWithImpl<ActivityScheduleModel>(this as ActivityScheduleModel, _$identity);

  /// Serializes this ActivityScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.dayName, dayName) || other.dayName == dayName)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime)&&(identical(other.room, room) || other.room == room)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchId,dayOfWeek,dayName,startTime,endTime,formattedTime,room,isActive);

@override
String toString() {
  return 'ActivityScheduleModel(id: $id, batchId: $batchId, dayOfWeek: $dayOfWeek, dayName: $dayName, startTime: $startTime, endTime: $endTime, formattedTime: $formattedTime, room: $room, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ActivityScheduleModelCopyWith<$Res>  {
  factory $ActivityScheduleModelCopyWith(ActivityScheduleModel value, $Res Function(ActivityScheduleModel) _then) = _$ActivityScheduleModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'batch_id') String batchId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'day_name') String? dayName,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'formatted_time') String? formattedTime, String? room,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ActivityScheduleModelCopyWithImpl<$Res>
    implements $ActivityScheduleModelCopyWith<$Res> {
  _$ActivityScheduleModelCopyWithImpl(this._self, this._then);

  final ActivityScheduleModel _self;
  final $Res Function(ActivityScheduleModel) _then;

/// Create a copy of ActivityScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? batchId = null,Object? dayOfWeek = null,Object? dayName = freezed,Object? startTime = null,Object? endTime = null,Object? formattedTime = freezed,Object? room = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,dayName: freezed == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,formattedTime: freezed == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityScheduleModel].
extension ActivityScheduleModelPatterns on ActivityScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'batch_id')  String batchId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'day_name')  String? dayName, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'formatted_time')  String? formattedTime,  String? room, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityScheduleModel() when $default != null:
return $default(_that.id,_that.batchId,_that.dayOfWeek,_that.dayName,_that.startTime,_that.endTime,_that.formattedTime,_that.room,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'batch_id')  String batchId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'day_name')  String? dayName, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'formatted_time')  String? formattedTime,  String? room, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ActivityScheduleModel():
return $default(_that.id,_that.batchId,_that.dayOfWeek,_that.dayName,_that.startTime,_that.endTime,_that.formattedTime,_that.room,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'batch_id')  String batchId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'day_name')  String? dayName, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'formatted_time')  String? formattedTime,  String? room, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ActivityScheduleModel() when $default != null:
return $default(_that.id,_that.batchId,_that.dayOfWeek,_that.dayName,_that.startTime,_that.endTime,_that.formattedTime,_that.room,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityScheduleModel implements ActivityScheduleModel {
  const _ActivityScheduleModel({required this.id, @JsonKey(name: 'batch_id') required this.batchId, @JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'day_name') this.dayName, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, @JsonKey(name: 'formatted_time') this.formattedTime, this.room, @JsonKey(name: 'is_active') this.isActive = true});
  factory _ActivityScheduleModel.fromJson(Map<String, dynamic> json) => _$ActivityScheduleModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'batch_id') final  String batchId;
@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'day_name') final  String? dayName;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey(name: 'formatted_time') final  String? formattedTime;
@override final  String? room;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ActivityScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityScheduleModelCopyWith<_ActivityScheduleModel> get copyWith => __$ActivityScheduleModelCopyWithImpl<_ActivityScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.dayName, dayName) || other.dayName == dayName)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime)&&(identical(other.room, room) || other.room == room)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchId,dayOfWeek,dayName,startTime,endTime,formattedTime,room,isActive);

@override
String toString() {
  return 'ActivityScheduleModel(id: $id, batchId: $batchId, dayOfWeek: $dayOfWeek, dayName: $dayName, startTime: $startTime, endTime: $endTime, formattedTime: $formattedTime, room: $room, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ActivityScheduleModelCopyWith<$Res> implements $ActivityScheduleModelCopyWith<$Res> {
  factory _$ActivityScheduleModelCopyWith(_ActivityScheduleModel value, $Res Function(_ActivityScheduleModel) _then) = __$ActivityScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'batch_id') String batchId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'day_name') String? dayName,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'formatted_time') String? formattedTime, String? room,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ActivityScheduleModelCopyWithImpl<$Res>
    implements _$ActivityScheduleModelCopyWith<$Res> {
  __$ActivityScheduleModelCopyWithImpl(this._self, this._then);

  final _ActivityScheduleModel _self;
  final $Res Function(_ActivityScheduleModel) _then;

/// Create a copy of ActivityScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? batchId = null,Object? dayOfWeek = null,Object? dayName = freezed,Object? startTime = null,Object? endTime = null,Object? formattedTime = freezed,Object? room = freezed,Object? isActive = null,}) {
  return _then(_ActivityScheduleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,dayName: freezed == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,formattedTime: freezed == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
