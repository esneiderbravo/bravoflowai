## MODIFIED Requirements

### Requirement: Auth screens visual layout matches Luminous Stratum design system
The auth screens (Sign In and Sign Up) SHALL implement the full Luminous Stratum visual language: atmospheric glow orbs in the background, a `GlassCard` container wrapping the form, an `AnimatedAuraCard` around the primary submit CTA, gradient `ShaderMask` treatment on the form title heading, filled input decoration with `primaryFixed` focus color, and a "Forgot password?" entry point (Sign In only). The logo and gradient wordmark SHALL float above the glass card outside of it.

#### Scenario: Sign In screen matches Luminous Stratum design
- **WHEN** the user navigates to the Sign In screen
- **THEN** the screen SHALL display: atmospheric orbs on the `surface` (#090d20) background, a centered logo and gradient BravoFlow AI wordmark above the glass card, a `GlassCard` containing the gradient-titled heading, filled email and password inputs, a "Forgot password?" right-aligned link below the password field, and a `GradientButton` wrapped in an `AnimatedAuraCard` as the submit CTA

#### Scenario: Sign Up screen matches Luminous Stratum design
- **WHEN** the user navigates to the Sign Up screen
- **THEN** the screen SHALL display: atmospheric orbs on the `surface` (#090d20) background, a centered logo and gradient BravoFlow AI wordmark above the glass card, a `GlassCard` containing the gradient-titled heading, filled name, email, and password inputs, and a `GradientButton` wrapped in an `AnimatedAuraCard` as the submit CTA

#### Scenario: Auth screens use only AppColors tokens
- **WHEN** the auth screens are rendered
- **THEN** all color values SHALL reference `AppColors` tokens — no hardcoded hex values SHALL appear in auth screen widgets
