import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/facility_members_api.dart';
import '../models/facility_member_model.dart';
import '../models/facility_model.dart';
import '../models/membership_renewal_model.dart';

part 'facility_members_repository.g.dart';

class FacilityMembersRepository {
  FacilityMembersRepository(this._api);

  final FacilityMembersApi _api;

  Future<FacilityMemberModel> getById(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) async {
    final response = await _api.getById(kind, facilityId, memberId);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return FacilityMemberModel.fromApiJson(data, kind: kind);
  }

  Future<List<MembershipRenewalModel>> renewals(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) async {
    final response = await _api.renewals(kind, facilityId, memberId);
    final data = response.data;
    final list = data is Map<String, dynamic> ? data['data'] : data;
    if (list is! List) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(MembershipRenewalModel.fromJson)
        .toList();
  }
}

@Riverpod(keepAlive: true)
FacilityMembersRepository facilityMembersRepository(Ref ref) =>
    FacilityMembersRepository(ref.watch(facilityMembersApiProvider));
