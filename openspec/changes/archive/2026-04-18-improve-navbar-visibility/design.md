## Context

The app uses a glass-morphism bottom navigation bar (`_GlassNavBar` in `app_shell.dart`) with a backdrop blur and `AppColors.surface` at 90% opacity. Current problems:

1. **Inactive tabs** use `AppColors.outline.withValues(alpha: 0.6)` — the `outline` token (#71748C) is already a muted mid-gray; at 60% opacity it falls below usable contrast against the dark surface.
2. **Active pill indicator** uses a gradient at only 10% alpha, making it almost imperceptible.
3. **No top separator** — the bar blends visually with scrollable content behind the blur.
4. **Ambient shadow** is very subtle (5% opacity, offset -12) and provides minimal depth cue.

All changes are isolated to `app_shell.dart` with no structural, routing, or state changes required.

## Goals / Non-Goals

**Goals:**
- Inactive tab icons/labels are clearly legible against the nav bar background
- Active tab pill is visually distinct without breaking the glass aesthetic
- A subtle top border/separator anchors the bar to the bottom of the screen
- Shadow depth is sufficient to distinguish the bar from body content

**Non-Goals:**
- Redesigning the nav bar layout, shape, or adding/removing tabs
- Changing the `+` add button or its animation
- Theming support (light mode) — that is covered by the `app-theming` spec

## Decisions

### D1: Inactive icon opacity → use `onSurfaceVariant` directly (no alpha reduction)

**Decision**: Replace `AppColors.outline.withValues(alpha: 0.6)` with `AppColors.onSurfaceVariant` (no alpha) for inactive tabs.

**Rationale**: `onSurfaceVariant` (#A7AAC3) is already the system token for secondary on-surface text and provides adequate contrast without manual opacity overrides. Removing the `.withValues(alpha: 0.6)` makes the token usage idiomatic and more visible.

**Alternative considered**: Keep `outline` but raise alpha to 0.85. Rejected because `outline` is a border/divider token — semantic mismatch. `onSurfaceVariant` is the correct token for secondary label text.

---

### D2: Active pill gradient alpha → 18%

**Decision**: Raise the active pill indicator gradient alpha from `0.10` to `0.18` for both `primaryFixed` and `secondary` stops.

**Rationale**: 18% is perceptible on a dark surface without looking opaque, preserving the glass character. Going above ~22% would make the pill look like a filled chip.

**Alternative considered**: Use a single-color tint instead of gradient. Rejected to keep consistency with the existing gradient language of the design system.

---

### D3: Top separator border

**Decision**: Add a `border` to the `_GlassNavBar` container with `AppColors.outlineVariant.withValues(alpha: 0.4)` as a 1px top edge.

**Rationale**: `outlineVariant` (#43475C) at 40% gives a barely-there divider that registers as a boundary without feeling heavy. This is consistent with how glass panels are typically anchored.

**Alternative considered**: Use a `Divider` widget above the bar. Rejected — adding a widget outside the `ClipRRect`/`BackdropFilter` stack would clip incorrectly and complicate layout.

---

### D4: Ambient shadow uplift

**Decision**: Increase the bar's `BoxShadow` opacity from `0.05` to `0.12` and blur from `40` to `32` (tighter, stronger).

**Rationale**: A tighter shadow at higher opacity gives a cleaner "floating tray" look compared to the current extremely diffuse, near-invisible shadow.

## Risks / Trade-offs

- [Risk] Higher shadow opacity may look heavy on content-heavy screens → Mitigation: 0.12 is still very subtle; can be tuned down if tested screens look heavy.
- [Risk] `outlineVariant` border may not render at 1px on high-DPI devices → Mitigation: This is standard Flutter behavior; `Border.symmetric` handles physical pixels correctly.
- [Risk] Light mode compatibility — `onSurfaceVariant` is a dark-mode token in the current palette → Mitigation: Light mode theming is out of scope; the `app-theming` change will address this holistically.
