---
name: flutter-dev
description: Flutter cross-platform development guide covering widget patterns, Riverpod/Bloc state management, GoRouter navigation, performance optimization, and platform-specific implementations. Includes const optimization, responsive layouts, testing strategies, and DevTools profiling. Use this skill whenever the user is building Flutter apps, implementing state management with Riverpod or Bloc, setting up GoRouter navigation, creating custom widgets, optimizing Flutter performance, writing widget or integration tests, or working on cross-platform Flutter development — even if they don't mention Flutter explicitly but are clearly working on a Dart/Flutter codebase.
license: MIT
metadata: {"version":"1.0.0","category":"mobile","sources":["Flutter Documentation","Riverpod Documentation","Bloc Library Documentation"]}
---

# Flutter Development Guide

A practical guide for building cross-platform applications with Flutter 3 and Dart. Focuses on proven patterns, state management, and performance optimization.

## Quick Reference

### Widget Patterns

| Purpose | Component |
|---------|-----------|
| State management (simple) | `StateProvider` + `ConsumerWidget` |
| State management (complex) | `NotifierProvider` / `Bloc` |
| Async data | `FutureProvider` / `AsyncNotifierProvider` |
| Real-time streams | `StreamProvider` |
| Navigation | `GoRouter` + `context.go`/`push` |
| Responsive layout | `LayoutBuilder` + breakpoints |
| List display | `ListView.builder` |
| Complex scrolling | `CustomScrollView` + Slivers |
| Hooks | `HookWidget` + `useState`/`useEffect` |
| Forms | `Form` + `TextFormField` + validation |

### Performance Patterns

| Purpose | Solution |
|---------|----------|
| Prevent rebuilds | `const` constructors |
| Selective updates | `ref.watch(provider.select(...))` |
| Isolate repaints | `RepaintBoundary` |
| Lazy lists | `ListView.builder` |
| Heavy computation | `compute()` isolate |
| Image caching | `cached_network_image` |

## Core Principles

### Widget Optimization
- Use `const` constructors wherever possible
- Extract static widgets to separate `const` classes
- Use `Key` for list items (`ValueKey`, `ObjectKey`)
- Prefer `ConsumerWidget` over `StatefulWidget` for state

### State Management
- Riverpod for dependency injection and simple state
- Bloc/Cubit for event-driven workflows and complex logic
- Never mutate state directly — create new instances
- Use `select()` to minimize rebuilds

### Layout
- 8pt spacing increments (8, 16, 24, 32, 48)
- Responsive breakpoints: mobile (<650), tablet (650–1100), desktop (>1100)
- Support all screen sizes with flexible layouts
- Follow Material 3 / Cupertino design guidelines

### Performance
- Profile with DevTools before optimizing
- Target <16ms frame time for 60fps
- Use `RepaintBoundary` for complex animations
- Offload heavy work with `compute()`

## Checklist

### Widget Best Practices
- [ ] `const` constructors on all static widgets
- [ ] Proper `Key` on list items
- [ ] `ConsumerWidget` for state-dependent widgets
- [ ] No widget building inside `build()` method
- [ ] Extract reusable widgets to separate files

### State Management
- [ ] Immutable state objects
- [ ] `select()` for granular rebuilds
- [ ] Proper provider scoping
- [ ] Dispose controllers and subscriptions
- [ ] Handle loading/error states

### Navigation
- [ ] GoRouter with typed routes
- [ ] Auth guards via `redirect`
- [ ] Deep linking support
- [ ] State preservation across routes

### Performance
- [ ] Profile mode testing (`flutter run --profile`)
- [ ] <16ms frame rendering time
- [ ] No unnecessary rebuilds (DevTools check)
- [ ] Images cached and resized
- [ ] Heavy computation in isolates

### Testing
- [ ] Widget tests for UI components
- [ ] Unit tests for business logic
- [ ] Integration tests for user flows
- [ ] Bloc tests with `blocTest()`

## Topic References

The following topics have dedicated reference sections. When working on these areas, apply the relevant patterns:

| Topic | Key Concerns |
|-------|-------------|
| Widget patterns, const optimization, responsive layout | `const` propagation, `LayoutBuilder`, breakpoints |
| Riverpod providers, notifiers, async state | `AsyncNotifierProvider`, `ref.watch`, `select()` |
| Bloc, Cubit, event-driven state | `BlocBuilder`, `blocTest`, sealed events |
| GoRouter setup, routes, deep linking | `GoRoute`, `ShellRoute`, `redirect` guards |
| Feature-based structure, dependencies | Layered architecture, barrel exports |
| Profiling, const optimization, DevTools | Flutter DevTools, frame timeline, memory |
| Widget tests, integration tests, mocking | `pumpWidget`, `find`, `MockGoRouter` |
| iOS/Android/Web specific implementations | Platform channels, conditional imports |
| Implicit/explicit animations, Hero, transitions | `AnimationController`, `Tween`, `Hero` |
| Dio, interceptors, error handling, caching | `Interceptor`, retry logic, response caching |
| Form validation, FormField, input formatters | `GlobalKey<FormState>`, `InputFormatter` |
| i18n, flutter_localizations, intl | `AppLocalizations`, ARB files, locale selection |

---

*Flutter, Dart, Material Design, and Cupertino are trademarks of Google LLC and Apple Inc. respectively. Riverpod, Bloc, and GoRouter are open-source packages by their respective maintainers.*
