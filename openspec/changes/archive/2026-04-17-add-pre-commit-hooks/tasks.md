## 1. Install lefthook

- [x] 1.1 Add `lefthook` installation instructions to `CONTRIBUTING.md` (e.g., `brew install lefthook` for macOS)
- [x] 1.2 Run `lefthook install` locally to verify the tool is available

## 2. Configure pre-commit hooks

- [x] 2.1 Create `lefthook.yml` at the repo root with a `pre-commit` section
- [x] 2.2 Add `format` command: `dart format .` with `stage_fixed: true`
- [x] 2.3 Add `fix` command: `dart fix --apply` with `stage_fixed: true`
- [x] 2.4 Add `analyze` command: `flutter analyze` (no `stage_fixed`)

## 3. Activate and verify

- [x] 3.1 Run `lefthook install` to activate the hooks from `lefthook.yml`
- [x] 3.2 Make a test commit with intentionally unformatted code and verify the hook auto-formats and re-stages it
- [x] 3.3 Make a test commit with an analysis error and verify the commit is blocked with error output shown
- [x] 3.4 Make a clean commit and verify it proceeds without issues

## 4. Documentation

- [x] 4.1 Update `CONTRIBUTING.md` with the one-time setup step (`lefthook install`) required after cloning
- [x] 4.2 Note known limitation: some GUI git clients may not invoke shell-based hooks
