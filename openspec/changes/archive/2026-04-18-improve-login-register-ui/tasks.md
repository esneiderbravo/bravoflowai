## 1. Input Decoration Alignment

- [x] 1.1 Update all `TextFormField` decorations in `auth_form.dart` (or passed from sign-in/sign-up screens) to use `InputDecoration` with `filled: true`, `fillColor: AppColors.surfaceContainerHigh`, no border at rest, and `focusedBorder` with a 1.5px `primaryFixed` border
- [x] 1.2 Remove any remaining hardcoded colors or border styles from input fields in `sign_in_screen.dart` and `sign_up_screen.dart`

## 2. AuthForm Layout Redesign

- [x] 2.1 Wrap the `AuthForm` `Scaffold` body in a `Stack` to allow positioning of atmospheric background orbs beneath the scrollable content
- [x] 2.2 Add 2–3 `Positioned` decorative `Container` widgets with `BoxDecoration` radial gradients using `AppColors.primaryFixed` and `AppColors.secondary` at ≤ 0.12 opacity as background orbs
- [x] 2.3 Wrap the heading, fields, CTA, and footer section inside a `GlassCard` widget with `padding: EdgeInsets.all(AppSpacing.lg)`; keep the logo and wordmark outside and above the card
- [x] 2.4 Replace the plain `Text(title, style: AppTextStyles.headingLarge)` with a `ShaderMask`-wrapped `Text` applying the AI gradient (`primaryFixed` → `secondary`, 135°) to the title
- [x] 2.5 Wrap the `GradientButton` submit CTA inside an `AnimatedAuraCard` within the `GlassCard`

## 3. Forgot Password Entry Point (Sign In)

- [x] 3.1 Add a right-aligned `TextButton` labelled "Forgot password?" below the password `TextFormField` in `sign_in_screen.dart`, styled with `AppColors.primaryFixed` foreground color
- [x] 3.2 Implement the tap handler to show a `SnackBar` with text "Coming soon" (placeholder — no navigation or backend call)

## 4. Visual QA & Token Compliance

- [x] 4.1 Verify neither `sign_in_screen.dart` nor `sign_up_screen.dart` nor `auth_form.dart` contains hardcoded hex color values; all colors reference `AppColors` tokens
- [x] 4.2 Confirm both screens scroll correctly when the software keyboard is open (glass card content remains accessible)
- [x] 4.3 Confirm `AnimatedAuraCard` animation disposes correctly when navigating away from the auth screens (no memory leaks)
- [x] 4.4 Run `flutter analyze` and resolve any new warnings introduced by the changes
