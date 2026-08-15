import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/image_url_resolver.dart';
import 'city_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? dob,
    String? gender,
    @JsonKey(name: 'city_id') String? cityId,
    CityModel? city,
    String? locality,
    String? address,
    String? pincode,
    String? landmark,
    String? profession,
    String? company,
    @JsonKey(name: 'work_experience') String? workExperience,
    String? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? interests,
    String? bio,
    List<String>? hobbies,
    @JsonKey(name: 'profile_visibility') @Default('public') String profileVisibility,
    @JsonKey(name: 'profile_completion_percentage') @Default(0) int profileCompletionPercentage,
    @Default('customer') String role,
    @Default('active') String status,
    String? avatar,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'custom_permissions') List<String>? customPermissions,
    @JsonKey(name: 'is_onboarding_user') @Default(false) bool isOnboardingUser,
    @JsonKey(name: 'is_client_user') @Default(false) bool isClientUser,
    @JsonKey(name: 'owned_facilities') Map<String, dynamic>? ownedFacilities,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  bool get isStaff => role == 'admin' || role == 'manager' || role == 'staff';

  bool get isActive => status == 'active';

  /// Synthetic, display-only citizen number. The API has no such field, so it
  /// is derived from the user id purely for the ID card visual.
  String get displayCitizenId {
    final String compact = id.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    final String tail = compact.length <= 6
        ? compact
        : compact.substring(compact.length - 6);
    return 'CID-${tail.toUpperCase()}';
  }

  String get initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String? get effectiveAvatarUrl {
    final url = photoUrl ?? avatar;
    return ImageUrlResolver.resolve(url);
  }
}
