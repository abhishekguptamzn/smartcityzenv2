import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/client_facility_api.dart';
import '../models/facility_model.dart';
import '../models/facility_operations_models.dart';
import '../models/fee_plan_model.dart';

part 'client_facility_repository.g.dart';

class ClientFacilityRepository {
  ClientFacilityRepository(this._api);

  final ClientFacilityApi _api;

  Future<Map<String, dynamic>> getMyFacilities() async {
    final res = await _api.getMyFacilities();
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final gymsRaw = data['gyms'] as List? ?? [];
    final libsRaw = data['libraries'] as List? ?? [];

    return {
      'gyms': gymsRaw.map((j) => FacilityModel.fromJson(j as Map<String, dynamic>)).toList(),
      'libraries': libsRaw.map((j) => FacilityModel.fromJson(j as Map<String, dynamic>)).toList(),
      'total_facilities': data['total_facilities'] ?? 0,
      'is_client_user': data['is_client_user'] ?? false,
    };
  }

  // Unified Operations
  Future<FacilityDashboardStats> getDashboardStats(FacilityKind kind, String facilityId) async {
    final res = await _api.getDashboardStats(kind.pathSegment, facilityId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FacilityDashboardStats.fromJson(data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> checkIn(FacilityKind kind, String facilityId, {String? memberId, String? userId, String? code}) async {
    final res = await _api.checkIn(kind.pathSegment, facilityId, {
      if (memberId != null) 'member_id': memberId,
      if (userId != null) 'user_id': userId,
      if (code != null) 'code': code,
    });
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<Map<String, dynamic>> checkOut(FacilityKind kind, String facilityId, {String? sessionId, String? memberId, String? userId}) async {
    final res = await _api.checkOut(kind.pathSegment, facilityId, {
      if (sessionId != null) 'session_id': sessionId,
      if (memberId != null) 'member_id': memberId,
      if (userId != null) 'user_id': userId,
    });
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<Map<String, dynamic>> getCurrentStatus(FacilityKind kind, String facilityId) async {
    final res = await _api.getCurrentStatus(kind.pathSegment, facilityId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final listRaw = data['members_inside'] as List? ?? [];
    return {
      'facility_id': data['facility_id'],
      'facility_name': data['facility_name'],
      'currently_inside_count': data['currently_inside_count'] ?? 0,
      'today_checkins_count': data['today_checkins_count'] ?? 0,
      'today_unique_users_count': data['today_unique_users_count'] ?? 0,
      'last_updated': data['last_updated'] ?? '',
      'members_inside': listRaw.map((j) => LiveSessionMember.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<int> checkoutAll(FacilityKind kind, String facilityId) async {
    final res = await _api.checkoutAll(kind.pathSegment, facilityId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return (data['checked_out_count'] as num?)?.toInt() ?? 0;
  }

  // Reports
  Future<Map<String, dynamic>> getDailyCheckinsReport(FacilityKind kind, String facilityId, {String? date, String? status}) async {
    final res = await _api.getDailyCheckinsReport(kind.pathSegment, facilityId, date: date, status: status);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final recordsRaw = data['records'] as List? ?? [];
    return {
      'date': data['date'] ?? '',
      'formatted_date': data['formatted_date'] ?? '',
      'total_checkins': data['total_checkins'] ?? 0,
      'unique_users': data['unique_users'] ?? 0,
      'avg_duration_minutes': data['avg_duration_minutes'] ?? 0,
      'avg_duration_text': data['avg_duration_text'] ?? '--',
      'records': recordsRaw.map((j) => DailyCheckinRecord.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<Map<String, dynamic>> getMonthlyCheckinsReport(FacilityKind kind, String facilityId, {String? month}) async {
    final res = await _api.getMonthlyCheckinsReport(kind.pathSegment, facilityId, month: month);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return {
      'month': data['month'] ?? '',
      'month_label': data['month_label'] ?? '',
      'total_checkins': data['total_checkins'] ?? 0,
      'unique_users': data['unique_users'] ?? 0,
      'daily_breakdown': data['daily_breakdown'] as List? ?? [],
    };
  }

  Future<Map<String, dynamic>> getUnpaidMembersReport(FacilityKind kind, String facilityId, {String? month}) async {
    final res = await _api.getUnpaidMembersReport(kind.pathSegment, facilityId, month: month);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final membersRaw = data['members'] as List? ?? [];
    return {
      'month': data['month'] ?? '',
      'month_label': data['month_label'] ?? '',
      'unpaid_count': data['unpaid_count'] ?? 0,
      'total_unpaid_amount': (data['total_unpaid_amount'] as num?)?.toDouble() ?? 0.0,
      'members': membersRaw.map((j) => UnpaidMemberItem.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<Map<String, dynamic>> getCollectionsReport(
    FacilityKind kind,
    String facilityId, {
    String period = 'month',
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    final res = await _api.getCollectionsReport(kind.pathSegment, facilityId, period: period, dateFrom: dateFrom, dateTo: dateTo, status: status);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final txsRaw = data['transactions'] as List? ?? [];
    return {
      'period': data['period'] ?? period,
      'date_range': data['date_range'] ?? '',
      'total_collection': (data['total_collection'] as num?)?.toDouble() ?? 0.0,
      'total_transactions': data['total_transactions'] ?? 0,
      'transactions': txsRaw.map((j) => CollectionTransaction.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<Map<String, dynamic>> getExpiringMembersReport(FacilityKind kind, String facilityId, {int days = 30}) async {
    final res = await _api.getExpiringMembersReport(kind.pathSegment, facilityId, days: days);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<Map<String, dynamic>> getPlanDistributionReport(FacilityKind kind, String facilityId) async {
    final res = await _api.getPlanDistributionReport(kind.pathSegment, facilityId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<Map<String, dynamic>> citizenScanAttendance(FacilityKind kind, String facilityId) async {
    final res = await _api.citizenScanAttendance(kind.pathSegment, facilityId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<void> deleteMember(FacilityKind kind, String facilityId, String memberId) async {
    if (kind == FacilityKind.gym) {
      await _api.deleteGymMember(facilityId, memberId);
    } else {
      await _api.deleteLibraryMember(facilityId, memberId);
    }
  }

  Future<Map<String, dynamic>> renewMember(
    FacilityKind kind,
    String facilityId,
    String memberId, {
    String? feePlanId,
    double? amount,
    String paymentMethod = 'cash',
    String? transactionReference,
    String? notes,
  }) async {
    final payload = {
      if (feePlanId != null) 'fee_plan_id': feePlanId,
      if (amount != null) 'amount': amount,
      'payment_method': paymentMethod,
      if (transactionReference != null) 'transaction_reference': transactionReference,
      if (notes != null) 'notes': notes,
    };

    final res = kind == FacilityKind.gym
        ? await _api.renewGymMember(facilityId, memberId, payload)
        : await _api.renewLibraryMember(facilityId, memberId, payload);

    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<List<Map<String, dynamic>>> getMemberRenewals(FacilityKind kind, String facilityId, String memberId) async {
    final res = kind == FacilityKind.gym
        ? await _api.getGymMemberRenewals(facilityId, memberId)
        : await _api.getLibraryMemberRenewals(facilityId, memberId);

    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  // Enquiries
  Future<Map<String, dynamic>> getEnquiries(FacilityKind kind, String facilityId, {String? status, String? search, int page = 1}) async {
    final res = await _api.getEnquiries(kind.pathSegment, facilityId, status: status, search: search, page: page);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final rawList = data['enquiries'] as List? ?? [];
    return {
      'counts': data['counts'] as Map<String, dynamic>? ?? {},
      'enquiries': rawList.map((j) => FacilityEnquiryItem.fromJson(j as Map<String, dynamic>)).toList(),
      'pagination': data['pagination'] as Map<String, dynamic>? ?? {},
    };
  }

  Future<Map<String, dynamic>> getEnquiryDetails(FacilityKind kind, String facilityId, String enquiryId) async {
    final res = await _api.getEnquiryDetails(kind.pathSegment, facilityId, enquiryId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final enq = data['enquiry'] as Map<String, dynamic>? ?? {};
    final msgs = enq['messages'] as List? ?? [];
    return {
      'enquiry': FacilityEnquiryItem.fromJson(enq),
      'messages': msgs.map((j) => EnquiryMessage.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<void> replyEnquiry(FacilityKind kind, String facilityId, String enquiryId, String message) async {
    await _api.replyEnquiry(kind.pathSegment, facilityId, enquiryId, message);
  }

  Future<void> updateEnquiryStatus(FacilityKind kind, String facilityId, String enquiryId, String status) async {
    await _api.updateEnquiryStatus(kind.pathSegment, facilityId, enquiryId, status);
  }

  Future<Map<String, dynamic>> submitCitizenEnquiry(FacilityKind kind, String facilityId, Map<String, dynamic> payload) async {
    final res = await _api.submitCitizenEnquiry(kind.pathSegment, facilityId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  // Communications
  Future<Map<String, dynamic>> getCommunications(FacilityKind kind, String facilityId, {int page = 1}) async {
    final res = await _api.getCommunications(kind.pathSegment, facilityId, page: page);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final rawList = data['communications'] as List? ?? [];
    return {
      'stats': data['stats'] as Map<String, dynamic>? ?? {},
      'communications': rawList.map((j) => FacilityCommunicationItem.fromJson(j as Map<String, dynamic>)).toList(),
    };
  }

  Future<Map<String, dynamic>> sendCommunication(FacilityKind kind, String facilityId, Map<String, dynamic> payload) async {
    final res = await _api.sendCommunication(kind.pathSegment, facilityId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  // Gyms
  Future<Map<String, dynamic>> getGymDetails(String gymId) async {
    final res = await _api.getGym(gymId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return {
      'facility': FacilityModel.fromJson(data['gym'] as Map<String, dynamic>),
      'stats': data['stats'] as Map<String, dynamic>? ?? {},
    };
  }

  Future<FacilityModel> updateGymDetails(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.updateGym(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FacilityModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<FeePlanModel>> getGymPlans(String gymId) async {
    final res = await _api.getGymPlans(gymId);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.map((j) => FeePlanModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FeePlanModel> createGymPlan(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.createGymPlan(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<FeePlanModel> updateGymPlan(String gymId, String planId, Map<String, dynamic> payload) async {
    final res = await _api.updateGymPlan(gymId, planId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteGymPlan(String gymId, String planId) async {
    await _api.deleteGymPlan(gymId, planId);
  }

  Future<List<Map<String, dynamic>>> getGymMembers(String gymId, {String? search, String? status, int page = 1}) async {
    final res = await _api.getGymMembers(gymId, search: search, status: status, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addGymMember(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.addGymMember(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<List<Map<String, dynamic>>> getGymAttendance(String gymId, {String? date, int page = 1}) async {
    final res = await _api.getGymAttendance(gymId, date: date, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  // Libraries
  Future<Map<String, dynamic>> getLibraryDetails(String libraryId) async {
    final res = await _api.getLibrary(libraryId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return {
      'facility': FacilityModel.fromJson(data['library'] as Map<String, dynamic>),
      'stats': data['stats'] as Map<String, dynamic>? ?? {},
    };
  }

  Future<FacilityModel> updateLibraryDetails(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.updateLibrary(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FacilityModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<FeePlanModel>> getLibraryPlans(String libraryId) async {
    final res = await _api.getLibraryPlans(libraryId);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.map((j) => FeePlanModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FeePlanModel> createLibraryPlan(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.createLibraryPlan(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<FeePlanModel> updateLibraryPlan(String libraryId, String planId, Map<String, dynamic> payload) async {
    final res = await _api.updateLibraryPlan(libraryId, planId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteLibraryPlan(String libraryId, String planId) async {
    await _api.deleteLibraryPlan(libraryId, planId);
  }

  Future<List<Map<String, dynamic>>> getLibraryMembers(String libraryId, {String? search, String? status, int page = 1}) async {
    final res = await _api.getLibraryMembers(libraryId, search: search, status: status, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addLibraryMember(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.addLibraryMember(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }
}

@Riverpod(keepAlive: true)
ClientFacilityRepository clientFacilityRepository(Ref ref) {
  return ClientFacilityRepository(ref.watch(clientFacilityApiProvider));
}
