# Session Management Specification

### Requirement: Authenticated users can explicitly close their active session
The system MUST provide a close-session action in authenticated UI and SHALL require explicit user confirmation before ending the session.

#### Scenario: User confirms close session
- **WHEN** an authenticated user opens the close-session prompt and confirms
- **THEN** the system SHALL execute the sign-out flow and transition the user to unauthenticated routes

#### Scenario: User cancels close session
- **WHEN** an authenticated user dismisses or cancels the close-session prompt
- **THEN** the system SHALL keep the current authenticated session active and SHALL NOT trigger sign-out

### Requirement: Close-session flow exposes loading and prevents duplicate requests
The system MUST represent close-session progress and SHALL block repeated sign-out dispatches while an attempt is running.

#### Scenario: Sign-out in progress
- **WHEN** close-session is confirmed and sign-out request is in-flight
- **THEN** the close-session action SHALL be disabled until the request completes

### Requirement: Sign-out failures are surfaced and recoverable
The system MUST preserve session continuity on sign-out failure and SHALL present user-visible localized feedback with retry capability.

#### Scenario: Sign-out fails
- **WHEN** repository sign-out returns a failure
- **THEN** the system SHALL keep the user authenticated, display localized error feedback, and allow another close-session attempt

### Requirement: Successful sign-out relies on auth-state-driven routing
The system MUST use auth session state as the source of truth for route access and SHALL redirect signed-out users to authentication routes.

#### Scenario: Auth state becomes signed out
- **WHEN** sign-out completes and auth state emits no active session
- **THEN** route guard logic SHALL redirect from protected routes to `/auth/sign-in`

### Requirement: Close-session UI copy is localized
The system MUST source close-session labels, confirmation text, and failure feedback from localization resources.

#### Scenario: Spanish locale close-session copy
- **WHEN** app locale is Spanish (`es`) and profile/settings renders close-session controls
- **THEN** action label, confirmation actions, and error feedback SHALL be displayed in Spanish from localization keys

#### Scenario: English locale close-session copy
- **WHEN** app locale is English (`en`) and profile/settings renders close-session controls
- **THEN** action label, confirmation actions, and error feedback SHALL be displayed in English from localization keys
