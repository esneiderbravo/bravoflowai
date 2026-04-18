# Spec: Pre-Commit Hooks

## Requirements

### Requirement: Pre-commit hook auto-formats all Dart files
The system SHALL run `dart format .` on all Dart files in the repository as part of the git pre-commit hook. Any files reformatted by this command SHALL be automatically re-staged so the commit contains correctly formatted code.

#### Scenario: Commit with unformatted code
- **WHEN** a developer runs `git commit` with staged changes containing unformatted Dart code
- **THEN** `dart format .` rewrites all files to conform to the project's formatting standard and the reformatted files are automatically re-staged before the commit proceeds

#### Scenario: Commit with already-formatted code
- **WHEN** a developer runs `git commit` with staged changes that are already correctly formatted
- **THEN** `dart format .` produces no changes and the commit proceeds without modification

### Requirement: Pre-commit hook auto-applies lint fixes
The system SHALL run `dart fix --apply` on all Dart files in the repository as part of the git pre-commit hook. Any files modified by this command SHALL be automatically re-staged so the commit contains auto-fixed code.

#### Scenario: Commit with auto-fixable lint violations
- **WHEN** a developer runs `git commit` with staged changes containing lint violations that `dart fix` can resolve
- **THEN** `dart fix --apply` rewrites affected files to resolve the violations and the modified files are automatically re-staged before the commit proceeds

#### Scenario: Commit with no auto-fixable violations
- **WHEN** a developer runs `git commit` with staged changes that have no auto-fixable lint violations
- **THEN** `dart fix --apply` produces no changes and the commit proceeds without modification

### Requirement: Pre-commit hook blocks commits that fail static analysis
The system SHALL run `flutter analyze` as the final step of the git pre-commit hook. If analysis reports any errors, the commit SHALL be blocked and the error output SHALL be displayed to the developer.

#### Scenario: Commit blocked by analysis errors
- **WHEN** a developer runs `git commit` and `flutter analyze` reports one or more errors after auto-fixes have been applied
- **THEN** the commit is blocked and the full analysis error output is shown to the developer

#### Scenario: Commit passes analysis
- **WHEN** a developer runs `git commit` and `flutter analyze` reports no errors
- **THEN** the commit proceeds successfully

### Requirement: Hook configuration is committed to the repository
The pre-commit hook configuration SHALL be defined in a `lefthook.yml` file at the repository root. This file SHALL be committed to version control so all contributors share identical hook behavior.

#### Scenario: New contributor activates hooks
- **WHEN** a new contributor clones the repository and runs `lefthook install`
- **THEN** the pre-commit hooks defined in `lefthook.yml` are activated in their local git configuration

#### Scenario: Hook configuration is updated
- **WHEN** `lefthook.yml` is modified and committed
- **THEN** contributors who pull the change and run `lefthook install` receive the updated hook behavior
