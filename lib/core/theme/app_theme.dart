import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// BravoFlow AI — Luminous Stratum Global Theme
///
/// Rules:
/// - No Material elevation shadows (use tonal layering via surface tokens).
/// - No Divider (dividerTheme is transparent — use SizedBox gaps instead).
/// - Dark is default; light is a fallback.
abstract final class AppTheme {
  // ── Dark Theme (default) ──────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surface,

      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primaryFixed,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryFixed,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.secondaryFixed,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.onSurface,
        errorContainer: AppColors.errorContainer,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
      ),

      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // ── App Bar ───────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Cards (no elevation — tonal layering only) ────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHigh,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      ),

      // ── Elevated Buttons (gradient via GradientButton widget) ─────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryFixed,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // ── Input Fields (filled, no outlined borders) ────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryFixed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.outline),
        prefixIconColor: AppColors.onSurfaceVariant,
        suffixIconColor: AppColors.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),

      // ── Divider (banned — silenced at theme level) ────────────────────────
      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),

      // ── Bottom Navigation ─────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface.withValues(alpha: 0.9),
        indicatorColor: AppColors.primaryFixed.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: AppColors.primaryFixed);
          }
          return AppTextStyles.labelSmall.copyWith(color: AppColors.outline.withValues(alpha: 0.6));
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryFixed, size: 24);
          }
          return IconThemeData(color: AppColors.outline.withValues(alpha: 0.6), size: 24);
        }),
      ),

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerHighest,
        labelStyle: AppTextStyles.labelSmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
        side: BorderSide.none,
      ),

      // ── Snack Bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: AppTextStyles.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      ),

      // ── Floating Action Button ────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryFixed,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
    );
  }

  // ── Light Theme (fallback) ────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryFixed,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: Colors.white,
        onSurface: Color(0xFF1A1A2E),
        outline: AppColors.outlineVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: const Color(0xFF1A1A2E)),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: const Color(0xFF1A1A2E)),
        headlineLarge: AppTextStyles.headingLarge.copyWith(color: const Color(0xFF1A1A2E)),
        headlineMedium: AppTextStyles.headingMedium.copyWith(color: const Color(0xFF1A1A2E)),
        headlineSmall: AppTextStyles.headingSmall.copyWith(color: const Color(0xFF1A1A2E)),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: const Color(0xFF1A1A2E)),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF1A1A2E)),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: const Color(0xFF1A1A2E)),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.black54),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      ),
      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.black45),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
