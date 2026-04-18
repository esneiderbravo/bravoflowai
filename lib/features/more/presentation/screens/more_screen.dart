import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/ghost_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../../auth/application/auth_providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final authState = ref.watch(authNotifierProvider);
    final user = authState.valueOrNull;
    final displayName = user?.name.isNotEmpty == true ? user!.name : (user?.email ?? '');
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Profile Hero ────────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    _UserAvatar(avatarUrl: user?.avatarUrl, name: displayName),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (b) => const LinearGradient(
                              colors: [AppColors.primaryFixed, AppColors.secondary],
                            ).createShader(b),
                            child: Text(
                              displayName,
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            email,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          if (user?.currency != null)
                            Text(
                              user!.currency,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primaryFixed,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Finance ──────────────────────────────────────────────────
              const _SectionLabel('Finance'),
              const SizedBox(height: AppSpacing.sm),
              _SettingsTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.primaryFixed,
                label: l10n.more_accounts,
                onTap: () => context.go('/more/accounts'),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Sign Out ─────────────────────────────────────────────────
              GhostButton(
                label: l10n.close_session_action,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.close_session_confirm_title),
                      content: Text(l10n.close_session_confirm_body),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(l10n.close_session_confirm_cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(
                            l10n.close_session_confirm_confirm,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(authNotifierProvider.notifier).signOut();
                  }
                },
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: AppTextStyles.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
      letterSpacing: 2.0,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          JeweledIcon(icon: icon, iconColor: iconColor, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
        ],
      ),
    ),
  );
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.avatarUrl, required this.name});

  final String? avatarUrl;
  final String name;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(avatarUrl!),
        onBackgroundImageError: (_, _) {},
        backgroundColor: AppColors.surfaceContainerHigh,
        child: null,
      );
    }
    // Fallback: gradient circle with initials
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primaryFixed, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Manrope',
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
