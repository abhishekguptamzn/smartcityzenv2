// The Laravel policies for LibraryMember/GymMember gate `index`, `create`,
// and `renew` shut for the customer role with no self-service branch — only
// a single-record `show` (self-view) and the `renewals` history endpoint are
// reachable. Do not add list/create/renew methods here without re-checking
// LibraryMemberPolicy/GymMemberPolicy server-side first.
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/facility_model.dart';
import 'dio_client.dart';

part 'facility_members_api.g.dart';

class FacilityMembersApi {
  FacilityMembersApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> getById(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) {
    return _dio.get('/${kind.pathSegment}/$facilityId/members/$memberId');
  }

  Future<Response<dynamic>> renewals(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) {
    return _dio.get(
      '/${kind.pathSegment}/$facilityId/members/$memberId/renewals',
    );
  }
}

@Riverpod(keepAlive: true)
FacilityMembersApi facilityMembersApi(Ref ref) =>
    FacilityMembersApi(ref.watch(dioProvider));
