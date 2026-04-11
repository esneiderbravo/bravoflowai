# BravoFlow AI

AI-powered personal finance mobile application built with Flutter and Supabase.

## 🧠 Description

BravoFlow AI is an AI-first personal finance assistant that helps users track,
understand, and optimize their financial flow. The project combines a modern
Flutter frontend with Supabase backend services and Open Spec governance for
clear, scalable development.

## ✨ Features (MVP)

- Expense tracking
- Budgeting foundations
- Financial dashboard
- AI insights (planned)

## 🏗️ Architecture

- **Frontend:** Flutter
- **Backend:** Supabase (Auth, Postgres, Realtime)
- **Governance:** Open Spec (modular configs)
- **Code organization:** Clean + feature-based hybrid architecture

## 📁 Project Structure

```text
bravoflowai/
├── lib/
│   ├── core/                # Theme, constants, services, router, errors
│   ├── domain/              # Entities, value objects, repository contracts
│   ├── features/            # Feature modules (auth, dashboard, transactions...)
│   └── shared/              # Reusable widgets/extensions/models
├── openspec/
│   ├── config.yaml          # Root orchestrator for modular specs
│   ├── architecture.yaml
│   ├── frontend.yaml
│   ├── backend.yaml
│   ├── ai.yaml
│   ├── migrations.yaml
│   ├── standards.yaml
│   └── workflow.yaml
├── supabase/
│   └── migrations/          # Versioned DB migrations
├── test/                    # Unit and widget tests
├── integration_test/        # Integration smoke tests
├── README.md
├── LICENSE
└── .gitignore
```

## ⚙️ Tech Stack

- Flutter (Dart)
- Supabase
- Riverpod (planned/partially prepared)
- Open Spec (workflow and architecture governance)

## 🧪 Development Workflow

BravoFlow AI follows a feature-by-feature Open Spec flow.

- `/opsx-analyze` for baseline and impact analysis
- `/opsx-propose` for defining change scope and architecture intent
- `/opsx-apply` for implementation against approved tasks

## 🗄️ Database

- Supabase Postgres with migration-driven schema management
- All schema changes are version-controlled in `supabase/migrations`
- Documentation maintained in `openspec/specs/database/schema.md`

## 🎨 Design System

- Dark-first UI approach
- Brand gradient: **blue → violet → cyan**
- Token-driven theming for scalable UI consistency

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (stable)
- Dart SDK (included with Flutter)
- Supabase project (URL + anon key)

### Run locally

```bash
flutter pub get
flutter run
```

### Quality checks

```bash
dart format .
flutter analyze
flutter test
```

## 🔐 Environment Setup

Create a `.env` file in the project root (or copy from `.env.example`):

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

> Never commit real credentials. `.env` is ignored by Git.

## 📌 Roadmap

- **MVP:** dashboard, transactions, budgeting baseline
- **Phase 2:** AI insights and forecasting
- **Phase 3:** automation and proactive financial recommendations

## 🤝 Contributing

Contributions are welcome. Read [`CONTRIBUTING.md`](CONTRIBUTING.md) for the
full guide including branch naming, commit format, and the Open Spec workflow.

Quick rules:

1. Open Spec workflow (`/opsx-propose` before implementation)
2. Project coding standards and linting rules (`openspec/standards.yaml`)
3. Migration required for all data model changes

## 📄 License

This project is licensed under the MIT License. See `LICENSE` for details.
