// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_batch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacilityBatchModel {

 String get id;@JsonKey(name: 'facility_id') String get facilityId;@JsonKey(name: 'instructor_id') String? get instructorId; String get name; String? get category; String? get room; String? get description; int get capacity;@JsonKey(name: 'enrolled_count') int get enrolledCount;@JsonKey(name: 'available_spots') int get availableSpots;@JsonKey(name: 'is_full') bool get isFull;@JsonKey(fromJson: _toDouble) double? get fee;@JsonKey(name: 'fee_plan_id') String? get feePlanId;@JsonKey(name: 'fee_plan') FeePlanModel? get feePlan;@JsonKey(name: 'start_date') String? get startDate;@JsonKey(name: 'end_date') String? get endDate;@JsonKey(name: 'start_time') String? get startTime;@JsonKey(name: 'end_time') String? get endTime;@JsonKey(name: 'days_of_week') List<int> get daysOfWeek;@JsonKey(name: 'recurring_days_formatted') String? get recurringDaysFormatted;@JsonKey(name: 'default_checkout_time') String? get defaultCheckoutTime;@JsonKey(name: 'auto_checkout_buffer_minutes') int get autoCheckoutBufferMinutes; String get status;@JsonKey(name: 'enrollment_rules') String? get enrollmentRules;@JsonKey(name: 'allow_waitlist') bool get allowWaitlist; ActivityInstructorModel? get instructor; List<ActivityScheduleModel> get schedules;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityBatchModelCopyWith<FacilityBatchModel> get copyWith => _$FacilityBatchModelCopyWithImpl<FacilityBatchModel>(this as FacilityBatchModel, _$identity);

  /// Serializes this FacilityBatchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacilityBatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.room, room) || other.room == room)&&(identical(other.description, description) || other.description == description)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.availableSpots, availableSpots) || other.availableSpots == availableSpots)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other.daysOfWeek, daysOfWeek)&&(identical(other.recurringDaysFormatted, recurringDaysFormatted) || other.recurringDaysFormatted == recurringDaysFormatted)&&(identical(other.defaultCheckoutTime, defaultCheckoutTime) || other.defaultCheckoutTime == defaultCheckoutTime)&&(identical(other.autoCheckoutBufferMinutes, autoCheckoutBufferMinutes) || other.autoCheckoutBufferMinutes == autoCheckoutBufferMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrollmentRules, enrollmentRules) || other.enrollmentRules == enrollmentRules)&&(identical(other.allowWaitlist, allowWaitlist) || other.allowWaitlist == allowWaitlist)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,facilityId,instructorId,name,category,room,description,capacity,enrolledCount,availableSpots,isFull,fee,feePlanId,feePlan,startDate,endDate,startTime,endTime,const DeepCollectionEquality().hash(daysOfWeek),recurringDaysFormatted,defaultCheckoutTime,autoCheckoutBufferMinutes,status,enrollmentRules,allowWaitlist,instructor,const DeepCollectionEquality().hash(schedules),createdAt]);

@override
String toString() {
  return 'FacilityBatchModel(id: $id, facilityId: $facilityId, instructorId: $instructorId, name: $name, category: $category, room: $room, description: $description, capacity: $capacity, enrolledCount: $enrolledCount, availableSpots: $availableSpots, isFull: $isFull, fee: $fee, feePlanId: $feePlanId, feePlan: $feePlan, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, daysOfWeek: $daysOfWeek, recurringDaysFormatted: $recurringDaysFormatted, defaultCheckoutTime: $defaultCheckoutTime, autoCheckoutBufferMinutes: $autoCheckoutBufferMinutes, status: $status, enrollmentRules: $enrollmentRules, allowWaitlist: $allowWaitlist, instructor: $instructor, schedules: $schedules, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FacilityBatchModelCopyWith<$Res>  {
  factory $FacilityBatchModelCopyWith(FacilityBatchModel value, $Res Function(FacilityBatchModel) _then) = _$FacilityBatchModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'facility_id') String facilityId,@JsonKey(name: 'instructor_id') String? instructorId, String name, String? category, String? room, String? description, int capacity,@JsonKey(name: 'enrolled_count') int enrolledCount,@JsonKey(name: 'available_spots') int availableSpots,@JsonKey(name: 'is_full') bool isFull,@JsonKey(fromJson: _toDouble) double? fee,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'fee_plan') FeePlanModel? feePlan,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime,@JsonKey(name: 'days_of_week') List<int> daysOfWeek,@JsonKey(name: 'recurring_days_formatted') String? recurringDaysFormatted,@JsonKey(name: 'default_checkout_time') String? defaultCheckoutTime,@JsonKey(name: 'auto_checkout_buffer_minutes') int autoCheckoutBufferMinutes, String status,@JsonKey(name: 'enrollment_rules') String? enrollmentRules,@JsonKey(name: 'allow_waitlist') bool allowWaitlist, ActivityInstructorModel? instructor, List<ActivityScheduleModel> schedules,@JsonKey(name: 'created_at') DateTime? createdAt
});


