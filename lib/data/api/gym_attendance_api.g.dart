// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_attendance_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gymAttendanceApi)
const gymAttendanceApiProvider = GymAttendanceApiProvider._();

final class GymAttendanceApiProvider
    extends
        $FunctionalProvider<
          GymAttendanceApi,
          GymAttendanceApi,
          GymAttendanceApi
        >
    with $Provider<GymAttendanceApi> {
  const GymAttendanceApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymAttendanceApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymAttendanceApiHash();

  @$internal
  @override
  $ProviderElement<GymAttendanceApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GymAttendanceApi create(Ref ref) {
    return gymAttendanceApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymAttendanceApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymAttendanceApi>(value),
    );
  }
}

String _$gymAttendanceApiHash() => r'634ffb6b4314b24a10677ff41070d9accac4422a';
