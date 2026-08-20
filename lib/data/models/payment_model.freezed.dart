// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentModel {

 String get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'payable_type') String? get payableType;@JsonKey(name: 'payable_id') String? get payableId;@JsonKey(fromJson: _toDouble) double get amount; String get currency; String get status;@JsonKey(name: 'payment_method') String? get paymentMethod;@JsonKey(name: 'transaction_reference') String? get transactionReference;@JsonKey(name: 'invoice_number') String? get invoiceNumber;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'paid_at') DateTime? get paidAt; String? get notes;@JsonKey(name: 'facility_name') String? get facilityName;@JsonKey(name: 'facility_id') String? get facilityId; UserModel? get user;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<PaymentModel> get copyWith => _$PaymentModelCopyWithImpl<PaymentModel>(this as PaymentModel, _$identity);

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.payableType, payableType) || other.payableType == payableType)&&(identical(other.payableId, payableId) || other.payableId == payableId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionReference, transactionReference) || other.transactionReference == transactionReference)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,payableType,payableId,amount,currency,status,paymentMethod,transactionReference,invoiceNumber,dueDate,paidAt,notes,facilityName,facilityId,user,createdAt,updatedAt);

@override
String toString() {
  return 'PaymentModel(id: $id, userId: $userId, payableType: $payableType, payableId: $payableId, amount: $amount, currency: $currency, status: $status, paymentMethod: $paymentMethod, transactionReference: $transactionReference, invoiceNumber: $invoiceNumber, dueDate: $dueDate, paidAt: $paidAt, notes: $notes, facilityName: $facilityName, facilityId: $facilityId, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PaymentModelCopyWith<$Res>  {
  factory $PaymentModelCopyWith(PaymentModel value, $Res Function(PaymentModel) _then) = _$PaymentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'payable_type') String? payableType,@JsonKey(name: 'payable_id') String? payableId,@JsonKey(fromJson: _toDouble) double amount, String currency, String status,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'transaction_reference') String? transactionReference,@JsonKey(name: 'invoice_number') String? invoiceNumber,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'paid_at') DateTime? paidAt, String? notes,@JsonKey(name: 'facility_name') String? facilityName,@JsonKey(name: 'facility_id') String? facilityId, UserModel? user,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$PaymentModelCopyWithImpl<$Res>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._self, this._then);

  final PaymentModel _self;
  final $Res Function(PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? payableType = freezed,Object? payableId = freezed,Object? amount = null,Object? currency = null,Object? status = null,Object? paymentMethod = freezed,Object? transactionReference = freezed,Object? invoiceNumber = freezed,Object? dueDate = freezed,Object? paidAt = freezed,Object? notes = freezed,Object? facilityName = freezed,Object? facilityId = freezed,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,payableType: freezed == payableType ? _self.payableType : payableType // ignore: cast_nullable_to_non_nullable
as String?,payableId: freezed == payableId ? _self.payableId : payableId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,transactionReference: freezed == transactionReference ? _self.transactionReference : transactionReference // ignore: cast_nullable_to_non_nullable
as String?,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,facilityName: freezed == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String?,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PaymentModel
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


/// Adds pattern-matching-related methods to [PaymentModel].
extension PaymentModelPatterns on PaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'payable_type')  String? payableType, @JsonKey(name: 'payable_id')  String? payableId, @JsonKey(fromJson: _toDouble)  double amount,  String currency,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'transaction_reference')  String? transactionReference, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'paid_at')  DateTime? paidAt,  String? notes, @JsonKey(name: 'facility_name')  String? facilityName, @JsonKey(name: 'facility_id')  String? facilityId,  UserModel? user, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.userId,_that.payableType,_that.payableId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.transactionReference,_that.invoiceNumber,_that.dueDate,_that.paidAt,_that.notes,_that.facilityName,_that.facilityId,_that.user,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'payable_type')  String? payableType, @JsonKey(name: 'payable_id')  String? payableId, @JsonKey(fromJson: _toDouble)  double amount,  String currency,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'transaction_reference')  String? transactionReference, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'paid_at')  DateTime? paidAt,  String? notes, @JsonKey(name: 'facility_name')  String? facilityName, @JsonKey(name: 'facility_id')  String? facilityId,  UserModel? user, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentModel():
return $default(_that.id,_that.userId,_that.payableType,_that.payableId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.transactionReference,_that.invoiceNumber,_that.dueDate,_that.paidAt,_that.notes,_that.facilityName,_that.facilityId,_that.user,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'payable_type')  String? payableType, @JsonKey(name: 'payable_id')  String? payableId, @JsonKey(fromJson: _toDouble)  double amount,  String currency,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'transaction_reference')  String? transactionReference, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'paid_at')  DateTime? paidAt,  String? notes, @JsonKey(name: 'facility_name')  String? facilityName, @JsonKey(name: 'facility_id')  String? facilityId,  UserModel? user, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.userId,_that.payableType,_that.payableId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.transactionReference,_that.invoiceNumber,_that.dueDate,_that.paidAt,_that.notes,_that.facilityName,_that.facilityId,_that.user,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentModel extends PaymentModel {
  const _PaymentModel({required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'payable_type') this.payableType, @JsonKey(name: 'payable_id') this.payableId, @JsonKey(fromJson: _toDouble) this.amount = 0, this.currency = 'INR', this.status = 'pending', @JsonKey(name: 'payment_method') this.paymentMethod, @JsonKey(name: 'transaction_reference') this.transactionReference, @JsonKey(name: 'invoice_number') this.invoiceNumber, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'paid_at') this.paidAt, this.notes, @JsonKey(name: 'facility_name') this.facilityName, @JsonKey(name: 'facility_id') this.facilityId, this.user, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  factory _PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'payable_type') final  String? payableType;
