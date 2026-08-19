// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_enrollment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityEnrollmentModel {

 String get id;@JsonKey(name: 'activity_id') String get activityId;@JsonKey(name: 'activity_name') String? get activityName;@JsonKey(name: 'activity_address') String? get activityAddress;@JsonKey(name: 'activity_image_url') String? get activityImageUrl;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'user_name') String? get userName;@JsonKey(name: 'user_email') String? get userEmail;@JsonKey(name: 'user_phone') String? get userPhone;@JsonKey(name: 'batch_id') String? get batchId;@JsonKey(name: 'batch_name') String? get batchName;@JsonKey(name: 'fee_plan_id') String? get feePlanId;@JsonKey(name: 'fee_plan_name') String? get feePlanName;@JsonKey(name: 'enrollment_type') String get enrollmentType;@JsonKey(name: 'start_date') String? get startDate;@JsonKey(name: 'end_date') String? get endDate;@JsonKey(name: 'days_remaining') int? get daysRemaining;@JsonKey(name: 'is_active_now') bool get isActiveNow; String get status;@JsonKey(name: 'qr_code_token') String? get qrCodeToken; ActivityBatchModel? get batch; FeePlanModel? get feePlan;
/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityEnrollmentModelCopyWith<ActivityEnrollmentModel> get copyWith => _$ActivityEnrollmentModelCopyWithImpl<ActivityEnrollmentModel>(this as ActivityEnrollmentModel, _$identity);

  /// Serializes this ActivityEnrollmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityEnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityName, activityName) || other.activityName == activityName)&&(identical(other.activityAddress, activityAddress) || other.activityAddress == activityAddress)&&(identical(other.activityImageUrl, activityImageUrl) || other.activityImageUrl == activityImageUrl)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userPhone, userPhone) || other.userPhone == userPhone)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchName, batchName) || other.batchName == batchName)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.feePlanName, feePlanName) || other.feePlanName == feePlanName)&&(identical(other.enrollmentType, enrollmentType) || other.enrollmentType == enrollmentType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.isActiveNow, isActiveNow) || other.isActiveNow == isActiveNow)&&(identical(other.status, status) || other.status == status)&&(identical(other.qrCodeToken, qrCodeToken) || other.qrCodeToken == qrCodeToken)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,activityId,activityName,activityAddress,activityImageUrl,userId,userName,userEmail,userPhone,batchId,batchName,feePlanId,feePlanName,enrollmentType,startDate,endDate,daysRemaining,isActiveNow,status,qrCodeToken,batch,feePlan]);

@override
String toString() {
  return 'ActivityEnrollmentModel(id: $id, activityId: $activityId, activityName: $activityName, activityAddress: $activityAddress, activityImageUrl: $activityImageUrl, userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, batchId: $batchId, batchName: $batchName, feePlanId: $feePlanId, feePlanName: $feePlanName, enrollmentType: $enrollmentType, startDate: $startDate, endDate: $endDate, daysRemaining: $daysRemaining, isActiveNow: $isActiveNow, status: $status, qrCodeToken: $qrCodeToken, batch: $batch, feePlan: $feePlan)';
}


}

/// @nodoc
abstract mixin class $ActivityEnrollmentModelCopyWith<$Res>  {
  factory $ActivityEnrollmentModelCopyWith(ActivityEnrollmentModel value, $Res Function(ActivityEnrollmentModel) _then) = _$ActivityEnrollmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'activity_name') String? activityName,@JsonKey(name: 'activity_address') String? activityAddress,@JsonKey(name: 'activity_image_url') String? activityImageUrl,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_phone') String? userPhone,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_name') String? batchName,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'fee_plan_name') String? feePlanName,@JsonKey(name: 'enrollment_type') String enrollmentType,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate,@JsonKey(name: 'days_remaining') int? daysRemaining,@JsonKey(name: 'is_active_now') bool isActiveNow, String status,@JsonKey(name: 'qr_code_token') String? qrCodeToken, ActivityBatchModel? batch, FeePlanModel? feePlan
});


