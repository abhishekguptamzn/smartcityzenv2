// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_membership_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyMembershipSummary {

 FacilityKind get kind; String get payableId; DateTime? get latestPaidAt; double get amount; String get currency; String? get facilityId; String? get facilityName; String? get categoryName; String? get status; bool? get isValid; DateTime? get startDate; DateTime? get endDate; String? get membershipType; String? get batchName;
/// Create a copy of MyMembershipSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyMembershipSummaryCopyWith<MyMembershipSummary> get copyWith => _$MyMembershipSummaryCopyWithImpl<MyMembershipSummary>(this as MyMembershipSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyMembershipSummary&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.payableId, payableId) || other.payableId == payableId)&&(identical(other.latestPaidAt, latestPaidAt) || other.latestPaidAt == latestPaidAt)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.batchName, batchName) || other.batchName == batchName));
}


@override
int get hashCode => Object.hash(runtimeType,kind,payableId,latestPaidAt,amount,currency,facilityId,facilityName,categoryName,status,isValid,startDate,endDate,membershipType,batchName);

@override
String toString() {
  return 'MyMembershipSummary(kind: $kind, payableId: $payableId, latestPaidAt: $latestPaidAt, amount: $amount, currency: $currency, facilityId: $facilityId, facilityName: $facilityName, categoryName: $categoryName, status: $status, isValid: $isValid, startDate: $startDate, endDate: $endDate, membershipType: $membershipType, batchName: $batchName)';
}


}

/// @nodoc
abstract mixin class $MyMembershipSummaryCopyWith<$Res>  {
  factory $MyMembershipSummaryCopyWith(MyMembershipSummary value, $Res Function(MyMembershipSummary) _then) = _$MyMembershipSummaryCopyWithImpl;
@useResult
$Res call({
 FacilityKind kind, String payableId, DateTime? latestPaidAt, double amount, String currency, String? facilityId, String? facilityName, String? categoryName, String? status, bool? isValid, DateTime? startDate, DateTime? endDate, String? membershipType, String? batchName
});




}
/// @nodoc
class _$MyMembershipSummaryCopyWithImpl<$Res>
    implements $MyMembershipSummaryCopyWith<$Res> {
  _$MyMembershipSummaryCopyWithImpl(this._self, this._then);

  final MyMembershipSummary _self;
  final $Res Function(MyMembershipSummary) _then;

/// Create a copy of MyMembershipSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? payableId = null,Object? latestPaidAt = freezed,Object? amount = null,Object? currency = null,Object? facilityId = freezed,Object? facilityName = freezed,Object? categoryName = freezed,Object? status = freezed,Object? isValid = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? membershipType = freezed,Object? batchName = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,payableId: null == payableId ? _self.payableId : payableId // ignore: cast_nullable_to_non_nullable
as String,latestPaidAt: freezed == latestPaidAt ? _self.latestPaidAt : latestPaidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,facilityName: freezed == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isValid: freezed == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyMembershipSummary].
extension MyMembershipSummaryPatterns on MyMembershipSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyMembershipSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyMembershipSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyMembershipSummary value)  $default,){
final _that = this;
switch (_that) {
case _MyMembershipSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyMembershipSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MyMembershipSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FacilityKind kind,  String payableId,  DateTime? latestPaidAt,  double amount,  String currency,  String? facilityId,  String? facilityName,  String? categoryName,  String? status,  bool? isValid,  DateTime? startDate,  DateTime? endDate,  String? membershipType,  String? batchName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyMembershipSummary() when $default != null:
return $default(_that.kind,_that.payableId,_that.latestPaidAt,_that.amount,_that.currency,_that.facilityId,_that.facilityName,_that.categoryName,_that.status,_that.isValid,_that.startDate,_that.endDate,_that.membershipType,_that.batchName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FacilityKind kind,  String payableId,  DateTime? latestPaidAt,  double amount,  String currency,  String? facilityId,  String? facilityName,  String? categoryName,  String? status,  bool? isValid,  DateTime? startDate,  DateTime? endDate,  String? membershipType,  String? batchName)  $default,) {final _that = this;
switch (_that) {
case _MyMembershipSummary():
return $default(_that.kind,_that.payableId,_that.latestPaidAt,_that.amount,_that.currency,_that.facilityId,_that.facilityName,_that.categoryName,_that.status,_that.isValid,_that.startDate,_that.endDate,_that.membershipType,_that.batchName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FacilityKind kind,  String payableId,  DateTime? latestPaidAt,  double amount,  String currency,  String? facilityId,  String? facilityName,  String? categoryName,  String? status,  bool? isValid,  DateTime? startDate,  DateTime? endDate,  String? membershipType,  String? batchName)?  $default,) {final _that = this;
switch (_that) {
case _MyMembershipSummary() when $default != null:
return $default(_that.kind,_that.payableId,_that.latestPaidAt,_that.amount,_that.currency,_that.facilityId,_that.facilityName,_that.categoryName,_that.status,_that.isValid,_that.startDate,_that.endDate,_that.membershipType,_that.batchName);case _:
  return null;

}
}

}

/// @nodoc


class _MyMembershipSummary extends MyMembershipSummary {
  const _MyMembershipSummary({required this.kind, required this.payableId, required this.latestPaidAt, required this.amount, required this.currency, this.facilityId, this.facilityName, this.categoryName, this.status, this.isValid, this.startDate, this.endDate, this.membershipType, this.batchName}): super._();
  

@override final  FacilityKind kind;
@override final  String payableId;
@override final  DateTime? latestPaidAt;
@override final  double amount;
@override final  String currency;
@override final  String? facilityId;
@override final  String? facilityName;
@override final  String? categoryName;
@override final  String? status;
@override final  bool? isValid;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  String? membershipType;
@override final  String? batchName;

/// Create a copy of MyMembershipSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyMembershipSummaryCopyWith<_MyMembershipSummary> get copyWith => __$MyMembershipSummaryCopyWithImpl<_MyMembershipSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyMembershipSummary&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.payableId, payableId) || other.payableId == payableId)&&(identical(other.latestPaidAt, latestPaidAt) || other.latestPaidAt == latestPaidAt)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.membershipType, membershipType) || other.membershipType == membershipType)&&(identical(other.batchName, batchName) || other.batchName == batchName));
}


@override
int get hashCode => Object.hash(runtimeType,kind,payableId,latestPaidAt,amount,currency,facilityId,facilityName,categoryName,status,isValid,startDate,endDate,membershipType,batchName);

@override
String toString() {
  return 'MyMembershipSummary(kind: $kind, payableId: $payableId, latestPaidAt: $latestPaidAt, amount: $amount, currency: $currency, facilityId: $facilityId, facilityName: $facilityName, categoryName: $categoryName, status: $status, isValid: $isValid, startDate: $startDate, endDate: $endDate, membershipType: $membershipType, batchName: $batchName)';
}


}

