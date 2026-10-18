import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic result colours — always readable on white/light surfaces.
/// Use these for domain-specific states only (healthy/grade/disease/error).
/// For neutral surfaces and text, use Theme.of(context).colorScheme.
abstract final class AppColors {
  // ── Domain result colours ────────────────────────────────────────────────
  /// Deep green: healthy leaf, Grade A, in-distribution success.
  static const accent = Color(0xFF1B5E20);
  static const success = accent;

  /// Orange: warning, near-boundary OOD, Grade C/D, caution states.
  static const warning = Color(0xFF9A4300);
  static const accent3 = warning;

  /// Red: disease, pest detected, error, Grade E, OOD rejection.
  static const error = Color(0xFFB3261E);
  static const accent2 = error;

  /// Blue: informational metrics, cross-validation, regression charts.
  static const info = Color(0xFF0D47A1);
  static const blue = info;

  /// Purple: complementary analytics accent.
  static const purple = Color(0xFF6A1B9A);

  // ── Gradients ────────────────────────────────────────────────────────────
  static const accentGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const purpleGradient = LinearGradient(
    colors: [purple, Color(0xFF4527A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract final class AppTheme {
  /// The single Material 3 light theme used throughout the app.
  /// Set `theme: AppTheme.light` and `themeMode: ThemeMode.light` in MaterialApp.
  static final ThemeData light = _buildLight();

  static ThemeData _buildLight() {
    // ── Colour scheme ──────────────────────────────────────────────────────
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32), // betel leaf green seed
      brightness: Brightness.light,
    ).copyWith(
      // Primary: green
      primary: const Color(0xFF2E7D32),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFB8EEB9),
      onPrimaryContainer: const Color(0xFF002106),

      // Secondary: lighter green accent
      secondary: const Color(0xFF66BB6A),
      onSecondary: const Color(0xFF1B1B1B),
      secondaryContainer: const Color(0xFFD4F0D5),
      onSecondaryContainer: const Color(0xFF002107),

      // Surface: always white
      surface: Colors.white,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Colors.white,
      surfaceContainer: Colors.white,
      surfaceContainerHigh: const Color(0xFFF5F5F5),
      surfaceContainerHighest: const Color(0xFFF0F0F0),

      // On-surface text: dark grey body, medium grey secondary
      onSurface: const Color(0xFF1B1B1B),
      onSurfaceVariant: const Color(0xFF5F6368),

      // Borders
      outline: const Color(0xFF5F6368),
      outlineVariant: const Color(0xFFE0E0E0),

      // Error
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFFFCDAD7),
      onErrorContainer: const Color(0xFF410002),

      // Remove any tint
      surfaceTint: Colors.transparent,
    );

    // ── Helper builders ────────────────────────────────────────────────────
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: scheme.outlineVariant),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    // ── Text theme (Inter via google_fonts) ────────────────────────────────
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.light(useMaterial3: true).textTheme,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ).copyWith(
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: scheme.onSurfaceVariant,
      ),
    );

    // ── ThemeData ──────────────────────────────────────────────────────────
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,

      // Backgrounds
      scaffoldBackgroundColor: Colors.white,
      canvasColor: scheme.surface,

      // Typography
      textTheme: textTheme,
      iconTheme: IconThemeData(color: scheme.primary),
      dividerColor: scheme.outlineVariant,

      // ── AppBar ─────────────────────────────────────────────────────────
      // White background, green title + icons, elevation 0, dark status bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Dark status-bar icons (black clock, battery, WiFi on white AppBar)
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: scheme.primary),
        actionsIconTheme: IconThemeData(color: scheme.primary),
      ),

      // ── ElevatedButton ──────────────────────────────────────────────────
      // Green background, white text, rounded 12
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.surfaceContainerHighest,
          disabledForegroundColor: scheme.onSurfaceVariant,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ── TextButton ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),

      // ── InputDecoration ─────────────────────────────────────────────────
      // White fill, grey border, green focused border, red error text
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: inputBorder(scheme.outlineVariant),
        enabledBorder: inputBorder(scheme.outlineVariant),
        focusedBorder: inputBorder(scheme.primary, 2),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 2),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        helperStyle: TextStyle(color: scheme.onSurfaceVariant),
        // Red validation/error text
        errorStyle: TextStyle(
          color: scheme.error,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(color: scheme.primary),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      // White surface, light grey border, small elevation
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: shape,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      // ── BottomNavigationBar ───────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        elevation: 2,
        type: BottomNavigationBarType.fixed,
      ),

      // ── NavigationBar (Material 3 nav bar) ────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 1,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(color: scheme.onSurfaceVariant, fontSize: 12);
        }),
      ),

      // ── BottomSheet ───────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      // Light style: white background, dark text, green action
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF1B1B1B),
        ),
        actionTextColor: scheme.primary,
        closeIconColor: scheme.onSurfaceVariant,
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        shape: shape,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.surfaceContainerHighest,
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimaryContainer),
        side: BorderSide(color: scheme.outlineVariant),
        checkmarkColor: scheme.primary,
        deleteIconColor: scheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ── Slider ───────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outlineVariant,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: scheme.primary,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),

      // ── FloatingActionButton ─────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
