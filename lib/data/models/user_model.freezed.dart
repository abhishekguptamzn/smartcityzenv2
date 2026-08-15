// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get name; String get email; String? get phone; String? get dob; String? get gender;@JsonKey(name: 'city_id') String? get cityId; CityModel? get city; String? get locality; String? get address; String? get pincode; String? get landmark; String? get profession; String? get company;@JsonKey(name: 'work_experience') String? get workExperience; String? get education; List<String>? get skills; List<String>? get languages; List<String>? get interests; String? get bio; List<String>? get hobbies;@JsonKey(name: 'profile_visibility') String get profileVisibility;@JsonKey(name: 'profile_completion_percentage') int get profileCompletionPercentage; String get role; String get status; String? get avatar;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'custom_permissions') List<String>? get customPermissions;@JsonKey(name: 'is_onboarding_user') bool get isOnboardingUser;@JsonKey(name: 'is_client_user') bool get isClientUser;@JsonKey(name: 'owned_facilities') Map<String, dynamic>? get ownedFacilities;@JsonKey(name: 'email_verified_at') DateTime? get emailVerifiedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.city, city) || other.city == city)&&(identical(other.locality, locality) || other.locality == locality)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.landmark, landmark) || other.landmark == landmark)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.company, company) || other.company == company)&&(identical(other.workExperience, workExperience) || other.workExperience == workExperience)&&(identical(other.education, education) || other.education == education)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.hobbies, hobbies)&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.profileCompletionPercentage, profileCompletionPercentage) || other.profileCompletionPercentage == profileCompletionPercentage)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other.customPermissions, customPermissions)&&(identical(other.isOnboardingUser, isOnboardingUser) || other.isOnboardingUser == isOnboardingUser)&&(identical(other.isClientUser, isClientUser) || other.isClientUser == isClientUser)&&const DeepCollectionEquality().equals(other.ownedFacilities, ownedFacilities)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,email,phone,dob,gender,cityId,city,locality,address,pincode,landmark,profession,company,workExperience,education,const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(interests),bio,const DeepCollectionEquality().hash(hobbies),profileVisibility,profileCompletionPercentage,role,status,avatar,photoUrl,const DeepCollectionEquality().hash(customPermissions),isOnboardingUser,isClientUser,const DeepCollectionEquality().hash(ownedFacilities),emailVerifiedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, dob: $dob, gender: $gender, cityId: $cityId, city: $city, locality: $locality, address: $address, pincode: $pincode, landmark: $landmark, profession: $profession, company: $company, workExperience: $workExperience, education: $education, skills: $skills, languages: $languages, interests: $interests, bio: $bio, hobbies: $hobbies, profileVisibility: $profileVisibility, profileCompletionPercentage: $profileCompletionPercentage, role: $role, status: $status, avatar: $avatar, photoUrl: $photoUrl, customPermissions: $customPermissions, isOnboardingUser: $isOnboardingUser, isClientUser: $isClientUser, ownedFacilities: $ownedFacilities, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String? phone, String? dob, String? gender,@JsonKey(name: 'city_id') String? cityId, CityModel? city, String? locality, String? address, String? pincode, String? landmark, String? profession, String? company,@JsonKey(name: 'work_experience') String? workExperience, String? education, List<String>? skills, List<String>? languages, List<String>? interests, String? bio, List<String>? hobbies,@JsonKey(name: 'profile_visibility') String profileVisibility,@JsonKey(name: 'profile_completion_percentage') int profileCompletionPercentage, String role, String status, String? avatar,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'custom_permissions') List<String>? customPermissions,@JsonKey(name: 'is_onboarding_user') bool isOnboardingUser,@JsonKey(name: 'is_client_user') bool isClientUser,@JsonKey(name: 'owned_facilities') Map<String, dynamic>? ownedFacilities,@JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


