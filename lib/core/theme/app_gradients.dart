import 'package:flutter/material.dart';

import 'app_colors.dart';

/// BravoFlow AI — Luminous Stratum Gradient Tokens
///
/// All gradient definitions are centralized here.  Never declare a
/// [LinearGradient] inline in widget code — always reference a token.
abstract final class AppGradients {
  // ── The AI Gradient ───────────────────────────────────────────────────────
  /// Primary AI gradient: neon cyan → electric violet at 135°.
  ///
  /// Used for: primary CTAs, hero text clips, aura borders, splash logo,
  /// verified badges, and any "digital energy" moment.
  static const LinearGradient ai = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment(-0.7071, -0.7071), // 135° in Flutter alignment space
    end: Alignment(0.7071, 0.7071),
  );

  /// Same gradient at full-opacity for solid fills (buttons, badges).
  static const LinearGradient aiSolid = LinearGradient(
    colors: [AppColors.primaryFixed, AppColors.secondary],
    begin: Alignment(-0.7071, -0.7071),
    end: Alignment(0.7071, 0.7071),
  );

  // ── Background ────────────────────────────────────────────────────────────
  /// Subtle full-screen background: surface → surfaceContainerLow.
  static const LinearGradient background = LinearGradient(
    colors: [AppColors.surface, AppColors.surfaceContainerLow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Helpers ───────────────────────────────────────────────────────────────
  /// Returns a [Shader] from [aiSolid] sized to [bounds].
  /// Use with [ShaderMask] to clip gradient over text or icons.
  static Shader aiGradientShader(Rect bounds) => aiSolid.createShader(bounds);

  // ── Backward-compat alias ─────────────────────────────────────────────────
  static const LinearGradient primary = ai;
}
