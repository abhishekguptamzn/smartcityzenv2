import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default('system') String type,
    required String title,
    required String message,
    @Default('normal') String priority,
    @JsonKey(name: 'action_type') String? actionType,
    @JsonKey(name: 'action_route') String? actionRoute,
    @JsonKey(name: 'action_label') String? actionLabel,
    @JsonKey(name: 'secondary_action_label') String? secondaryActionLabel,
    @JsonKey(name: 'secondary_action_route') String? secondaryActionRoute,
    Map<String, dynamic>? data,
    @JsonKey(name: 'read_at') String? readAt,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'action_taken_at') String? actionTakenAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_at_formatted') String? createdAtFormatted,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  bool get isUnread => !isRead && readAt == null;
  bool get hasAction => actionRoute != null && actionRoute!.isNotEmpty;
  bool get hasSecondaryAction =>
      secondaryActionRoute != null && secondaryActionRoute!.isNotEmpty;
  bool get isUrgent => priority == 'urgent' || priority == 'high';

  String get categoryGroup {
    switch (type) {
      case 'facility':
      case 'system':
      case 'announcement':
        return 'announcements';
      case 'checkin':
      case 'checkout':
      case 'membership':
      case 'payment':
      case 'ticket':
      case 'security':
        return 'alerts';
      default:
        return 'all';
    }
  }
}
