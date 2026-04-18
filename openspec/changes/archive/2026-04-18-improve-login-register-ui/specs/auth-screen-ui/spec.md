## ADDED Requirements

### Requirement: Auth screens display atmospheric background orbs
The system SHALL render 2–3 decorative radial-gradient glow circles positioned behind the form content on both Sign In and Sign Up screens, using `primaryFixed` and `secondary` colors at low opacity (≤ 0.12) to match the platform's atmospheric depth.

#### Scenario: Background orbs visible on Sign In
- **WHEN** the user opens the Sign In screen
- **THEN** the screen SHALL display at least two ambient glow orbs behind the form, using `primaryFixed` and `secondary` color stops at low opacity

#### Scenario: Background orbs visible on Sign Up
- **WHEN** the user opens the Sign Up screen
- **THEN** the screen SHALL display at least two ambient glow orbs behind the form, using `primaryFixed` and `secondary` color stops at low opacity

#### Scenario: Orbs do not interfere with form interaction
- **WHEN** the user taps any input field or button on the auth screens
- **THEN** the orbs SHALL NOT intercept touch events or obscure any interactive element

---

### Requirement: Auth form is wrapped in a glassmorphic container
The system SHALL wrap the heading, form fields, submit CTA, and footer link inside a `GlassCard` widget on both Sign In and Sign Up screens, providing a frosted-glass surface (12σ backdrop blur, `surfaceVariant` at 40% opacity, ghost border at 15% opacity) that visually separates the form from the background orbs.

#### Scenario: Glass card visible on Sign In
- **WHEN** the user views the Sign In screen
- **THEN** a frosted-glass card SHALL contain the title, email field, password field, submit button, and sign-up footer link

#### Scenario: Glass card visible on Sign Up
- **WHEN** the user views the Sign Up screen
- **THEN** a frosted-glass card SHALL contain the title, name field, email field, password field, submit button, and sign-in footer link

#### Scenario: Glass card scrolls with keyboard
- **WHEN** the user focuses an input field and the software keyboard appears
- **THEN** the glass card SHALL remain fully scrollable and no field SHALL be permanently hidden behind the keyboard

---

### Requirement: Auth form title uses gradient text treatment
The system SHALL render the `title` text on both Sign In and Sign Up screens with a `ShaderMask` applying the AI gradient (`primaryFixed` → `secondary`, 135°), matching the gradient heading pattern used across the platform.

#### Scenario: Gradient title on Sign In
- **WHEN** the user opens the Sign In screen
- **THEN** the "Welcome back" heading SHALL display with the AI gradient (`primaryFixed` → `secondary`)

#### Scenario: Gradient title on Sign Up
- **WHEN** the user opens the Sign Up screen
- **THEN** the "Create account" heading SHALL display with the AI gradient (`primaryFixed` → `secondary`)

---

### Requirement: Auth submit button uses AnimatedAuraCard treatment
The system SHALL wrap the primary submit `GradientButton` on both auth screens in an `AnimatedAuraCard`, giving it a continuously rotating gradient border aura (3s rotation cycle, `primaryFixed` → `secondary`) consistent with primary CTAs elsewhere in the app.

#### Scenario: Aura animates on Sign In
- **WHEN** the Sign In screen is visible
- **THEN** the "Sign In" button SHALL have an animated rotating gradient border aura

#### Scenario: Aura animates on Sign Up
- **WHEN** the Sign Up screen is visible
- **THEN** the "Sign Up" button SHALL have an animated rotating gradient border aura

#### Scenario: Aura does not animate when loading
- **WHEN** a sign-in or sign-up submission is in progress
- **THEN** the button SHALL display a loading indicator and the aura border SHALL continue animating

---

### Requirement: Auth input fields use filled style with primaryFixed focus color
The system SHALL style all `TextFormField` widgets on the auth screens with the filled input decoration variant: `surfaceContainerHigh` fill color, no border at rest, and a `primaryFixed` focused border, matching the input style defined in the luminous-stratum-theme spec.

#### Scenario: Input fill color matches design system
- **WHEN** the user views any auth input field in its default (unfocused) state
- **THEN** the field background SHALL use `AppColors.surfaceContainerHigh` and SHALL display no border

#### Scenario: Focused input shows primaryFixed border
- **WHEN** the user taps and focuses any auth input field
- **THEN** the field SHALL display a 1.5px border in `AppColors.primaryFixed` color

---

### Requirement: Sign In screen provides a Forgot Password entry point
The system SHALL display a right-aligned "Forgot password?" text link below the password field on the Sign In screen, styled in `AppColors.primaryFixed`.

#### Scenario: Forgot password link visible
- **WHEN** the user views the Sign In screen
- **THEN** a "Forgot password?" link SHALL be visible below the password field, right-aligned, in `primaryFixed` color

#### Scenario: Forgot password tap shows placeholder
- **WHEN** the user taps the "Forgot password?" link
- **THEN** the system SHALL display a snackbar message indicating the feature is coming soon (placeholder, no navigation or backend call)
