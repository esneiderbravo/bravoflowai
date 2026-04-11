# Architecture & Foundation — Change Proposal

**Change:** `architecture-foundation`  
**Type:** Core Architecture  
**Status:** Proposed  
**Date:** 2026-04-11  
**Product:** BravoFlow AI

---

## Executive Summary

BravoFlow AI has a functional bootstrap: theme system, Supabase initialization, Riverpod
wired at the root, a dashboard placeholder, and a clean folder skeleton. This is a solid
starting point. However, the current code has **no architectural layers** — screens talk
directly to services, state lives in `setState`, and there are no domain models,
repositories, or use cases.

Without addressing this now — before any feature work starts — every new feature will add
coupling debt that compounds. The goal of this change is to define and lock in the
**Hybrid Clean Architecture** that all future features will follow, and to capture it as
the single source of truth in this spec.

---

## Current State Analysis

### What's Good

| Aspect | Status |
|--------|--------|
| Theme tokens (`AppColors`, `AppTextStyles`, `AppTheme`) | ✅ Clean |
| Constants + spacing system | ✅ Clean |
| Supabase init centralized | ✅ Good |
| Riverpod at root (`ProviderScope`) | ✅ Wired |
| Feature folder skeleton | ✅ Present |
| Shared widget primitives | ✅ Started |

### Identified Gaps

| Gap | Risk | Priority |
|-----|------|----------|
| No domain layer — zero business objects | Data bleeds into UI | 🔴 Critical |
| No repository pattern | Supabase calls anywhere | 🔴 Critical |
| No use cases / application layer | Fat screens inevitable | 🔴 Critical |
| Riverpod present but unused | State in `setState` | 🔴 Critical |
| No routing system | Navigation will be ad-hoc | 🟠 High |
| Static services (not injectable) | Untestable | 🟠 High |
| No error/exception model | Crashes bubble raw | 🟠 High |
| Hardcoded mock data in screen | No data / presentation split | 🟠 High |
| No DTO ↔ Domain model mapping | Schema changes break UI | 🟡 Medium |
| No logging or error tracking | Blind in production | 🟡 Medium |
| No auth flow or session guard | Feature blocker | 🟡 Medium |
| No testing infrastructure | No safety net | 🟡 Medium |

---

## Proposed Architecture

### Decision: Hybrid Clean Architecture + Feature-First Organisation

**Why not pure Clean Architecture?** Pure CA (entities → use cases → interface adapters →
frameworks) is verbose for a mobile app. Each feature would need 5–7 files before anything
renders.

**Why not pure Feature-First?** Without layers, screens talk to the database. AI features
require stable domain abstractions that can't live in a single feature folder.

**Hybrid approach** gives us:
- Feature isolation (independent deploy units, team scalability)
- Clean layering *within* each feature (presentation → application → domain → data)
- A shared `core/` for cross-cutting concerns
- A shared `domain/` for entities used across features

This is the pattern used by production Flutter teams at scale (Very Good Ventures, Bricks,
Invertase) and aligns perfectly with Riverpod's provider tree model.

---

## Scope of This Change

### Included

- [ ] Define final folder structure (locked, not negotiable per-feature)
- [ ] Define layer contracts and dependency rules
- [ ] Define Riverpod state architecture pattern (AsyncNotifier + providers)
- [ ] Define Repository + DTO + Domain Model pattern
- [ ] Define routing strategy (go_router)
- [ ] Define error model (`AppException`)
- [ ] Define Supabase data access pattern
- [ ] Define AI service abstraction interface
- [ ] Define logging strategy
- [ ] Define testing pyramid
- [ ] Database schema proposal (Supabase)
- [ ] Development workflow (Git, CI)

### Excluded

- Actual implementation of auth UI
- Actual Supabase queries (real data)
- AI provider integration (OpenAI / Gemini)
- Advanced analytics / observability tooling

---

## Non-Goals

- Microservices (not needed at MVP)
- Custom state management solution (Riverpod is the answer)
- Multiple themes (dark-first is locked in)

---

## Definition of Done

- `design.md` captures all architectural decisions with rationale
- All future features have a clear folder template to follow
- No architectural rework needed for Features 1–5
- Team can onboard to the architecture from `design.md` alone

---

## Next Change (Do NOT implement yet)

**Design System & UI Component Library** — formalize the token system into a full
component library (buttons, inputs, cards, bottom sheets) with a Storybook-equivalent
widget gallery.

