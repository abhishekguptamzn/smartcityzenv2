// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginHistoryList)
const loginHistoryListProvider = LoginHistoryListProvider._();

final class LoginHistoryListProvider
    extends $AsyncNotifierProvider<LoginHistoryList, List<LoginHistoryModel>> {
  const LoginHistoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginHistoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginHistoryListHash();

  @$internal
  @override
  LoginHistoryList create() => LoginHistoryList();
}

String _$loginHistoryListHash() => r'0c9028549b5c337e1d2479f3e4142c1e3f111211';

abstract class _$LoginHistoryList
    extends $AsyncNotifier<List<LoginHistoryModel>> {
  FutureOr<List<LoginHistoryModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LoginHistoryModel>>,
              List<LoginHistoryModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LoginHistoryModel>>,
                List<LoginHistoryModel>
              >,
              AsyncValue<List<LoginHistoryModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
