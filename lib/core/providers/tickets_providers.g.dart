// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketList)
const ticketListProvider = TicketListFamily._();

final class TicketListProvider
    extends $AsyncNotifierProvider<TicketList, List<TicketModel>> {
  const TicketListProvider._({
    required TicketListFamily super.from,
    required TicketListParams super.argument,
  }) : super(
         retry: null,
         name: r'ticketListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketListHash();

  @override
  String toString() {
    return r'ticketListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TicketList create() => TicketList();

  @override
  bool operator ==(Object other) {
    return other is TicketListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketListHash() => r'5df6c760ce3d3db06e4969cc136658d05512a5f4';

final class TicketListFamily extends $Family
    with
        $ClassFamilyOverride<
          TicketList,
          AsyncValue<List<TicketModel>>,
          List<TicketModel>,
          FutureOr<List<TicketModel>>,
          TicketListParams
        > {
  const TicketListFamily._()
    : super(
        retry: null,
        name: r'ticketListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketListProvider call(TicketListParams params) =>
      TicketListProvider._(argument: params, from: this);

  @override
  String toString() => r'ticketListProvider';
}

abstract class _$TicketList extends $AsyncNotifier<List<TicketModel>> {
  late final _$args = ref.$arg as TicketListParams;
  TicketListParams get params => _$args;

  FutureOr<List<TicketModel>> build(TicketListParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<TicketModel>>, List<TicketModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TicketModel>>, List<TicketModel>>,
              AsyncValue<List<TicketModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ticketDetail)
const ticketDetailProvider = TicketDetailFamily._();

final class TicketDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<TicketModel>,
          TicketModel,
          FutureOr<TicketModel>
        >
    with $FutureModifier<TicketModel>, $FutureProvider<TicketModel> {
  const TicketDetailProvider._({
    required TicketDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ticketDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketDetailHash();

  @override
  String toString() {
    return r'ticketDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TicketModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TicketModel> create(Ref ref) {
    final argument = this.argument as int;
    return ticketDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TicketDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketDetailHash() => r'bbe969f9d4aa2bd056422b8c8af2abe00eb0766a';

final class TicketDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TicketModel>, int> {
  const TicketDetailFamily._()
    : super(
        retry: null,
        name: r'ticketDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketDetailProvider call(int id) =>
      TicketDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'ticketDetailProvider';
}
