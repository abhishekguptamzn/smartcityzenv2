// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GymAttendanceModel {

 String get id;@JsonKey(name: 'gym_id') String? get gymId;@JsonKey(name: 'member_id') String? get memberId;@JsonKey(name: 'check_in_at') DateTime? get checkInAt;@JsonKey(name: 'check_out_at') DateTime? get checkOutAt; int? get duration; DateTime? get date; FacilityModel? get gym; FacilityMemberModel? get member;
/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymAttendanceModelCopyWith<GymAttendanceModel> get copyWith => _$GymAttendanceModelCopyWithImpl<GymAttendanceModel>(this as GymAttendanceModel, _$identity);

  /// Serializes this GymAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gymId, gymId) || other.gymId == gymId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.date, date) || other.date == date)&&(identical(other.gym, gym) || other.gym == gym)&&(identical(other.member, member) || other.member == member));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gymId,memberId,checkInAt,checkOutAt,duration,date,gym,member);

@override
String toString() {
  return 'GymAttendanceModel(id: $id, gymId: $gymId, memberId: $memberId, checkInAt: $checkInAt, checkOutAt: $checkOutAt, duration: $duration, date: $date, gym: $gym, member: $member)';
}


}

/// @nodoc
abstract mixin class $GymAttendanceModelCopyWith<$Res>  {
  factory $GymAttendanceModelCopyWith(GymAttendanceModel value, $Res Function(GymAttendanceModel) _then) = _$GymAttendanceModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'gym_id') String? gymId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'check_in_at') DateTime? checkInAt,@JsonKey(name: 'check_out_at') DateTime? checkOutAt, int? duration, DateTime? date, FacilityModel? gym, FacilityMemberModel? member
});


$FacilityModelCopyWith<$Res>? get gym;$FacilityMemberModelCopyWith<$Res>? get member;

}
/// @nodoc
class _$GymAttendanceModelCopyWithImpl<$Res>
    implements $GymAttendanceModelCopyWith<$Res> {
  _$GymAttendanceModelCopyWithImpl(this._self, this._then);

  final GymAttendanceModel _self;
  final $Res Function(GymAttendanceModel) _then;

/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gymId = freezed,Object? memberId = freezed,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? duration = freezed,Object? date = freezed,Object? gym = freezed,Object? member = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gymId: freezed == gymId ? _self.gymId : gymId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,gym: freezed == gym ? _self.gym : gym // ignore: cast_nullable_to_non_nullable
as FacilityModel?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as FacilityMemberModel?,
  ));
}
/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacilityModelCopyWith<$Res>? get gym {
    if (_self.gym == null) {
    return null;
  }

  return $FacilityModelCopyWith<$Res>(_self.gym!, (value) {
    return _then(_self.copyWith(gym: value));
  });
}/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacilityMemberModelCopyWith<$Res>? get member {
    if (_self.member == null) {
    return null;
  }

  return $FacilityMemberModelCopyWith<$Res>(_self.member!, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}


/// Adds pattern-matching-related methods to [GymAttendanceModel].
extension GymAttendanceModelPatterns on GymAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _GymAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _GymAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'gym_id')  String? gymId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'check_in_at')  DateTime? checkInAt, @JsonKey(name: 'check_out_at')  DateTime? checkOutAt,  int? duration,  DateTime? date,  FacilityModel? gym,  FacilityMemberModel? member)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymAttendanceModel() when $default != null:
return $default(_that.id,_that.gymId,_that.memberId,_that.checkInAt,_that.checkOutAt,_that.duration,_that.date,_that.gym,_that.member);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'gym_id')  String? gymId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'check_in_at')  DateTime? checkInAt, @JsonKey(name: 'check_out_at')  DateTime? checkOutAt,  int? duration,  DateTime? date,  FacilityModel? gym,  FacilityMemberModel? member)  $default,) {final _that = this;
switch (_that) {
case _GymAttendanceModel():
return $default(_that.id,_that.gymId,_that.memberId,_that.checkInAt,_that.checkOutAt,_that.duration,_that.date,_that.gym,_that.member);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'gym_id')  String? gymId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'check_in_at')  DateTime? checkInAt, @JsonKey(name: 'check_out_at')  DateTime? checkOutAt,  int? duration,  DateTime? date,  FacilityModel? gym,  FacilityMemberModel? member)?  $default,) {final _that = this;
switch (_that) {
case _GymAttendanceModel() when $default != null:
return $default(_that.id,_that.gymId,_that.memberId,_that.checkInAt,_that.checkOutAt,_that.duration,_that.date,_that.gym,_that.member);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GymAttendanceModel extends GymAttendanceModel {
  const _GymAttendanceModel({required this.id, @JsonKey(name: 'gym_id') this.gymId, @JsonKey(name: 'member_id') this.memberId, @JsonKey(name: 'check_in_at') this.checkInAt, @JsonKey(name: 'check_out_at') this.checkOutAt, this.duration, this.date, this.gym, this.member}): super._();
  factory _GymAttendanceModel.fromJson(Map<String, dynamic> json) => _$GymAttendanceModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'gym_id') final  String? gymId;
@override@JsonKey(name: 'member_id') final  String? memberId;
@override@JsonKey(name: 'check_in_at') final  DateTime? checkInAt;
@override@JsonKey(name: 'check_out_at') final  DateTime? checkOutAt;
@override final  int? duration;
@override final  DateTime? date;
@override final  FacilityModel? gym;
@override final  FacilityMemberModel? member;

/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymAttendanceModelCopyWith<_GymAttendanceModel> get copyWith => __$GymAttendanceModelCopyWithImpl<_GymAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GymAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gymId, gymId) || other.gymId == gymId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.date, date) || other.date == date)&&(identical(other.gym, gym) || other.gym == gym)&&(identical(other.member, member) || other.member == member));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gymId,memberId,checkInAt,checkOutAt,duration,date,gym,member);

