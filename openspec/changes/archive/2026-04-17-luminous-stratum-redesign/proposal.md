## Why

The current BravoFlow AI app uses a generic Material 3 dark theme (blue primary, violet secondary, solid borders, dividers, Inter-only typography) that does not match the premium fintech identity the product requires. High-fidelity designs for all 7 core screens have been produced under the **Luminous Stratum** design system and are stored in `stitch_bravoflow_ai_finance_app/`. The app must be redesigned to match these references exactly.

## What Changes

A complete UI redesign covering design tokens, shared components, and all feature screens. **No changes to data layer, business logic, state management, or routing.** The redesign implements:

- **New color token system** — midnight void (`#090d20`) base, neon cyan (`#a1faff`/`#00f4fe`) primary, electric violet (`#bf81ff`) secondary, full Material 3 surface hierarchy
- **Typography overhaul** — Manrope (via google_fonts) for all display/headline text; Inter retained for body and labels
- **Glassmorphism** — `BackdropFilter` + `ImageFilter.blur` with `surface-variant` at 40% opacity, replacing solid card fills
- **Animated AI Aura** — rotating/pulsing gradient border via `CustomPainter` + `AnimationController` on all AI-generated content cards
- **No-border rule** — all `Divider()`, explicit `Border`, and shadow-based elevation removed; containment via tonal layering and whitespace
- **Gradient CTAs** — primary buttons use linear gradient cyan→violet at 135°, `borderRadius: full`
- **All 7 screens reskinned** — Splash, Dashboard, Accounts List, Account Detail, Add/Edit Account, Add Transfer, More/Settings

## Capabilities

### New Capabilities
- `luminous-stratum-theme`: Design token system (colors, gradients, spacing, typography) matching the Luminous Stratum spec
- `glass-components`: Reusable glassmorphism components — GlassCard, AnimatedAuraCard, gradient buttons
- `luminous-screens`: All 7 redesigned screens pixel-faithful to stitch HTML references

### Modified Capabilities
- None — this is a UI-only change; no behavioral requirements change

## Impact

**Files changed:**
- `lib/core/theme/app_colors.dart` — full rewrite with new token set
- `lib/core/theme/app_theme.dart` — full rewrite (no borders, tonal layering, glassmorphism defaults)
- `lib/core/theme/app_gradients.dart` — updated to cyan→violet 135°
- `lib/core/theme/app_text_styles.dart` — Manrope for display/headline, Inter for body
- `lib/core/theme/app_spacing.dart` — new radius tokens (full/xl/lg/md)
- `lib/shared/widgets/app_shell.dart` — glass bottom nav, 4-tab layout matching new labels
- `lib/shared/widgets/gradient_card.dart` — updated to glassmorphism
- `lib/shared/widgets/ai_insight_chip.dart` — animated aura via CustomPainter
- `lib/shared/widgets/glass_card.dart` — **new** reusable glassmorphism container
- `lib/features/dashboard/dashboard_screen.dart` and widgets
- `lib/features/accounts/presentation/screens/` — all 4 screens
- `lib/features/more/presentation/screens/more_screen.dart`
- `lib/features/auth/presentation/screens/` — sign in / sign up styled to new theme
- `pubspec.yaml` — add `flutter_native_splash` dependency

**Dependencies added:**
- `flutter_native_splash` (splash screen with void background + gradient logo)

**No changes to:**
- Data repositories, DTOs, domain entities
- Riverpod providers / notifiers
- GoRouter configuration
- Supabase integration