$ActivityBatchModelCopyWith<$Res>? get batch;$FeePlanModelCopyWith<$Res>? get feePlan;

}
/// @nodoc
class _$ActivityEnrollmentModelCopyWithImpl<$Res>
    implements $ActivityEnrollmentModelCopyWith<$Res> {
  _$ActivityEnrollmentModelCopyWithImpl(this._self, this._then);

  final ActivityEnrollmentModel _self;
  final $Res Function(ActivityEnrollmentModel) _then;

/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? activityId = null,Object? activityName = freezed,Object? activityAddress = freezed,Object? activityImageUrl = freezed,Object? userId = null,Object? userName = freezed,Object? userEmail = freezed,Object? userPhone = freezed,Object? batchId = freezed,Object? batchName = freezed,Object? feePlanId = freezed,Object? feePlanName = freezed,Object? enrollmentType = null,Object? startDate = freezed,Object? endDate = freezed,Object? daysRemaining = freezed,Object? isActiveNow = null,Object? status = null,Object? qrCodeToken = freezed,Object? batch = freezed,Object? feePlan = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityName: freezed == activityName ? _self.activityName : activityName // ignore: cast_nullable_to_non_nullable
as String?,activityAddress: freezed == activityAddress ? _self.activityAddress : activityAddress // ignore: cast_nullable_to_non_nullable
as String?,activityImageUrl: freezed == activityImageUrl ? _self.activityImageUrl : activityImageUrl // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPhone: freezed == userPhone ? _self.userPhone : userPhone // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,feePlanName: freezed == feePlanName ? _self.feePlanName : feePlanName // ignore: cast_nullable_to_non_nullable
as String?,enrollmentType: null == enrollmentType ? _self.enrollmentType : enrollmentType // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,daysRemaining: freezed == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int?,isActiveNow: null == isActiveNow ? _self.isActiveNow : isActiveNow // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,qrCodeToken: freezed == qrCodeToken ? _self.qrCodeToken : qrCodeToken // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as ActivityBatchModel?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,
  ));
}
/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBatchModelCopyWith<$Res>? get batch {
    if (_self.batch == null) {
    return null;
  }

  return $ActivityBatchModelCopyWith<$Res>(_self.batch!, (value) {
    return _then(_self.copyWith(batch: value));
  });
}/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeePlanModelCopyWith<$Res>? get feePlan {
    if (_self.feePlan == null) {
    return null;
  }

  return $FeePlanModelCopyWith<$Res>(_self.feePlan!, (value) {
    return _then(_self.copyWith(feePlan: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityEnrollmentModel].
extension ActivityEnrollmentModelPatterns on ActivityEnrollmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityEnrollmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityEnrollmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityEnrollmentModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityEnrollmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityEnrollmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityEnrollmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'activity_name')  String? activityName, @JsonKey(name: 'activity_address')  String? activityAddress, @JsonKey(name: 'activity_image_url')  String? activityImageUrl, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_name')  String? batchName, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan_name')  String? feePlanName, @JsonKey(name: 'enrollment_type')  String enrollmentType, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'days_remaining')  int? daysRemaining, @JsonKey(name: 'is_active_now')  bool isActiveNow,  String status, @JsonKey(name: 'qr_code_token')  String? qrCodeToken,  ActivityBatchModel? batch,  FeePlanModel? feePlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityEnrollmentModel() when $default != null:
return $default(_that.id,_that.activityId,_that.activityName,_that.activityAddress,_that.activityImageUrl,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.batchId,_that.batchName,_that.feePlanId,_that.feePlanName,_that.enrollmentType,_that.startDate,_that.endDate,_that.daysRemaining,_that.isActiveNow,_that.status,_that.qrCodeToken,_that.batch,_that.feePlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'activity_name')  String? activityName, @JsonKey(name: 'activity_address')  String? activityAddress, @JsonKey(name: 'activity_image_url')  String? activityImageUrl, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_name')  String? batchName, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan_name')  String? feePlanName, @JsonKey(name: 'enrollment_type')  String enrollmentType, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'days_remaining')  int? daysRemaining, @JsonKey(name: 'is_active_now')  bool isActiveNow,  String status, @JsonKey(name: 'qr_code_token')  String? qrCodeToken,  ActivityBatchModel? batch,  FeePlanModel? feePlan)  $default,) {final _that = this;
switch (_that) {
case _ActivityEnrollmentModel():
return $default(_that.id,_that.activityId,_that.activityName,_that.activityAddress,_that.activityImageUrl,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.batchId,_that.batchName,_that.feePlanId,_that.feePlanName,_that.enrollmentType,_that.startDate,_that.endDate,_that.daysRemaining,_that.isActiveNow,_that.status,_that.qrCodeToken,_that.batch,_that.feePlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'activity_name')  String? activityName, @JsonKey(name: 'activity_address')  String? activityAddress, @JsonKey(name: 'activity_image_url')  String? activityImageUrl, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_name')  String? batchName, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan_name')  String? feePlanName, @JsonKey(name: 'enrollment_type')  String enrollmentType, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'days_remaining')  int? daysRemaining, @JsonKey(name: 'is_active_now')  bool isActiveNow,  String status, @JsonKey(name: 'qr_code_token')  String? qrCodeToken,  ActivityBatchModel? batch,  FeePlanModel? feePlan)?  $default,) {final _that = this;
switch (_that) {
case _ActivityEnrollmentModel() when $default != null:
return $default(_that.id,_that.activityId,_that.activityName,_that.activityAddress,_that.activityImageUrl,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.batchId,_that.batchName,_that.feePlanId,_that.feePlanName,_that.enrollmentType,_that.startDate,_that.endDate,_that.daysRemaining,_that.isActiveNow,_that.status,_that.qrCodeToken,_that.batch,_that.feePlan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityEnrollmentModel implements ActivityEnrollmentModel {
  const _ActivityEnrollmentModel({required this.id, @JsonKey(name: 'activity_id') required this.activityId, @JsonKey(name: 'activity_name') this.activityName, @JsonKey(name: 'activity_address') this.activityAddress, @JsonKey(name: 'activity_image_url') this.activityImageUrl, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'user_name') this.userName, @JsonKey(name: 'user_email') this.userEmail, @JsonKey(name: 'user_phone') this.userPhone, @JsonKey(name: 'batch_id') this.batchId, @JsonKey(name: 'batch_name') this.batchName, @JsonKey(name: 'fee_plan_id') this.feePlanId, @JsonKey(name: 'fee_plan_name') this.feePlanName, @JsonKey(name: 'enrollment_type') this.enrollmentType = 'monthly', @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'days_remaining') this.daysRemaining, @JsonKey(name: 'is_active_now') this.isActiveNow = true, this.status = 'active', @JsonKey(name: 'qr_code_token') this.qrCodeToken, this.batch, this.feePlan});
  factory _ActivityEnrollmentModel.fromJson(Map<String, dynamic> json) => _$ActivityEnrollmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'activity_id') final  String activityId;
@override@JsonKey(name: 'activity_name') final  String? activityName;
@override@JsonKey(name: 'activity_address') final  String? activityAddress;
@override@JsonKey(name: 'activity_image_url') final  String? activityImageUrl;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'user_name') final  String? userName;
@override@JsonKey(name: 'user_email') final  String? userEmail;
@override@JsonKey(name: 'user_phone') final  String? userPhone;
@override@JsonKey(name: 'batch_id') final  String? batchId;
@override@JsonKey(name: 'batch_name') final  String? batchName;
@override@JsonKey(name: 'fee_plan_id') final  String? feePlanId;
@override@JsonKey(name: 'fee_plan_name') final  String? feePlanName;
@override@JsonKey(name: 'enrollment_type') final  String enrollmentType;
@override@JsonKey(name: 'start_date') final  String? startDate;
@override@JsonKey(name: 'end_date') final  String? endDate;
@override@JsonKey(name: 'days_remaining') final  int? daysRemaining;
@override@JsonKey(name: 'is_active_now') final  bool isActiveNow;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'qr_code_token') final  String? qrCodeToken;
@override final  ActivityBatchModel? batch;
@override final  FeePlanModel? feePlan;

