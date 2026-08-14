// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginHistoryModel {

 String get id;@JsonKey(name: 'user_id') String? get userId; String? get email;@JsonKey(name: 'ip_address') String? get ipAddress;@JsonKey(name: 'user_agent') String? get userAgent;@JsonKey(name: 'device_type') String? get deviceType; String? get browser; String? get platform; String? get location; String get status;@JsonKey(name: 'failure_reason') String? get failureReason;@JsonKey(name: 'is_suspicious') bool get isSuspicious;@JsonKey(name: 'flagged_reason') String? get flaggedReason;@JsonKey(name: 'created_at') DateTime? get createdAt; UserModel? get user;
/// Create a copy of LoginHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginHistoryModelCopyWith<LoginHistoryModel> get copyWith => _$LoginHistoryModelCopyWithImpl<LoginHistoryModel>(this as LoginHistoryModel, _$identity);

  /// Serializes this LoginHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.browser, browser) || other.browser == browser)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.isSuspicious, isSuspicious) || other.isSuspicious == isSuspicious)&&(identical(other.flaggedReason, flaggedReason) || other.flaggedReason == flaggedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,email,ipAddress,userAgent,deviceType,browser,platform,location,status,failureReason,isSuspicious,flaggedReason,createdAt,user);

@override
String toString() {
  return 'LoginHistoryModel(id: $id, userId: $userId, email: $email, ipAddress: $ipAddress, userAgent: $userAgent, deviceType: $deviceType, browser: $browser, platform: $platform, location: $location, status: $status, failureReason: $failureReason, isSuspicious: $isSuspicious, flaggedReason: $flaggedReason, createdAt: $createdAt, user: $user)';
}


}