/// @nodoc
abstract mixin class _$MyMembershipSummaryCopyWith<$Res> implements $MyMembershipSummaryCopyWith<$Res> {
  factory _$MyMembershipSummaryCopyWith(_MyMembershipSummary value, $Res Function(_MyMembershipSummary) _then) = __$MyMembershipSummaryCopyWithImpl;
@override @useResult
$Res call({
 FacilityKind kind, String payableId, DateTime? latestPaidAt, double amount, String currency, String? facilityId, String? facilityName, String? categoryName, String? status, bool? isValid, DateTime? startDate, DateTime? endDate, String? membershipType, String? batchName
});




}
/// @nodoc
class __$MyMembershipSummaryCopyWithImpl<$Res>
    implements _$MyMembershipSummaryCopyWith<$Res> {
  __$MyMembershipSummaryCopyWithImpl(this._self, this._then);

  final _MyMembershipSummary _self;
  final $Res Function(_MyMembershipSummary) _then;

/// Create a copy of MyMembershipSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? payableId = null,Object? latestPaidAt = freezed,Object? amount = null,Object? currency = null,Object? facilityId = freezed,Object? facilityName = freezed,Object? categoryName = freezed,Object? status = freezed,Object? isValid = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? membershipType = freezed,Object? batchName = freezed,}) {
  return _then(_MyMembershipSummary(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,payableId: null == payableId ? _self.payableId : payableId // ignore: cast_nullable_to_non_nullable
as String,latestPaidAt: freezed == latestPaidAt ? _self.latestPaidAt : latestPaidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,facilityName: freezed == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isValid: freezed == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,membershipType: freezed == membershipType ? _self.membershipType : membershipType // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
