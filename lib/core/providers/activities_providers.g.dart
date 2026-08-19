// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityCategories)
const activityCategoriesProvider = ActivityCategoriesProvider._();

final class ActivityCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityCategoryModel>>,
          List<ActivityCategoryModel>,
          FutureOr<List<ActivityCategoryModel>>
        >
    with
        $FutureModifier<List<ActivityCategoryModel>>,
        $FutureProvider<List<ActivityCategoryModel>> {
  const ActivityCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivityCategoryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityCategoryModel>> create(Ref ref) {
    return activityCategories(ref);
  }
}

String _$activityCategoriesHash() =>
    r'54f567b7742d599dddabbae4eebbdc5ac27b8447';

@ProviderFor(ActivityList)
const activityListProvider = ActivityListFamily._();

final class ActivityListProvider
    extends $AsyncNotifierProvider<ActivityList, List<ActivityModel>> {
  const ActivityListProvider._({
    required ActivityListFamily super.from,
    required ActivityListParams super.argument,
  }) : super(
         retry: null,
         name: r'activityListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityListHash();

  @override
  String toString() {
    return r'activityListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityList create() => ActivityList();

  @override
  bool operator ==(Object other) {
    return other is ActivityListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityListHash() => r'fe6ac5bd37a9ab79b5c484b550bc3eb3ff3cfb04';

final class ActivityListFamily extends $Family
    with
        $ClassFamilyOverride<
          ActivityList,
          AsyncValue<List<ActivityModel>>,
          List<ActivityModel>,
          FutureOr<List<ActivityModel>>,
          ActivityListParams
        > {
  const ActivityListFamily._()
    : super(
        retry: null,
        name: r'activityListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityListProvider call(ActivityListParams params) =>
      ActivityListProvider._(argument: params, from: this);

  @override
  String toString() => r'activityListProvider';
}

abstract class _$ActivityList extends $AsyncNotifier<List<ActivityModel>> {
  late final _$args = ref.$arg as ActivityListParams;
  ActivityListParams get params => _$args;

  FutureOr<List<ActivityModel>> build(ActivityListParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<ActivityModel>>, List<ActivityModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ActivityModel>>, List<ActivityModel>>,
              AsyncValue<List<ActivityModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(activityDetails)
const activityDetailsProvider = ActivityDetailsFamily._();

final class ActivityDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityModel>,
          ActivityModel,
          FutureOr<ActivityModel>
        >
    with $FutureModifier<ActivityModel>, $FutureProvider<ActivityModel> {
  const ActivityDetailsProvider._({
    required ActivityDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityDetailsHash();

  @override
  String toString() {
    return r'activityDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ActivityModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActivityModel> create(Ref ref) {
    final argument = this.argument as String;
    return activityDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityDetailsHash() => r'05fae3eeb6d7c9bd3bbb4900abae42192d5a86a3';

final class ActivityDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ActivityModel>, String> {
  const ActivityDetailsFamily._()
    : super(
        retry: null,
        name: r'activityDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityDetailsProvider call(String id) =>
      ActivityDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'activityDetailsProvider';
}

@ProviderFor(activityReviews)
const activityReviewsProvider = ActivityReviewsFamily._();

final class ActivityReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityReviewModel>>,
          List<ActivityReviewModel>,
          FutureOr<List<ActivityReviewModel>>
        >
    with
        $FutureModifier<List<ActivityReviewModel>>,
        $FutureProvider<List<ActivityReviewModel>> {
  const ActivityReviewsProvider._({
    required ActivityReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityReviewsHash();

  @override
  String toString() {
    return r'activityReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ActivityReviewModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityReviewModel>> create(Ref ref) {
    final argument = this.argument as String;
    return activityReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityReviewsHash() => r'0830ca6513a3a9aca54d8d0bf8102c9f6db21bfa';

final class ActivityReviewsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<ActivityReviewModel>>, String> {
  const ActivityReviewsFamily._()
    : super(
        retry: null,
        name: r'activityReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityReviewsProvider call(String id) =>
      ActivityReviewsProvider._(argument: id, from: this);

  @override
  String toString() => r'activityReviewsProvider';
}

@ProviderFor(myActivityEnrollments)
const myActivityEnrollmentsProvider = MyActivityEnrollmentsProvider._();

final class MyActivityEnrollmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityEnrollmentModel>>,
          List<ActivityEnrollmentModel>,
          FutureOr<List<ActivityEnrollmentModel>>
        >
    with
        $FutureModifier<List<ActivityEnrollmentModel>>,
        $FutureProvider<List<ActivityEnrollmentModel>> {
  const MyActivityEnrollmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myActivityEnrollmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myActivityEnrollmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivityEnrollmentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityEnrollmentModel>> create(Ref ref) {
    return myActivityEnrollments(ref);
  }
}

String _$myActivityEnrollmentsHash() =>
    r'b2096b511086278d0a24d8d9a1f0d2e1829cf43e';