@override@JsonKey(name: 'payable_id') final  String? payableId;
@override@JsonKey(fromJson: _toDouble) final  double amount;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override@JsonKey(name: 'transaction_reference') final  String? transactionReference;
@override@JsonKey(name: 'invoice_number') final  String? invoiceNumber;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'paid_at') final  DateTime? paidAt;
@override final  String? notes;
@override@JsonKey(name: 'facility_name') final  String? facilityName;
@override@JsonKey(name: 'facility_id') final  String? facilityId;
@override final  UserModel? user;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentModelCopyWith<_PaymentModel> get copyWith => __$PaymentModelCopyWithImpl<_PaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.payableType, payableType) || other.payableType == payableType)&&(identical(other.payableId, payableId) || other.payableId == payableId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionReference, transactionReference) || other.transactionReference == transactionReference)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,payableType,payableId,amount,currency,status,paymentMethod,transactionReference,invoiceNumber,dueDate,paidAt,notes,facilityName,facilityId,user,createdAt,updatedAt);

@override
String toString() {
  return 'PaymentModel(id: $id, userId: $userId, payableType: $payableType, payableId: $payableId, amount: $amount, currency: $currency, status: $status, paymentMethod: $paymentMethod, transactionReference: $transactionReference, invoiceNumber: $invoiceNumber, dueDate: $dueDate, paidAt: $paidAt, notes: $notes, facilityName: $facilityName, facilityId: $facilityId, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentModelCopyWith<$Res> implements $PaymentModelCopyWith<$Res> {
  factory _$PaymentModelCopyWith(_PaymentModel value, $Res Function(_PaymentModel) _then) = __$PaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'payable_type') String? payableType,@JsonKey(name: 'payable_id') String? payableId,@JsonKey(fromJson: _toDouble) double amount, String currency, String status,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'transaction_reference') String? transactionReference,@JsonKey(name: 'invoice_number') String? invoiceNumber,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'paid_at') DateTime? paidAt, String? notes,@JsonKey(name: 'facility_name') String? facilityName,@JsonKey(name: 'facility_id') String? facilityId, UserModel? user,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$PaymentModelCopyWithImpl<$Res>
    implements _$PaymentModelCopyWith<$Res> {
  __$PaymentModelCopyWithImpl(this._self, this._then);

  final _PaymentModel _self;
  final $Res Function(_PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? payableType = freezed,Object? payableId = freezed,Object? amount = null,Object? currency = null,Object? status = null,Object? paymentMethod = freezed,Object? transactionReference = freezed,Object? invoiceNumber = freezed,Object? dueDate = freezed,Object? paidAt = freezed,Object? notes = freezed,Object? facilityName = freezed,Object? facilityId = freezed,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,payableType: freezed == payableType ? _self.payableType : payableType // ignore: cast_nullable_to_non_nullable
as String?,payableId: freezed == payableId ? _self.payableId : payableId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,transactionReference: freezed == transactionReference ? _self.transactionReference : transactionReference // ignore: cast_nullable_to_non_nullable
as String?,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,facilityName: freezed == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String?,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PaymentModel
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
