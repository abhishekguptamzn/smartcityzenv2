// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaymentList)
const paymentListProvider = PaymentListFamily._();

final class PaymentListProvider
    extends $AsyncNotifierProvider<PaymentList, List<PaymentModel>> {
  const PaymentListProvider._({
    required PaymentListFamily super.from,
    required PaymentListParams super.argument,
  }) : super(
         retry: null,
         name: r'paymentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentListHash();

  @override
  String toString() {
    return r'paymentListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PaymentList create() => PaymentList();

  @override
  bool operator ==(Object other) {
    return other is PaymentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentListHash() => r'f09cf4eedd5868333faddeeee1c15313f3175a72';

final class PaymentListFamily extends $Family
    with
        $ClassFamilyOverride<
          PaymentList,
          AsyncValue<List<PaymentModel>>,
          List<PaymentModel>,
          FutureOr<List<PaymentModel>>,
          PaymentListParams
        > {
  const PaymentListFamily._()
    : super(
        retry: null,
        name: r'paymentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PaymentListProvider call(PaymentListParams params) =>
      PaymentListProvider._(argument: params, from: this);

  @override
  String toString() => r'paymentListProvider';
}

abstract class _$PaymentList extends $AsyncNotifier<List<PaymentModel>> {
  late final _$args = ref.$arg as PaymentListParams;
  PaymentListParams get params => _$args;

  FutureOr<List<PaymentModel>> build(PaymentListParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<PaymentModel>>, List<PaymentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PaymentModel>>, List<PaymentModel>>,
              AsyncValue<List<PaymentModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(paymentDetail)
const paymentDetailProvider = PaymentDetailFamily._();

final class PaymentDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaymentModel>,
          PaymentModel,
          FutureOr<PaymentModel>
        >
    with $FutureModifier<PaymentModel>, $FutureProvider<PaymentModel> {
  const PaymentDetailProvider._({
    required PaymentDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'paymentDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentDetailHash();

  @override
  String toString() {
    return r'paymentDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaymentModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaymentModel> create(Ref ref) {
    final argument = this.argument as String;
    return paymentDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentDetailHash() => r'ba8e766105e627bb830adeb7c3cf0f39cc6d4111';

final class PaymentDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PaymentModel>, String> {
  const PaymentDetailFamily._()
    : super(
        retry: null,
        name: r'paymentDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PaymentDetailProvider call(String id) =>
      PaymentDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'paymentDetailProvider';
}