$CityModelCopyWith<$Res>? get city;

}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? dob = freezed,Object? gender = freezed,Object? cityId = freezed,Object? city = freezed,Object? locality = freezed,Object? address = freezed,Object? pincode = freezed,Object? landmark = freezed,Object? profession = freezed,Object? company = freezed,Object? workExperience = freezed,Object? education = freezed,Object? skills = freezed,Object? languages = freezed,Object? interests = freezed,Object? bio = freezed,Object? hobbies = freezed,Object? profileVisibility = null,Object? profileCompletionPercentage = null,Object? role = null,Object? status = null,Object? avatar = freezed,Object? photoUrl = freezed,Object? customPermissions = freezed,Object? isOnboardingUser = null,Object? isClientUser = null,Object? ownedFacilities = freezed,Object? emailVerifiedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,locality: freezed == locality ? _self.locality : locality // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,landmark: freezed == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,workExperience: freezed == workExperience ? _self.workExperience : workExperience // ignore: cast_nullable_to_non_nullable
as String?,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,skills: freezed == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,hobbies: freezed == hobbies ? _self.hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>?,profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as String,profileCompletionPercentage: null == profileCompletionPercentage ? _self.profileCompletionPercentage : profileCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,customPermissions: freezed == customPermissions ? _self.customPermissions : customPermissions // ignore: cast_nullable_to_non_nullable
as List<String>?,isOnboardingUser: null == isOnboardingUser ? _self.isOnboardingUser : isOnboardingUser // ignore: cast_nullable_to_non_nullable
as bool,isClientUser: null == isClientUser ? _self.isClientUser : isClientUser // ignore: cast_nullable_to_non_nullable
as bool,ownedFacilities: freezed == ownedFacilities ? _self.ownedFacilities : ownedFacilities // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityModelCopyWith<$Res>? get city {
    if (_self.city == null) {
    return null;
  }

  return $CityModelCopyWith<$Res>(_self.city!, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String? phone,  String? dob,  String? gender, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city,  String? locality,  String? address,  String? pincode,  String? landmark,  String? profession,  String? company, @JsonKey(name: 'work_experience')  String? workExperience,  String? education,  List<String>? skills,  List<String>? languages,  List<String>? interests,  String? bio,  List<String>? hobbies, @JsonKey(name: 'profile_visibility')  String profileVisibility, @JsonKey(name: 'profile_completion_percentage')  int profileCompletionPercentage,  String role,  String status,  String? avatar, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'custom_permissions')  List<String>? customPermissions, @JsonKey(name: 'is_onboarding_user')  bool isOnboardingUser, @JsonKey(name: 'is_client_user')  bool isClientUser, @JsonKey(name: 'owned_facilities')  Map<String, dynamic>? ownedFacilities, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.dob,_that.gender,_that.cityId,_that.city,_that.locality,_that.address,_that.pincode,_that.landmark,_that.profession,_that.company,_that.workExperience,_that.education,_that.skills,_that.languages,_that.interests,_that.bio,_that.hobbies,_that.profileVisibility,_that.profileCompletionPercentage,_that.role,_that.status,_that.avatar,_that.photoUrl,_that.customPermissions,_that.isOnboardingUser,_that.isClientUser,_that.ownedFacilities,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String? phone,  String? dob,  String? gender, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city,  String? locality,  String? address,  String? pincode,  String? landmark,  String? profession,  String? company, @JsonKey(name: 'work_experience')  String? workExperience,  String? education,  List<String>? skills,  List<String>? languages,  List<String>? interests,  String? bio,  List<String>? hobbies, @JsonKey(name: 'profile_visibility')  String profileVisibility, @JsonKey(name: 'profile_completion_percentage')  int profileCompletionPercentage,  String role,  String status,  String? avatar, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'custom_permissions')  List<String>? customPermissions, @JsonKey(name: 'is_onboarding_user')  bool isOnboardingUser, @JsonKey(name: 'is_client_user')  bool isClientUser, @JsonKey(name: 'owned_facilities')  Map<String, dynamic>? ownedFacilities, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.dob,_that.gender,_that.cityId,_that.city,_that.locality,_that.address,_that.pincode,_that.landmark,_that.profession,_that.company,_that.workExperience,_that.education,_that.skills,_that.languages,_that.interests,_that.bio,_that.hobbies,_that.profileVisibility,_that.profileCompletionPercentage,_that.role,_that.status,_that.avatar,_that.photoUrl,_that.customPermissions,_that.isOnboardingUser,_that.isClientUser,_that.ownedFacilities,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String? phone,  String? dob,  String? gender, @JsonKey(name: 'city_id')  String? cityId,  CityModel? city,  String? locality,  String? address,  String? pincode,  String? landmark,  String? profession,  String? company, @JsonKey(name: 'work_experience')  String? workExperience,  String? education,  List<String>? skills,  List<String>? languages,  List<String>? interests,  String? bio,  List<String>? hobbies, @JsonKey(name: 'profile_visibility')  String profileVisibility, @JsonKey(name: 'profile_completion_percentage')  int profileCompletionPercentage,  String role,  String status,  String? avatar, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'custom_permissions')  List<String>? customPermissions, @JsonKey(name: 'is_onboarding_user')  bool isOnboardingUser, @JsonKey(name: 'is_client_user')  bool isClientUser, @JsonKey(name: 'owned_facilities')  Map<String, dynamic>? ownedFacilities, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.dob,_that.gender,_that.cityId,_that.city,_that.locality,_that.address,_that.pincode,_that.landmark,_that.profession,_that.company,_that.workExperience,_that.education,_that.skills,_that.languages,_that.interests,_that.bio,_that.hobbies,_that.profileVisibility,_that.profileCompletionPercentage,_that.role,_that.status,_that.avatar,_that.photoUrl,_that.customPermissions,_that.isOnboardingUser,_that.isClientUser,_that.ownedFacilities,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.name, required this.email, this.phone, this.dob, this.gender, @JsonKey(name: 'city_id') this.cityId, this.city, this.locality, this.address, this.pincode, this.landmark, this.profession, this.company, @JsonKey(name: 'work_experience') this.workExperience, this.education, final  List<String>? skills, final  List<String>? languages, final  List<String>? interests, this.bio, final  List<String>? hobbies, @JsonKey(name: 'profile_visibility') this.profileVisibility = 'public', @JsonKey(name: 'profile_completion_percentage') this.profileCompletionPercentage = 0, this.role = 'customer', this.status = 'active', this.avatar, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'custom_permissions') final  List<String>? customPermissions, @JsonKey(name: 'is_onboarding_user') this.isOnboardingUser = false, @JsonKey(name: 'is_client_user') this.isClientUser = false, @JsonKey(name: 'owned_facilities') final  Map<String, dynamic>? ownedFacilities, @JsonKey(name: 'email_verified_at') this.emailVerifiedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _skills = skills,_languages = languages,_interests = interests,_hobbies = hobbies,_customPermissions = customPermissions,_ownedFacilities = ownedFacilities,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String? phone;
