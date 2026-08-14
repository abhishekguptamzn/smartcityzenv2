import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
abstract class TicketModel with _$TicketModel {
  const TicketModel._();

  const factory TicketModel({
    required int id,
    @JsonKey(name: 'ticket_number') required String ticketNumber,
    @JsonKey(name: 'user_id') required String userId,
    required String subject,
    @Default('general') String category,
    @Default('medium') String priority,
    @Default('open') String status,
    @Default([]) List<TicketMessageModel> messages,
    @JsonKey(name: 'latest_message') TicketMessageModel? latestMessage,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  bool get isOpen => status == 'open';
  bool get isInProgress => status == 'in_progress';
  bool get isWaitingUser => status == 'waiting_user';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';
}

@freezed
abstract class TicketMessageModel with _$TicketMessageModel {
  const TicketMessageModel._();

  const factory TicketMessageModel({
    required int id,
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'sender_type') @Default('citizen') String senderType,
    required String message,
    UserModel? user,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _TicketMessageModel;

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TicketMessageModelFromJson(json);

  bool get isAdmin => senderType == 'admin';
  bool get isCitizen => senderType == 'citizen';
}
