// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_batch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityBatchModel {

 String get id;@JsonKey(name: 'activity_id') String get activityId;@JsonKey(name: 'instructor_id') String? get instructorId; String get name; String? get description;@JsonKey(name: 'age_group') String? get ageGroup;@JsonKey(name: 'skill_level') String? get skillLevel; int get capacity;@JsonKey(name: 'active_enrollments_count') int get activeEnrollmentsCount;@JsonKey(name: 'available_spots') int? get availableSpots; String get status; ActivityInstructorModel? get instructor; List<ActivityScheduleModel> get schedules;
/// Create a copy of ActivityBatchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityBatchModelCopyWith<ActivityBatchModel> get copyWith => _$ActivityBatchModelCopyWithImpl<ActivityBatchModel>(this as ActivityBatchModel, _$identity);

  /// Serializes this ActivityBatchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityBatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.activeEnrollmentsCount, activeEnrollmentsCount) || other.activeEnrollmentsCount == activeEnrollmentsCount)&&(identical(other.availableSpots, availableSpots) || other.availableSpots == availableSpots)&&(identical(other.status, status) || other.status == status)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&const DeepCollectionEquality().equals(other.schedules, schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,instructorId,name,description,ageGroup,skillLevel,capacity,activeEnrollmentsCount,availableSpots,status,instructor,const DeepCollectionEquality().hash(schedules));

@override
String toString() {
  return 'ActivityBatchModel(id: $id, activityId: $activityId, instructorId: $instructorId, name: $name, description: $description, ageGroup: $ageGroup, skillLevel: $skillLevel, capacity: $capacity, activeEnrollmentsCount: $activeEnrollmentsCount, availableSpots: $availableSpots, status: $status, instructor: $instructor, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class $ActivityBatchModelCopyWith<$Res>  {
  factory $ActivityBatchModelCopyWith(ActivityBatchModel value, $Res Function(ActivityBatchModel) _then) = _$ActivityBatchModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'instructor_id') String? instructorId, String name, String? description,@JsonKey(name: 'age_group') String? ageGroup,@JsonKey(name: 'skill_level') String? skillLevel, int capacity,@JsonKey(name: 'active_enrollments_count') int activeEnrollmentsCount,@JsonKey(name: 'available_spots') int? availableSpots, String status, ActivityInstructorModel? instructor, List<ActivityScheduleModel> schedules
});


$ActivityInstructorModelCopyWith<$Res>? get instructor;

}
/// @nodoc
class _$ActivityBatchModelCopyWithImpl<$Res>
    implements $ActivityBatchModelCopyWith<$Res> {
  _$ActivityBatchModelCopyWithImpl(this._self, this._then);

  final ActivityBatchModel _self;
  final $Res Function(ActivityBatchModel) _then;

/// Create a copy of ActivityBatchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? activityId = null,Object? instructorId = freezed,Object? name = null,Object? description = freezed,Object? ageGroup = freezed,Object? skillLevel = freezed,Object? capacity = null,Object? activeEnrollmentsCount = null,Object? availableSpots = freezed,Object? status = null,Object? instructor = freezed,Object? schedules = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String?,skillLevel: freezed == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,activeEnrollmentsCount: null == activeEnrollmentsCount ? _self.activeEnrollmentsCount : activeEnrollmentsCount // ignore: cast_nullable_to_non_nullable
as int,availableSpots: freezed == availableSpots ? _self.availableSpots : availableSpots // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,instructor: freezed == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as ActivityInstructorModel?,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ActivityScheduleModel>,
  ));
}
/// Create a copy of ActivityBatchModel
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


