import 'package:freezed_annotation/freezed_annotation.dart';

import 'facility_member_model.dart';
import 'facility_model.dart';

part 'gym_attendance_model.freezed.dart';
part 'gym_attendance_model.g.dart';

@freezed
abstract class GymAttendanceModel with _$GymAttendanceModel {
  const GymAttendanceModel._();

  const factory GymAttendanceModel({
    required String id,
    @JsonKey(name: 'gym_id') String? gymId,
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'check_in_at') DateTime? checkInAt,
    @JsonKey(name: 'check_out_at') DateTime? checkOutAt,
    int? duration,
    DateTime? date,
    FacilityModel? gym,
    FacilityMemberModel? member,
  }) = _GymAttendanceModel;

  factory GymAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$GymAttendanceModelFromJson(json);

  bool get isOpenSession => checkInAt != null && checkOutAt == null;

  /// `duration` is stored in seconds by the API.
  String? get formattedDuration {
    final int? seconds = duration;
    if (seconds == null || seconds <= 0) return null;
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }
}
