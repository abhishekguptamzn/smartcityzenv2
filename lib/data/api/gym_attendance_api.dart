// The plain `/gyms/{id}/attendance` index and `/attendance/today` endpoints
// are authorised for the customer role but are NOT query-scoped to the
// caller server-side — using them for a "my attendance" screen would be
// architecturally wrong (best case) or a data leak (worst case). Only the
// per-member and per-record endpoints below are actually self-scoped.
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'gym_attendance_api.g.dart';

class GymAttendanceApi {
  GymAttendanceApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> checkIn(String gymId, {required String memberId}) {
    return _dio.post(
      '/facilities/$gymId/attendance/check-in',
      data: {'member_id': memberId},
    );
  }

  Future<Response<dynamic>> checkOut(
    String gymId, {
    required String attendanceId,
  }) {
    return _dio.post(
      '/facilities/$gymId/attendance/check-out',
      data: {'attendance_id': attendanceId},
    );
  }

  Future<Response<dynamic>> memberAttendance(
    String gymId,
    String memberId, {
    String? dateFrom,
    String? dateTo,
    int perPage = 15,
    int page = 1,
  }) {
    return _dio.get(
      '/facilities/$gymId/attendance',
      queryParameters: {
        'member_id': memberId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> getById(String gymId, String attendanceId) {
    return _dio.get('/facilities/$gymId/attendance/$attendanceId');
  }
}

@Riverpod(keepAlive: true)
GymAttendanceApi gymAttendanceApi(Ref ref) =>
    GymAttendanceApi(ref.watch(dioProvider));