/// @nodoc
abstract mixin class $LoginHistoryModelCopyWith<$Res>  {
  factory $LoginHistoryModelCopyWith(LoginHistoryModel value, $Res Function(LoginHistoryModel) _then) = _$LoginHistoryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String? email,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent,@JsonKey(name: 'device_type') String? deviceType, String? browser, String? platform, String? location, String status,@JsonKey(name: 'failure_reason') String? failureReason,@JsonKey(name: 'is_suspicious') bool isSuspicious,@JsonKey(name: 'flagged_reason') String? flaggedReason,@JsonKey(name: 'created_at') DateTime? createdAt, UserModel? user
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$LoginHistoryModelCopyWithImpl<$Res>
    implements $LoginHistoryModelCopyWith<$Res> {
  _$LoginHistoryModelCopyWithImpl(this._self, this._then);

  final LoginHistoryModel _self;
  final $Res Function(LoginHistoryModel) _then;

/// Create a copy of LoginHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? email = freezed,Object? ipAddress = freezed,Object? userAgent = freezed,Object? deviceType = freezed,Object? browser = freezed,Object? platform = freezed,Object? location = freezed,Object? status = null,Object? failureReason = freezed,Object? isSuspicious = null,Object? flaggedReason = freezed,Object? createdAt = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,browser: freezed == browser ? _self.browser : browser // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,isSuspicious: null == isSuspicious ? _self.isSuspicious : isSuspicious // ignore: cast_nullable_to_non_nullable
as bool,flaggedReason: freezed == flaggedReason ? _self.flaggedReason : flaggedReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}
/// Create a copy of LoginHistoryModel
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


/// Adds pattern-matching-related methods to [LoginHistoryModel].
extension LoginHistoryModelPatterns on LoginHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _LoginHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _LoginHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String? email, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'device_type')  String? deviceType,  String? browser,  String? platform,  String? location,  String status, @JsonKey(name: 'failure_reason')  String? failureReason, @JsonKey(name: 'is_suspicious')  bool isSuspicious, @JsonKey(name: 'flagged_reason')  String? flaggedReason, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserModel? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginHistoryModel() when $default != null:
return $default(_that.id,_that.userId,_that.email,_that.ipAddress,_that.userAgent,_that.deviceType,_that.browser,_that.platform,_that.location,_that.status,_that.failureReason,_that.isSuspicious,_that.flaggedReason,_that.createdAt,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String? email, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'device_type')  String? deviceType,  String? browser,  String? platform,  String? location,  String status, @JsonKey(name: 'failure_reason')  String? failureReason, @JsonKey(name: 'is_suspicious')  bool isSuspicious, @JsonKey(name: 'flagged_reason')  String? flaggedReason, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserModel? user)  $default,) {final _that = this;
switch (_that) {
case _LoginHistoryModel():
return $default(_that.id,_that.userId,_that.email,_that.ipAddress,_that.userAgent,_that.deviceType,_that.browser,_that.platform,_that.location,_that.status,_that.failureReason,_that.isSuspicious,_that.flaggedReason,_that.createdAt,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId,  String? email, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'device_type')  String? deviceType,  String? browser,  String? platform,  String? location,  String status, @JsonKey(name: 'failure_reason')  String? failureReason, @JsonKey(name: 'is_suspicious')  bool isSuspicious, @JsonKey(name: 'flagged_reason')  String? flaggedReason, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserModel? user)?  $default,) {final _that = this;
switch (_that) {
case _LoginHistoryModel() when $default != null:
return $default(_that.id,_that.userId,_that.email,_that.ipAddress,_that.userAgent,_that.deviceType,_that.browser,_that.platform,_that.location,_that.status,_that.failureReason,_that.isSuspicious,_that.flaggedReason,_that.createdAt,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginHistoryModel extends LoginHistoryModel {
  const _LoginHistoryModel({required this.id, @JsonKey(name: 'user_id') this.userId, this.email, @JsonKey(name: 'ip_address') this.ipAddress, @JsonKey(name: 'user_agent') this.userAgent, @JsonKey(name: 'device_type') this.deviceType, this.browser, this.platform, this.location, this.status = 'success', @JsonKey(name: 'failure_reason') this.failureReason, @JsonKey(name: 'is_suspicious') this.isSuspicious = false, @JsonKey(name: 'flagged_reason') this.flaggedReason, @JsonKey(name: 'created_at') this.createdAt, this.user}): super._();
  factory _LoginHistoryModel.fromJson(Map<String, dynamic> json) => _$LoginHistoryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String? email;
@override@JsonKey(name: 'ip_address') final  String? ipAddress;
@override@JsonKey(name: 'user_agent') final  String? userAgent;
@override@JsonKey(name: 'device_type') final  String? deviceType;
@override final  String? browser;
@override final  String? platform;
@override final  String? location;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'failure_reason') final  String? failureReason;
@override@JsonKey(name: 'is_suspicious') final  bool isSuspicious;
@override@JsonKey(name: 'flagged_reason') final  String? flaggedReason;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override final  UserModel? user;

/// Create a copy of LoginHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginHistoryModelCopyWith<_LoginHistoryModel> get copyWith => __$LoginHistoryModelCopyWithImpl<_LoginHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.browser, browser) || other.browser == browser)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.isSuspicious, isSuspicious) || other.isSuspicious == isSuspicious)&&(identical(other.flaggedReason, flaggedReason) || other.flaggedReason == flaggedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,email,ipAddress,userAgent,deviceType,browser,platform,location,status,failureReason,isSuspicious,flaggedReason,createdAt,user);

@override
String toString() {
  return 'LoginHistoryModel(id: $id, userId: $userId, email: $email, ipAddress: $ipAddress, userAgent: $userAgent, deviceType: $deviceType, browser: $browser, platform: $platform, location: $location, status: $status, failureReason: $failureReason, isSuspicious: $isSuspicious, flaggedReason: $flaggedReason, createdAt: $createdAt, user: $user)';
}


}

/// @nodoc
abstract mixin class _$LoginHistoryModelCopyWith<$Res> implements $LoginHistoryModelCopyWith<$Res> {
  factory _$LoginHistoryModelCopyWith(_LoginHistoryModel value, $Res Function(_LoginHistoryModel) _then) = __$LoginHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String? email,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent,@JsonKey(name: 'device_type') String? deviceType, String? browser, String? platform, String? location, String status,@JsonKey(name: 'failure_reason') String? failureReason,@JsonKey(name: 'is_suspicious') bool isSuspicious,@JsonKey(name: 'flagged_reason') String? flaggedReason,@JsonKey(name: 'created_at') DateTime? createdAt, UserModel? user
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$LoginHistoryModelCopyWithImpl<$Res>
    implements _$LoginHistoryModelCopyWith<$Res> {
  __$LoginHistoryModelCopyWithImpl(this._self, this._then);

  final _LoginHistoryModel _self;
  final $Res Function(_LoginHistoryModel) _then;

/// Create a copy of LoginHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? email = freezed,Object? ipAddress = freezed,Object? userAgent = freezed,Object? deviceType = freezed,Object? browser = freezed,Object? platform = freezed,Object? location = freezed,Object? status = null,Object? failureReason = freezed,Object? isSuspicious = null,Object? flaggedReason = freezed,Object? createdAt = freezed,Object? user = freezed,}) {
  return _then(_LoginHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,browser: freezed == browser ? _self.browser : browser // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,isSuspicious: null == isSuspicious ? _self.isSuspicious : isSuspicious // ignore: cast_nullable_to_non_nullable
as bool,flaggedReason: freezed == flaggedReason ? _self.flaggedReason : flaggedReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}

/// Create a copy of LoginHistoryModel
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
