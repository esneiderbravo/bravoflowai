## 1. Restructure More Screen Layout

- [x] 1.1 Wrap the existing profile hero `GlassCard` in a `GestureDetector` and call `context.go('/profile')` on tap
- [x] 1.2 Add a trailing chevron icon to the profile hero card to signal it is tappable
- [x] 1.3 Remove the `GhostButton` sign-out button from `more_screen.dart`

## 2. Add Preferences Section

- [x] 2.1 Add a `_SectionLabel('Preferences')` (or localized equivalent) above the new preference tiles
- [x] 2.2 Add a Language `_SettingsTile` (icon: `Icons.language_outlined`) that calls `context.go('/profile')` on tap
- [x] 2.3 Add a Theme `_SettingsTile` (icon: `Icons.dark_mode_outlined`) that calls `context.go('/profile')` on tap

## 3. Localization

- [x] 3.1 Add localization keys for "Preferences" section label, "Language", and "Theme" tile labels in both `en` and `es` ARB files (if not already present)
- [x] 3.2 Run `flutter gen-l10n` to regenerate localization files and verify new keys compile without errors

## 4. Validation

- [x] 4.1 Verify tapping the profile card navigates to `/profile` with the bottom nav shell intact
- [x] 4.2 Verify the More screen no longer shows any sign-out button
- [x] 4.3 Verify Language and Theme tiles appear under the Preferences section and navigate to `/profile`
- [x] 4.4 Verify the Finance / Accounts tile still works and navigates to `/more/accounts`
- [x] 4.5 Run `flutter analyze` and resolve any warnings introduced by the changes