/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityEnrollmentModelCopyWith<_ActivityEnrollmentModel> get copyWith => __$ActivityEnrollmentModelCopyWithImpl<_ActivityEnrollmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityEnrollmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityEnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityName, activityName) || other.activityName == activityName)&&(identical(other.activityAddress, activityAddress) || other.activityAddress == activityAddress)&&(identical(other.activityImageUrl, activityImageUrl) || other.activityImageUrl == activityImageUrl)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userPhone, userPhone) || other.userPhone == userPhone)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchName, batchName) || other.batchName == batchName)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.feePlanName, feePlanName) || other.feePlanName == feePlanName)&&(identical(other.enrollmentType, enrollmentType) || other.enrollmentType == enrollmentType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.isActiveNow, isActiveNow) || other.isActiveNow == isActiveNow)&&(identical(other.status, status) || other.status == status)&&(identical(other.qrCodeToken, qrCodeToken) || other.qrCodeToken == qrCodeToken)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,activityId,activityName,activityAddress,activityImageUrl,userId,userName,userEmail,userPhone,batchId,batchName,feePlanId,feePlanName,enrollmentType,startDate,endDate,daysRemaining,isActiveNow,status,qrCodeToken,batch,feePlan]);

@override
String toString() {
  return 'ActivityEnrollmentModel(id: $id, activityId: $activityId, activityName: $activityName, activityAddress: $activityAddress, activityImageUrl: $activityImageUrl, userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, batchId: $batchId, batchName: $batchName, feePlanId: $feePlanId, feePlanName: $feePlanName, enrollmentType: $enrollmentType, startDate: $startDate, endDate: $endDate, daysRemaining: $daysRemaining, isActiveNow: $isActiveNow, status: $status, qrCodeToken: $qrCodeToken, batch: $batch, feePlan: $feePlan)';
}


}

