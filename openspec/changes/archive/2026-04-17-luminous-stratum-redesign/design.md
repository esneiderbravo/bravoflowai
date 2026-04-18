# Design: luminous-stratum-redesign

## Architecture Overview

This is a **UI-only** change. The existing layered architecture (data / domain / application / presentation) is preserved. All changes are confined to:
1. `lib/core/theme/` — design tokens
2. `lib/shared/widgets/` — shared components
3. `lib/features/*/presentation/` — screens and feature widgets

```
lib/
├── core/
│   └── theme/                    ← REWRITE
│       ├── app_colors.dart
│       ├── app_gradients.dart
│       ├── app_spacing.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
│
├── shared/
│   └── widgets/                  ← UPDATE + ADD
│       ├── app_shell.dart        (redesigned bottom nav)
│       ├── glass_card.dart       (NEW)
│       ├── animated_aura_card.dart (NEW)
│       ├── gradient_button.dart  (UPDATE existing or new)
│       ├── ghost_button.dart     (NEW)
│       ├── jeweled_icon.dart     (NEW)
│       ├── gradient_card.dart    (UPDATE)
│       ├── ai_insight_chip.dart  (UPDATE → uses AnimatedAuraCard)
│       └── loading_overlay.dart  (UPDATE colors only)
│
└── features/
    ├── auth/presentation/screens/   ← RESKIN
    ├── dashboard/
    │   ├── dashboard_screen.dart    ← RESKIN
    │   └── presentation/widgets/    ← RESKIN
    ├── accounts/presentation/
    │   └── screens/                 ← RESKIN (all 4)
    ├── more/presentation/screens/   ← RESKIN
    └── ai_insights/                 ← RESKIN
```

---

## Design Decisions

### DD-1: Token Layer as Single Source of Truth
All colors, gradients, spacing, and radii are accessed only through `AppColors`, `AppGradients`, and `AppSpacing`. No hardcoded hex values in any widget or screen file. This ensures theme consistency and enables future light-mode support.

### DD-2: GlassCard as the Universal Container
The existing `Card` widget is removed from all usage. `GlassCard` becomes the standard container for all content areas. This enforces the glassmorphism language consistently without per-screen implementation.

### DD-3: AnimatedAuraCard via CustomPainter
The rotating gradient aura is implemented as a `CustomPainter` that draws a 2px gradient stroke along the card perimeter. The painter receives an `Animation<double>` (0.0–1.0, representing full rotation) and computes the gradient's start angle. A separate `CurvedAnimation` drives the opacity pulse on a sine curve.

```
AuraPainter
  ├── _rotationAnimation: 0→1, linear, 3s repeat → rotates gradient startAngle
  └── _pulseAnimation: 0→1, sine curve, 2s repeat → opacity 0.4→0.7
```

### DD-4: No Divider Policy — Enforced at Theme Level
`ThemeData.dividerTheme` is set with `thickness: 0, space: 0, color: Colors.transparent`. This silences any accidental `Divider()` usage. List item separation uses explicit `SizedBox(height: 16)` gaps.

### DD-5: Manrope via GoogleFonts
`GoogleFonts.manrope(...)` is used directly in `AppTextStyles` for display/headline styles. `GoogleFonts.inter(...)` for body/label. No `pubspec.yaml` asset font entries needed.

### DD-6: flutter_native_splash for Splash
The splash configuration is in `pubspec.yaml` under the `flutter_native_splash` key. Run `dart run flutter_native_splash:create` post-config. No Flutter route for splash — the native layer handles it while the app initializes.

### DD-7: AppShell Routing Stays Unchanged
The 4 bottom nav tabs map to existing routes: `/dashboard`, `/transactions`, `/ai`, `/more`. Only the visual presentation of the nav bar changes — no router modifications needed.

### DD-8: Light Theme Preserved but Dark is Default
`main.dart` keeps `themeMode: ThemeMode.dark`. The light theme in `AppTheme.lightTheme` is updated to use consistent token names but remains a fallback for system override scenarios.

---

## Component Hierarchy

```
AppShell (glass bottom nav)
└── [active tab]
    ├── DashboardScreen
    │   ├── GlassTopAppBar
    │   ├── AccountsHorizontalScroll
    │   │   └── AccountGlassCard (× n)
    │   ├── AnimatedAuraCard  ← AI Insights
    │   └── QuickActionsGrid
    │       └── QuickActionTile (× 4)
    │
    ├── TransactionListScreen (Flow tab)
    │   └── TransactionTile (no Divider)
    │
    ├── AiInsightsScreen (Bravo AI tab)
    │   └── AnimatedAuraCard (× n)
    │
    └── MoreScreen
        ├── ProfileHero
        └── SettingsGroup (× 3)
            └── SettingsTile (JeweledIcon + chevron)
```

---

## Glassmorphism Flutter Implementation Pattern

```dart
// GlassCard core pattern
ClipRRect(
  borderRadius: BorderRadius.circular(borderRadius),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: child,
    ),
  ),
)
```

---

## Gradient Text Pattern

```dart
// Used for app title, hero balances, section labels
ShaderMask(
  shaderCallback: (bounds) => AppGradients.aiGradient.createShader(bounds),
  child: Text('BravoFlow AI', style: TextStyle(color: Colors.white)),
)
```

---

## Risks

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| BackdropFilter performance on mid-range Android | Medium | Test on API 28 emulator; provide opaque fallback if `isLowEndDevice` |
| Manrope font not loading offline | Low | GoogleFonts caches fonts after first load; acceptable for MVP |
| AnimatedAuraCard jank if many cards on screen | Low | Limit to 1 aura per screen; others use static GlassCard |
| flutter_native_splash Android 12 adaptive icon | Low | Follow package docs for `android_12` configuration |
