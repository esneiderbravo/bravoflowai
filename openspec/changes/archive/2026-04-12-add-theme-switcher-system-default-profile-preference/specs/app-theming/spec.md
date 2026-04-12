## ADDED Requirements

### Requirement: Users can choose app theme mode
The system MUST allow authenticated users to select and save a theme preference with supported values `system`, `dark`, and `light` from profile/settings.

#### Scenario: Save selected theme preference
- **WHEN** a user selects a theme mode and saves profile changes successfully
- **THEN** the system SHALL persist the selected value and return it in the updated profile payload

### Requirement: App applies persisted theme preference on startup
The system MUST load the user theme preference at session bootstrap and SHALL apply it to the root app theme configuration.

#### Scenario: Existing user with saved preference
- **WHEN** an authenticated session starts and profile contains `theme_mode = dark`
- **THEN** the app SHALL render using dark theme mode without requiring manual reselection

#### Scenario: Missing or invalid preference fallback
- **WHEN** profile theme preference is missing, null-equivalent, or unsupported
- **THEN** the app SHALL fallback to `system` theme mode

### Requirement: Theme changes commit only after successful profile update
The system MUST treat theme selection as draft UI state until profile save succeeds.

#### Scenario: Update fails
- **WHEN** a user selects a new theme mode but profile update request fails
- **THEN** the global app theme SHALL remain at the previously persisted mode and the user SHALL receive an error message

### Requirement: All app screens honor active theme mode
The system MUST render shell, shared widgets, and feature screens using theme-aware tokens so `system`, `dark`, and `light` produce consistent UI across the application.

#### Scenario: User selects light mode
- **WHEN** an authenticated user saves `theme_mode = light`
- **THEN** all primary routes (`dashboard`, `transactions`, `ai`, `budget`, and `profile`) SHALL render with light-theme surfaces and readable text contrast

#### Scenario: No dark-only hardcoded surfaces
- **WHEN** the UI is audited for theme compliance
- **THEN** route-level scaffolds and shell navigation SHALL NOT depend on hardcoded dark-only background tokens

