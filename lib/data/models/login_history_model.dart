import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'login_history_model.freezed.dart';
part 'login_history_model.g.dart';

@freezed
abstract class LoginHistoryModel with _$LoginHistoryModel {
  const LoginHistoryModel._();

  const factory LoginHistoryModel({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    String? email,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
    @JsonKey(name: 'device_type') String? deviceType,
    String? browser,
    String? platform,
    String? location,
    @Default('success') String status,
    @JsonKey(name: 'failure_reason') String? failureReason,
    @JsonKey(name: 'is_suspicious') @Default(false) bool isSuspicious,
    @JsonKey(name: 'flagged_reason') String? flaggedReason,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    UserModel? user,
  }) = _LoginHistoryModel;

  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$LoginHistoryModelFromJson(json);

  bool get isSuccess => status == 'success';
}
