## ADDED Requirements

### Requirement: Application supports Spanish and English localization
The system MUST provide generated localizations for Spanish (`es`) and English (`en`) using Flutter localization resources, and Spanish SHALL be the default locale.

#### Scenario: Default locale on first launch
- **WHEN** the app starts and no persisted user language preference is available
- **THEN** the app SHALL initialize locale as Spanish (`es`)

#### Scenario: Supported locale registration
- **WHEN** `MaterialApp` is configured during app bootstrap
- **THEN** it SHALL include `es` and `en` in `supportedLocales` and localization delegates required for generated strings

### Requirement: Users can switch language dynamically
The system MUST allow authenticated users to choose between Spanish and English from the settings/profile UI and SHALL apply the selected locale across the app without requiring restart.

#### Scenario: Runtime switch to English
- **WHEN** a user selects English from the language selector
- **THEN** visible translated text SHALL update to English in the active session

#### Scenario: Runtime switch to Spanish
- **WHEN** a user selects Spanish from the language selector
- **THEN** visible translated text SHALL update to Spanish in the active session

### Requirement: User preference is persisted and restored
The system MUST persist the selected language in the user profile and SHALL restore that value after login/session recovery.

#### Scenario: Save selected locale to profile
- **WHEN** a user confirms a new language selection
- **THEN** the system SHALL update `profiles.language_code` with `es` or `en` for that user

#### Scenario: Restore persisted locale on authenticated startup
- **WHEN** an authenticated user session is initialized
- **THEN** the system SHALL read `profiles.language_code` and apply it as the app locale before rendering primary signed-in content

#### Scenario: Invalid stored value fallback
- **WHEN** `profiles.language_code` is missing or not in the supported set
- **THEN** the system SHALL fallback to Spanish (`es`) and continue rendering

### Requirement: UI text uses localization keys
The system MUST avoid hardcoded user-facing UI strings in localized surfaces and SHALL source display text from localization keys.

#### Scenario: Localized shared actions
- **WHEN** shared actions such as app title, welcome message, profile title, save button, and language label are rendered
- **THEN** each label SHALL come from localization resources rather than inline literals

