import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// BravoFlow AI — Typography Tokens
abstract final class AppTextStyles {
  // ── Display ────────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  // ── Headings ───────────────────────────────────────────────────────────────
  static TextStyle get headingLarge => GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get headingMedium => GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get headingSmall => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600);

  // ── Body ───────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400);

  // ── Labels ─────────────────────────────────────────────────────────────────
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ── AI / Accent ────────────────────────────────────────────────────────────
  static TextStyle get aiLabel => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.violetAI,
    letterSpacing: 1.0,
  );
}
