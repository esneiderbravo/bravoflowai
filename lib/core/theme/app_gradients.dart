import 'package:flutter/material.dart';

import 'app_colors.dart';

/// BravoFlow AI — Gradient Tokens
///
/// All gradient definitions are centralised here.  Never declare a
/// [LinearGradient] inline in widget code — always reference a token.
abstract final class AppGradients {
  // ── Brand ──────────────────────────────────────────────────────────────────

  /// Primary AI gradient: primaryBlue → violetAI → accentCyan.
  ///
  /// Used for hero sections, AI badges, and call-to-action elements.
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primaryBlue, AppColors.violetAI, AppColors.accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Background ─────────────────────────────────────────────────────────────

  /// Subtle full-screen background gradient: backgroundDark → surfaceDark.
  static const LinearGradient background = LinearGradient(
    colors: [AppColors.backgroundDark, AppColors.surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
