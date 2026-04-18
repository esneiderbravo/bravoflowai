# Tasks: luminous-stratum-redesign

## Phase 1 — Design Tokens

- [x] **Rewrite `app_colors.dart`**  
  Replace all existing tokens with the full Luminous Stratum palette. Add all surface hierarchy tokens, brand accents, text tokens, outline tokens. Remove old blue/violet tokens.

- [x] **Rewrite `app_text_styles.dart`**  
  Introduce Manrope via `GoogleFonts.manrope()` for all display/headline styles. Keep Inter for body/label. Update the full scale (displayLarge → labelSmall) per spec table.

- [x] **Update `app_spacing.dart`**  
  Add `radiusFull` (9999), `radiusXl` (48), `radiusLg` (32), `radiusMd` (24), `radiusSm` (16). Remove old radius values.

- [x] **Rewrite `app_gradients.dart`**  
  Update primary gradient to 135°, `primaryFixed` → `secondary`. Add `aiGradientShader()` helper for `ShaderMask` usage.

- [x] **Rewrite `app_theme.dart`**  
  Dark theme: new color scheme, no elevation, `dividerTheme` silenced (transparent), card theme uses `surfaceContainerHigh`, input fields use `surfaceContainerHigh` fill + `radiusMd`. Light theme: update token names as fallback.

---

## Phase 2 — Shared Components

- [x] **Create `glass_card.dart`**  
  `GlassCard` widget: `ClipRRect` → `BackdropFilter(blur 12)` → `Container` with `surfaceVariant@40%` + ghost border. Accept `borderRadius`, `padding`, `backgroundColor` params.

- [x] **Create `animated_aura_card.dart`**  
  `AnimatedAuraCard` widget: `Stack` with `AuraPainter` (rotation + pulse `AnimationController`) behind a `GlassCard` inset by 2px. Dispose controller on unmount.

- [x] **Create `gradient_button.dart`**  
  `GradientButton` widget: `InkWell` with press-scale 0.95, gradient container, `radiusFull`, `primaryFixed` glow `BoxShadow`.

- [x] **Create `ghost_button.dart`**  
  `GhostButton` widget: transparent bg, `outline@20%` border, `radiusFull`.

- [x] **Create `jeweled_icon.dart`**  
  `JeweledIcon` widget: circle container `surfaceContainerHighest`, 8px padding, icon inside with accent color param.

- [x] **Redesign `app_shell.dart`**  
  Replace bottom nav: glass background (`surface@90%` + blur 24), `radiusXl` top corners, ambient top shadow, 4 tabs (Home/Flow/Bravo AI/More), active pill indicator, label style Manrope uppercase.

- [x] **Update `ai_insight_chip.dart`**  
  Refactor to use `AnimatedAuraCard` as container. Update internal layout to match dashboard design (gradient avatar, insight text, 3 pill action buttons).

- [x] **Update `gradient_card.dart`**  
  Update to use `GlassCard` internally with gradient overlay. Keep backward-compatible API.

- [x] **Update `loading_overlay.dart`**  
  Update spinner/background colors to new tokens.

---

## Phase 3 — Screen Redesigns

- [x] **`dashboard_screen.dart` + widgets**  
  Implement all 5 sections per spec: glass TopAppBar, greeting, accounts horizontal scroll (AccountGlassCard), AI insights (AnimatedAuraCard), quick actions grid (QuickActionTile with JeweledIcon).

- [x] **`accounts_screen.dart`**  
  Editorial net worth header, GlassCard account list items with JeweledIcon, ghost border cards, FAB/add button as GradientButton.

- [x] **`account_detail_screen.dart`**  
  Balance hero GlassCard, transaction history list (no Divider, 16px gaps), GradientButton for transfer CTA.

- [x] **`add_edit_account_screen.dart`**  
  Form with filled inputs per new InputDecorationTheme, focus border transitions, GradientButton save CTA.

- [x] **`add_transfer_screen.dart`**  
  Two GlassCard account selectors with swap icon, large amount input in displayMedium, GradientButton confirm.

- [x] **`more_screen.dart`**  
  Profile hero section, 3 settings groups (no Divider, JeweledIcon tiles), ghost sign-out button in error color.

- [x] **`sign_in_screen.dart` + `sign_up_screen.dart`**  
  Dark background, gradient wordmark, filled inputs, GradientButton CTA, ghost switch-mode button.

---

## Phase 4 — Splash & Polish

- [x] **Add `flutter_native_splash` dependency**  
  Add to `pubspec.yaml`. Configure `color: "#090d20"` and splash logo asset. Run `dart run flutter_native_splash:create`.

- [x] **Add splash logo asset**  
  Create/export `assets/images/splash_logo.png` from the app icon design (screen_0 reference).

- [x] **Verify no hardcoded hex values remain**  
  Search for `Color(0xFF` and `Color.fromARGB` in `lib/features/` and `lib/shared/` to confirm all colors use `AppColors` tokens.

- [x] **Verify no Divider widgets remain**  
  Search for `Divider()` and `VerticalDivider()` in all Dart files.

- [x] **Run `flutter analyze`**  
  Fix any warnings or errors introduced by the redesign.

- [x] **Smoke test on iOS Simulator and Android Emulator**  
  Verify glassmorphism blur renders, aura animates, gradient text clips correctly, bottom nav active states work, all 7 screens load without errors.