$FeePlanModelCopyWith<$Res>? get feePlan;$ActivityInstructorModelCopyWith<$Res>? get instructor;

}
/// @nodoc
class _$FacilityBatchModelCopyWithImpl<$Res>
    implements $FacilityBatchModelCopyWith<$Res> {
  _$FacilityBatchModelCopyWithImpl(this._self, this._then);

  final FacilityBatchModel _self;
  final $Res Function(FacilityBatchModel) _then;

/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? facilityId = null,Object? instructorId = freezed,Object? name = null,Object? category = freezed,Object? room = freezed,Object? description = freezed,Object? capacity = null,Object? enrolledCount = null,Object? availableSpots = null,Object? isFull = null,Object? fee = freezed,Object? feePlanId = freezed,Object? feePlan = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? daysOfWeek = null,Object? recurringDaysFormatted = freezed,Object? defaultCheckoutTime = freezed,Object? autoCheckoutBufferMinutes = null,Object? status = null,Object? enrollmentRules = freezed,Object? allowWaitlist = null,Object? instructor = freezed,Object? schedules = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,availableSpots: null == availableSpots ? _self.availableSpots : availableSpots // ignore: cast_nullable_to_non_nullable
as int,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,fee: freezed == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as double?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,recurringDaysFormatted: freezed == recurringDaysFormatted ? _self.recurringDaysFormatted : recurringDaysFormatted // ignore: cast_nullable_to_non_nullable
as String?,defaultCheckoutTime: freezed == defaultCheckoutTime ? _self.defaultCheckoutTime : defaultCheckoutTime // ignore: cast_nullable_to_non_nullable
as String?,autoCheckoutBufferMinutes: null == autoCheckoutBufferMinutes ? _self.autoCheckoutBufferMinutes : autoCheckoutBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,enrollmentRules: freezed == enrollmentRules ? _self.enrollmentRules : enrollmentRules // ignore: cast_nullable_to_non_nullable
as String?,allowWaitlist: null == allowWaitlist ? _self.allowWaitlist : allowWaitlist // ignore: cast_nullable_to_non_nullable
as bool,instructor: freezed == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as ActivityInstructorModel?,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ActivityScheduleModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of FacilityBatchModel
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
}/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityInstructorModelCopyWith<$Res>? get instructor {
    if (_self.instructor == null) {
    return null;
  }

  return $ActivityInstructorModelCopyWith<$Res>(_self.instructor!, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [FacilityBatchModel].
extension FacilityBatchModelPatterns on FacilityBatchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacilityBatchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacilityBatchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacilityBatchModel value)  $default,){
final _that = this;
switch (_that) {
case _FacilityBatchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacilityBatchModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacilityBatchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_id')  String facilityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? category,  String? room,  String? description,  int capacity, @JsonKey(name: 'enrolled_count')  int enrolledCount, @JsonKey(name: 'available_spots')  int availableSpots, @JsonKey(name: 'is_full')  bool isFull, @JsonKey(fromJson: _toDouble)  double? fee, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'days_of_week')  List<int> daysOfWeek, @JsonKey(name: 'recurring_days_formatted')  String? recurringDaysFormatted, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'auto_checkout_buffer_minutes')  int autoCheckoutBufferMinutes,  String status, @JsonKey(name: 'enrollment_rules')  String? enrollmentRules, @JsonKey(name: 'allow_waitlist')  bool allowWaitlist,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacilityBatchModel() when $default != null:
return $default(_that.id,_that.facilityId,_that.instructorId,_that.name,_that.category,_that.room,_that.description,_that.capacity,_that.enrolledCount,_that.availableSpots,_that.isFull,_that.fee,_that.feePlanId,_that.feePlan,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.daysOfWeek,_that.recurringDaysFormatted,_that.defaultCheckoutTime,_that.autoCheckoutBufferMinutes,_that.status,_that.enrollmentRules,_that.allowWaitlist,_that.instructor,_that.schedules,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'facility_id')  String facilityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? category,  String? room,  String? description,  int capacity, @JsonKey(name: 'enrolled_count')  int enrolledCount, @JsonKey(name: 'available_spots')  int availableSpots, @JsonKey(name: 'is_full')  bool isFull, @JsonKey(fromJson: _toDouble)  double? fee, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'days_of_week')  List<int> daysOfWeek, @JsonKey(name: 'recurring_days_formatted')  String? recurringDaysFormatted, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'auto_checkout_buffer_minutes')  int autoCheckoutBufferMinutes,  String status, @JsonKey(name: 'enrollment_rules')  String? enrollmentRules, @JsonKey(name: 'allow_waitlist')  bool allowWaitlist,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FacilityBatchModel():
return $default(_that.id,_that.facilityId,_that.instructorId,_that.name,_that.category,_that.room,_that.description,_that.capacity,_that.enrolledCount,_that.availableSpots,_that.isFull,_that.fee,_that.feePlanId,_that.feePlan,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.daysOfWeek,_that.recurringDaysFormatted,_that.defaultCheckoutTime,_that.autoCheckoutBufferMinutes,_that.status,_that.enrollmentRules,_that.allowWaitlist,_that.instructor,_that.schedules,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'facility_id')  String facilityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? category,  String? room,  String? description,  int capacity, @JsonKey(name: 'enrolled_count')  int enrolledCount, @JsonKey(name: 'available_spots')  int availableSpots, @JsonKey(name: 'is_full')  bool isFull, @JsonKey(fromJson: _toDouble)  double? fee, @JsonKey(name: 'fee_plan_id')  String? feePlanId, @JsonKey(name: 'fee_plan')  FeePlanModel? feePlan, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'days_of_week')  List<int> daysOfWeek, @JsonKey(name: 'recurring_days_formatted')  String? recurringDaysFormatted, @JsonKey(name: 'default_checkout_time')  String? defaultCheckoutTime, @JsonKey(name: 'auto_checkout_buffer_minutes')  int autoCheckoutBufferMinutes,  String status, @JsonKey(name: 'enrollment_rules')  String? enrollmentRules, @JsonKey(name: 'allow_waitlist')  bool allowWaitlist,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FacilityBatchModel() when $default != null:
return $default(_that.id,_that.facilityId,_that.instructorId,_that.name,_that.category,_that.room,_that.description,_that.capacity,_that.enrolledCount,_that.availableSpots,_that.isFull,_that.fee,_that.feePlanId,_that.feePlan,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.daysOfWeek,_that.recurringDaysFormatted,_that.defaultCheckoutTime,_that.autoCheckoutBufferMinutes,_that.status,_that.enrollmentRules,_that.allowWaitlist,_that.instructor,_that.schedules,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacilityBatchModel extends FacilityBatchModel {
  const _FacilityBatchModel({required this.id, @JsonKey(name: 'facility_id') required this.facilityId, @JsonKey(name: 'instructor_id') this.instructorId, required this.name, this.category, this.room, this.description, this.capacity = 30, @JsonKey(name: 'enrolled_count') this.enrolledCount = 0, @JsonKey(name: 'available_spots') this.availableSpots = 0, @JsonKey(name: 'is_full') this.isFull = false, @JsonKey(fromJson: _toDouble) this.fee, @JsonKey(name: 'fee_plan_id') this.feePlanId, @JsonKey(name: 'fee_plan') this.feePlan, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'start_time') this.startTime, @JsonKey(name: 'end_time') this.endTime, @JsonKey(name: 'days_of_week') final  List<int> daysOfWeek = const [], @JsonKey(name: 'recurring_days_formatted') this.recurringDaysFormatted, @JsonKey(name: 'default_checkout_time') this.defaultCheckoutTime, @JsonKey(name: 'auto_checkout_buffer_minutes') this.autoCheckoutBufferMinutes = 15, this.status = 'active', @JsonKey(name: 'enrollment_rules') this.enrollmentRules, @JsonKey(name: 'allow_waitlist') this.allowWaitlist = false, this.instructor, final  List<ActivityScheduleModel> schedules = const [], @JsonKey(name: 'created_at') this.createdAt}): _daysOfWeek = daysOfWeek,_schedules = schedules,super._();
  factory _FacilityBatchModel.fromJson(Map<String, dynamic> json) => _$FacilityBatchModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'facility_id') final  String facilityId;
