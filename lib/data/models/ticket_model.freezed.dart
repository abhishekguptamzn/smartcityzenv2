// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TicketModel {

 int get id;@JsonKey(name: 'ticket_number') String get ticketNumber;@JsonKey(name: 'user_id') String get userId; String get subject; String get category; String get priority; String get status; List<TicketMessageModel> get messages;@JsonKey(name: 'latest_message') TicketMessageModel? get latestMessage;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketModelCopyWith<TicketModel> get copyWith => _$TicketModelCopyWithImpl<TicketModel>(this as TicketModel, _$identity);

  /// Serializes this TicketModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,userId,subject,category,priority,status,const DeepCollectionEquality().hash(messages),latestMessage,createdAt,updatedAt);

@override
String toString() {
  return 'TicketModel(id: $id, ticketNumber: $ticketNumber, userId: $userId, subject: $subject, category: $category, priority: $priority, status: $status, messages: $messages, latestMessage: $latestMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TicketModelCopyWith<$Res>  {
  factory $TicketModelCopyWith(TicketModel value, $Res Function(TicketModel) _then) = _$TicketModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'ticket_number') String ticketNumber,@JsonKey(name: 'user_id') String userId, String subject, String category, String priority, String status, List<TicketMessageModel> messages,@JsonKey(name: 'latest_message') TicketMessageModel? latestMessage,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});


$TicketMessageModelCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class _$TicketModelCopyWithImpl<$Res>
    implements $TicketModelCopyWith<$Res> {
  _$TicketModelCopyWithImpl(this._self, this._then);

  final TicketModel _self;
  final $Res Function(TicketModel) _then;

/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ticketNumber = null,Object? userId = null,Object? subject = null,Object? category = null,Object? priority = null,Object? status = null,Object? messages = null,Object? latestMessage = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<TicketMessageModel>,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as TicketMessageModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketMessageModelCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $TicketMessageModelCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketModel].
extension TicketModelPatterns on TicketModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketModel value)  $default,){
final _that = this;
switch (_that) {
case _TicketModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketModel value)?  $default,){
final _that = this;
switch (_that) {
case _TicketModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'ticket_number')  String ticketNumber, @JsonKey(name: 'user_id')  String userId,  String subject,  String category,  String priority,  String status,  List<TicketMessageModel> messages, @JsonKey(name: 'latest_message')  TicketMessageModel? latestMessage, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.userId,_that.subject,_that.category,_that.priority,_that.status,_that.messages,_that.latestMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'ticket_number')  String ticketNumber, @JsonKey(name: 'user_id')  String userId,  String subject,  String category,  String priority,  String status,  List<TicketMessageModel> messages, @JsonKey(name: 'latest_message')  TicketMessageModel? latestMessage, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TicketModel():
return $default(_that.id,_that.ticketNumber,_that.userId,_that.subject,_that.category,_that.priority,_that.status,_that.messages,_that.latestMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'ticket_number')  String ticketNumber, @JsonKey(name: 'user_id')  String userId,  String subject,  String category,  String priority,  String status,  List<TicketMessageModel> messages, @JsonKey(name: 'latest_message')  TicketMessageModel? latestMessage, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TicketModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.userId,_that.subject,_that.category,_that.priority,_that.status,_that.messages,_that.latestMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketModel extends TicketModel {
  const _TicketModel({required this.id, @JsonKey(name: 'ticket_number') required this.ticketNumber, @JsonKey(name: 'user_id') required this.userId, required this.subject, this.category = 'general', this.priority = 'medium', this.status = 'open', final  List<TicketMessageModel> messages = const [], @JsonKey(name: 'latest_message') this.latestMessage, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _messages = messages,super._();
  factory _TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'ticket_number') final  String ticketNumber;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String subject;
@override@JsonKey() final  String category;
@override@JsonKey() final  String priority;
@override@JsonKey() final  String status;
 final  List<TicketMessageModel> _messages;
@override@JsonKey() List<TicketMessageModel> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey(name: 'latest_message') final  TicketMessageModel? latestMessage;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketModelCopyWith<_TicketModel> get copyWith => __$TicketModelCopyWithImpl<_TicketModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,userId,subject,category,priority,status,const DeepCollectionEquality().hash(_messages),latestMessage,createdAt,updatedAt);

@override
String toString() {
  return 'TicketModel(id: $id, ticketNumber: $ticketNumber, userId: $userId, subject: $subject, category: $category, priority: $priority, status: $status, messages: $messages, latestMessage: $latestMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TicketModelCopyWith<$Res> implements $TicketModelCopyWith<$Res> {
  factory _$TicketModelCopyWith(_TicketModel value, $Res Function(_TicketModel) _then) = __$TicketModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'ticket_number') String ticketNumber,@JsonKey(name: 'user_id') String userId, String subject, String category, String priority, String status, List<TicketMessageModel> messages,@JsonKey(name: 'latest_message') TicketMessageModel? latestMessage,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});


