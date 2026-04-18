import 'package:flutter/material.dart';

/// BravoFlow AI — Luminous Stratum Design System Color Tokens
abstract final class AppColors {
  // ── Surface Hierarchy ─────────────────────────────────────────────────────
  static const Color surface = Color(0xFF090D20);
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow = Color(0xFF0D1227);
  static const Color surfaceContainer = Color(0xFF13182F);
  static const Color surfaceContainerHigh = Color(0xFF191E37);
  static const Color surfaceContainerHighest = Color(0xFF1E2440);
  static const Color surfaceBright = Color(0xFF242A48);
  static const Color surfaceVariant = Color(0xFF1E2440);
  static const Color surfaceDim = Color(0xFF090D20);

  // ── Brand Accents ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFA1FAFF);
  static const Color primaryFixed = Color(0xFF00F4FE);
  static const Color primaryFixedDim = Color(0xFF00E5EE);
  static const Color primaryDim = Color(0xFF00E5EE);
  static const Color secondary = Color(0xFFBF81FF);
  static const Color secondaryFixed = Color(0xFFE4C6FF);
  static const Color secondaryFixedDim = Color(0xFFDAB4FF);
  static const Color secondaryDim = Color(0xFF9C42F4);
  static const Color secondaryContainer = Color(0xFF7701D0);
  static const Color tertiary = Color(0xFF64B3FF);
  static const Color tertiaryFixed = Color(0xFF6BB6FF);
  static const Color tertiaryFixedDim = Color(0xFF49A8FC);

  // ── Text / On-Surface ─────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFFE1E4FF);
  static const Color onSurfaceVariant = Color(0xFFA7AAC3);
  static const Color onPrimary = Color(0xFF006165);
  static const Color onSecondary = Color(0xFF32005C);
  static const Color onTertiary = Color(0xFF003053);
  static const Color inverseSurface = Color(0xFFFBF8FF);
  static const Color inverseOnSurface = Color(0xFF50546A);

  // ── System ────────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF71748C);
  static const Color outlineVariant = Color(0xFF43475C);
  static const Color error = Color(0xFFFF716C);
  static const Color errorContainer = Color(0xFF9F0519);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // ── Ambient Glow ─────────────────────────────────────────────────────────
  static List<BoxShadow> aiGlow([Color? color]) => [
    BoxShadow(
      color: (color ?? primaryFixed).withValues(alpha: 0.20),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Ambient shadow for floating elements (bottom sheets, modals).
  static List<BoxShadow> ambientShadow() => [
    BoxShadow(
      color: onSurface.withValues(alpha: 0.05),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
  ];

  // ── Backward-Compat Aliases (remove after Phase 3 complete) ───────────────
  static const Color backgroundDark = surface;
  static const Color surfaceDark = surfaceContainer;
  static const Color cardDark = surfaceContainerHigh;
  static const Color primaryBlue = primaryFixed;
  static const Color violetAI = secondary;
  static const Color accentCyan = primaryFixed;
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textDisabled = outline;
}