@override final  String? dob;
@override final  String? gender;
@override@JsonKey(name: 'city_id') final  String? cityId;
@override final  CityModel? city;
@override final  String? locality;
@override final  String? address;
@override final  String? pincode;
@override final  String? landmark;
@override final  String? profession;
@override final  String? company;
@override@JsonKey(name: 'work_experience') final  String? workExperience;
@override final  String? education;
 final  List<String>? _skills;
@override List<String>? get skills {
  final value = _skills;
  if (value == null) return null;
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _languages;
@override List<String>? get languages {
  final value = _languages;
  if (value == null) return null;
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _interests;
@override List<String>? get interests {
  final value = _interests;
  if (value == null) return null;
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? bio;
 final  List<String>? _hobbies;
@override List<String>? get hobbies {
  final value = _hobbies;
  if (value == null) return null;
  if (_hobbies is EqualUnmodifiableListView) return _hobbies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'profile_visibility') final  String profileVisibility;
@override@JsonKey(name: 'profile_completion_percentage') final  int profileCompletionPercentage;
@override@JsonKey() final  String role;
@override@JsonKey() final  String status;
@override final  String? avatar;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
 final  List<String>? _customPermissions;
@override@JsonKey(name: 'custom_permissions') List<String>? get customPermissions {
  final value = _customPermissions;
  if (value == null) return null;
  if (_customPermissions is EqualUnmodifiableListView) return _customPermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'is_onboarding_user') final  bool isOnboardingUser;
@override@JsonKey(name: 'is_client_user') final  bool isClientUser;
 final  Map<String, dynamic>? _ownedFacilities;
@override@JsonKey(name: 'owned_facilities') Map<String, dynamic>? get ownedFacilities {
  final value = _ownedFacilities;
  if (value == null) return null;
  if (_ownedFacilities is EqualUnmodifiableMapView) return _ownedFacilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'email_verified_at') final  DateTime? emailVerifiedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.city, city) || other.city == city)&&(identical(other.locality, locality) || other.locality == locality)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.landmark, landmark) || other.landmark == landmark)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.company, company) || other.company == company)&&(identical(other.workExperience, workExperience) || other.workExperience == workExperience)&&(identical(other.education, education) || other.education == education)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._hobbies, _hobbies)&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.profileCompletionPercentage, profileCompletionPercentage) || other.profileCompletionPercentage == profileCompletionPercentage)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other._customPermissions, _customPermissions)&&(identical(other.isOnboardingUser, isOnboardingUser) || other.isOnboardingUser == isOnboardingUser)&&(identical(other.isClientUser, isClientUser) || other.isClientUser == isClientUser)&&const DeepCollectionEquality().equals(other._ownedFacilities, _ownedFacilities)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,email,phone,dob,gender,cityId,city,locality,address,pincode,landmark,profession,company,workExperience,education,const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_interests),bio,const DeepCollectionEquality().hash(_hobbies),profileVisibility,profileCompletionPercentage,role,status,avatar,photoUrl,const DeepCollectionEquality().hash(_customPermissions),isOnboardingUser,isClientUser,const DeepCollectionEquality().hash(_ownedFacilities),emailVerifiedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, dob: $dob, gender: $gender, cityId: $cityId, city: $city, locality: $locality, address: $address, pincode: $pincode, landmark: $landmark, profession: $profession, company: $company, workExperience: $workExperience, education: $education, skills: $skills, languages: $languages, interests: $interests, bio: $bio, hobbies: $hobbies, profileVisibility: $profileVisibility, profileCompletionPercentage: $profileCompletionPercentage, role: $role, status: $status, avatar: $avatar, photoUrl: $photoUrl, customPermissions: $customPermissions, isOnboardingUser: $isOnboardingUser, isClientUser: $isClientUser, ownedFacilities: $ownedFacilities, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String? phone, String? dob, String? gender,@JsonKey(name: 'city_id') String? cityId, CityModel? city, String? locality, String? address, String? pincode, String? landmark, String? profession, String? company,@JsonKey(name: 'work_experience') String? workExperience, String? education, List<String>? skills, List<String>? languages, List<String>? interests, String? bio, List<String>? hobbies,@JsonKey(name: 'profile_visibility') String profileVisibility,@JsonKey(name: 'profile_completion_percentage') int profileCompletionPercentage, String role, String status, String? avatar,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'custom_permissions') List<String>? customPermissions,@JsonKey(name: 'is_onboarding_user') bool isOnboardingUser,@JsonKey(name: 'is_client_user') bool isClientUser,@JsonKey(name: 'owned_facilities') Map<String, dynamic>? ownedFacilities,@JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