@override@JsonKey(name: 'instructor_id') final  String? instructorId;
@override final  String name;
@override final  String? category;
@override final  String? room;
@override final  String? description;
@override@JsonKey() final  int capacity;
@override@JsonKey(name: 'enrolled_count') final  int enrolledCount;
@override@JsonKey(name: 'available_spots') final  int availableSpots;
@override@JsonKey(name: 'is_full') final  bool isFull;
@override@JsonKey(fromJson: _toDouble) final  double? fee;
@override@JsonKey(name: 'fee_plan_id') final  String? feePlanId;
@override@JsonKey(name: 'fee_plan') final  FeePlanModel? feePlan;
@override@JsonKey(name: 'start_date') final  String? startDate;
@override@JsonKey(name: 'end_date') final  String? endDate;
@override@JsonKey(name: 'start_time') final  String? startTime;
@override@JsonKey(name: 'end_time') final  String? endTime;
 final  List<int> _daysOfWeek;
@override@JsonKey(name: 'days_of_week') List<int> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfWeek);
}

@override@JsonKey(name: 'recurring_days_formatted') final  String? recurringDaysFormatted;
@override@JsonKey(name: 'default_checkout_time') final  String? defaultCheckoutTime;
@override@JsonKey(name: 'auto_checkout_buffer_minutes') final  int autoCheckoutBufferMinutes;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'enrollment_rules') final  String? enrollmentRules;
@override@JsonKey(name: 'allow_waitlist') final  bool allowWaitlist;
@override final  ActivityInstructorModel? instructor;
 final  List<ActivityScheduleModel> _schedules;
