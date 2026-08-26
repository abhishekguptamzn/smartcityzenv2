import 'package:freezed_annotation/freezed_annotation.dart';

import 'facility_model.dart';

part 'my_membership_summary.freezed.dart';

@freezed
abstract class MyMembershipSummary with _$MyMembershipSummary {
  const MyMembershipSummary._();

  const factory MyMembershipSummary({
    required FacilityKind kind,
    required String payableId,
    required DateTime? latestPaidAt,
    required double amount,
    required String currency,
    String? facilityId,
    String? facilityName,
    String? categoryName,
    String? status,
    bool? isValid,
    DateTime? startDate,
    DateTime? endDate,
    String? membershipType,
    String? batchName,
  }) = _MyMembershipSummary;

  bool get isActuallyActive {
    if (isValid == false) return false;
    if (status != null && status!.toLowerCase() != 'active') return false;
    if (endDate != null && endDate!.isBefore(DateTime.now())) return false;
    return true;
  }

  bool get isExpired => !isActuallyActive;
}
