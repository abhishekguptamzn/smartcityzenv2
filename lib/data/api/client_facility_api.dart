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

  Future<Response<dynamic>> citizenScanAttendance(
    String type,
    String facilityId, {
    String? qrNonce,
    String? bleNonce,
    int? rssi,
  }) =>
      _dio.post(
        '/facilities/$type/$facilityId/attendance/check-in',
        data: {
          if (qrNonce != null && qrNonce.isNotEmpty) 'qr_nonce': qrNonce,
          if (bleNonce != null && bleNonce.isNotEmpty) 'ble_nonce': bleNonce,
          if (rssi != null) 'rssi': rssi,
        },
      );

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

  // Facilities / Gyms / Libraries
  Future<Response<dynamic>> getGym(String gymId) =>
      _dio.get('/client/facilities/$gymId');

  Future<Response<dynamic>> updateGym(String gymId, Map<String, dynamic> data) =>
      _dio.put('/client/facilities/$gymId', data: data);

  Future<Response<dynamic>> getGymPlans(String gymId) =>
      _dio.get('/client/facilities/$gymId/plans');

  Future<Response<dynamic>> createGymPlan(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$gymId/plans', data: data);

  Future<Response<dynamic>> updateGymPlan(String gymId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/facilities/$gymId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteGymPlan(String gymId, String planId) =>
      _dio.delete('/client/facilities/$gymId/plans/$planId');

  Future<Response<dynamic>> getGymMembers(String gymId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/facilities/$gymId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addGymMember(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$gymId/members', data: data);

  Future<Response<dynamic>> deleteGymMember(String gymId, String memberId, {String? reason, String? comment}) =>
      _dio.delete('/client/facilities/$gymId/members/$memberId', data: {
        if (reason != null) 'reason': reason,
        if (comment != null) 'comment': comment,
      });

  Future<Response<dynamic>> renewGymMember(String gymId, String memberId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$gymId/members/$memberId/renew', data: data);

  Future<Response<dynamic>> getGymMemberRenewals(String gymId, String memberId) =>
      _dio.get('/client/facilities/$gymId/members/$memberId/renewals');

  Future<Response<dynamic>> getGymAttendance(String gymId, {String? date, int page = 1}) =>
      _dio.get('/client/facilities/$gymId/attendance', queryParameters: {
        if (date != null) 'date': date,
        'page': page,
      });

  // Libraries
  Future<Response<dynamic>> getLibrary(String libraryId) =>
      _dio.get('/client/facilities/$libraryId');

  Future<Response<dynamic>> updateLibrary(String libraryId, Map<String, dynamic> data) =>
      _dio.put('/client/facilities/$libraryId', data: data);

  Future<Response<dynamic>> getLibraryPlans(String libraryId) =>
      _dio.get('/client/facilities/$libraryId/plans');

  Future<Response<dynamic>> createLibraryPlan(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$libraryId/plans', data: data);

  Future<Response<dynamic>> updateLibraryPlan(String libraryId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/facilities/$libraryId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteLibraryPlan(String libraryId, String planId) =>
      _dio.delete('/client/facilities/$libraryId/plans/$planId');

  Future<Response<dynamic>> getLibraryMembers(String libraryId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/facilities/$libraryId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addLibraryMember(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$libraryId/members', data: data);

  Future<Response<dynamic>> deleteLibraryMember(String libraryId, String memberId, {String? reason, String? comment}) =>
      _dio.delete('/client/facilities/$libraryId/members/$memberId', data: {
        if (reason != null) 'reason': reason,
        if (comment != null) 'comment': comment,
      });

  // Activities / Facility Centers
  Future<Response<dynamic>> getActivity(String activityId) =>
      _dio.get('/facilities/$activityId');

  Future<Response<dynamic>> updateActivity(String activityId, Map<String, dynamic> data) =>
      _dio.put('/client/facilities/$activityId', data: data);

  Future<Response<dynamic>> getActivityPlans(String activityId) =>
      _dio.get('/facilities/$activityId/fee-plans');

  Future<Response<dynamic>> createActivityPlan(String activityId, Map<String, dynamic> data) =>
      _dio.post('/facilities/$activityId/fee-plans', data: data);

  Future<Response<dynamic>> updateActivityPlan(String activityId, String planId, Map<String, dynamic> data) =>
      _dio.put('/facilities/$activityId/fee-plans/$planId', data: data);

  Future<Response<dynamic>> deleteActivityPlan(String activityId, String planId) =>
      _dio.delete('/facilities/$activityId/fee-plans/$planId');

  Future<Response<dynamic>> getActivityMembers(String activityId, {String? search, String? status, int page = 1}) =>
      _dio.get('/facilities/$activityId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addActivityMember(String activityId, Map<String, dynamic> data) =>
      _dio.post('/facilities/$activityId/members', data: data);

  Future<Response<dynamic>> deleteActivityMember(String activityId, String enrollmentId, {String? reason, String? comment}) =>
      _dio.delete('/facilities/$activityId/members/$enrollmentId', data: {
        if (reason != null) 'reason': reason,
        if (comment != null) 'comment': comment,
      });

  Future<Response<dynamic>> uploadFacilityLogo(
    String type,
    String facilityId, {
    required List<int> bytes,
    required String filename,
  }) async {
    final formData = FormData.fromMap({
      'logo': MultipartFile.fromBytes(bytes, filename: filename),
    });
    return _dio.post('/client/$type/$facilityId/logo', data: formData);
  }

  Future<Response<dynamic>> deleteFacilityLogo(String type, String facilityId) =>
      _dio.delete('/client/$type/$facilityId/logo');

  Future<Response<dynamic>> renewActivityMember(String activityId, String enrollmentId, Map<String, dynamic> data) =>
      _dio.post('/client/facilities/$activityId/members/$enrollmentId/renew', data: data);

  Future<Response<dynamic>> getActivityMemberRenewals(String activityId, String enrollmentId) =>
      _dio.get('/client/facilities/$activityId/members/$enrollmentId/renewals');

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

  Future<Response<dynamic>> getPaymentDetails(
    String type,
    String facilityId,
    String paymentId,
  ) =>
      _dio.get('/client/$type/$facilityId/payments/$paymentId');

  Future<Response<dynamic>> emailPaymentInvoice(
    String type,
    String facilityId,
    String paymentId,
  ) =>
      _dio.post('/client/$type/$facilityId/payments/$paymentId/email-invoice');

  Future<Response<dynamic>> refundPayment(
    String type,
    String facilityId,
    String paymentId,
    Map<String, dynamic> data,
  ) =>
      _dio.post('/client/$type/$facilityId/payments/$paymentId/refund', data: data);

  Future<Response<dynamic>> renewLibraryMember(String libraryId, String memberId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/members/$memberId/renew', data: data);

  Future<Response<dynamic>> getLibraryMemberRenewals(String libraryId, String memberId) =>
      _dio.get('/client/libraries/$libraryId/members/$memberId/renewals');

  Future<Response<dynamic>> getGlobalAmenities({String? search, int perPage = 50}) =>
      _dio.get('/amenities', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'per_page': perPage,
      });

  Future<Response<dynamic>> createAmenity(String name, {String? icon}) =>
      _dio.post('/amenities', data: {
        'name': name,
        if (icon != null) 'icon': icon,
        'is_active': true,
      });

  Future<Response<dynamic>> getFacilityAmenities(String type, String facilityId) =>
      _dio.get('/$type/$facilityId/amenities');

  // Media / Gallery
  Future<Response<dynamic>> getFacilityMedia(String type, String facilityId) =>
      _dio.get('/$type/$facilityId/media');

  Future<Response<dynamic>> uploadFacilityMedia(
    String type,
    String facilityId, {
    required List<int> bytes,
    required String filename,
    String? caption,
  }) {
    final lower = filename.toLowerCase();
    final ext = lower.endsWith('.png')
        ? 'png'
        : lower.endsWith('.webp')
            ? 'webp'
            : 'jpeg';
    final safeFilename = filename.isNotEmpty
        ? (filename.contains('.') ? filename : '$filename.$ext')
        : 'facility.$ext';

    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: safeFilename),
      if (caption != null && caption.isNotEmpty) 'caption': caption,
    });
    return _dio.post(
      '/$type/$facilityId/media',
      data: formData,
    );
  }

  Future<Response<dynamic>> setPrimaryMedia(String mediaId) =>
      _dio.post('/media/$mediaId/primary');

  Future<Response<dynamic>> deleteMedia(String mediaId) =>
      _dio.delete('/media/$mediaId');

  // Batch Management API
  Future<Response<dynamic>> getBatches(
    String type,
    String id, {
    String? search,
    String? status,
    int page = 1,
  }) =>
      _dio.get(
        '/client/$type/$id/batches',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (status != null && status != 'all') 'status': status,
          'page': page,
        },
      );

  Future<Response<dynamic>> getBatchDetails(String type, String id, String batchId) =>
      _dio.get('/client/$type/$id/batches/$batchId');

  Future<Response<dynamic>> createBatch(String type, String id, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/batches', data: data);

  Future<Response<dynamic>> updateBatch(String type, String id, String batchId, Map<String, dynamic> data) =>
      _dio.put('/client/$type/$id/batches/$batchId', data: data);

  Future<Response<dynamic>> deleteBatch(String type, String id, String batchId) =>
      _dio.delete('/client/$type/$id/batches/$batchId');

  Future<Response<dynamic>> getBatchMembers(
    String type,
    String id,
    String batchId, {
    String? status,
    String? search,
    int page = 1,
  }) =>
      _dio.get(
        '/client/$type/$id/batches/$batchId/members',
        queryParameters: {
          if (status != null && status != 'all') 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
        },
      );

  Future<Response<dynamic>> enrollBatchMember(String type, String id, String batchId, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/batches/$batchId/enroll', data: data);

  Future<Response<dynamic>> unenrollBatchMember(
    String type,
    String id,
    String batchId,
    String memberId, {
    String? reason,
  }) =>
      _dio.delete(
        '/client/$type/$id/batches/$batchId/members/$memberId',
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );

  Future<Response<dynamic>> switchBatch(
    String type,
    String id,
    String batchId,
    String memberId,
    String targetBatchId,
  ) =>
      _dio.post(
        '/client/$type/$id/batches/$batchId/members/$memberId/switch',
        data: {'target_batch_id': targetBatchId},
      );

  Future<Response<dynamic>> getBatchAttendance(String type, String id, String batchId, {String? date}) =>
      _dio.get(
        '/client/$type/$id/batches/$batchId/attendance',
        queryParameters: {if (date != null) 'date': date},
      );

  Future<Response<dynamic>> markBatchAttendance(
    String type,
    String id,
    String batchId, {
    required String date,
    required List<Map<String, dynamic>> records,
  }) =>
      _dio.post(
        '/client/$type/$id/batches/$batchId/attendance',
        data: {
          'date': date,
          'records': records,
        },
      );

  Future<Response<dynamic>> getBatchAnnouncements(String type, String id, String batchId, {int page = 1}) =>
      _dio.get(
        '/client/$type/$id/batches/$batchId/announcements',
        queryParameters: {'page': page},
      );

  Future<Response<dynamic>> sendBatchAnnouncement(String type, String id, String batchId, Map<String, dynamic> data) =>
      _dio.post('/client/$type/$id/batches/$batchId/announcements', data: data);
}

@Riverpod(keepAlive: true)
ClientFacilityApi clientFacilityApi(Ref ref) {
  return ClientFacilityApi(ref.watch(dioProvider));
}
