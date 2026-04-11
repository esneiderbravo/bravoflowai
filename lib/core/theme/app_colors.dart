import 'package:flutter/material.dart';

/// BravoFlow AI — Design System Color Tokens
abstract final class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0B132B);
  static const Color surfaceDark = Color(0xFF131D35);
  static const Color cardDark = Color(0xFF1A2540);

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF3A86FF);
  static const Color violetAI = Color(0xFF7B61FF);
  static const Color accentCyan = Color(0xFF00D4FF);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF4B5563);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, violetAI, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Glow / AI Accent ───────────────────────────────────────────────────────
  static List<BoxShadow> aiGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
}

