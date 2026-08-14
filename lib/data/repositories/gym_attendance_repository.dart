import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/gym_attendance_api.dart';
import '../models/gym_attendance_model.dart';
import '../models/pagination_meta.dart';

part 'gym_attendance_repository.g.dart';

class GymAttendanceRepository {
  GymAttendanceRepository(this._api);

  final GymAttendanceApi _api;

  Future<GymAttendanceModel> checkIn(
    String gymId, {
    required String memberId,
  }) async {
    final response = await _api.checkIn(gymId, memberId: memberId);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return GymAttendanceModel.fromJson(data);
  }

  Future<GymAttendanceModel> checkOut(
    String gymId, {
    required String attendanceId,
  }) async {
    final response = await _api.checkOut(gymId, attendanceId: attendanceId);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return GymAttendanceModel.fromJson(data);
  }

  Future<Paginated<GymAttendanceModel>> memberAttendance(
    String gymId,
    String memberId, {
    String? dateFrom,
    String? dateTo,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _api.memberAttendance(
      gymId,
      memberId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      perPage: perPage,
      page: page,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      GymAttendanceModel.fromJson,
    );
  }

  Future<GymAttendanceModel> getById(String gymId, String attendanceId) async {
    final response = await _api.getById(gymId, attendanceId);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return GymAttendanceModel.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
GymAttendanceRepository gymAttendanceRepository(Ref ref) =>
    GymAttendanceRepository(ref.watch(gymAttendanceApiProvider));
