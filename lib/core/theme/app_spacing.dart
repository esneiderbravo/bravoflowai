/// BravoFlow AI — Luminous Stratum Spacing & Layout Tokens
///
/// No magic numbers in widgets — always reference a token from this class.
abstract final class AppSpacing {
  // ── Base Spacing ───────────────────────────────────────────────────────────
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

  /// 48dp — hero spacing, xxl sections.
  static const double xxl = 48;

  // ── Border Radius ──────────────────────────────────────────────────────────
  /// 16dp — small elements, tags.
  static const double radiusSm = 16;

  /// 24dp — input fields, action buttons.
  static const double radiusMd = 24;

  /// 32dp — standard cards (2rem).
  static const double radiusLg = 32;

  /// 48dp — glass cards, modals, bottom nav top edge (3rem).
  static const double radiusXl = 48;

  /// 9999dp — buttons, pills, fully-rounded chips.
  static const double radiusFull = 9999;
}
