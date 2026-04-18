## 1. Session Flow Contracts

- [x] 1.1 Update auth application flow so `signOut` maps repository failures into error state instead of forcing signed-out state
- [x] 1.2 Ensure close-session flow exposes in-flight/loading state to prevent duplicate requests
- [x] 1.3 Normalize failure mapping for user-safe localized messaging

## 2. Profile UX Integration

- [x] 2.1 Add close-session action to `ProfileScreen`
- [x] 2.2 Add confirmation prompt before dispatching sign-out
- [x] 2.3 Disable close-session action while sign-out is in progress
- [x] 2.4 Show localized failure feedback when sign-out fails

## 3. Routing and Session Transition Validation

- [x] 3.1 Verify successful sign-out emits auth-state change that redirects to `/auth/sign-in`
- [x] 3.2 Verify canceling confirmation does not alter auth/session state
- [x] 3.3 Verify failed sign-out does not incorrectly redirect to auth routes

## 4. Localization

- [x] 4.1 Add localization keys for close-session action and confirmation copy (`es`, `en`)
- [x] 4.2 Add localization keys for sign-out loading/failure feedback
- [x] 4.3 Regenerate localization outputs and ensure no hardcoded close-session strings remain

## 5. Quality Gates

- [x] 5.1 Add unit tests for `AuthNotifier.signOut` success/failure transitions
- [x] 5.2 Add widget tests for profile close-session UI + confirmation + error snackbar behavior
- [x] 5.3 Run `dart format .`, `flutter analyze`, and `flutter test`

