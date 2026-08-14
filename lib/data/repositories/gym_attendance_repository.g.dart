// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_attendance_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gymAttendanceRepository)
const gymAttendanceRepositoryProvider = GymAttendanceRepositoryProvider._();

final class GymAttendanceRepositoryProvider
    extends
        $FunctionalProvider<
          GymAttendanceRepository,
          GymAttendanceRepository,
          GymAttendanceRepository
        >
    with $Provider<GymAttendanceRepository> {
  const GymAttendanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymAttendanceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymAttendanceRepositoryHash();

  @$internal
  @override
  $ProviderElement<GymAttendanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GymAttendanceRepository create(Ref ref) {
    return gymAttendanceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymAttendanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymAttendanceRepository>(value),
    );
  }
}

String _$gymAttendanceRepositoryHash() =>
    r'eea91d8613dba755e13b17738eb6a123532facbb';
