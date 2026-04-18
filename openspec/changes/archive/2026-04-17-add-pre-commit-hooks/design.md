## Context

The project's `analysis_options.yaml` and `openspec/standards.yaml` already define formatting and linting standards. However, there is no local enforcement mechanism — developers can commit code that violates formatting or analysis rules without any automated gate.

**Current state**: No `.github/workflows/` CI pipelines exist and no git hooks are configured.

**Tool choice**: `lefthook` is selected over raw git hooks or the `pre-commit` Python framework because:
- Config is committed to the repo (shareable with the team)
- Single binary with no Python/Node.js runtime dependency
- Native `stage_fixed: true` support for auto-fix workflows
- Supports sequential or parallel hook execution

## Goals / Non-Goals

**Goals:**
- Enforce `dart format .` on all files before every commit, auto-staging reformatted files
- Enforce `dart fix --apply` on all files before every commit, auto-staging fixed files
- Block commits where `flutter analyze` reports errors after auto-fixes are applied
- Provide a shareable configuration (committed to repo) so all contributors get the same gates

**Non-Goals:**
- CI/CD pipeline setup (separate concern)
- Enforcing hooks on push (pre-push hook out of scope)
- Per-file or staged-only scoping (full repo format chosen for consistency)
- Adding new lint rules beyond what `analysis_options.yaml` already defines

## Decisions

### lefthook over raw git hooks
Raw `.git/hooks/` scripts are local-only and not committed to the repo. lefthook's `lefthook.yml` is committed and shared with all contributors, making the setup reproducible. Any developer who runs `lefthook install` gets the identical hooks.

**Alternatives considered:**
- `pre-commit` (Python framework): Requires Python environment; adds cognitive overhead for a Dart-first team.
- Raw shell script: Not shareable; each dev would need to manually copy or set up.

### Auto-fix with `stage_fixed: true` over check-only mode
`dart format --set-exit-if-changed` and check-only mode would require the developer to manually re-run the fix and re-commit. Auto-fix silently corrects the issue and re-stages the file, keeping the commit workflow smooth. The commit always contains correctly formatted code.

### Format all files, not just staged files
Formatting only staged files risks leaving the repo in an inconsistent state where unstaged files diverge from the standard. Formatting all files on each commit ensures the whole codebase stays consistent over time at a low incremental cost.

### Hook order: format → fix → analyze
`dart format` is purely structural (whitespace/layout) and must run before `dart fix` to avoid re-introducing formatting issues. `flutter analyze` runs last as a gate — if fixes introduced by `dart fix` still leave analysis errors, the commit is blocked.

## Risks / Trade-offs

- **Slow commits on large changesets** → `dart format .` and `dart fix --apply` scan the entire repo. On the current codebase size this is acceptable; revisit if commit times exceed ~10s.
- **lefthook not installed** → Hooks simply don't run; no hard failure. Mitigated by documenting `lefthook install` as a required setup step in the README/CONTRIBUTING.
- **`dart fix --apply` modifies unexpected files** → Rare, but possible if a new lint rule is added. Developers should review staged changes before confirming a commit.
- **Incompatibility with GUI git clients** → Some GUI clients (e.g., Tower, SourceTree) may not invoke shell-based hooks correctly. Documented as a known limitation.

## Migration Plan

1. Add `lefthook.yml` to repo root
2. Document one-time setup (`brew install lefthook && lefthook install`) in `CONTRIBUTING.md`
3. Existing contributors activate hooks by running `lefthook install` after pulling
4. No rollback needed — removing hooks is `lefthook uninstall` or deleting `.git/hooks/pre-commit`
