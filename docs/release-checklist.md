# Release Checklist

Use this checklist before publishing a new release of BravoFlow AI.

## 1) Scope & Planning

- [ ] Release version decided (e.g. `v0.1.0`)
- [ ] Open Spec changes for this release are complete and archived (or explicitly deferred)
- [ ] Release notes draft created (features, fixes, known issues)

## 2) Code Quality

- [ ] Code formatted
- [ ] Linting passes
- [ ] Tests pass (unit, widget, integration smoke)

```bash
dart format .
flutter analyze
flutter test
```

## 3) Architecture & Standards

- [ ] Layer boundaries respected (`presentation -> application -> domain -> data`)
- [ ] No direct data-layer calls from UI
- [ ] New files follow naming/import conventions from `openspec/standards.yaml`

## 4) Database & Supabase

- [ ] All schema changes are migration-based (`supabase/migrations`)
- [ ] RLS policies reviewed for each changed table
- [ ] `openspec/specs/database/schema.md` updated if data model changed
- [ ] Migration tested in staging/dev database

## 5) Security & Environment

- [ ] `.env` is not committed
- [ ] `.env.example` is up to date
- [ ] Supabase keys validated for target environment
- [ ] No secrets hardcoded in code or docs

## 6) App Validation

- [ ] App launches successfully on at least one target platform
- [ ] Critical flows verified:
  - [ ] Auth flow (sign in/up)
  - [ ] Dashboard rendering
  - [ ] Transactions list/add
  - [ ] AI insights screen
  - [ ] Budget screen

## 7) GitHub Release Prep

- [ ] `README.md` reflects latest capabilities
- [ ] `LICENSE` present and correct
- [ ] PR merged into release branch/main with approvals
- [ ] Tag created (`vX.Y.Z`)
- [ ] GitHub release notes published

## 8) Post-Release

- [ ] Monitor errors/logs after release
- [ ] Validate DB health and auth behavior
- [ ] Capture follow-up tasks and open new Open Spec changes

