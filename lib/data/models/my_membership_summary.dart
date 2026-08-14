import 'package:freezed_annotation/freezed_annotation.dart';

import 'facility_model.dart';

part 'my_membership_summary.freezed.dart';

/// See the top-of-file comment in `FacilitiesRepository` for why this exists:
/// there is no API endpoint to list a customer's own memberships, so this is
/// derived purely from payment history and intentionally carries nothing
/// more than a payment record already gives us.
@freezed
abstract class MyMembershipSummary with _$MyMembershipSummary {
  const factory MyMembershipSummary({
    required FacilityKind kind,
    required String payableId,
    required DateTime? latestPaidAt,
    required double amount,
    required String currency,
  }) = _MyMembershipSummary;
}