/// Adds pattern-matching-related methods to [ActivityBatchModel].
extension ActivityBatchModelPatterns on ActivityBatchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityBatchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityBatchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityBatchModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityBatchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityBatchModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityBatchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? description, @JsonKey(name: 'age_group')  String? ageGroup, @JsonKey(name: 'skill_level')  String? skillLevel,  int capacity, @JsonKey(name: 'active_enrollments_count')  int activeEnrollmentsCount, @JsonKey(name: 'available_spots')  int? availableSpots,  String status,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityBatchModel() when $default != null:
return $default(_that.id,_that.activityId,_that.instructorId,_that.name,_that.description,_that.ageGroup,_that.skillLevel,_that.capacity,_that.activeEnrollmentsCount,_that.availableSpots,_that.status,_that.instructor,_that.schedules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? description, @JsonKey(name: 'age_group')  String? ageGroup, @JsonKey(name: 'skill_level')  String? skillLevel,  int capacity, @JsonKey(name: 'active_enrollments_count')  int activeEnrollmentsCount, @JsonKey(name: 'available_spots')  int? availableSpots,  String status,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules)  $default,) {final _that = this;
switch (_that) {
case _ActivityBatchModel():
return $default(_that.id,_that.activityId,_that.instructorId,_that.name,_that.description,_that.ageGroup,_that.skillLevel,_that.capacity,_that.activeEnrollmentsCount,_that.availableSpots,_that.status,_that.instructor,_that.schedules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'activity_id')  String activityId, @JsonKey(name: 'instructor_id')  String? instructorId,  String name,  String? description, @JsonKey(name: 'age_group')  String? ageGroup, @JsonKey(name: 'skill_level')  String? skillLevel,  int capacity, @JsonKey(name: 'active_enrollments_count')  int activeEnrollmentsCount, @JsonKey(name: 'available_spots')  int? availableSpots,  String status,  ActivityInstructorModel? instructor,  List<ActivityScheduleModel> schedules)?  $default,) {final _that = this;
switch (_that) {
case _ActivityBatchModel() when $default != null:
return $default(_that.id,_that.activityId,_that.instructorId,_that.name,_that.description,_that.ageGroup,_that.skillLevel,_that.capacity,_that.activeEnrollmentsCount,_that.availableSpots,_that.status,_that.instructor,_that.schedules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityBatchModel implements ActivityBatchModel {
  const _ActivityBatchModel({required this.id, @JsonKey(name: 'activity_id') required this.activityId, @JsonKey(name: 'instructor_id') this.instructorId, required this.name, this.description, @JsonKey(name: 'age_group') this.ageGroup, @JsonKey(name: 'skill_level') this.skillLevel, this.capacity = 0, @JsonKey(name: 'active_enrollments_count') this.activeEnrollmentsCount = 0, @JsonKey(name: 'available_spots') this.availableSpots, this.status = 'active', this.instructor, final  List<ActivityScheduleModel> schedules = const []}): _schedules = schedules;
  factory _ActivityBatchModel.fromJson(Map<String, dynamic> json) => _$ActivityBatchModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'activity_id') final  String activityId;
@override@JsonKey(name: 'instructor_id') final  String? instructorId;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'age_group') final  String? ageGroup;
@override@JsonKey(name: 'skill_level') final  String? skillLevel;
@override@JsonKey() final  int capacity;
@override@JsonKey(name: 'active_enrollments_count') final  int activeEnrollmentsCount;
@override@JsonKey(name: 'available_spots') final  int? availableSpots;
@override@JsonKey() final  String status;
@override final  ActivityInstructorModel? instructor;
 final  List<ActivityScheduleModel> _schedules;
@override@JsonKey() List<ActivityScheduleModel> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}


/// Create a copy of ActivityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityBatchModelCopyWith<_ActivityBatchModel> get copyWith => __$ActivityBatchModelCopyWithImpl<_ActivityBatchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityBatchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityBatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.activeEnrollmentsCount, activeEnrollmentsCount) || other.activeEnrollmentsCount == activeEnrollmentsCount)&&(identical(other.availableSpots, availableSpots) || other.availableSpots == availableSpots)&&(identical(other.status, status) || other.status == status)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&const DeepCollectionEquality().equals(other._schedules, _schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,activityId,instructorId,name,description,ageGroup,skillLevel,capacity,activeEnrollmentsCount,availableSpots,status,instructor,const DeepCollectionEquality().hash(_schedules));

@override
String toString() {
  return 'ActivityBatchModel(id: $id, activityId: $activityId, instructorId: $instructorId, name: $name, description: $description, ageGroup: $ageGroup, skillLevel: $skillLevel, capacity: $capacity, activeEnrollmentsCount: $activeEnrollmentsCount, availableSpots: $availableSpots, status: $status, instructor: $instructor, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class _$ActivityBatchModelCopyWith<$Res> implements $ActivityBatchModelCopyWith<$Res> {
  factory _$ActivityBatchModelCopyWith(_ActivityBatchModel value, $Res Function(_ActivityBatchModel) _then) = __$ActivityBatchModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'activity_id') String activityId,@JsonKey(name: 'instructor_id') String? instructorId, String name, String? description,@JsonKey(name: 'age_group') String? ageGroup,@JsonKey(name: 'skill_level') String? skillLevel, int capacity,@JsonKey(name: 'active_enrollments_count') int activeEnrollmentsCount,@JsonKey(name: 'available_spots') int? availableSpots, String status, ActivityInstructorModel? instructor, List<ActivityScheduleModel> schedules
});


@override $ActivityInstructorModelCopyWith<$Res>? get instructor;

}
/// @nodoc
class __$ActivityBatchModelCopyWithImpl<$Res>
    implements _$ActivityBatchModelCopyWith<$Res> {
  __$ActivityBatchModelCopyWithImpl(this._self, this._then);

  final _ActivityBatchModel _self;
  final $Res Function(_ActivityBatchModel) _then;

/// Create a copy of ActivityBatchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? activityId = null,Object? instructorId = freezed,Object? name = null,Object? description = freezed,Object? ageGroup = freezed,Object? skillLevel = freezed,Object? capacity = null,Object? activeEnrollmentsCount = null,Object? availableSpots = freezed,Object? status = null,Object? instructor = freezed,Object? schedules = null,}) {
  return _then(_ActivityBatchModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String?,skillLevel: freezed == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,activeEnrollmentsCount: null == activeEnrollmentsCount ? _self.activeEnrollmentsCount : activeEnrollmentsCount // ignore: cast_nullable_to_non_nullable
as int,availableSpots: freezed == availableSpots ? _self.availableSpots : availableSpots // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,instructor: freezed == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as ActivityInstructorModel?,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ActivityScheduleModel>,
  ));
}

/// Create a copy of ActivityBatchModel
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
