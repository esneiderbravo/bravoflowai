import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../application/account_balance_provider.dart';
import '../../application/account_providers.dart';
import '../widgets/account_card.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accountsAsync = ref.watch(accountNotifierProvider);
    final totalAsync = ref.watch(totalBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _AccountsAppBar(l10n: l10n),
      body: accountsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
        ),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (accounts) => SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + AppSpacing.xxl + AppSpacing.lg,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // ── Total Balance Hero ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: _TotalBalanceCard(
                    totalAsync: totalAsync,
                    accountCount: accounts.length,
                    l10n: l10n,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Account count badge ───────────────────────────────────
                if (accounts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryFixed.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        accounts.length == 1
                            ? l10n.accounts_count_one(accounts.length)
                            : l10n.accounts_count_other(accounts.length),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primaryFixed,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.md),

                // ── Account Cards ─────────────────────────────────────────
                if (accounts.isEmpty)
                  _EmptyState(l10n: l10n)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: accounts
                          .map(
                            (account) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: AccountCard(
                                account: account,
                                onTap: () => context.push('/more/accounts/${account.id}'),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Total Balance Hero Card ───────────────────────────────────────────────────

class _TotalBalanceCard extends StatelessWidget {
  const _TotalBalanceCard({
    required this.totalAsync,
    required this.accountCount,
    required this.l10n,
  });

  final AsyncValue<dynamic> totalAsync;
  final int accountCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label row with accent bar ──────────────────────────────
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryFixed, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.accounts_total_balance.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Balance amount ─────────────────────────────────────────
          totalAsync.when(
            loading: () => const SizedBox(
              height: 44,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
                ),
              ),
            ),
            error: (e, _) => Text(
              '\$—',
              style: AppTextStyles.headingLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            data: (total) => ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primaryFixed, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  total.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // ── Subtitle ───────────────────────────────────────────────
          Text(
            accountCount == 1 ? l10n.accounts_across_one : l10n.accounts_across_other(accountCount),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixed.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.primaryFixed.withValues(alpha: 0.15)),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: AppColors.primaryFixed,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.accounts_no_accounts,
            style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.accounts_empty_subtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          GestureDetector(
            onTap: () => context.push('/more/accounts/add'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryFixed, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryFixed.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: AppColors.onPrimary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.accounts_add_account,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _AccountsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AccountsAppBar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

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
                children: [
                  GestureDetector(
                    onTap: () => context.canPop() ? context.pop() : context.go('/more'),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.primaryFixed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primaryFixed, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        l10n.accounts_title,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/more/accounts/add'),
                    child: const Icon(Icons.add_rounded, color: AppColors.primaryFixed, size: 26),
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
