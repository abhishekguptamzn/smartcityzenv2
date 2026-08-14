import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
abstract class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'payable_type') String? payableType,
    @JsonKey(name: 'payable_id') String? payableId,
    @JsonKey(fromJson: _toDouble) @Default(0) double amount,
    @Default('INR') String currency,
    @Default('pending') String status,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'transaction_reference') String? transactionReference,
    @JsonKey(name: 'invoice_number') String? invoiceNumber,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    String? notes,
    UserModel? user,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  bool get isPaid => status == 'paid';

  bool get isMembershipPayment =>
      payableType == 'LibraryMember' || payableType == 'GymMember';
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
