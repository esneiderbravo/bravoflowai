## Why

The Sign In and Sign Up screens are visually inconsistent with the rest of the platform. While every other screen in BravoFlow AI applies the Luminous Stratum design system — glassmorphism cards, atmospheric glow orbs, gradient text accents, and `AnimatedAuraCard` highlights — the auth screens still render a plain dark background with a basic text/input layout that feels like a different app.

## What Changes

- Replace the plain `AuthForm` layout with a glassmorphic form container (`GlassCard`) centered on an atmospheric background
- Add ambient glow orbs (decorative `BoxDecoration` radial gradients) to the background, matching the visual energy of the dashboard and other screens
- Wrap the primary action area with an `AnimatedAuraCard` to give the CTA button the platform's signature AI aura treatment
- Apply `ShaderMask` gradient text to the `title` heading on both Sign In and Sign Up
- Add a "Forgot password?" text link (`primaryFixed` color) below the password field in Sign In
- Ensure both screens share the same visual structure through the unified `AuthForm` widget, with no divergent layouts
- Align input decoration styling (filled style, `surfaceContainerHigh` fill color, `primaryFixed` focus border) to match the app-wide input spec from luminous-stratum-theme

## Capabilities

### New Capabilities
- `auth-screen-ui`: Full Luminous Stratum visual redesign of Sign In and Sign Up screens — atmospheric background, glass form container, animated aura CTA, gradient heading, forgot-password entry point, and consistent filled-input styling

### Modified Capabilities
- `luminous-screens`: Auth Screens section updated to reflect the full glassmorphic layout spec (atmospheric orbs, `AnimatedAuraCard` CTA wrapper, gradient title, forgot-password link, filled inputs with `primaryFixed` focus ring)

## Impact

- `lib/features/auth/presentation/widgets/auth_form.dart` — primary change: new layout with orbs, glass container, aura CTA
- `lib/features/auth/presentation/screens/sign_in_screen.dart` — adds forgot-password link; no logic change
- `lib/features/auth/presentation/screens/sign_up_screen.dart` — minor field/spacing alignment; no logic change
- No changes to auth logic, Supabase integration, routing, or state management
- No new dependencies required (all design primitives already exist: `GlassCard`, `AnimatedAuraCard`, `GradientButton`, `GhostButton`)
