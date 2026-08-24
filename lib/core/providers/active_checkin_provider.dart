import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/client_facility_repository.dart';
import 'auth_controller.dart';

final activeCheckinProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  // Keep provider alive for 60s to avoid repeated requests during navigation
  final link = ref.keepAlive();
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(timer.cancel);

  final user = ref.watch(authControllerProvider).value;
  if (user == null || !user.isClientUser) {
    return {'has_active_session': false};
  }

  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getActiveCheckinSession();
});

