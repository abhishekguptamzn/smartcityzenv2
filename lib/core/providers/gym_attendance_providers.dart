import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/gym_attendance_model.dart';
import '../../data/repositories/gym_attendance_repository.dart';

part 'gym_attendance_providers.g.dart';

@riverpod
Future<List<GymAttendanceModel>> memberAttendanceHistory(
  Ref ref,
  String gymId,
  String memberId,
) async {
  final repo = ref.watch(gymAttendanceRepositoryProvider);
  final result = await repo.memberAttendance(gymId, memberId, perPage: 50);
  return result.items;
}