/// @nodoc
abstract mixin class _$ActivityEnrollmentModelCopyWith<$Res> implements $ActivityEnrollmentModelCopyWith<$Res> {
  factory _$ActivityEnrollmentModelCopyWith(_ActivityEnrollmentModel value, $Res Function(_ActivityEnrollmentModel) _then) = __$ActivityEnrollmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'activity_name') String? activityName,@JsonKey(name: 'activity_address') String? activityAddress,@JsonKey(name: 'activity_image_url') String? activityImageUrl,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_phone') String? userPhone,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_name') String? batchName,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'fee_plan_name') String? feePlanName,@JsonKey(name: 'enrollment_type') String enrollmentType,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate,@JsonKey(name: 'days_remaining') int? daysRemaining,@JsonKey(name: 'is_active_now') bool isActiveNow, String status,@JsonKey(name: 'qr_code_token') String? qrCodeToken, ActivityBatchModel? batch, FeePlanModel? feePlan
});


@override $ActivityBatchModelCopyWith<$Res>? get batch;@override $FeePlanModelCopyWith<$Res>? get feePlan;

}
/// @nodoc
class __$ActivityEnrollmentModelCopyWithImpl<$Res>
    implements _$ActivityEnrollmentModelCopyWith<$Res> {
  __$ActivityEnrollmentModelCopyWithImpl(this._self, this._then);

  final _ActivityEnrollmentModel _self;
  final $Res Function(_ActivityEnrollmentModel) _then;

/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? activityId = null,Object? activityName = freezed,Object? activityAddress = freezed,Object? activityImageUrl = freezed,Object? userId = null,Object? userName = freezed,Object? userEmail = freezed,Object? userPhone = freezed,Object? batchId = freezed,Object? batchName = freezed,Object? feePlanId = freezed,Object? feePlanName = freezed,Object? enrollmentType = null,Object? startDate = freezed,Object? endDate = freezed,Object? daysRemaining = freezed,Object? isActiveNow = null,Object? status = null,Object? qrCodeToken = freezed,Object? batch = freezed,Object? feePlan = freezed,}) {
  return _then(_ActivityEnrollmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityName: freezed == activityName ? _self.activityName : activityName // ignore: cast_nullable_to_non_nullable
as String?,activityAddress: freezed == activityAddress ? _self.activityAddress : activityAddress // ignore: cast_nullable_to_non_nullable
as String?,activityImageUrl: freezed == activityImageUrl ? _self.activityImageUrl : activityImageUrl // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPhone: freezed == userPhone ? _self.userPhone : userPhone // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,feePlanName: freezed == feePlanName ? _self.feePlanName : feePlanName // ignore: cast_nullable_to_non_nullable
as String?,enrollmentType: null == enrollmentType ? _self.enrollmentType : enrollmentType // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,daysRemaining: freezed == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int?,isActiveNow: null == isActiveNow ? _self.isActiveNow : isActiveNow // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,qrCodeToken: freezed == qrCodeToken ? _self.qrCodeToken : qrCodeToken // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as ActivityBatchModel?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,
  ));
}

/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBatchModelCopyWith<$Res>? get batch {
    if (_self.batch == null) {
    return null;
  }

  return $ActivityBatchModelCopyWith<$Res>(_self.batch!, (value) {
    return _then(_self.copyWith(batch: value));
  });
}/// Create a copy of ActivityEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeePlanModelCopyWith<$Res>? get feePlan {
    if (_self.feePlan == null) {
    return null;
  }

  return $FeePlanModelCopyWith<$Res>(_self.feePlan!, (value) {
    return _then(_self.copyWith(feePlan: value));
  });
}
}

// dart format on
