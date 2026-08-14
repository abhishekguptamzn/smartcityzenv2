import 'package:freezed_annotation/freezed_annotation.dart';

import 'fee_plan_model.dart';
import 'payment_model.dart';

part 'membership_renewal_model.freezed.dart';
part 'membership_renewal_model.g.dart';

@freezed
abstract class MembershipRenewalModel with _$MembershipRenewalModel {
  const factory MembershipRenewalModel({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'membership_type') String? membershipType,
    @JsonKey(name: 'membership_id') String? membershipId,
    @JsonKey(name: 'fee_plan_id') String? feePlanId,
    @JsonKey(name: 'payment_id') String? paymentId,
    @JsonKey(name: 'previous_end_date') DateTime? previousEndDate,
    @JsonKey(name: 'new_end_date') DateTime? newEndDate,
    @JsonKey(name: 'extended_interval') String? extendedInterval,
    @JsonKey(name: 'extended_count') @Default(1) int extendedCount,
    @JsonKey(name: 'amount_paid', fromJson: _toDouble)
    @Default(0)
    double amountPaid,
    @Default('INR') String currency,
    String? notes,
    @JsonKey(name: 'fee_plan') FeePlanModel? feePlan,
    PaymentModel? payment,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MembershipRenewalModel;

  factory MembershipRenewalModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipRenewalModelFromJson(json);
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
