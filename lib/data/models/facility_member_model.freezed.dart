// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacilityMemberModel {

 String get id;@JsonKey(name: 'facility_id') String? get facilityId;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'membership_type') String? get membershipType;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate; String get status; UserModel? get user;@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind get facilityKind;
/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityMemberModelCopyWith<FacilityMemberModel> get copyWith => _$FacilityMemberModelCopyWithImpl<FacilityMemberModel>(this as FacilityMemberModel, _$identity);

  /// Serializes this FacilityMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacilityMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.facilityKind, facilityKind) || other.facilityKind == facilityKind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityId,userId,membershipType,startDate,endDate,status,user,facilityKind);

@override
String toString() {
  return 'FacilityMemberModel(id: $id, facilityId: $facilityId, userId: $userId, membershipType: $membershipType, startDate: $startDate, endDate: $endDate, status: $status, user: $user, facilityKind: $facilityKind)';
}


}

/// @nodoc
abstract mixin class $FacilityMemberModelCopyWith<$Res>  {
  factory $FacilityMemberModelCopyWith(FacilityMemberModel value, $Res Function(FacilityMemberModel) _then) = _$FacilityMemberModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'facility_id') String? facilityId,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'membership_type') String? membershipType,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String status, UserModel? user,@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind facilityKind
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$FacilityMemberModelCopyWithImpl<$Res>
    implements $FacilityMemberModelCopyWith<$Res> {
  _$FacilityMemberModelCopyWithImpl(this._self, this._then);

  final FacilityMemberModel _self;
  final $Res Function(FacilityMemberModel) _then;

/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? facilityId = freezed,Object? userId = freezed,Object? membershipType = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? user = freezed,Object? facilityKind = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,facilityKind: null == facilityKind ? _self.facilityKind : facilityKind // ignore: cast_nullable_to_non_nullable
as FacilityKind,
  ));
}
/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [FacilityMemberModel].
extension FacilityMemberModelPatterns on FacilityMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacilityMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacilityMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacilityMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _FacilityMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacilityMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacilityMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_id')  String? facilityId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  UserModel? user, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind facilityKind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacilityMemberModel() when $default != null:
return $default(_that.id,_that.facilityId,_that.userId,_that.membershipType,_that.startDate,_that.endDate,_that.status,_that.user,_that.facilityKind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_id')  String? facilityId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  UserModel? user, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind facilityKind)  $default,) {final _that = this;
switch (_that) {
case _FacilityMemberModel():
return $default(_that.id,_that.facilityId,_that.userId,_that.membershipType,_that.startDate,_that.endDate,_that.status,_that.user,_that.facilityKind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'facility_id')  String? facilityId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  UserModel? user, @JsonKey(includeFromJson: false, includeToJson: false)  FacilityKind facilityKind)?  $default,) {final _that = this;
switch (_that) {
case _FacilityMemberModel() when $default != null:
return $default(_that.id,_that.facilityId,_that.userId,_that.membershipType,_that.startDate,_that.endDate,_that.status,_that.user,_that.facilityKind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacilityMemberModel extends FacilityMemberModel {
  const _FacilityMemberModel({required this.id, @JsonKey(name: 'facility_id') this.facilityId, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'membership_type') this.membershipType, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, this.status = 'active', this.user, @JsonKey(includeFromJson: false, includeToJson: false) this.facilityKind = FacilityKind.library}): super._();
  factory _FacilityMemberModel.fromJson(Map<String, dynamic> json) => _$FacilityMemberModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'facility_id') final  String? facilityId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'membership_type') final  String? membershipType;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey() final  String status;
@override final  UserModel? user;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  FacilityKind facilityKind;

/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityMemberModelCopyWith<_FacilityMemberModel> get copyWith => __$FacilityMemberModelCopyWithImpl<_FacilityMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacilityMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacilityMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.facilityKind, facilityKind) || other.facilityKind == facilityKind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityId,userId,membershipType,startDate,endDate,status,user,facilityKind);

@override
String toString() {
  return 'FacilityMemberModel(id: $id, facilityId: $facilityId, userId: $userId, membershipType: $membershipType, startDate: $startDate, endDate: $endDate, status: $status, user: $user, facilityKind: $facilityKind)';
}


}

/// @nodoc
abstract mixin class _$FacilityMemberModelCopyWith<$Res> implements $FacilityMemberModelCopyWith<$Res> {
  factory _$FacilityMemberModelCopyWith(_FacilityMemberModel value, $Res Function(_FacilityMemberModel) _then) = __$FacilityMemberModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'facility_id') String? facilityId,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'membership_type') String? membershipType,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String status, UserModel? user,@JsonKey(includeFromJson: false, includeToJson: false) FacilityKind facilityKind
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$FacilityMemberModelCopyWithImpl<$Res>
    implements _$FacilityMemberModelCopyWith<$Res> {
  __$FacilityMemberModelCopyWithImpl(this._self, this._then);

  final _FacilityMemberModel _self;
  final $Res Function(_FacilityMemberModel) _then;

/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? facilityId = freezed,Object? userId = freezed,Object? membershipType = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? user = freezed,Object? facilityKind = null,}) {
  return _then(_FacilityMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,facilityKind: null == facilityKind ? _self.facilityKind : facilityKind // ignore: cast_nullable_to_non_nullable
as FacilityKind,
  ));
}

/// Create a copy of FacilityMemberModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
