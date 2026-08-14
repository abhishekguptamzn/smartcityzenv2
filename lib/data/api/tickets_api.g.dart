// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ticketsApi)
const ticketsApiProvider = TicketsApiProvider._();

final class TicketsApiProvider
    extends $FunctionalProvider<TicketsApi, TicketsApi, TicketsApi>
    with $Provider<TicketsApi> {
  const TicketsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsApiHash();

  @$internal
  @override
  $ProviderElement<TicketsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TicketsApi create(Ref ref) {
    return ticketsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketsApi>(value),
    );
  }
}

String _$ticketsApiHash() => r'c75eb832a550b8756dde672d214d7872ea3b2842';
