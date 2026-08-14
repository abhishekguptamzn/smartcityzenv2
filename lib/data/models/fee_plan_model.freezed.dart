// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeePlanModel {

 String get id;@JsonKey(name: 'facility_type') String? get facilityType;@JsonKey(name: 'facility_id') String? get facilityId; String get name; String get interval;@JsonKey(name: 'interval_count') int get intervalCount;@JsonKey(fromJson: _toDouble) double get amount; String get currency;@JsonKey(name: 'is_active') bool get isActive; String? get description;
/// Create a copy of FeePlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeePlanModelCopyWith<FeePlanModel> get copyWith => _$FeePlanModelCopyWithImpl<FeePlanModel>(this as FeePlanModel, _$identity);

  /// Serializes this FeePlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeePlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityType, facilityType) || other.facilityType == facilityType)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityType,facilityId,name,interval,intervalCount,amount,currency,isActive,description);

@override
String toString() {
  return 'FeePlanModel(id: $id, facilityType: $facilityType, facilityId: $facilityId, name: $name, interval: $interval, intervalCount: $intervalCount, amount: $amount, currency: $currency, isActive: $isActive, description: $description)';
}


}

/// @nodoc
abstract mixin class $FeePlanModelCopyWith<$Res>  {
  factory $FeePlanModelCopyWith(FeePlanModel value, $Res Function(FeePlanModel) _then) = _$FeePlanModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'facility_type') String? facilityType,@JsonKey(name: 'facility_id') String? facilityId, String name, String interval,@JsonKey(name: 'interval_count') int intervalCount,@JsonKey(fromJson: _toDouble) double amount, String currency,@JsonKey(name: 'is_active') bool isActive, String? description
});




}
/// @nodoc
class _$FeePlanModelCopyWithImpl<$Res>
    implements $FeePlanModelCopyWith<$Res> {
  _$FeePlanModelCopyWithImpl(this._self, this._then);

  final FeePlanModel _self;
  final $Res Function(FeePlanModel) _then;

/// Create a copy of FeePlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? facilityType = freezed,Object? facilityId = freezed,Object? name = null,Object? interval = null,Object? intervalCount = null,Object? amount = null,Object? currency = null,Object? isActive = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityType: freezed == facilityType ? _self.facilityType : facilityType // ignore: cast_nullable_to_non_nullable
as String?,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeePlanModel].
extension FeePlanModelPatterns on FeePlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeePlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeePlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeePlanModel value)  $default,){
final _that = this;
switch (_that) {
case _FeePlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeePlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeePlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_type')  String? facilityType, @JsonKey(name: 'facility_id')  String? facilityId,  String name,  String interval, @JsonKey(name: 'interval_count')  int intervalCount, @JsonKey(fromJson: _toDouble)  double amount,  String currency, @JsonKey(name: 'is_active')  bool isActive,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeePlanModel() when $default != null:
return $default(_that.id,_that.facilityType,_that.facilityId,_that.name,_that.interval,_that.intervalCount,_that.amount,_that.currency,_that.isActive,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_type')  String? facilityType, @JsonKey(name: 'facility_id')  String? facilityId,  String name,  String interval, @JsonKey(name: 'interval_count')  int intervalCount, @JsonKey(fromJson: _toDouble)  double amount,  String currency, @JsonKey(name: 'is_active')  bool isActive,  String? description)  $default,) {final _that = this;
switch (_that) {
case _FeePlanModel():
return $default(_that.id,_that.facilityType,_that.facilityId,_that.name,_that.interval,_that.intervalCount,_that.amount,_that.currency,_that.isActive,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'facility_type')  String? facilityType, @JsonKey(name: 'facility_id')  String? facilityId,  String name,  String interval, @JsonKey(name: 'interval_count')  int intervalCount, @JsonKey(fromJson: _toDouble)  double amount,  String currency, @JsonKey(name: 'is_active')  bool isActive,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _FeePlanModel() when $default != null:
return $default(_that.id,_that.facilityType,_that.facilityId,_that.name,_that.interval,_that.intervalCount,_that.amount,_that.currency,_that.isActive,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeePlanModel implements FeePlanModel {
  const _FeePlanModel({required this.id, @JsonKey(name: 'facility_type') this.facilityType, @JsonKey(name: 'facility_id') this.facilityId, required this.name, this.interval = 'month', @JsonKey(name: 'interval_count') this.intervalCount = 1, @JsonKey(fromJson: _toDouble) this.amount = 0, this.currency = 'INR', @JsonKey(name: 'is_active') this.isActive = true, this.description});
  factory _FeePlanModel.fromJson(Map<String, dynamic> json) => _$FeePlanModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'facility_type') final  String? facilityType;
@override@JsonKey(name: 'facility_id') final  String? facilityId;
@override final  String name;
@override@JsonKey() final  String interval;
@override@JsonKey(name: 'interval_count') final  int intervalCount;
@override@JsonKey(fromJson: _toDouble) final  double amount;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override final  String? description;

/// Create a copy of FeePlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeePlanModelCopyWith<_FeePlanModel> get copyWith => __$FeePlanModelCopyWithImpl<_FeePlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeePlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeePlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityType, facilityType) || other.facilityType == facilityType)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityType,facilityId,name,interval,intervalCount,amount,currency,isActive,description);

@override
String toString() {
  return 'FeePlanModel(id: $id, facilityType: $facilityType, facilityId: $facilityId, name: $name, interval: $interval, intervalCount: $intervalCount, amount: $amount, currency: $currency, isActive: $isActive, description: $description)';
}


}

/// @nodoc
abstract mixin class _$FeePlanModelCopyWith<$Res> implements $FeePlanModelCopyWith<$Res> {
  factory _$FeePlanModelCopyWith(_FeePlanModel value, $Res Function(_FeePlanModel) _then) = __$FeePlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'facility_type') String? facilityType,@JsonKey(name: 'facility_id') String? facilityId, String name, String interval,@JsonKey(name: 'interval_count') int intervalCount,@JsonKey(fromJson: _toDouble) double amount, String currency,@JsonKey(name: 'is_active') bool isActive, String? description
});




}
/// @nodoc
class __$FeePlanModelCopyWithImpl<$Res>
    implements _$FeePlanModelCopyWith<$Res> {
  __$FeePlanModelCopyWithImpl(this._self, this._then);

  final _FeePlanModel _self;
  final $Res Function(_FeePlanModel) _then;

/// Create a copy of FeePlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? facilityType = freezed,Object? facilityId = freezed,Object? name = null,Object? interval = null,Object? intervalCount = null,Object? amount = null,Object? currency = null,Object? isActive = null,Object? description = freezed,}) {
  return _then(_FeePlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityType: freezed == facilityType ? _self.facilityType : facilityType // ignore: cast_nullable_to_non_nullable
as String?,facilityId: freezed == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
