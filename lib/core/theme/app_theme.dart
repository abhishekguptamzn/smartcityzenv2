import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  // "Civic Blue" primary — trustworthy, tech-forward, matches the logo blue.
  static const Color _primary = Color(0xFF1565D8);
  static const Color _onPrimary = Color(0xFFFFFFFF);
  static const Color _primaryContainer = Color(0xFF0E3A8F);
  static const Color _onPrimaryContainer = Color(0xFFD7E3FF);
  // "Growth Green" secondary — the brand accent for selected states,
  // highlights and success/active indicators. Replaces the old cyan.
  static const Color _secondary = Color(0xFF1B6E3E);
  static const Color _onSecondary = Color(0xFFFFFFFF);
  static const Color _secondaryContainer = Color(0xFF2E9E5B);
  static const Color _onSecondaryContainer = Color(0xFF00210F);
  // "Sunrise Amber" tertiary — badges, ratings, featured tags.
  static const Color _tertiary = Color(0xFF7A5000);
  static const Color _onTertiary = Color(0xFFFFFFFF);
  static const Color _tertiaryContainer = Color(0xFFF2A93B);
  static const Color _onTertiaryContainer = Color(0xFF3D2600);
  static const Color _error = Color(0xFFBA1A1A);
  static const Color _onError = Color(0xFFFFFFFF);
  static const Color _errorContainer = Color(0xFFFFDAD6);
  static const Color _onErrorContainer = Color(0xFF93000A);
  static const Color _surface = Color(0xFFF7F9FB);
  static const Color _onSurface = Color(0xFF191C1E);
  static const Color _onSurfaceVariant = Color(0xFF44464F);
  static const Color _outline = Color(0xFF757780);
  static const Color _outlineVariant = Color(0xFFC5C6D1);
  static const Color _inverseSurface = Color(0xFF2D3133);
  static const Color _inverseOnSurface = Color(0xFFEFF1F3);
  static const Color _inversePrimary = Color(0xFFA8C7FF);

  static const Color _darkBackground = Color(0xFF000814);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: _primaryContainer,
    onPrimaryContainer: _onPrimaryContainer,
    secondary: _secondary,
    onSecondary: _onSecondary,
    secondaryContainer: _secondaryContainer,
    onSecondaryContainer: _onSecondaryContainer,
    tertiary: _tertiary,
    onTertiary: _onTertiary,
    tertiaryContainer: _tertiaryContainer,
    onTertiaryContainer: _onTertiaryContainer,
    error: _error,
    onError: _onError,
    errorContainer: _errorContainer,
    onErrorContainer: _onErrorContainer,
    surface: _surface,
    onSurface: _onSurface,
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F4F6),
    surfaceContainer: Color(0xFFECEEF0),
    surfaceContainerHigh: Color(0xFFE6E8EA),
    surfaceContainerHighest: Color(0xFFE0E3E5),
    surfaceDim: Color(0xFFD8DADC),
    surfaceBright: _surface,
    onSurfaceVariant: _onSurfaceVariant,
    outline: _outline,
    outlineVariant: _outlineVariant,
    inverseSurface: _inverseSurface,
    onInverseSurface: _inverseOnSurface,
    inversePrimary: _inversePrimary,
    surfaceTint: Color(0xFF1565D8),
  );

  static ColorScheme get _darkScheme {
    // Seeded from the brand blue, then the atmospheric-navy surfaces from
    // DESIGN.md are layered back over the generated tones. Accents shift to
    // lighter blue/green/amber tints so they read clearly on near-black navy.
    final ColorScheme seeded = ColorScheme.fromSeed(
      seedColor: _primaryContainer,
      brightness: Brightness.dark,
    );
    return seeded.copyWith(
      primary: _inversePrimary,
      onPrimary: const Color(0xFF001C3D),
      primaryContainer: const Color(0xFF15427A),
      onPrimaryContainer: const Color(0xFFD7E3FF),
      secondary: const Color(0xFF7ED99B),
      onSecondary: const Color(0xFF00391A),
      secondaryContainer: const Color(0xFF1B6E3E),
      onSecondaryContainer: const Color(0xFFB6F0C6),
      tertiary: const Color(0xFFFFC876),
      onTertiary: const Color(0xFF3D2600),
      tertiaryContainer: const Color(0xFF7A5000),
      onTertiaryContainer: const Color(0xFFFFE3B8),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: _darkBackground,
      onSurface: const Color(0xFFE1E3E5),
      surfaceContainerLowest: const Color(0xFF00050F),
      surfaceContainerLow: const Color(0xFF0A1220),
      surfaceContainer: const Color(0xFF0E1826),
      surfaceContainerHigh: const Color(0xFF18232F),
      surfaceContainerHighest: const Color(0xFF232E3A),
      surfaceDim: _darkBackground,
      surfaceBright: const Color(0xFF283442),
      onSurfaceVariant: const Color(0xFFC0C6CC),
      outline: const Color(0xFF8A9199),
      outlineVariant: const Color(0xFF41474D),
      inverseSurface: const Color(0xFFE1E3E5),
      onInverseSurface: const Color(0xFF191C1E),
      inversePrimary: _primaryContainer,
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final Color onSurface = scheme.onSurface;
    final Color variant = scheme.onSurfaceVariant;

    return TextTheme(
      displayLarge: GoogleFonts.sora(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        height: 46 / 38,
        letterSpacing: -0.02 * 38,
        color: onSurface,
      ),
      displayMedium: GoogleFonts.sora(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 38 / 32,
        letterSpacing: -0.02 * 32,
        color: onSurface,
      ),
      displaySmall: GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 34 / 28,
        letterSpacing: -0.01 * 28,
        color: onSurface,
      ),
      headlineLarge: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 30 / 24,
        letterSpacing: -0.01 * 24,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 26 / 20,
        color: onSurface,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 17.5,
        fontWeight: FontWeight.w600,
        height: 24 / 17.5,
        letterSpacing: -0.2,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 21 / 15,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        height: 19 / 13.5,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        height: 21 / 14.5,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18 / 13,
        color: onSurface,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        height: 16 / 11.5,
        color: variant,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 15 / 11,
        letterSpacing: 0.04 * 11,
        color: variant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        letterSpacing: 0.04 * 10,
        color: variant,
      ),
    );
  }

  static ThemeData get light => _build(_lightScheme, AppColors.light);

  static ThemeData get dark => _build(_darkScheme, AppColors.dark);

  static ThemeData _build(ColorScheme scheme, AppColors ext) {
    final TextTheme text = _textTheme(scheme);
    final bool isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[ext],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 17.5,
          fontWeight: FontWeight.w600,
          height: 24 / 17.5,
          letterSpacing: -0.2,
          color: isDark ? ext.secondaryFixed : scheme.primary,
        ),
        iconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 22),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isDark ? ext.primaryFixedDim : scheme.primary,
          foregroundColor: isDark ? ext.onPrimaryFixed : scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? ext.primaryFixedDim : scheme.primary,
          foregroundColor: isDark ? ext.onPrimaryFixed : scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 0,
          shadowColor: ext.glassShadow,
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? ext.primaryFixedDim : scheme.primary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: scheme.outline),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.secondary,
          textStyle: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.04 * 13.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? ext.surfaceContainerLow.withValues(alpha: 0.6)
            : ext.surfaceContainerLow,
        contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        // DESIGN.md "Inputs": filled field with a bottom-only indigo stroke that
        // thickens on focus — hence rounded top corners with no side/bottom box.
        border: UnderlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(
            color: isDark ? ext.primaryFixedDim : scheme.primary,
            width: 2,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.04 * 11.5,
          color: isDark ? ext.primaryFixedDim : scheme.primary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: scheme.outline,
        ),
        errorStyle: GoogleFonts.inter(fontSize: 11.5, color: scheme.error),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? ext.surfaceContainerHigh
            : scheme.secondaryContainer.withValues(alpha: 0.18),
        selectedColor: isDark
            ? ext.onSecondaryFixedVariant
            : scheme.secondaryContainer.withValues(alpha: 0.55),
        side: BorderSide(color: ext.glassBorder),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelStyle: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.04 * 11.5,
          color: isDark ? ext.secondaryFixed : ext.onPrimaryFixedVariant,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: isDark ? ext.secondaryFixed : ext.onPrimaryFixedVariant,
        ),
        showCheckmark: false,
      ),
      cardTheme: CardThemeData(
        color: ext.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ext.glassBorder),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.secondaryContainer.withValues(alpha: 0.25),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.04 * 11.5,
            color: selected ? scheme.secondary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? scheme.secondary : scheme.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.secondaryContainer.withValues(alpha: 0.25),
        selectedIconTheme: IconThemeData(color: scheme.secondary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: scheme.secondary,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ext.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: ext.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ext.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 13.5,
          height: 19 / 13.5,
          color: scheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 13,
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.secondary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.secondary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.sora(fontSize: 13.5, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.sora(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onSecondary
              : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.secondary
              : ext.surfaceContainerHighest,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        circularTrackColor: ext.surfaceContainerHigh,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 12,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
