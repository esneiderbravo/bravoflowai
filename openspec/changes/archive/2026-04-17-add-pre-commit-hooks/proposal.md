## Why

The project has linting rules and formatting standards defined in `analysis_options.yaml` and `openspec/standards.yaml`, but nothing enforces them locally before code is committed. Developers can commit unformatted or lint-failing code with no automated gate.

## What Changes

- Add `lefthook` as a dev tooling dependency for managing git hooks
- Add `lefthook.yml` configuration committed to the repo (sharable with all contributors)
- Configure a `pre-commit` hook that:
  - Runs `dart format .` on all files and re-stages any changes
  - Runs `dart fix --apply` on all files and re-stages any changes
  - Runs `flutter analyze` and blocks the commit if analysis fails

## Capabilities

### New Capabilities

- `pre-commit-hooks`: Git pre-commit hook configuration using lefthook that auto-formats, auto-fixes, and analyzes Dart/Flutter code before each commit

### Modified Capabilities

## Impact

- New file: `lefthook.yml` at repo root
- Developers must run `lefthook install` once after cloning (or pulling this change) to activate hooks locally
- `lefthook` must be installed on each developer machine (e.g., `brew install lefthook`)
- No application code changes — tooling only
