// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_renewal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MembershipRenewalModel {

 String get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'membership_type') String? get membershipType;@JsonKey(name: 'membership_id') String? get membershipId;@JsonKey(name: 'fee_plan_id') String? get feePlanId;@JsonKey(name: 'payment_id') String? get paymentId;@JsonKey(name: 'previous_end_date') DateTime? get previousEndDate;@JsonKey(name: 'new_end_date') DateTime? get newEndDate;@JsonKey(name: 'extended_interval') String? get extendedInterval;@JsonKey(name: 'extended_count') int get extendedCount;@JsonKey(name: 'amount_paid', fromJson: _toDouble) double get amountPaid; String get currency; String? get notes;@JsonKey(name: 'fee_plan') FeePlanModel? get feePlan; PaymentModel? get payment;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipRenewalModelCopyWith<MembershipRenewalModel> get copyWith => _$MembershipRenewalModelCopyWithImpl<MembershipRenewalModel>(this as MembershipRenewalModel, _$identity);

  /// Serializes this MembershipRenewalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipRenewalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.previousEndDate, previousEndDate) || other.previousEndDate == previousEndDate)&&(identical(other.newEndDate, newEndDate) || other.newEndDate == newEndDate)&&(identical(other.extendedInterval, extendedInterval) || other.extendedInterval == extendedInterval)&&(identical(other.extendedCount, extendedCount) || other.extendedCount == extendedCount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,membershipType,membershipId,feePlanId,paymentId,previousEndDate,newEndDate,extendedInterval,extendedCount,amountPaid,currency,notes,feePlan,payment,createdAt);

@override
String toString() {
  return 'MembershipRenewalModel(id: $id, userId: $userId, membershipType: $membershipType, membershipId: $membershipId, feePlanId: $feePlanId, paymentId: $paymentId, previousEndDate: $previousEndDate, newEndDate: $newEndDate, extendedInterval: $extendedInterval, extendedCount: $extendedCount, amountPaid: $amountPaid, currency: $currency, notes: $notes, feePlan: $feePlan, payment: $payment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MembershipRenewalModelCopyWith<$Res>  {
  factory $MembershipRenewalModelCopyWith(MembershipRenewalModel value, $Res Function(MembershipRenewalModel) _then) = _$MembershipRenewalModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'membership_type') String? membershipType,@JsonKey(name: 'membership_id') String? membershipId,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'payment_id') String? paymentId,@JsonKey(name: 'previous_end_date') DateTime? previousEndDate,@JsonKey(name: 'new_end_date') DateTime? newEndDate,@JsonKey(name: 'extended_interval') String? extendedInterval,@JsonKey(name: 'extended_count') int extendedCount,@JsonKey(name: 'amount_paid', fromJson: _toDouble) double amountPaid, String currency, String? notes,@JsonKey(name: 'fee_plan') FeePlanModel? feePlan, PaymentModel? payment,@JsonKey(name: 'created_at') DateTime? createdAt
});


