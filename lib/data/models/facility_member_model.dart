import 'package:freezed_annotation/freezed_annotation.dart';

import 'facility_model.dart';
import 'user_model.dart';

part 'facility_member_model.freezed.dart';
part 'facility_member_model.g.dart';

@freezed
abstract class FacilityMemberModel with _$FacilityMemberModel {
  const FacilityMemberModel._();

  const factory FacilityMemberModel({
    required String id,
    @JsonKey(name: 'facility_id') String? facilityId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'membership_type') String? membershipType,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @Default('active') String status,
    UserModel? user,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(FacilityKind.library)
    FacilityKind facilityKind,
  }) = _FacilityMemberModel;

  factory FacilityMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityMemberModelFromJson(json);

  /// The API returns the owning facility under `library_id` on library members,
  /// `gym_id` on gym members, and `activity_id` on activity enrollments, so all keys
  /// are normalised to `facility_id` before the generated deserializer runs.
  factory FacilityMemberModel.fromApiJson(
    Map<String, dynamic> json, {
    FacilityKind? kind,
  }) {
    final Map<String, dynamic> normalised = Map<String, dynamic>.from(json);
    final Object? facilityId =
        json['facility_id'] ?? json['library_id'] ?? json['gym_id'] ?? json['activity_id'];
    normalised['facility_id'] = facilityId?.toString();
    if (json.containsKey('enrollment_type') && !json.containsKey('membership_type')) {
      normalised['membership_type'] = json['enrollment_type'];
    }

    final FacilityKind resolvedKind =
        kind ??
        (json.containsKey('gym_id') || json.containsKey('gym')
            ? FacilityKind.gym
            : (json.containsKey('activity_id') || json.containsKey('activity')
                ? FacilityKind.activity
                : FacilityKind.library));

    return FacilityMemberModel.fromJson(
      normalised,
    ).copyWith(facilityKind: resolvedKind);
  }

  bool get isActive => status == 'active';

  bool get isExpired {
    final DateTime? end = endDate;
    if (end == null) return false;
    return end.isBefore(DateTime.now());
  }
}
