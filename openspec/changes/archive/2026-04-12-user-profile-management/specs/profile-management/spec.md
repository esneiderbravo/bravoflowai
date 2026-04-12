## ADDED Requirements

### Requirement: User profile can be loaded for the authenticated user
The system MUST load the authenticated user's profile data from the repository when the Profile screen is opened.

#### Scenario: Profile load succeeds
- **WHEN** an authenticated user opens the Profile screen
- **THEN** the system SHALL display full name, email, and avatar URL (if present) from persisted data

#### Scenario: Profile load fails
- **WHEN** profile retrieval returns an error
- **THEN** the system SHALL present an error state with retry action and SHALL NOT crash

### Requirement: User can edit and save profile information
The system MUST allow the user to edit full name and persist updates through the profile repository.

#### Scenario: Valid profile update
- **WHEN** the user edits full name with valid input and taps Save
- **THEN** the system SHALL persist the update and show a success confirmation

#### Scenario: Invalid profile update
- **WHEN** the user submits empty or invalid full name input
- **THEN** the system SHALL block submission and show inline validation feedback

### Requirement: Email is visible but not editable in profile management
The system MUST display the authenticated email as read-only in this feature.

#### Scenario: Profile form rendering
- **WHEN** the profile form is displayed
- **THEN** the system SHALL render email as non-editable text or disabled field

### Requirement: User can upload and update profile avatar
The system MUST support avatar upload to Supabase Storage and persist the resulting URL in `avatar_url`.

#### Scenario: Avatar upload and save succeeds
- **WHEN** the user selects a valid image and saves profile changes
- **THEN** the system SHALL upload the image to bucket `avatars` using path `user_id/avatar.<ext>` and SHALL persist the new avatar URL

#### Scenario: Avatar upload fails
- **WHEN** the upload operation fails
- **THEN** the system SHALL show an error state and SHALL NOT overwrite existing persisted avatar URL

### Requirement: Presentation layer must not call Supabase directly
The system MUST enforce repository-only backend access for profile flows.

#### Scenario: Profile UI interaction
- **WHEN** the user performs load/save/avatar actions from the Profile screen
- **THEN** the system SHALL execute backend operations via application and repository layers, not from UI widgets

### Requirement: Profile state management uses Riverpod with loading and error states
The system MUST manage profile state using Riverpod and expose loading/data/error outcomes.

#### Scenario: Save operation in progress
- **WHEN** the user submits profile changes
- **THEN** the system SHALL emit loading state, disable duplicate submissions, and resume interactive state after completion

#### Scenario: Save operation fails
- **WHEN** repository returns a failure during save
- **THEN** the system SHALL emit error state and preserve user-entered values for retry

