import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/facility_model.dart';
import '../../data/models/my_membership_summary.dart';
import '../../data/repositories/facilities_repository.dart';

part 'facilities_providers.g.dart';

class FacilityListParams {
  const FacilityListParams({
    required this.kind,
    this.search,
    this.cityId,
    this.status,
  });

  final FacilityKind kind;
  final String? search;
  final String? cityId;
  final String? status;

  @override
  bool operator ==(Object other) =>
      other is FacilityListParams &&
      other.kind == kind &&
      other.search == search &&
      other.cityId == cityId &&
      other.status == status;

  @override
  int get hashCode => Object.hash(kind, search, cityId, status);
}

@riverpod
class FacilityList extends _$FacilityList {
  static const _perPage = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<FacilityModel>> build(FacilityListParams params) async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(facilitiesRepositoryProvider);
    final result = await repo.list(
      kind: params.kind,
      search: params.search,
      cityId: params.cityId,
      status: params.status,
      perPage: _perPage,
      page: _page,
    );
    _hasMore = result.meta.hasMorePages;
    return result.items;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final repo = ref.read(facilitiesRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.list(
        kind: params.kind,
        search: params.search,
        cityId: params.cityId,
        status: params.status,
        perPage: _perPage,
        page: nextPage,
      );
      _page = nextPage;
      _hasMore = result.meta.hasMorePages;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}

class NearbyLibraryListParams {
  const NearbyLibraryListParams({
    this.latitude,
    this.longitude,
    this.cityId,
    this.search,
    this.maxDistanceKm,
  });

  final double? latitude;
  final double? longitude;
  final String? cityId;
  final String? search;
  final double? maxDistanceKm;

  @override
  bool operator ==(Object other) =>
      other is NearbyLibraryListParams &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.cityId == cityId &&
      other.search == search &&
      other.maxDistanceKm == maxDistanceKm;

  @override
  int get hashCode =>
      Object.hash(latitude, longitude, cityId, search, maxDistanceKm);
}

@riverpod
class NearbyLibraryList extends _$NearbyLibraryList {
  static const _perPage = 15;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<FacilityModel>> build(NearbyLibraryListParams params) async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(facilitiesRepositoryProvider);
    final result = await repo.nearbyLibraries(
      latitude: params.latitude,
      longitude: params.longitude,
      cityId: params.cityId,
      search: params.search,
      maxDistanceKm: params.maxDistanceKm,
      perPage: _perPage,
      page: _page,
    );
    _hasMore = result.meta.hasMorePages;
    return result.items;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final repo = ref.read(facilitiesRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.nearbyLibraries(
        latitude: params.latitude,
        longitude: params.longitude,
        cityId: params.cityId,
        search: params.search,
        maxDistanceKm: params.maxDistanceKm,
        perPage: _perPage,
        page: nextPage,
      );
      _page = nextPage;
      _hasMore = result.meta.hasMorePages;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}

@riverpod
Future<FacilityModel> facilityDetail(Ref ref, FacilityKind kind, String id) {
  return ref.watch(facilitiesRepositoryProvider).getById(kind, id);
}

@riverpod
Future<List<Map<String, dynamic>>> facilityFeePlans(
  Ref ref,
  FacilityKind kind,
  String facilityId,
) {
  return ref.watch(facilitiesRepositoryProvider).feePlans(kind, facilityId);
}

@riverpod
Future<List<MyMembershipSummary>> myMembershipSummaries(Ref ref) {
  return ref.watch(facilitiesRepositoryProvider).myMembershipSummaries();
}
