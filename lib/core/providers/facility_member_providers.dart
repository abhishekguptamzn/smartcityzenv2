import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/facility_member_model.dart';
import '../../data/models/facility_model.dart';
import '../../data/models/membership_renewal_model.dart';
import '../../data/repositories/facility_members_repository.dart';

part 'facility_member_providers.g.dart';

@riverpod
Future<FacilityMemberModel> facilityMemberDetail(
  Ref ref,
  FacilityKind kind,
  String facilityId,
  String memberId,
) {
  return ref
      .watch(facilityMembersRepositoryProvider)
      .getById(kind, facilityId, memberId);
}

@riverpod
Future<List<MembershipRenewalModel>> memberRenewals(
  Ref ref,
  FacilityKind kind,
  String facilityId,
  String memberId,
) {
  return ref
      .watch(facilityMembersRepositoryProvider)
      .renewals(kind, facilityId, memberId);
}
