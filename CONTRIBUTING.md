# Contributing to BravoFlow AI

Thank you for contributing! This guide ensures every change follows the same
quality bar and architecture standards.

---

## 🚀 Quick Start

1. Fork the repository and clone your fork
2. Copy `.env.example` → `.env` and fill in your Supabase credentials
3. Install dependencies and run quality checks

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

---

## 🌿 Branch Naming

Use the following convention:

| Type       | Pattern                        | Example                         |
| ---------- | ------------------------------ | ------------------------------- |
| Feature    | `feature/<short-description>`  | `feature/transaction-list`      |
| Bug fix    | `fix/<short-description>`      | `fix/auth-redirect-loop`        |
| Refactor   | `refactor/<short-description>` | `refactor/dashboard-state`      |
| Docs       | `docs/<short-description>`     | `docs/readme-update`            |
| Chore      | `chore/<short-description>`    | `chore/update-dependencies`     |
| AI feature | `ai/<short-description>`       | `ai/spending-insight-rules`     |

> Branches should be **short**, **lowercase**, and **hyphenated**.

---

## 📝 Commit Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>
```

### Types

| Type       | When to use                                      |
| ---------- | ------------------------------------------------ |
| `feat`     | A new feature or capability                      |
| `fix`      | A bug fix                                        |
| `refactor` | Code change without functional impact            |
| `docs`     | Documentation-only changes                      |
| `chore`    | Build, dependencies, tooling                     |
| `test`     | Adding or fixing tests                           |
| `style`    | Formatting, linting (no logic change)            |
| `perf`     | Performance improvement                          |
| `ci`       | CI/CD workflow changes                           |

### Scopes (aligned to project structure)

`auth`, `dashboard`, `transactions`, `budget`, `ai`, `core`, `shared`,
`domain`, `router`, `openspec`, `migrations`, `tests`, `docs`

### Examples

```bash
feat(transactions): add TransactionListScreen with empty state
fix(auth): handle null session on cold start
refactor(dashboard): migrate to ConsumerWidget with DashboardNotifier
docs(readme): update architecture section
chore(deps): upgrade go_router to v14
test(ai): add RulesBasedAiRepository unit tests
```

---

## 🔁 Development Workflow

All changes follow the **Open Spec workflow**. See `openspec/workflow.yaml` for
the complete definition.

### Steps

1. **Propose** — Run `/opsx-propose` with your feature spec before writing code
2. **Design** — Capture architecture decisions in a `design.md` artifact
3. **Plan** — Define tasks in `tasks.md`; each task should take ≤ 2 hours
4. **Implement** — Follow the architecture module (`openspec/architecture.yaml`)
5. **Verify** — Run quality checks (see below)
6. **Archive** — Run `/opsx-archive` once all tasks are complete

---

## 🏗️ Architecture Rules

All contributions must respect these boundaries (see `openspec/architecture.yaml`):

- `presentation` → `application` → `domain` ← `data`
- **No** business logic in UI widgets
- **No** direct repository calls from screens
- Domain entities must be **framework-independent**
- Each feature must include `presentation/`, `application/`, and `data/` layers

---

## ✅ Quality Checklist (before every PR)

```bash
dart format .
flutter analyze
flutter test
```

- [ ] All tests pass
- [ ] `flutter analyze` shows no errors
- [ ] No unused imports
- [ ] No hardcoded values in widgets (use theme tokens)
- [ ] Database changes have a migration in `supabase/migrations/`
- [ ] `openspec/specs/database/schema.md` updated if data model changed

---

## 📋 Pull Request Process

1. Open a PR using the `.github/pull_request_template.md` (loaded automatically)
2. Link the Open Spec change name in the PR description
3. Request a review
4. Address all review feedback before merging

---

## 📄 Key Reference Files

| File                              | Purpose                             |
| --------------------------------- | ----------------------------------- |
| `openspec/standards.yaml`         | Code quality and naming rules       |
| `openspec/architecture.yaml`      | Layer structure and dependency rules |
| `openspec/workflow.yaml`          | Feature delivery workflow           |
| `openspec/migrations.yaml`        | DB migration requirements           |
| `docs/release-checklist.md`       | Pre-release validation steps        |
| `.github/pull_request_template.md`| PR checklist template               |

---

## 📄 License

By contributing, you agree your contributions will be licensed under the
MIT License that covers this project.

