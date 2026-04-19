## ADDED Requirements

### Requirement: Inactive nav tab items SHALL be legible
Inactive bottom navigation tab icons and labels SHALL use the `onSurfaceVariant` color token without additional alpha reduction, ensuring adequate contrast against the glass nav bar background.

#### Scenario: Inactive tab icon is visible
- **WHEN** the user is on any main tab and views a non-active tab item
- **THEN** the icon and label SHALL render at full `AppColors.onSurfaceVariant` opacity (no `.withValues(alpha: ...)` applied)

#### Scenario: Contrast is sufficient
- **WHEN** the nav bar is rendered on the standard dark surface
- **THEN** inactive tab labels and icons SHALL NOT use the `outline` color token (reserved for borders and dividers)

---

### Requirement: Active tab pill indicator SHALL be clearly visible
The active tab pill background gradient SHALL use an alpha value of at least 0.18 for both gradient stops, making the active state visually distinct from inactive tabs.

#### Scenario: Active pill is distinguishable
- **WHEN** the user is on any main tab
- **THEN** the active tab pill background gradient SHALL have an opacity of 0.18 or greater for each color stop
- **THEN** the pill SHALL remain translucent (not fully opaque), preserving the glass aesthetic

---

### Requirement: Nav bar SHALL have a visible top separator
The bottom navigation bar container SHALL display a 1-pixel top border using `AppColors.outlineVariant` at 40% alpha to visually anchor the bar and separate it from scrollable content.

#### Scenario: Top border is rendered
- **WHEN** the nav bar is displayed on any screen
- **THEN** a 1px top border with `AppColors.outlineVariant.withValues(alpha: 0.4)` SHALL be visible at the top edge of the bar

#### Scenario: Border is inside the rounded clip
- **WHEN** the nav bar renders with its rounded top corners
- **THEN** the border SHALL be part of the container decoration (not a separate widget) so it is correctly clipped to the rounded shape

---

### Requirement: Nav bar ambient shadow SHALL provide depth separation
The bottom navigation bar box shadow SHALL use an opacity of at least 0.10 and a blur radius no greater than 36 to create a noticeable separation between the bar and body content.

#### Scenario: Shadow is visible against content
- **WHEN** content is scrolled behind the nav bar
- **THEN** the bar SHALL cast a shadow with `AppColors.onSurface` at 0.12 opacity and blur radius 32
- **THEN** the shadow SHALL appear above the bar (negative Y offset)
