## 1. Refactor AppShell — BottomAppBar with Notch

- [x] 1.1 In `app_shell.dart`, add `floatingActionButton` and `floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked` to the `Scaffold` in `AppShell.build`
- [x] 1.2 Replace `bottomNavigationBar: _GlassNavBar(...)` with a new `_GlassNavBar` built on `BottomAppBar(shape: CircularNotchedRectangle(), color: AppColors.surface @ 0.9, elevation: 0)`
- [x] 1.3 Rewrite `_GlassNavBar.build` to wrap its content in `ClipRRect` (top corners `radiusXl`) → `BackdropFilter(blur 24)` → `BottomAppBar` — same glass treatment as before
- [x] 1.4 Lay out the three tab items as: [Home, Flow] on the left side, [More] on the right side (Expanded rows with 72dp SizedBox gap for notch)
- [x] 1.5 Extract `_CenterAddFab` as the FAB widget: 56×56 circle, `primaryFixed → secondary` gradient, `add_rounded` icon, scale-press animation; on tap calls `onAddTap` callback

## 2. Quick-Add Bottom Sheet

- [x] 2.1 Create `lib/shared/widgets/quick_add_sheet.dart` as a `ConsumerStatefulWidget`
- [x] 2.2 Add state: `TransactionType _type`, `TextEditingController _amountCtrl`, `String? _selectedAccountId`, `bool _amountError`, `bool _accountError`
- [x] 2.3 Build the sheet layout: drag handle → title → type toggle pill (Income / Expense) → amount field → account dropdown → Save `GradientButton`
- [x] 2.4 Populate account dropdown from `accountNotifierProvider`
- [x] 2.5 Implement save logic: validate required fields (amount > 0, account selected), call `transactionNotifierProvider.add(...)`, then `ref.invalidate` for `financialSummaryProvider` and `categorySummaryProvider`, then `Navigator.pop(context)`
- [x] 2.6 Add inline validation messages shown below amount/account fields on failed save attempt

## 3. Wire Sheet to AppShell

- [x] 3.1 In `AppShell.build`, call `showModalBottomSheet(isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const QuickAddSheet())` via `_openQuickAdd(context)` passed to `_CenterAddFab.onTap`
- [x] 3.2 Import `quick_add_sheet.dart` in `app_shell.dart`

## 4. Remove Redundant FAB from Flow Screen

- [x] 4.1 In `transaction_list_screen.dart`, remove the `_AddFab` widget class and its usage from the `Scaffold.floatingActionButton` property

## 5. Validate

- [x] 5.1 Run `flutter analyze --no-fatal-infos` and fix any issues (fixed: `CircularNotchAndBar` → `CircularNotchedRectangle`)
- [x] 5.2 Manually verify: "+" button visible as inline nav item on all tabs; sheet opens with correct fields; save creates transaction and refreshes dashboard; dismiss without save does nothing
