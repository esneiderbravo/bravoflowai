import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../application/transaction_providers.dart';
import '../widgets/transaction_tile.dart';

// ── Tab index constants ───────────────────────────────────────────────────────
const int _tabAll = 0;
const int _tabIncome = 1;
const int _tabExpenses = 2;

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  int _selectedTab = _tabAll;

  List<Transaction> _filtered(List<Transaction> all) => switch (_selectedTab) {
    _tabIncome => all.where((t) => t.isIncome).toList(),
    _tabExpenses => all.where((t) => t.isExpense).toList(),
    _ => all,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(transactionNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _GlassAppBar(l10n: l10n),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(e.toString(), style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => ref.read(transactionNotifierProvider.notifier).refresh(),
                child: Text(l10n.retry_button),
              ),
            ],
          ),
        ),
        data: (all) {
          final transactions = _filtered(all);
          return SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.primaryFixed,
              backgroundColor: AppColors.surfaceContainerHigh,
              onRefresh: () => ref.read(transactionNotifierProvider.notifier).refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: kToolbarHeight + AppSpacing.xl + AppSpacing.sm),
                  ),
                  // ── Filter tabs ─────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _FlowTabBar(
                      selected: _selectedTab,
                      onSelect: (i) => setState(() => _selectedTab = i),
                      l10n: l10n,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                  // ── Monthly summary header ──────────────────────────────
                  SliverToBoxAdapter(
                    child: _MonthlySummaryHeader(all: all, tab: _selectedTab, l10n: l10n),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                  // ── Transaction list or empty state ─────────────────────
                  if (transactions.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(tab: _selectedTab, l10n: l10n),
                    )
                  else
                    _GroupedTransactionSliver(
                      transactions: transactions,
                      l10n: l10n,
                      onDelete: (id) => ref.read(transactionNotifierProvider.notifier).remove(id),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Glass App Bar ─────────────────────────────────────────────────────────────

class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GlassAppBar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.tab_flow, style: AppTextStyles.headingMedium),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColors.primaryFixed, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Filter tab bar ────────────────────────────────────────────────────────────

class _FlowTabBar extends StatelessWidget {
  const _FlowTabBar({required this.selected, required this.onSelect, required this.l10n});

  final int selected;
  final ValueChanged<int> onSelect;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final labels = [l10n.flow_tab_all, l10n.flow_tab_income, l10n.flow_tab_expenses];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: List.generate(labels.length, (i) {
            final isActive = i == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryFixed.withValues(alpha: 0.15) : null,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Center(
                    child: Text(
                      labels[i],
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: isActive ? AppColors.primaryFixed : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Monthly summary header ────────────────────────────────────────────────────

class _MonthlySummaryHeader extends StatelessWidget {
  const _MonthlySummaryHeader({required this.all, required this.tab, required this.l10n});

  final List<Transaction> all;
  final int tab;
  final AppLocalizations l10n;

  bool _isCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final monthly = all.where((t) => _isCurrentMonth(t.date)).toList();

    final income = monthly.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.amount.amount);
    final expenses = monthly.where((t) => t.isExpense).fold(0.0, (sum, t) => sum + t.amount.amount);
    final net = income - expenses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: switch (tab) {
        _tabIncome => _SingleMetric(
          label: l10n.flow_monthly_income,
          amount: income,
          color: AppColors.success,
          prefix: '+',
        ),
        _tabExpenses => _SingleMetric(
          label: l10n.flow_monthly_expenses,
          amount: expenses,
          color: AppColors.error,
          prefix: '-',
        ),
        _ => _TripleMetric(income: income, expenses: expenses, net: net, l10n: l10n),
      },
    );
  }
}

class _SingleMetric extends StatelessWidget {
  const _SingleMetric({
    required this.label,
    required this.amount,
    required this.color,
    required this.prefix,
  });

  final String label;
  final double amount;
  final Color color;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 9,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$prefix\$${amount.toStringAsFixed(2)}',
          style: AppTextStyles.headingMedium.copyWith(color: color, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _TripleMetric extends StatelessWidget {
  const _TripleMetric({
    required this.income,
    required this.expenses,
    required this.net,
    required this.l10n,
  });

  final double income;
  final double expenses;
  final double net;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final netPositive = net >= 0;
    return Row(
      children: [
        _MetricChip(
          label: l10n.flow_monthly_income,
          value: '+\$${income.toStringAsFixed(2)}',
          color: AppColors.success,
        ),
        const SizedBox(width: AppSpacing.sm),
        _MetricChip(
          label: l10n.flow_monthly_expenses,
          value: '-\$${expenses.toStringAsFixed(2)}',
          color: AppColors.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        _MetricChip(
          label: l10n.flow_net_balance,
          value: '${netPositive ? '+' : '-'}\$${net.abs().toStringAsFixed(2)}',
          color: netPositive ? AppColors.success : AppColors.error,
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 8,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.labelMedium.copyWith(color: color, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tab, required this.l10n});
  final int tab;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (tab) {
      _tabIncome => (Icons.arrow_downward_rounded, l10n.flow_empty_income),
      _tabExpenses => (Icons.arrow_upward_rounded, l10n.flow_empty_expenses),
      _ => (Icons.receipt_long_outlined, l10n.flow_empty_all),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryFixed, size: 32),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

// ── Grouped transaction sliver ────────────────────────────────────────────────

class _GroupedTransactionSliver extends StatelessWidget {
  const _GroupedTransactionSliver({
    required this.transactions,
    required this.l10n,
    required this.onDelete,
  });

  final List<Transaction> transactions;
  final AppLocalizations l10n;
  final void Function(String id) onDelete;

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(txDate).inDays;
    if (diff == 0) return l10n.flow_today;
    if (diff == 1) return l10n.flow_yesterday;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<String, List<Transaction>> _group() {
    final map = <String, List<Transaction>>{};
    for (final t in transactions) {
      final label = _dateLabel(t.date);
      (map[label] ??= []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _group();
    final items = <Widget>[];

    for (final entry in groups.entries) {
      // Date section header
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Text(
            entry.key,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
        ),
      );
      // Tiles
      for (final txn in entry.value) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
            child: TransactionTile(transaction: txn, onDelete: () => onDelete(txn.id)),
          ),
        );
      }
    }

    return SliverList(delegate: SliverChildListDelegate(items));
  }
}
