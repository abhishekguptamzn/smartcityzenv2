// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardDraftController)
const onboardDraftControllerProvider = OnboardDraftControllerProvider._();

final class OnboardDraftControllerProvider
    extends $NotifierProvider<OnboardDraftController, OnboardDraft> {
  const OnboardDraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardDraftControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardDraftControllerHash();

  @$internal
  @override
  OnboardDraftController create() => OnboardDraftController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardDraft>(value),
    );
  }
}

String _$onboardDraftControllerHash() =>
    r'3419cfb97693e9d2ac5e3b310575a5519a321139';

abstract class _$OnboardDraftController extends $Notifier<OnboardDraft> {
  OnboardDraft build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OnboardDraft, OnboardDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardDraft, OnboardDraft>,
              OnboardDraft,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(searchOwners)
const searchOwnersProvider = SearchOwnersFamily._();

final class SearchOwnersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OwnerSearchResult>>,
          List<OwnerSearchResult>,
          FutureOr<List<OwnerSearchResult>>
        >
    with
        $FutureModifier<List<OwnerSearchResult>>,
        $FutureProvider<List<OwnerSearchResult>> {
  const SearchOwnersProvider._({
    required SearchOwnersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchOwnersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchOwnersHash();

  @override
  String toString() {
    return r'searchOwnersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<OwnerSearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OwnerSearchResult>> create(Ref ref) {
    final argument = this.argument as String;
    return searchOwners(ref, query: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchOwnersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchOwnersHash() => r'4bfa56b82dd2a329e627e02336b3179faf1d06b6';

final class SearchOwnersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<OwnerSearchResult>>, String> {
  const SearchOwnersFamily._()
    : super(
        retry: null,
        name: r'searchOwnersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchOwnersProvider call({required String query}) =>
      SearchOwnersProvider._(argument: query, from: this);

  @override
  String toString() => r'searchOwnersProvider';
}

@ProviderFor(verifyOnboardToken)
const verifyOnboardTokenProvider = VerifyOnboardTokenFamily._();

final class VerifyOnboardTokenProvider
    extends
        $FunctionalProvider<
          AsyncValue<TokenVerificationResult>,
          TokenVerificationResult,
          FutureOr<TokenVerificationResult>
        >
    with
        $FutureModifier<TokenVerificationResult>,
        $FutureProvider<TokenVerificationResult> {
  const VerifyOnboardTokenProvider._({
    required VerifyOnboardTokenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'verifyOnboardTokenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verifyOnboardTokenHash();

  @override
  String toString() {
    return r'verifyOnboardTokenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TokenVerificationResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TokenVerificationResult> create(Ref ref) {
    final argument = this.argument as String;
    return verifyOnboardToken(ref, token: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyOnboardTokenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verifyOnboardTokenHash() =>
    r'6b0f9400ce9510836cf77c84238e33af4cffef6f';

final class VerifyOnboardTokenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TokenVerificationResult>, String> {
  const VerifyOnboardTokenFamily._()
    : super(
        retry: null,
        name: r'verifyOnboardTokenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VerifyOnboardTokenProvider call({required String token}) =>
      VerifyOnboardTokenProvider._(argument: token, from: this);

  @override
  String toString() => r'verifyOnboardTokenProvider';
}
