## 1. Translation Keys

- [x] 1.1 Add keys to `app_en.arb`
- [x] 1.2 Add matching Spanish translations for all new keys to `app_es.arb`
- [x] 1.3 Run `flutter gen-l10n` to regenerate l10n classes

## 2. Flow Screen Redesign

- [x] 2.1 Convert `TransactionListScreen` to `ConsumerStatefulWidget` with `_selectedTab` state
- [x] 2.2 Add `_FlowTabBar` pill-style filter tabs
- [x] 2.3 Add `_MonthlySummaryHeader` reactive to active tab
- [x] 2.4 Add `_GroupedTransactionSliver` with Today/Yesterday/date grouping
- [x] 2.5 Three empty-state variants per tab
- [x] 2.6 Apply `AppColors.surface` background and glass app bar

## 3. Transaction Tile Redesign

- [x] 3.1 Replace `ListTile` with `GlassCard` row layout
- [x] 3.2 Leading: circle with accent tint; emoji icon or fallback type icon
- [x] 3.3 Body: description + category·date subtitle with design system styles
- [x] 3.4 Trailing: +/- amount in success/error color; delete button preserved

## 4. Add Transaction Screen Redesign

- [x] 4.1 Replace `Scaffold` background and app bar with Luminous Stratum glass app bar
- [x] 4.2 Replace `SegmentedButton` with custom `_TypeToggle` pill using `GlassCard` + `AppColors`
- [x] 4.3 Wrap form fields in `GlassCard`; apply `AppSpacing` + `AppTextStyles` to all inputs
- [x] 4.4 Replace `ElevatedButton` with `GradientButton`

## 5. Validation

- [x] 5.1 Run `flutter analyze --no-fatal-infos` and fix any issues
- [x] 5.2 Manually verify: All/Income/Expenses tabs filter correctly; monthly summary header updates on tab switch; date grouping shows Today/Yesterday/date labels; transaction tile renders with Luminous Stratum style; add transaction screen saves successfully with GradientButton
