// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardRepository)
const onboardRepositoryProvider = OnboardRepositoryProvider._();

final class OnboardRepositoryProvider
    extends
        $FunctionalProvider<
          OnboardRepository,
          OnboardRepository,
          OnboardRepository
        >
    with $Provider<OnboardRepository> {
  const OnboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<OnboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnboardRepository create(Ref ref) {
    return onboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardRepository>(value),
    );
  }
}

String _$onboardRepositoryHash() => r'aa80aa4e8ea011cbaa8785261705f3a7362c0001';