@override $TicketMessageModelCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class __$TicketModelCopyWithImpl<$Res>
    implements _$TicketModelCopyWith<$Res> {
  __$TicketModelCopyWithImpl(this._self, this._then);

  final _TicketModel _self;
  final $Res Function(_TicketModel) _then;

/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketNumber = null,Object? userId = null,Object? subject = null,Object? category = null,Object? priority = null,Object? status = null,Object? messages = null,Object? latestMessage = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TicketModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<TicketMessageModel>,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as TicketMessageModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TicketModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketMessageModelCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $TicketMessageModelCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}


/// @nodoc
mixin _$TicketMessageModel {

 int get id;@JsonKey(name: 'ticket_id') int get ticketId;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'sender_type') String get senderType; String get message; UserModel? get user;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of TicketMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketMessageModelCopyWith<TicketMessageModel> get copyWith => _$TicketMessageModelCopyWithImpl<TicketMessageModel>(this as TicketMessageModel, _$identity);

  /// Serializes this TicketMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.senderType, senderType) || other.senderType == senderType)&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketId,userId,senderType,message,user,createdAt,updatedAt);

@override
String toString() {
  return 'TicketMessageModel(id: $id, ticketId: $ticketId, userId: $userId, senderType: $senderType, message: $message, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TicketMessageModelCopyWith<$Res>  {
  factory $TicketMessageModelCopyWith(TicketMessageModel value, $Res Function(TicketMessageModel) _then) = _$TicketMessageModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'ticket_id') int ticketId,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'sender_type') String senderType, String message, UserModel? user,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$TicketMessageModelCopyWithImpl<$Res>
    implements $TicketMessageModelCopyWith<$Res> {
  _$TicketMessageModelCopyWithImpl(this._self, this._then);

  final TicketMessageModel _self;
  final $Res Function(TicketMessageModel) _then;

/// Create a copy of TicketMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ticketId = null,Object? userId = freezed,Object? senderType = null,Object? message = null,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,senderType: null == senderType ? _self.senderType : senderType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TicketMessageModel
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


/// Adds pattern-matching-related methods to [TicketMessageModel].
extension TicketMessageModelPatterns on TicketMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _TicketMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _TicketMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'ticket_id')  int ticketId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'sender_type')  String senderType,  String message,  UserModel? user, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketMessageModel() when $default != null:
return $default(_that.id,_that.ticketId,_that.userId,_that.senderType,_that.message,_that.user,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'ticket_id')  int ticketId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'sender_type')  String senderType,  String message,  UserModel? user, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TicketMessageModel():
return $default(_that.id,_that.ticketId,_that.userId,_that.senderType,_that.message,_that.user,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'ticket_id')  int ticketId, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'sender_type')  String senderType,  String message,  UserModel? user, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TicketMessageModel() when $default != null:
return $default(_that.id,_that.ticketId,_that.userId,_that.senderType,_that.message,_that.user,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketMessageModel extends TicketMessageModel {
  const _TicketMessageModel({required this.id, @JsonKey(name: 'ticket_id') required this.ticketId, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'sender_type') this.senderType = 'citizen', required this.message, this.user, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  factory _TicketMessageModel.fromJson(Map<String, dynamic> json) => _$TicketMessageModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'ticket_id') final  int ticketId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'sender_type') final  String senderType;
@override final  String message;
@override final  UserModel? user;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of TicketMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketMessageModelCopyWith<_TicketMessageModel> get copyWith => __$TicketMessageModelCopyWithImpl<_TicketMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.senderType, senderType) || other.senderType == senderType)&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketId,userId,senderType,message,user,createdAt,updatedAt);

@override
String toString() {
  return 'TicketMessageModel(id: $id, ticketId: $ticketId, userId: $userId, senderType: $senderType, message: $message, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TicketMessageModelCopyWith<$Res> implements $TicketMessageModelCopyWith<$Res> {
  factory _$TicketMessageModelCopyWith(_TicketMessageModel value, $Res Function(_TicketMessageModel) _then) = __$TicketMessageModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'ticket_id') int ticketId,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'sender_type') String senderType, String message, UserModel? user,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$TicketMessageModelCopyWithImpl<$Res>
    implements _$TicketMessageModelCopyWith<$Res> {
  __$TicketMessageModelCopyWithImpl(this._self, this._then);

  final _TicketMessageModel _self;
  final $Res Function(_TicketMessageModel) _then;

/// Create a copy of TicketMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketId = null,Object? userId = freezed,Object? senderType = null,Object? message = null,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TicketMessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,senderType: null == senderType ? _self.senderType : senderType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TicketMessageModel
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
