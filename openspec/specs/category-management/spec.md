# Category Management Specification

### Requirement: Categories screen lists all user categories
The system SHALL provide a Categories screen at `/more/categories` that displays all categories belonging to the authenticated user, grouped into **Default** and **Custom** sections. Default categories (is_default = true) SHALL be shown but SHALL NOT be editable or deletable.

#### Scenario: Categories screen shows default categories
- **WHEN** the user navigates to the Categories screen
- **THEN** the system SHALL display all default (is_default = true) categories in a read-only Default section

#### Scenario: Categories screen shows custom categories
- **WHEN** the user has created one or more custom categories
- **THEN** the system SHALL display them in a Custom section beneath the Default section

#### Scenario: Empty custom section
- **WHEN** the user has no custom categories
- **THEN** the Custom section SHALL display an empty-state prompt encouraging the user to create a category

#### Scenario: Loading state
- **WHEN** the Categories screen is loading data
- **THEN** the system SHALL display a loading indicator

### Requirement: User can add a custom category
The system SHALL allow the user to create a custom category with a name, optional icon identifier, and optional hex colour. The created category SHALL be saved to the database and SHALL appear in the Custom section of the Categories screen.

#### Scenario: Successfully adding a custom category
- **WHEN** the user fills in a valid name and submits the Add Category form
- **THEN** the system SHALL persist the category and return to the Categories screen with the new category visible

#### Scenario: Name validation on add
- **WHEN** the user submits the Add Category form with an empty name
- **THEN** the system SHALL display a validation error and SHALL NOT persist the category

### Requirement: User can edit a custom category
The system SHALL allow the user to edit the name, icon, or colour of any custom category (is_default = false). Default categories SHALL NOT present an edit action.

#### Scenario: Edit custom category
- **WHEN** the user taps a custom category and confirms edits
- **THEN** the system SHALL update the category in the database and reflect the changes in the list

#### Scenario: Default category has no edit action
- **WHEN** the user views a default category in the list
- **THEN** the system SHALL NOT display an edit affordance for that category

### Requirement: User can delete a custom category
The system SHALL allow the user to delete a custom category after confirming a destructive action dialog. Default categories SHALL NOT present a delete action. Transactions previously linked to the deleted category SHALL have their category reference set to null.

#### Scenario: Delete custom category with confirmation
- **WHEN** the user initiates a delete on a custom category and confirms the dialog
- **THEN** the system SHALL remove the category from the database and from the list

#### Scenario: Delete cancelled
- **WHEN** the user initiates a delete but cancels the confirmation dialog
- **THEN** the category SHALL remain unchanged

#### Scenario: Default category has no delete action
- **WHEN** the user views a default category
- **THEN** the system SHALL NOT display a delete affordance for that category
