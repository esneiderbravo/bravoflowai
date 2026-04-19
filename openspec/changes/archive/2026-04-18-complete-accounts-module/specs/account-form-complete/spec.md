## ADDED Requirements

### Requirement: Account form matches Luminous Stratum design system
The system SHALL render the add/edit account form using a backdrop-blur app bar, `GlassCard` form sections, `GradientButton` primary action, and `AppTextStyles` / `AppColors` tokens — consistent with all other screens in the app.

#### Scenario: Form opens with branded app bar
- **WHEN** the user navigates to the add or edit account screen
- **THEN** the app bar SHALL display a backdrop-blur background, gradient title text, and a back arrow using `AppColors.primaryFixed`

#### Scenario: Form fields grouped in glass cards
- **WHEN** the form is rendered
- **THEN** the name, type, and balance fields SHALL be wrapped inside a `GlassCard` container and the submit button SHALL be a `GradientButton`

### Requirement: User can select a color for an account
The system SHALL present a horizontal scrollable row of preset color swatches; selecting one SHALL store the corresponding hex string in the `color` field.

#### Scenario: Color chip selected
- **WHEN** the user taps a color swatch
- **THEN** the swatch SHALL show a checkmark overlay and the `color` value SHALL be updated in the form state

#### Scenario: No color selected (default)
- **WHEN** the user submits the form without choosing a color
- **THEN** the system SHALL save the account with a `null` color value

### Requirement: User can select an icon for an account
The system SHALL show a "Choose icon" tappable row that opens a bottom sheet grid of finance icons; selecting one SHALL store the icon code-point as a string in the `icon` field.

#### Scenario: Icon picker opens
- **WHEN** the user taps the "Choose icon" row
- **THEN** a modal bottom sheet SHALL appear with a scrollable grid of curated finance icons rendered as `JeweledIcon` widgets

#### Scenario: Icon selected and previewed
- **WHEN** the user taps an icon in the grid
- **THEN** the bottom sheet SHALL dismiss, the selected icon SHALL appear in the form row, and the `icon` field SHALL be updated

### Requirement: User can select a currency for an account
The system SHALL provide a `DropdownButtonFormField` with a curated list of currencies (USD, EUR, COP, GBP, BRL); the selected value SHALL be stored in the `currency` field. USD is the default.

#### Scenario: Currency dropdown populated
- **WHEN** the form is opened for a new account
- **THEN** the currency dropdown SHALL default to USD and list all supported currencies

#### Scenario: Currency saved on submit
- **WHEN** the user selects a non-default currency and submits the form
- **THEN** the account SHALL be persisted with the chosen currency value

### Requirement: User can mark an account as default
The system SHALL include an "isDefault" toggle switch in the form; activating it SHALL set `isDefault = true` for the account.

#### Scenario: Default toggle persisted
- **WHEN** the user enables the isDefault switch and saves
- **THEN** the account SHALL be stored with `isDefault = true`

### Requirement: Success feedback after create or edit
After a successful create or edit, the system SHALL display a success snack bar and navigate back.

#### Scenario: Account created successfully
- **WHEN** the user submits the form for a new account and the operation succeeds
- **THEN** the system SHALL show a success snack bar and pop back to the accounts list

#### Scenario: Account edited successfully
- **WHEN** the user submits the form to edit an existing account and the operation succeeds
- **THEN** the system SHALL show a success snack bar and pop back to the account detail

### Requirement: Error feedback on form submission failure
If the create or edit operation fails, the system SHALL display an error snack bar and SHALL NOT navigate away.

#### Scenario: Create fails with error snack
- **WHEN** the user submits the form and the repository returns a failure
- **THEN** the system SHALL show an error snack bar with the failure message and keep the form open

#### Scenario: Edit fails with error snack
- **WHEN** the user submits the edited form and the repository returns a failure
- **THEN** the system SHALL show an error snack bar with the failure message and keep the form open
