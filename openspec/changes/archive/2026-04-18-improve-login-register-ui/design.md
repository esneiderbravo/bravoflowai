## Context

The BravoFlow AI app implements the "Luminous Stratum" design system across all screens: deep void backgrounds (`#090d20`), glassmorphic cards, atmospheric glow orbs, `AnimatedAuraCard` for key interactive elements, and gradient text clips for headings. The auth screens (Sign In / Sign Up) predate this system and were not updated during the initial redesign pass. They currently render a plain dark `Scaffold` with a centered logo and basic form fields — functional but visually disconnected from the platform.

The `AuthForm` widget is the single shared layout component for both screens. All UI changes should flow through it to maintain the single-source-of-truth pattern already in place.

Existing design primitives are available and require no new dependencies:
- `GlassCard` — frosted glass container
- `AnimatedAuraCard` — rotating gradient border card
- `GradientButton` — primary CTA
- `GhostButton` — secondary text action
- `AppColors`, `AppSpacing`, `AppTextStyles` — full token system

## Goals / Non-Goals

**Goals:**
- Bring auth screens visually in line with every other Luminous Stratum screen
- Add atmospheric background (decorative radial glow orbs) to auth screens
- Wrap the form content in a `GlassCard` container for depth and glassmorphism consistency
- Apply animated AI aura (`AnimatedAuraCard`) around the submit button for emphasis
- Add gradient `ShaderMask` treatment to the form's title heading
- Introduce a "Forgot password?" entry point in Sign In (UI only — no backend plumbing in scope)
- Align `TextFormField` input decoration (filled style, `surfaceContainerHigh` fill, `primaryFixed` focus color) to match the app-wide input spec

**Non-Goals:**
- Password reset flow implementation (backend / Supabase integration)
- Social login / OAuth buttons
- Animated page transitions between Sign In and Sign Up
- Changes to auth logic, validation rules, or error handling
- Changes to routing or navigation

## Decisions

### 1. Atmospheric orbs via `Stack` + `Positioned` in `AuthForm`

**Decision:** Add 2–3 decorative radial-gradient circles (`Container` with `BoxDecoration`) as `Positioned` children in a `Stack` at the root of `AuthForm`, beneath the scrollable form content.

**Rationale:** This mirrors how the dashboard achieves its atmospheric look (blur-filtered orbs behind content). Using `Stack` + `Positioned` keeps the decoration non-intrusive and removes it from the layout flow. Implementing in `AuthForm` applies it to both screens at once.

**Alternative considered:** Custom `CustomPainter` for orbs — rejected as overly complex for a static decorative effect.

### 2. `GlassCard` wraps the entire form body

**Decision:** The logo/wordmark section remains outside the glass card (above it), while the heading, fields, CTA, and footer live inside a `GlassCard` with `padding: EdgeInsets.all(AppSpacing.lg)`.

**Rationale:** Matches the visual pattern of the account add/edit and other form screens where input groups are contained in a glass surface. The logo floating above gives depth and breathing room.

**Alternative considered:** Full-screen glass tint — rejected as it reduces legibility and loses the atmospheric effect behind the card.

### 3. `AnimatedAuraCard` wraps only the `GradientButton`

**Decision:** Wrap the submit `GradientButton` in an `AnimatedAuraCard` rather than the whole form card.

**Rationale:** The aura is most impactful on the primary CTA. Wrapping the full card would create visual noise and slow down the screen. The existing AI Insights section uses this same focused pattern.

**Alternative considered:** No aura on auth — rejected as it makes the screens feel static compared to the rest of the app.

### 4. Gradient heading via `ShaderMask` in `AuthForm.title`

**Decision:** Apply the app's standard AI gradient (`primaryFixed` → `secondary`, 135°) via `ShaderMask` to the `title` text in `AuthForm`, replacing the plain `AppTextStyles.headingLarge` style.

**Rationale:** Dashboard, accounts, and more screens all use gradient text for prominent headings. The auth screens are the user's first impression of the app — gradient treatment is appropriate here.

### 5. Forgot password as inline `GhostButton`-style text link

**Decision:** Add a right-aligned `TextButton` with `primaryFixed` color beneath the password field in `sign_in_screen.dart`. Tapping it shows a `SnackBar` with "Coming soon" (placeholder).

**Rationale:** The entry point should exist in the UI to complete the design. Backend implementation is a separate change. Using a `TextButton` with brand color matches the ghost-link pattern.

## Risks / Trade-offs

- [`AnimatedAuraCard` performance] → The animation runs a continuous rotation. On lower-end devices this may cause mild battery drain. Mitigation: `AnimatedAuraCard` already handles `dispose()` correctly; this risk is no different from its existing use in Dashboard.
- [Form card scroll behavior] → Wrapping content in `GlassCard` inside `SingleChildScrollView` must not clip the card's backdrop blur. Mitigation: ensure `GlassCard` is a direct child of the scroll view column, not inside a `ClipRRect` at scroll level.
- [Keyboard overlap] → The glass card form must remain scrollable when the software keyboard appears. The existing `SingleChildScrollView` handles this; no additional change needed.
