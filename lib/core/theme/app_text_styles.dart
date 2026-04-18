import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// BravoFlow AI — Luminous Stratum Typography Tokens
///
/// Headlines / Display → Manrope (geometric, editorial authority)
/// Body / Labels       → Inter  (high-legibility workhorse)
abstract final class AppTextStyles {
  // ── Display (Manrope) ─────────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.manrope(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );

  static TextStyle get displayMedium => GoogleFonts.manrope(
    fontSize: 45,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  // ── Headlines (Manrope) ───────────────────────────────────────────────────
  static TextStyle get headingLarge => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get headingMedium => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get headingSmall => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get titleLarge => GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get titleMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
  );

  // ── Body (Inter) ──────────────────────────────────────────────────────────
  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  // ── Labels (Inter) ────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.onSurface,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
  );

  // ── AI / Accent ────────────────────────────────────────────────────────────
  static TextStyle get aiLabel => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: AppColors.primaryFixed,
  );
}
