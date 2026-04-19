## Context

The app currently uses a custom `_GlassNavBar` widget (inside `app_shell.dart`) that renders via `Scaffold.bottomNavigationBar`. It is a `ClipRRect` → `BackdropFilter` → `Container` → `Row` of three `_NavTabItem` widgets.

There is no global shortcut to add a transaction; users must navigate to the Flow tab and tap the in-screen FAB.

The user expects a **concave curved indentation** (notch) at the center of the bottom nav bar with a floating "+" button docked inside it — a well-established pattern in mobile finance UIs.

---

## Goals / Non-Goals

**Goals:**
- Introduce a persistent center "+" button accessible from every tab
- The button visually fits into the bar via a curved concave notch
- Tapping opens a **quick-add modal bottom sheet** (type, amount, category, account) without leaving the current screen
- On save, invalidate financial providers so dashboard and flow screen update instantly
- Remove the now-redundant FAB inside `TransactionListScreen`

**Non-Goals:**
- Adding new transaction fields not already on the full add screen (date picker, notes, etc. are out of scope)
- Replacing or modifying the full `AddTransactionScreen` (it still exists for deep editing)
- Animations on the notch shape itself

---

## Decisions

### Decision 1 — Use Flutter's native `BottomAppBar` + `FloatingActionButtonLocation.centerDocked`

**Chosen:** Replace `_GlassNavBar` with a `BottomAppBar(shape: CircularNotchAndBar())` and move the gradient circle button to `Scaffold.floatingActionButton` at `FloatingActionButtonLocation.centerDocked`.

**Why:** Flutter's `BottomAppBar` was designed precisely for this pattern. The `CircularNotchAndBar` shape cuts a smooth concave arc in the bar's paint, and the Scaffold layout engine handles FAB docking and notch sizing automatically. No custom clipping, no Stack overflow hacks.

**Alternative considered:** `Stack(clipBehavior: Clip.none)` inside `bottomNavigationBar` with a `Positioned` button protruding upward. Rejected because `bottomNavigationBar` is layout-bounded by the Scaffold — overflow is clipped by the parent, not controlled by the inner Stack.

**Alternative considered:** A 5-item row where the center item is a styled circle. Rejected because it doesn't produce a real concave notch; the curve is purely aesthetic paint, not a structural indentation.

---

### Decision 2 — Glass blur applied via `DecoratedBox` inside `BottomAppBar.child`

**Chosen:** Wrap the tab row in `BackdropFilter` + semi-transparent `Container` inside the `BottomAppBar.child`, mirroring the existing `_GlassNavBar` blur treatment.

**Why:** `BottomAppBar` itself has a `color` + `elevation` API, but that renders a solid fill. To preserve the Luminous Stratum glass aesthetic, the blur must be applied in the widget tree via `BackdropFilter`, which requires `BottomAppBar.child` to be a `Stack` or wrapped widget.

**Note:** Set `BottomAppBar.color = Colors.transparent` and `elevation = 0` so the native paint doesn't conflict with the custom glass paint.

---

### Decision 3 — Quick-add sheet is a `showModalBottomSheet` with `DraggableScrollableSheet`

**Chosen:** Open via `showModalBottomSheet(isScrollControlled: true, ...)` with an inner `DraggableScrollableSheet`.

**Why:** `isScrollControlled: true` lets the sheet resize with the keyboard. A `DraggableScrollableSheet` allows the user to dismiss by dragging down. The sheet is self-contained (its own `ConsumerWidget`) and does not depend on the current route.

---

### Decision 4 — Tab layout: 2 tabs left, 1 tab right of the notch

**Chosen:** Home and Flow on the left; More on the right. The notch sits between Flow and More.

**Why:** Home and Flow are the two primary navigation targets. Grouping them on the left mirrors common usage patterns. More (settings/secondary) sits alone on the right. This gives symmetric visual weight (2 items | notch | 1 item + implicit right balance).

---

## Risks / Trade-offs

- **Risk**: `BottomAppBar` top-corner rounding requires matching `BottomAppBar.shape` to a custom `NotchedShape` or using `clipBehavior`. The default `CircularNotchAndBar` does not include rounded top corners.  
  → **Mitigation**: Wrap `BottomAppBar` in a `ClipRRect` for the top-left/top-right `radiusXl` rounding, same as before.

- **Risk**: The `BackdropFilter` inside `BottomAppBar.child` may not blur content behind the notch gap.  
  → **Mitigation**: The notch gap is small (≈ FAB radius + margin); any un-blurred area is visually occupied by the FAB itself. Acceptable.

- **Risk**: Removing the in-screen FAB from `TransactionListScreen` is a visible UX change.  
  → **Mitigation**: The global "+" button replaces it directly; the Flow screen already has a tab bar and summary header that retain visual weight without the FAB.

---

## Migration Plan

1. Modify `AppShell`: replace `_GlassNavBar` with `BottomAppBar` + `floatingActionButton` + `floatingActionButtonLocation`
2. Create `lib/shared/widgets/quick_add_sheet.dart`
3. Remove `_AddFab` widget from `TransactionListScreen`
4. `flutter analyze` to confirm no regressions

Rollback: revert `app_shell.dart` and restore `_AddFab` in `transaction_list_screen.dart`.

---

## Open Questions

_None — all key decisions resolved above._
