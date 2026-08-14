// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentsApi)
const paymentsApiProvider = PaymentsApiProvider._();

final class PaymentsApiProvider
    extends $FunctionalProvider<PaymentsApi, PaymentsApi, PaymentsApi>
    with $Provider<PaymentsApi> {
  const PaymentsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsApiHash();

  @$internal
  @override
  $ProviderElement<PaymentsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentsApi create(Ref ref) {
    return paymentsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentsApi>(value),
    );
  }
}

String _$paymentsApiHash() => r'd5c8d190ffa2a870146efcf7afa5742921c56242';