@override $CityModelCopyWith<$Res>? get city;

}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? dob = freezed,Object? gender = freezed,Object? cityId = freezed,Object? city = freezed,Object? locality = freezed,Object? address = freezed,Object? pincode = freezed,Object? landmark = freezed,Object? profession = freezed,Object? company = freezed,Object? workExperience = freezed,Object? education = freezed,Object? skills = freezed,Object? languages = freezed,Object? interests = freezed,Object? bio = freezed,Object? hobbies = freezed,Object? profileVisibility = null,Object? profileCompletionPercentage = null,Object? role = null,Object? status = null,Object? avatar = freezed,Object? photoUrl = freezed,Object? customPermissions = freezed,Object? isOnboardingUser = null,Object? isClientUser = null,Object? ownedFacilities = freezed,Object? emailVerifiedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityModel?,locality: freezed == locality ? _self.locality : locality // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,landmark: freezed == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,workExperience: freezed == workExperience ? _self.workExperience : workExperience // ignore: cast_nullable_to_non_nullable
as String?,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,skills: freezed == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>?,languages: freezed == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>?,interests: freezed == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,hobbies: freezed == hobbies ? _self._hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>?,profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as String,profileCompletionPercentage: null == profileCompletionPercentage ? _self.profileCompletionPercentage : profileCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,customPermissions: freezed == customPermissions ? _self._customPermissions : customPermissions // ignore: cast_nullable_to_non_nullable
as List<String>?,isOnboardingUser: null == isOnboardingUser ? _self.isOnboardingUser : isOnboardingUser // ignore: cast_nullable_to_non_nullable
as bool,isClientUser: null == isClientUser ? _self.isClientUser : isClientUser // ignore: cast_nullable_to_non_nullable
as bool,ownedFacilities: freezed == ownedFacilities ? _self._ownedFacilities : ownedFacilities // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityModelCopyWith<$Res>? get city {
    if (_self.city == null) {
    return null;
  }

  return $CityModelCopyWith<$Res>(_self.city!, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}

// dart format on
