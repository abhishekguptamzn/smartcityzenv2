import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/client_facility_repository.dart';
import 'auth_controller.dart';

final activeCheckinProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) {
    return {'has_active_session': false};
  }

  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getActiveCheckinSession();
});
