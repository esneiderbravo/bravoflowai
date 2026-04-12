/// BravoFlow AI — Spacing & Layout Tokens
///
/// Centralized spacing constants used for margins, paddings, gaps, and
/// border radii throughout the application.  No magic numbers in widgets —
/// always reference a token from this class.
abstract final class AppSpacing {
  // ── Base Spacing ────────────────────────────────────────────────────────────

  /// 4dp — micro gap, icon-text separation.
  static const double xs = 4;

  /// 8dp — compact inner padding, list-item gap.
  static const double sm = 8;

  /// 16dp — base layout unit, section inner padding.
  static const double md = 16;

  /// 24dp — section separator, large inner padding.
  static const double lg = 24;

  /// 32dp — screen-level margin, hero sections.
  static const double xl = 32;

  // ── Border Radius ───────────────────────────────────────────────────────────

  /// 8dp — chips, badges, small containers.
  static const double radiusSm = 8;

  /// 12dp — buttons, text-fields, input fields.
  static const double radiusMd = 12;

  /// 16dp — cards, surface containers.
  static const double radiusLg = 16;

  /// 24dp — bottom sheets, dialogs, hero cards.
  static const double radiusXl = 24;
}
