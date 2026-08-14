import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.glassTint,
    required this.glassBorder,
    required this.glassShadow,
    required this.idCardGradientStart,
    required this.idCardGradientEnd,
    required this.idCardGlow,
    required this.ambientOne,
    required this.ambientTwo,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;

  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceDim;
  final Color surfaceBright;

  final Color glassTint;
  final Color glassBorder;
  final Color glassShadow;

  final Color idCardGradientStart;
  final Color idCardGradientEnd;
  final Color idCardGlow;

  final Color ambientOne;
  final Color ambientTwo;

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;

  // Brand palette — "Civic Blue" (primary), "Growth Green" (secondary),
  // "Sunrise Amber" (tertiary) — echoing the app's blue-to-green shield
  // logo. Fixed* tones stay legible against both light and dark surfaces,
  // matching Material 3's "fixed color" convention.
  static const AppColors light = AppColors(
    primaryFixed: Color(0xFFD7E3FF),
    primaryFixedDim: Color(0xFFA8C7FF),
    onPrimaryFixed: Color(0xFF001C3D),
    onPrimaryFixedVariant: Color(0xFF15427A),
    secondaryFixed: Color(0xFFB6F0C6),
    secondaryFixedDim: Color(0xFF7ED99B),
    onSecondaryFixed: Color(0xFF00210F),
    onSecondaryFixedVariant: Color(0xFF1B6E3E),
    tertiaryFixed: Color(0xFFFFE3B8),
    tertiaryFixedDim: Color(0xFFFFC876),
    onTertiaryFixed: Color(0xFF3D2600),
    onTertiaryFixedVariant: Color(0xFF7A5000),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F4F6),
    surfaceContainer: Color(0xFFECEEF0),
    surfaceContainerHigh: Color(0xFFE6E8EA),
    surfaceContainerHighest: Color(0xFFE0E3E5),
    surfaceDim: Color(0xFFD8DADC),
    surfaceBright: Color(0xFFF7F9FB),
    glassTint: Color(0xFFFFFFFF),
    glassBorder: Color(0x33FFFFFF),
    glassShadow: Color(0x141F2687),
    idCardGradientStart: Color(0xFF0E3A8F),
    idCardGradientEnd: Color(0xFF1C8A54),
    idCardGlow: Color(0xFF3FCB80),
    ambientOne: Color(0xFF1565D8),
    ambientTwo: Color(0xFF2E9E5B),
    success: Color(0xFF1B6E3E),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFB6F0C6),
    onSuccessContainer: Color(0xFF0A4A24),
    warning: Color(0xFF7A5000),
    warningContainer: Color(0xFFFFE3B8),
    onWarningContainer: Color(0xFF3D2600),
  );

  static const AppColors dark = AppColors(
    primaryFixed: Color(0xFFD7E3FF),
    primaryFixedDim: Color(0xFFA8C7FF),
    onPrimaryFixed: Color(0xFF001C3D),
    onPrimaryFixedVariant: Color(0xFF15427A),
    secondaryFixed: Color(0xFFB6F0C6),
    secondaryFixedDim: Color(0xFF7ED99B),
    onSecondaryFixed: Color(0xFF00210F),
    onSecondaryFixedVariant: Color(0xFF1B6E3E),
    tertiaryFixed: Color(0xFFFFE3B8),
    tertiaryFixedDim: Color(0xFFFFC876),
    onTertiaryFixed: Color(0xFF3D2600),
    onTertiaryFixedVariant: Color(0xFF7A5000),
    surfaceContainerLowest: Color(0xFF00050F),
    surfaceContainerLow: Color(0xFF0A1220),
    surfaceContainer: Color(0xFF0E1826),
    surfaceContainerHigh: Color(0xFF18232F),
    surfaceContainerHighest: Color(0xFF232E3A),
    surfaceDim: Color(0xFF000814),
    surfaceBright: Color(0xFF283442),
    glassTint: Color(0xFF16243A),
    glassBorder: Color(0x2EFFFFFF),
    glassShadow: Color(0x66000000),
    idCardGradientStart: Color(0xFF0A2E73),
    idCardGradientEnd: Color(0xFF166B41),
    idCardGlow: Color(0xFF4FE39A),
    ambientOne: Color(0xFF3D7FE0),
    ambientTwo: Color(0xFF2FA968),
    success: Color(0xFF7ED99B),
    onSuccess: Color(0xFF00391A),
    successContainer: Color(0xFF1B6E3E),
    onSuccessContainer: Color(0xFFB6F0C6),
    warning: Color(0xFFFFC876),
    warningContainer: Color(0xFF5C3D00),
    onWarningContainer: Color(0xFFFFE3B8),
  );

  @override
  AppColors copyWith({
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? glassTint,
    Color? glassBorder,
    Color? glassShadow,
    Color? idCardGradientStart,
    Color? idCardGradientEnd,
    Color? idCardGlow,
    Color? ambientOne,
    Color? ambientTwo,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return AppColors(
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
      onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      glassTint: glassTint ?? this.glassTint,
      glassBorder: glassBorder ?? this.glassBorder,
      glassShadow: glassShadow ?? this.glassShadow,
      idCardGradientStart: idCardGradientStart ?? this.idCardGradientStart,
      idCardGradientEnd: idCardGradientEnd ?? this.idCardGradientEnd,
      idCardGlow: idCardGlow ?? this.idCardGlow,
      ambientOne: ambientOne ?? this.ambientOne,
      ambientTwo: ambientTwo ?? this.ambientTwo,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant: Color.lerp(
        onPrimaryFixedVariant,
        other.onPrimaryFixedVariant,
        t,
      )!,
      secondaryFixed: Color.lerp(secondaryFixed, other.secondaryFixed, t)!,
      secondaryFixedDim: Color.lerp(
        secondaryFixedDim,
        other.secondaryFixedDim,
        t,
      )!,
      onSecondaryFixed: Color.lerp(
        onSecondaryFixed,
        other.onSecondaryFixed,
        t,
      )!,
      onSecondaryFixedVariant: Color.lerp(
        onSecondaryFixedVariant,
        other.onSecondaryFixedVariant,
        t,
      )!,
      tertiaryFixed: Color.lerp(tertiaryFixed, other.tertiaryFixed, t)!,
      tertiaryFixedDim: Color.lerp(
        tertiaryFixedDim,
        other.tertiaryFixedDim,
        t,
      )!,
      onTertiaryFixed: Color.lerp(onTertiaryFixed, other.onTertiaryFixed, t)!,
      onTertiaryFixedVariant: Color.lerp(
        onTertiaryFixedVariant,
        other.onTertiaryFixedVariant,
        t,
      )!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassShadow: Color.lerp(glassShadow, other.glassShadow, t)!,
      idCardGradientStart: Color.lerp(
        idCardGradientStart,
        other.idCardGradientStart,
        t,
      )!,
      idCardGradientEnd: Color.lerp(
        idCardGradientEnd,
        other.idCardGradientEnd,
        t,
      )!,
      idCardGlow: Color.lerp(idCardGlow, other.idCardGlow, t)!,
      ambientOne: Color.lerp(ambientOne, other.ambientOne, t)!,
      ambientTwo: Color.lerp(ambientTwo, other.ambientTwo, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