$FeePlanModelCopyWith<$Res>? get feePlan;$PaymentModelCopyWith<$Res>? get payment;

}
/// @nodoc
class _$MembershipRenewalModelCopyWithImpl<$Res>
    implements $MembershipRenewalModelCopyWith<$Res> {
  _$MembershipRenewalModelCopyWithImpl(this._self, this._then);

  final MembershipRenewalModel _self;
  final $Res Function(MembershipRenewalModel) _then;

/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? membershipType = freezed,Object? membershipId = freezed,Object? feePlanId = freezed,Object? paymentId = freezed,Object? previousEndDate = freezed,Object? newEndDate = freezed,Object? extendedInterval = freezed,Object? extendedCount = null,Object? amountPaid = null,Object? currency = null,Object? notes = freezed,Object? feePlan = freezed,Object? payment = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,previousEndDate: freezed == previousEndDate ? _self.previousEndDate : previousEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,newEndDate: freezed == newEndDate ? _self.newEndDate : newEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,extendedInterval: freezed == extendedInterval ? _self.extendedInterval : extendedInterval // ignore: cast_nullable_to_non_nullable
as String?,extendedCount: null == extendedCount ? _self.extendedCount : extendedCount // ignore: cast_nullable_to_non_nullable
as int,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MembershipRenewalModel
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
}/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $PaymentModelCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// Adds pattern-matching-related methods to [MembershipRenewalModel].
extension MembershipRenewalModelPatterns on MembershipRenewalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipRenewalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipRenewalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipRenewalModel value)  $default,){
final _that = this;
switch (_that) {
case _MembershipRenewalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipRenewalModel value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipRenewalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'payment_id')  String? paymentId, @JsonKey(name: 'previous_end_date')  DateTime? previousEndDate, @JsonKey(name: 'new_end_date')  DateTime? newEndDate, @JsonKey(name: 'extended_interval')  String? extendedInterval, @JsonKey(name: 'extended_count')  int extendedCount, @JsonKey(name: 'amount_paid', fromJson: _toDouble)  double amountPaid,  String currency,  String? notes, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan,  PaymentModel? payment, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipRenewalModel() when $default != null:
return $default(_that.id,_that.userId,_that.membershipType,_that.membershipId,_that.feePlanId,_that.paymentId,_that.previousEndDate,_that.newEndDate,_that.extendedInterval,_that.extendedCount,_that.amountPaid,_that.currency,_that.notes,_that.feePlan,_that.payment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'payment_id')  String? paymentId, @JsonKey(name: 'previous_end_date')  DateTime? previousEndDate, @JsonKey(name: 'new_end_date')  DateTime? newEndDate, @JsonKey(name: 'extended_interval')  String? extendedInterval, @JsonKey(name: 'extended_count')  int extendedCount, @JsonKey(name: 'amount_paid', fromJson: _toDouble)  double amountPaid,  String currency,  String? notes, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan,  PaymentModel? payment, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MembershipRenewalModel():
return $default(_that.id,_that.userId,_that.membershipType,_that.membershipId,_that.feePlanId,_that.paymentId,_that.previousEndDate,_that.newEndDate,_that.extendedInterval,_that.extendedCount,_that.amountPaid,_that.currency,_that.notes,_that.feePlan,_that.payment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'membership_type')  String? membershipType, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'payment_id')  String? paymentId, @JsonKey(name: 'previous_end_date')  DateTime? previousEndDate, @JsonKey(name: 'new_end_date')  DateTime? newEndDate, @JsonKey(name: 'extended_interval')  String? extendedInterval, @JsonKey(name: 'extended_count')  int extendedCount, @JsonKey(name: 'amount_paid', fromJson: _toDouble)  double amountPaid,  String currency,  String? notes, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan,  PaymentModel? payment, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MembershipRenewalModel() when $default != null:
return $default(_that.id,_that.userId,_that.membershipType,_that.membershipId,_that.feePlanId,_that.paymentId,_that.previousEndDate,_that.newEndDate,_that.extendedInterval,_that.extendedCount,_that.amountPaid,_that.currency,_that.notes,_that.feePlan,_that.payment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipRenewalModel implements MembershipRenewalModel {
  const _MembershipRenewalModel({required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'membership_type') this.membershipType, @JsonKey(name: 'membership_id') this.membershipId, @JsonKey(name: 'fee_plan_id') this.feePlanId, @JsonKey(name: 'payment_id') this.paymentId, @JsonKey(name: 'previous_end_date') this.previousEndDate, @JsonKey(name: 'new_end_date') this.newEndDate, @JsonKey(name: 'extended_interval') this.extendedInterval, @JsonKey(name: 'extended_count') this.extendedCount = 1, @JsonKey(name: 'amount_paid', fromJson: _toDouble) this.amountPaid = 0, this.currency = 'INR', this.notes, @JsonKey(name: 'fee_plan') this.feePlan, this.payment, @JsonKey(name: 'created_at') this.createdAt});
  factory _MembershipRenewalModel.fromJson(Map<String, dynamic> json) => _$MembershipRenewalModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'membership_type') final  String? membershipType;
