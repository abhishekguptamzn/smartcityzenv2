import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/activity_category_model.dart';
import '../../data/models/activity_enrollment_model.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/activity_review_model.dart';
import '../../data/repositories/activities_repository.dart';

part 'activities_providers.g.dart';

class ActivityListParams {
  const ActivityListParams({
    this.category,
    this.categoryId,
    this.type,
    this.typeId,
    this.search,
    this.cityId,
    this.featured,
    this.minRating,
    this.latitude,
    this.longitude,
    this.radius,
    this.sortBy,
    this.sortDir,
  });

  final String? category;
  final String? categoryId;
  final String? type;
  final String? typeId;
  final String? search;
  final String? cityId;
  final bool? featured;
  final double? minRating;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? sortBy;
  final String? sortDir;

  @override
  bool operator ==(Object other) =>
      other is ActivityListParams &&
      other.category == category &&
      other.categoryId == categoryId &&
      other.type == type &&
      other.typeId == typeId &&
      other.search == search &&
      other.cityId == cityId &&
      other.featured == featured &&
      other.minRating == minRating &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.radius == radius &&
      other.sortBy == sortBy &&
      other.sortDir == sortDir;

  @override
  int get hashCode => Object.hash(
        category,
        categoryId,
        type,
        typeId,
        search,
        cityId,
        featured,
        minRating,
        latitude,
        longitude,
        radius,
        sortBy,
        sortDir,
      );
}

@riverpod
Future<List<ActivityCategoryModel>> activityCategories(Ref ref) async {
  final repo = ref.watch(activitiesRepositoryProvider);
  return repo.categories();
}

@riverpod
class ActivityList extends _$ActivityList {
  static const _perPage = 15;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<ActivityModel>> build(ActivityListParams params) async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(activitiesRepositoryProvider);
    final result = await repo.list(
      category: params.category,
      categoryId: params.categoryId,
      type: params.type,
      typeId: params.typeId,
      search: params.search,
      cityId: params.cityId,
      featured: params.featured,
      minRating: params.minRating,
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      sortBy: params.sortBy,
      sortDir: params.sortDir,
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
      final repo = ref.read(activitiesRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.list(
        category: params.category,
        categoryId: params.categoryId,
        type: params.type,
        typeId: params.typeId,
        search: params.search,
        cityId: params.cityId,
        featured: params.featured,
        minRating: params.minRating,
        latitude: params.latitude,
        longitude: params.longitude,
        radius: params.radius,
        sortBy: params.sortBy,
        sortDir: params.sortDir,
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
  bool get isLoadingMore => _isLoadingMore;
}

@riverpod
Future<ActivityModel> activityDetails(Ref ref, String id) async {
  final repo = ref.watch(activitiesRepositoryProvider);
  return repo.getById(id);
}

@riverpod
Future<List<ActivityReviewModel>> activityReviews(Ref ref, String id) async {
  final repo = ref.watch(activitiesRepositoryProvider);
  final result = await repo.reviews(id);
  return result.items;
}

@riverpod
Future<List<ActivityEnrollmentModel>> myActivityEnrollments(Ref ref) async {
  final repo = ref.watch(activitiesRepositoryProvider);
  final result = await repo.myEnrollments();
  return result.items;
}