@override
String toString() {
  return 'GymAttendanceModel(id: $id, gymId: $gymId, memberId: $memberId, checkInAt: $checkInAt, checkOutAt: $checkOutAt, duration: $duration, date: $date, gym: $gym, member: $member)';
}


}

/// @nodoc
abstract mixin class _$GymAttendanceModelCopyWith<$Res> implements $GymAttendanceModelCopyWith<$Res> {
  factory _$GymAttendanceModelCopyWith(_GymAttendanceModel value, $Res Function(_GymAttendanceModel) _then) = __$GymAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'gym_id') String? gymId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'check_in_at') DateTime? checkInAt,@JsonKey(name: 'check_out_at') DateTime? checkOutAt, int? duration, DateTime? date, FacilityModel? gym, FacilityMemberModel? member
});


@override $FacilityModelCopyWith<$Res>? get gym;@override $FacilityMemberModelCopyWith<$Res>? get member;

}
/// @nodoc
class __$GymAttendanceModelCopyWithImpl<$Res>
    implements _$GymAttendanceModelCopyWith<$Res> {
  __$GymAttendanceModelCopyWithImpl(this._self, this._then);

  final _GymAttendanceModel _self;
  final $Res Function(_GymAttendanceModel) _then;

/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gymId = freezed,Object? memberId = freezed,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? duration = freezed,Object? date = freezed,Object? gym = freezed,Object? member = freezed,}) {
  return _then(_GymAttendanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gymId: freezed == gymId ? _self.gymId : gymId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,gym: freezed == gym ? _self.gym : gym // ignore: cast_nullable_to_non_nullable
as FacilityModel?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as FacilityMemberModel?,
  ));
}

/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacilityModelCopyWith<$Res>? get gym {
    if (_self.gym == null) {
    return null;
  }

  return $FacilityModelCopyWith<$Res>(_self.gym!, (value) {
    return _then(_self.copyWith(gym: value));
  });
}/// Create a copy of GymAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacilityMemberModelCopyWith<$Res>? get member {
    if (_self.member == null) {
    return null;
  }

  return $FacilityMemberModelCopyWith<$Res>(_self.member!, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}

// dart format on