@override@JsonKey() List<ActivityScheduleModel> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityBatchModelCopyWith<_FacilityBatchModel> get copyWith => __$FacilityBatchModelCopyWithImpl<_FacilityBatchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacilityBatchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacilityBatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.room, room) || other.room == room)&&(identical(other.description, description) || other.description == description)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.availableSpots, availableSpots) || other.availableSpots == availableSpots)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.feePlanId, feePlanId) || other.feePlanId == feePlanId)&&(identical(other.feePlan, feePlan) || other.feePlan == feePlan)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek)&&(identical(other.recurringDaysFormatted, recurringDaysFormatted) || other.recurringDaysFormatted == recurringDaysFormatted)&&(identical(other.defaultCheckoutTime, defaultCheckoutTime) || other.defaultCheckoutTime == defaultCheckoutTime)&&(identical(other.autoCheckoutBufferMinutes, autoCheckoutBufferMinutes) || other.autoCheckoutBufferMinutes == autoCheckoutBufferMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrollmentRules, enrollmentRules) || other.enrollmentRules == enrollmentRules)&&(identical(other.allowWaitlist, allowWaitlist) || other.allowWaitlist == allowWaitlist)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,facilityId,instructorId,name,category,room,description,capacity,enrolledCount,availableSpots,isFull,fee,feePlanId,feePlan,startDate,endDate,startTime,endTime,const DeepCollectionEquality().hash(_daysOfWeek),recurringDaysFormatted,defaultCheckoutTime,autoCheckoutBufferMinutes,status,enrollmentRules,allowWaitlist,instructor,const DeepCollectionEquality().hash(_schedules),createdAt]);

