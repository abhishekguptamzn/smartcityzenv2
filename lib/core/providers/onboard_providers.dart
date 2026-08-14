import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/onboard_model.dart';
import '../../data/repositories/onboard_repository.dart';

part 'onboard_providers.g.dart';

@Riverpod(keepAlive: true)
class OnboardDraftController extends _$OnboardDraftController {
  @override
  OnboardDraft build() {
    return const OnboardDraft();
  }

  void setType(OnboardType type) {
    state = state.copyWith(type: type);
  }

  void updateBasicDetails({
    required String name,
    required String email,
    required String phone,
    String? address,
    required String cityId,
    required String cityName,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address ?? state.address,
      cityId: cityId,
      cityName: cityName,
    );
  }

  void selectOwner(OwnerSearchResult owner) {
    state = state.copyWith(
      ownerId: owner.id,
      ownerName: owner.name,
      ownerEmail: owner.email,
      ownerAvatar: owner.avatar ?? '',
    );
  }

  void reset() {
    state = const OnboardDraft();
  }
}

@riverpod
Future<List<OwnerSearchResult>> searchOwners(
  Ref ref, {
  required String query,
}) async {
  final repo = ref.watch(onboardRepositoryProvider);
  return repo.searchOwners(query);
}

@riverpod
Future<TokenVerificationResult> verifyOnboardToken(
  Ref ref, {
  required String token,
}) async {
  final repo = ref.watch(onboardRepositoryProvider);
  return repo.verifyToken(token);
}
