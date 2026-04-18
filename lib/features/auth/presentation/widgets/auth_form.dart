import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/ghost_button.dart';
import '../../../../shared/widgets/gradient_button.dart';

/// Reusable auth form layout used by both Sign In and Sign Up.
///
/// Callers compose the [fields] they need and provide an [onSubmit] callback.
class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.submitLabel,
    required this.onSubmit,
    this.footer,
    this.footerLabel,
    this.onFooterTap,
    this.isLoading = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> fields;
  final String submitLabel;
  final VoidCallback onSubmit;
  final Widget? footer;
  final String? footerLabel;
  final VoidCallback? onFooterTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // ── Brand ───────────────────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/images/bravoflow_logo.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primaryFixed,
                      size: 56,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primaryFixed, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    AppConstants.appName,
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Heading ─────────────────────────────────────────────────
              Text(title, style: AppTextStyles.headingLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Fields ──────────────────────────────────────────────────
              ...fields.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: f,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Submit ───────────────────────────────────────────────────
              GradientButton(
                label: submitLabel,
                onPressed: isLoading ? null : onSubmit,
                isLoading: isLoading,
              ),

              if (footerLabel != null && onFooterTap != null) ...[
                const SizedBox(height: AppSpacing.md),
                GhostButton(label: footerLabel!, onPressed: onFooterTap!),
              ],

              if (footer != null) ...[const SizedBox(height: AppSpacing.md), footer!],
            ],
          ),
        ),
      ),
    );
  }
}
