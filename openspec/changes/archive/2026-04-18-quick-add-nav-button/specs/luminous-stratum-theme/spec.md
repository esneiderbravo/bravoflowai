## MODIFIED Requirements

### Requirement: Bottom navigation bar visual treatment
The bottom navigation bar SHALL be implemented using Flutter's `BottomAppBar` with `shape: CircularNotchAndBar()` and `Scaffold.floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked`. The glass blur and Luminous Stratum styling SHALL be preserved by applying `BackdropFilter` (sigmaX/Y: 24) and a semi-transparent `AppColors.surface` at 90% opacity inside the `BottomAppBar.child`. The `BottomAppBar` itself SHALL have `color: Colors.transparent` and `elevation: 0` to prevent native paint conflicting with the glass effect. Top corners SHALL be rounded to `AppSpacing.radiusXl` via a wrapping `ClipRRect`.

#### Scenario: Glass effect is preserved
- **WHEN** the bottom nav bar is rendered over app content
- **THEN** the bar shows a blurred glass effect (BackdropFilter blur 24) with `AppColors.surface` at 90% opacity

#### Scenario: Top corners are rounded
- **WHEN** the bottom nav bar is rendered
- **THEN** the top-left and top-right corners have `AppSpacing.radiusXl` (48dp) radius

#### Scenario: Notch does not break glass effect
- **WHEN** the FAB is docked in the center notch
- **THEN** the visible portions of the bar (left and right of the notch) maintain the glass blur treatment
