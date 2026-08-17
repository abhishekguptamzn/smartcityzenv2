import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'client_facility_api.g.dart';

class ClientFacilityApi {
  ClientFacilityApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> getMyFacilities() =>
      _dio.get('/client/facilities');

  // Unified Facility Operations & Dashboard Stats
  Future<Response<dynamic>> getDashboardStats(String type, String id) =>
      _dio.get('/client/$type/$id/dashboard-stats');

  Future<Response<dynamic>> checkIn(String type, String id, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/check-in', data: data);

  Future<Response<dynamic>> checkOut(String type, String id, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/check-out', data: data);

  Future<Response<dynamic>> getCurrentStatus(String type, String id) =>
      _dio.get('/client/$type/$id/current-status');

  Future<Response<dynamic>> checkoutAll(String type, String id) =>
      _dio.post('/client/$type/$id/checkout-all');

  // Reports
  Future<Response<dynamic>> getDailyCheckinsReport(String type, String id, {String? date, String? status}) =>
      _dio.get('/client/$type/$id/reports/daily-checkins', queryParameters: {
        if (date != null) 'date': date,
        if (status != null && status != 'all') 'status': status,
      });

  Future<Response<dynamic>> getMonthlyCheckinsReport(String type, String id, {String? month}) =>
      _dio.get('/client/$type/$id/reports/monthly-checkins', queryParameters: {
        if (month != null) 'month': month,
      });

  Future<Response<dynamic>> getUnpaidMembersReport(String type, String id, {String? month}) =>
      _dio.get('/client/$type/$id/reports/unpaid-members', queryParameters: {
        if (month != null) 'month': month,
      });

  Future<Response<dynamic>> getCollectionsReport(
    String type,
    String id, {
    String period = 'month',
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _dio.get('/client/$type/$id/reports/collections', queryParameters: {
        'period': period,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (status != null && status != 'all') 'status': status,
      });

  Future<Response<dynamic>> getExpiringMembersReport(String type, String id, {int days = 30}) =>
      _dio.get('/client/$type/$id/reports/expiring-members', queryParameters: {'days': days});

  Future<Response<dynamic>> getPlanDistributionReport(String type, String id) =>
      _dio.get('/client/$type/$id/reports/plan-distribution');

  Future<Response<dynamic>> citizenScanAttendance(String type, String facilityId) =>
      _dio.post('/facilities/$type/$facilityId/attendance/check-in');

  // Enquiries
  Future<Response<dynamic>> getEnquiries(String type, String id, {String? status, String? search, int page = 1}) =>
      _dio.get('/client/$type/$id/enquiries', queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
      });

  Future<Response<dynamic>> getEnquiryDetails(String type, String id, String enquiryId) =>
      _dio.get('/client/$type/$id/enquiries/$enquiryId');

  Future<Response<dynamic>> replyEnquiry(String type, String id, String enquiryId, String message) =>
      _dio.post('/client/$type/$id/enquiries/$enquiryId/reply', data: {'message': message});

  Future<Response<dynamic>> updateEnquiryStatus(String type, String id, String enquiryId, String status) =>
      _dio.patch('/client/$type/$id/enquiries/$enquiryId/status', data: {'status': status});

  Future<Response<dynamic>> submitCitizenEnquiry(String type, String id, Map<String, dynamic> data) =>
      _dio.post('/facilities/$type/$id/enquiries', data: data);

  // Communications
  Future<Response<dynamic>> getCommunications(String type, String id, {int page = 1}) =>
      _dio.get('/client/$type/$id/communications', queryParameters: {'page': page});

  Future<Response<dynamic>> sendCommunication(String type, String id, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/communications/send', data: data);

  // Gyms
  Future<Response<dynamic>> getGym(String gymId) =>
      _dio.get('/client/gyms/$gymId');

  Future<Response<dynamic>> updateGym(String gymId, Map<String, dynamic> data) =>
      _dio.put('/client/gyms/$gymId', data: data);

  Future<Response<dynamic>> getGymPlans(String gymId) =>
      _dio.get('/client/gyms/$gymId/plans');

  Future<Response<dynamic>> createGymPlan(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/gyms/$gymId/plans', data: data);

  Future<Response<dynamic>> updateGymPlan(String gymId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/gyms/$gymId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteGymPlan(String gymId, String planId) =>
      _dio.delete('/client/gyms/$gymId/plans/$planId');

  Future<Response<dynamic>> getGymMembers(String gymId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/gyms/$gymId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addGymMember(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/gyms/$gymId/members', data: data);

  Future<Response<dynamic>> deleteGymMember(String gymId, String memberId) =>
      _dio.delete('/client/gyms/$gymId/members/$memberId');

  Future<Response<dynamic>> renewGymMember(String gymId, String memberId, Map<String, dynamic> data) =>
      _dio.post('/client/gyms/$gymId/members/$memberId/renew', data: data);

  Future<Response<dynamic>> getGymMemberRenewals(String gymId, String memberId) =>
      _dio.get('/client/gyms/$gymId/members/$memberId/renewals');

  Future<Response<dynamic>> getGymAttendance(String gymId, {String? date, int page = 1}) =>
      _dio.get('/client/gyms/$gymId/attendance', queryParameters: {
        if (date != null) 'date': date,
        'page': page,
      });

  // Libraries
  Future<Response<dynamic>> getLibrary(String libraryId) =>
      _dio.get('/client/libraries/$libraryId');

  Future<Response<dynamic>> updateLibrary(String libraryId, Map<String, dynamic> data) =>
      _dio.put('/client/libraries/$libraryId', data: data);

  Future<Response<dynamic>> getLibraryPlans(String libraryId) =>
      _dio.get('/client/libraries/$libraryId/plans');

  Future<Response<dynamic>> createLibraryPlan(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/plans', data: data);

  Future<Response<dynamic>> updateLibraryPlan(String libraryId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/libraries/$libraryId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteLibraryPlan(String libraryId, String planId) =>
      _dio.delete('/client/libraries/$libraryId/plans/$planId');

  Future<Response<dynamic>> getLibraryMembers(String libraryId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/libraries/$libraryId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addLibraryMember(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/members', data: data);

  Future<Response<dynamic>> deleteLibraryMember(String libraryId, String memberId) =>
      _dio.delete('/client/libraries/$libraryId/members/$memberId');

  // Active Session Status (Citizen)
  Future<Response<dynamic>> getActiveCheckinSession() =>
      _dio.get('/facilities/active-checkin');

  // Unified Member Details & Analytics (Facility Owner/Admin)
  Future<Response<dynamic>> getMemberDetails(String type, String facilityId, String memberId) =>
      _dio.get('/client/$type/$facilityId/members/$memberId/details');

  Future<Response<dynamic>> getMemberAttendanceReport(
    String type,
    String facilityId,
    String memberId, {
    String period = 'month',
    String? dateFrom,
    String? dateTo,
  }) =>
      _dio.get('/client/$type/$facilityId/members/$memberId/attendance-report', queryParameters: {
        'period': period,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
      });

  Future<Response<dynamic>> getMemberPayments(
    String type,
    String facilityId,
    String memberId, {
    int page = 1,
  }) =>
      _dio.get('/client/$type/$facilityId/members/$memberId/payments', queryParameters: {'page': page});

  Future<Response<dynamic>> sendMemberDirectCommunication(
    String type,
    String facilityId,
    String memberId,
    Map<String, dynamic> data,
  ) =>
      _dio.post('/client/$type/$facilityId/members/$memberId/send-communication', data: data);

  Future<Response<dynamic>> renewLibraryMember(String libraryId, String memberId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/members/$memberId/renew', data: data);

  Future<Response<dynamic>> getLibraryMemberRenewals(String libraryId, String memberId) =>
      _dio.get('/client/libraries/$libraryId/members/$memberId/renewals');
}

@Riverpod(keepAlive: true)
ClientFacilityApi clientFacilityApi(Ref ref) {
  return ClientFacilityApi(ref.watch(dioProvider));
}