@override@JsonKey(name: 'membership_id') final  String? membershipId;
@override@JsonKey(name: 'fee_plan_id') final  String? feePlanId;
@override@JsonKey(name: 'payment_id') final  String? paymentId;
@override@JsonKey(name: 'previous_end_date') final  DateTime? previousEndDate;
@override@JsonKey(name: 'new_end_date') final  DateTime? newEndDate;
@override@JsonKey(name: 'extended_interval') final  String? extendedInterval;
@override@JsonKey(name: 'extended_count') final  int extendedCount;
@override@JsonKey(name: 'amount_paid', fromJson: _toDouble) final  double amountPaid;
@override@JsonKey() final  String currency;
@override final  String? notes;
@override@JsonKey(name: 'fee_plan') final  FeePlanModel? feePlan;
@override final  PaymentModel? payment;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipRenewalModelCopyWith<_MembershipRenewalModel> get copyWith => __$MembershipRenewalModelCopyWithImpl<_MembershipRenewalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipRenewalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipRenewalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.previousEndDate, previousEndDate) || other.previousEndDate == previousEndDate)&&(identical(other.newEndDate, newEndDate) || other.newEndDate == newEndDate)&&(identical(other.extendedInterval, extendedInterval) || other.extendedInterval == extendedInterval)&&(identical(other.extendedCount, extendedCount) || other.extendedCount == extendedCount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,membershipType,membershipId,feePlanId,paymentId,previousEndDate,newEndDate,extendedInterval,extendedCount,amountPaid,currency,notes,feePlan,payment,createdAt);

@override
String toString() {
  return 'MembershipRenewalModel(id: $id, userId: $userId, membershipType: $membershipType, membershipId: $membershipId, feePlanId: $feePlanId, paymentId: $paymentId, previousEndDate: $previousEndDate, newEndDate: $newEndDate, extendedInterval: $extendedInterval, extendedCount: $extendedCount, amountPaid: $amountPaid, currency: $currency, notes: $notes, feePlan: $feePlan, payment: $payment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MembershipRenewalModelCopyWith<$Res> implements $MembershipRenewalModelCopyWith<$Res> {
  factory _$MembershipRenewalModelCopyWith(_MembershipRenewalModel value, $Res Function(_MembershipRenewalModel) _then) = __$MembershipRenewalModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'membership_type') String? membershipType,@JsonKey(name: 'membership_id') String? membershipId,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'payment_id') String? paymentId,@JsonKey(name: 'previous_end_date') DateTime? previousEndDate,@JsonKey(name: 'new_end_date') DateTime? newEndDate,@JsonKey(name: 'extended_interval') String? extendedInterval,@JsonKey(name: 'extended_count') int extendedCount,@JsonKey(name: 'amount_paid', fromJson: _toDouble) double amountPaid, String currency, String? notes,@JsonKey(name: 'fee_plan') FeePlanModel? feePlan, PaymentModel? payment,@JsonKey(name: 'created_at') DateTime? createdAt
});


@override $FeePlanModelCopyWith<$Res>? get feePlan;@override $PaymentModelCopyWith<$Res>? get payment;

}
/// @nodoc
class __$MembershipRenewalModelCopyWithImpl<$Res>
    implements _$MembershipRenewalModelCopyWith<$Res> {
  __$MembershipRenewalModelCopyWithImpl(this._self, this._then);

  final _MembershipRenewalModel _self;
  final $Res Function(_MembershipRenewalModel) _then;

/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? membershipType = freezed,Object? membershipId = freezed,Object? feePlanId = freezed,Object? paymentId = freezed,Object? previousEndDate = freezed,Object? newEndDate = freezed,Object? extendedInterval = freezed,Object? extendedCount = null,Object? amountPaid = null,Object? currency = null,Object? notes = freezed,Object? feePlan = freezed,Object? payment = freezed,Object? createdAt = freezed,}) {
  return _then(_MembershipRenewalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,previousEndDate: freezed == previousEndDate ? _self.previousEndDate : previousEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,newEndDate: freezed == newEndDate ? _self.newEndDate : newEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,extendedInterval: freezed == extendedInterval ? _self.extendedInterval : extendedInterval // ignore: cast_nullable_to_non_nullable
as String?,extendedCount: null == extendedCount ? _self.extendedCount : extendedCount // ignore: cast_nullable_to_non_nullable
as int,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MembershipRenewalModel
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
}/// Create a copy of MembershipRenewalModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $PaymentModelCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}

// dart format on
