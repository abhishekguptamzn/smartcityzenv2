import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/facility_model.dart';
import '../../data/repositories/activities_repository.dart';
import '../../data/repositories/facilities_repository.dart';
import '../../features/facilities/models/facility_hierarchy_models.dart';
import '../services/location_service.dart';
import 'activities_providers.dart';
import 'auth_controller.dart';

part 'facility_explorer_providers.g.dart';

enum FacilitySortFilter {
  nearest('Nearest'),
  openNow('Open Now'),
  topRated('Top Rated'),
  az('A-Z');

  const FacilitySortFilter(this.label);
  final String label;
}

@Riverpod(keepAlive: true)
Future<List<FacilityCategoryItem>> unifiedFacilityCategories(Ref ref) async {
  final activityCategoriesAsync = await ref.watch(activityCategoriesProvider.future);
  return buildUnifiedCategories(activityCategoriesAsync);
}

class FacilityExplorerQuery {
  const FacilityExplorerQuery({
    required this.categoryId,
    this.typeId,
    this.search,
    this.cityId,
    this.userLat,
    this.userLng,
  });

  final String categoryId;
  final String? typeId;
  final String? search;
  final String? cityId;
  final double? userLat;
  final double? userLng;

  @override
  bool operator ==(Object other) =>
      other is FacilityExplorerQuery &&
      other.categoryId == categoryId &&
      other.typeId == typeId &&
      other.search == search &&
      other.cityId == cityId &&
      other.userLat == userLat &&
      other.userLng == userLng;

  @override
  int get hashCode => Object.hash(categoryId, typeId, search, cityId, userLat, userLng);
}

@riverpod
class FacilityExplorerList extends _$FacilityExplorerList {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<FacilityModel>> build(FacilityExplorerQuery query) async {
    _page = 1;
    _hasMore = true;
    return _fetchPage(1, query);
  }

  Future<List<FacilityModel>> _fetchPage(int page, FacilityExplorerQuery query) async {
    final locationSvc = ref.read(locationServiceProvider);
    final user = ref.read(authControllerProvider).value;
    final cityId = query.cityId ?? user?.cityId;

    final userLat = query.userLat ?? user?.city?.latitude;
    final userLng = query.userLng ?? user?.city?.longitude;

    if (query.categoryId == 'libraries') {
      final repo = ref.read(facilitiesRepositoryProvider);
      final res = await repo.list(
        kind: FacilityKind.library,
        search: query.search?.trim().isEmpty == true ? null : query.search,
        cityId: cityId,
        page: page,
        perPage: 20,
      );
      _hasMore = res.meta.hasMorePages;

      return res.items.map((f) {
        final dist = locationSvc.calculateDistanceKm(
          startLat: userLat,
          startLng: userLng,
          endLat: f.latitude,
          endLng: f.longitude,
        );
        return f.copyWith(
          distanceKm: f.distanceKm ?? dist,
          distanceFormatted: f.distanceFormatted ?? locationSvc.formatDistance(dist),
          kind: FacilityKind.library,
        );
      }).toList();
    } else if (query.categoryId == 'gyms') {
      final repo = ref.read(facilitiesRepositoryProvider);
      final res = await repo.list(
        kind: FacilityKind.gym,
        search: query.search?.trim().isEmpty == true ? null : query.search,
        cityId: cityId,
        page: page,
        perPage: 20,
      );
      _hasMore = res.meta.hasMorePages;

      return res.items.map((f) {
        final dist = locationSvc.calculateDistanceKm(
          startLat: userLat,
          startLng: userLng,
          endLat: f.latitude,
          endLng: f.longitude,
        );
        return f.copyWith(
          distanceKm: f.distanceKm ?? dist,
          distanceFormatted: f.distanceFormatted ?? locationSvc.formatDistance(dist),
          kind: FacilityKind.gym,
        );
      }).toList();
    } else {
      // Activity Category / Academies
      final repo = ref.read(activitiesRepositoryProvider);
      final res = await repo.list(
        category: query.categoryId,
        typeId: (query.typeId != null && query.typeId != 'all') ? query.typeId : null,
        search: query.search?.trim().isEmpty == true ? null : query.search,
        cityId: cityId,
        latitude: userLat,
        longitude: userLng,
        page: page,
        perPage: 20,
      );
      _hasMore = res.meta.hasMorePages;

      return res.items.map((a) {
        final dist = locationSvc.calculateDistanceKm(
          startLat: userLat,
          startLng: userLng,
          endLat: a.latitude,
          endLng: a.longitude,
        );
        return FacilityModel(
          id: a.id,
          name: a.name,
          description: a.description,
          address: a.address,
          cityId: a.cityId,
          city: a.city,
          latitude: a.latitude,
          longitude: a.longitude,
          distanceKm: dist,
          distanceFormatted: locationSvc.formatDistance(dist),
          imageUrl: a.imageUrl,
          images: a.mediaUrls.map((u) => <String, dynamic>{'url': u}).toList(),
          amenities: a.amenities,
          contactPhone: a.contactPhone,
          contactEmail: a.contactEmail,
          openingTime: a.openingTime,
          closingTime: a.closingTime,
          status: a.status,
          kind: FacilityKind.activity,
        );
      }).toList();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final newItems = await _fetchPage(nextPage, query);
      _page = nextPage;
      state = AsyncData([...current, ...newItems]);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}
