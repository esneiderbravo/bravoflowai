import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/account_providers.dart';
import '../widgets/account_card.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: const _AccountsAppBar(),
      body: accountsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
        ),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (accounts) => SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + AppSpacing.xl,
              bottom: 100,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Net Worth Editorial Header ────────────────────────────
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'TOTAL BALANCE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          _totalBalance(accounts),
                          style: GoogleFonts.manrope(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '+2.4%',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Account Cards ─────────────────────────────────────────
                if (accounts.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xxl),
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('No accounts yet', style: AppTextStyles.headingSmall),
                      ],
                    ),
                  )
                else
                  ...accounts.map(
                    (account) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AccountCard(
                        account: account,
                        onTap: () => context.push('/more/accounts/${account.id}'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/more/accounts/add'),
        backgroundColor: AppColors.primaryFixed,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        label: Text(
          'Add Account',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimary),
        ),
        icon: const Icon(Icons.add_rounded, color: AppColors.onPrimary),
      ),
    );
  }

  String _totalBalance(List<dynamic> accounts) {
    if (accounts.isEmpty) return '\$0.00';
    return '\$—';
  }
}

class _AccountsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AccountsAppBar();

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
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
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
                      child: const Text(
                        'Accounts',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.search_rounded, color: AppColors.primaryFixed, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
