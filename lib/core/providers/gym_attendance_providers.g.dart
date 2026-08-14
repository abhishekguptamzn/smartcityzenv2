// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_attendance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memberAttendanceHistory)
const memberAttendanceHistoryProvider = MemberAttendanceHistoryFamily._();

final class MemberAttendanceHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GymAttendanceModel>>,
          List<GymAttendanceModel>,
          FutureOr<List<GymAttendanceModel>>
        >
    with
        $FutureModifier<List<GymAttendanceModel>>,
        $FutureProvider<List<GymAttendanceModel>> {
  const MemberAttendanceHistoryProvider._({
    required MemberAttendanceHistoryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'memberAttendanceHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberAttendanceHistoryHash();

  @override
  String toString() {
    return r'memberAttendanceHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GymAttendanceModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GymAttendanceModel>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return memberAttendanceHistory(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberAttendanceHistoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberAttendanceHistoryHash() =>
    r'82329a2d29d92344c546466322373d596637fe86';

final class MemberAttendanceHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GymAttendanceModel>>,
          (String, String)
        > {
  const MemberAttendanceHistoryFamily._()
    : super(
        retry: null,
        name: r'memberAttendanceHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberAttendanceHistoryProvider call(String gymId, String memberId) =>
      MemberAttendanceHistoryProvider._(
        argument: (gymId, memberId),
        from: this,
      );

  @override
  String toString() => r'memberAttendanceHistoryProvider';
}