@override
String toString() {
  return 'FacilityBatchModel(id: $id, facilityId: $facilityId, instructorId: $instructorId, name: $name, category: $category, room: $room, description: $description, capacity: $capacity, enrolledCount: $enrolledCount, availableSpots: $availableSpots, isFull: $isFull, fee: $fee, feePlanId: $feePlanId, feePlan: $feePlan, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, daysOfWeek: $daysOfWeek, recurringDaysFormatted: $recurringDaysFormatted, defaultCheckoutTime: $defaultCheckoutTime, autoCheckoutBufferMinutes: $autoCheckoutBufferMinutes, status: $status, enrollmentRules: $enrollmentRules, allowWaitlist: $allowWaitlist, instructor: $instructor, schedules: $schedules, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FacilityBatchModelCopyWith<$Res> implements $FacilityBatchModelCopyWith<$Res> {
  factory _$FacilityBatchModelCopyWith(_FacilityBatchModel value, $Res Function(_FacilityBatchModel) _then) = __$FacilityBatchModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'facility_id') String facilityId,@JsonKey(name: 'instructor_id') String? instructorId, String name, String? category, String? room, String? description, int capacity,@JsonKey(name: 'enrolled_count') int enrolledCount,@JsonKey(name: 'available_spots') int availableSpots,@JsonKey(name: 'is_full') bool isFull,@JsonKey(fromJson: _toDouble) double? fee,@JsonKey(name: 'fee_plan_id') String? feePlanId,@JsonKey(name: 'fee_plan') FeePlanModel? feePlan,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime,@JsonKey(name: 'days_of_week') List<int> daysOfWeek,@JsonKey(name: 'recurring_days_formatted') String? recurringDaysFormatted,@JsonKey(name: 'default_checkout_time') String? defaultCheckoutTime,@JsonKey(name: 'auto_checkout_buffer_minutes') int autoCheckoutBufferMinutes, String status,@JsonKey(name: 'enrollment_rules') String? enrollmentRules,@JsonKey(name: 'allow_waitlist') bool allowWaitlist, ActivityInstructorModel? instructor, List<ActivityScheduleModel> schedules,@JsonKey(name: 'created_at') DateTime? createdAt
});


@override $FeePlanModelCopyWith<$Res>? get feePlan;@override $ActivityInstructorModelCopyWith<$Res>? get instructor;

}
/// @nodoc
class __$FacilityBatchModelCopyWithImpl<$Res>
    implements _$FacilityBatchModelCopyWith<$Res> {
  __$FacilityBatchModelCopyWithImpl(this._self, this._then);

  final _FacilityBatchModel _self;
  final $Res Function(_FacilityBatchModel) _then;

/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? facilityId = null,Object? instructorId = freezed,Object? name = null,Object? category = freezed,Object? room = freezed,Object? description = freezed,Object? capacity = null,Object? enrolledCount = null,Object? availableSpots = null,Object? isFull = null,Object? fee = freezed,Object? feePlanId = freezed,Object? feePlan = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? daysOfWeek = null,Object? recurringDaysFormatted = freezed,Object? defaultCheckoutTime = freezed,Object? autoCheckoutBufferMinutes = null,Object? status = null,Object? enrollmentRules = freezed,Object? allowWaitlist = null,Object? instructor = freezed,Object? schedules = null,Object? createdAt = freezed,}) {
  return _then(_FacilityBatchModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,availableSpots: null == availableSpots ? _self.availableSpots : availableSpots // ignore: cast_nullable_to_non_nullable
as int,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,fee: freezed == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as double?,feePlanId: freezed == feePlanId ? _self.feePlanId : feePlanId // ignore: cast_nullable_to_non_nullable
as String?,feePlan: freezed == feePlan ? _self.feePlan : feePlan // ignore: cast_nullable_to_non_nullable
as FeePlanModel?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,recurringDaysFormatted: freezed == recurringDaysFormatted ? _self.recurringDaysFormatted : recurringDaysFormatted // ignore: cast_nullable_to_non_nullable
as String?,defaultCheckoutTime: freezed == defaultCheckoutTime ? _self.defaultCheckoutTime : defaultCheckoutTime // ignore: cast_nullable_to_non_nullable
as String?,autoCheckoutBufferMinutes: null == autoCheckoutBufferMinutes ? _self.autoCheckoutBufferMinutes : autoCheckoutBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,enrollmentRules: freezed == enrollmentRules ? _self.enrollmentRules : enrollmentRules // ignore: cast_nullable_to_non_nullable
as String?,allowWaitlist: null == allowWaitlist ? _self.allowWaitlist : allowWaitlist // ignore: cast_nullable_to_non_nullable
as bool,instructor: freezed == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as ActivityInstructorModel?,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ActivityScheduleModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of FacilityBatchModel
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
}/// Create a copy of FacilityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityInstructorModelCopyWith<$Res>? get instructor {
    if (_self.instructor == null) {
    return null;
  }

  return $ActivityInstructorModelCopyWith<$Res>(_self.instructor!, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}

// dart format on
