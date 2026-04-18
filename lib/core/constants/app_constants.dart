/// BravoFlow AI — App-wide Constants
abstract final class AppConstants {
  // ── App Info ───────────────────────────────────────────────────────────────
  static const String appName = 'BravoFlow AI';
  static const String appVersion = '1.0.0';

  // ── Spacing ────────────────────────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ── Border Radius (Luminous Stratum tokens) ───────────────────────────────
  static const double radiusSm = 16.0;
  static const double radiusMd = 24.0;
  static const double radiusLg = 32.0;
  static const double radiusXl = 48.0;
  static const double radiusFull = 9999.0;

  // ── Durations ──────────────────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationDefault = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ── Environment Keys ───────────────────────────────────────────────────────
  static const String envSupabaseUrl = 'SUPABASE_URL';
  static const String envSupabaseAnonKey = 'SUPABASE_ANON_KEY';
}
