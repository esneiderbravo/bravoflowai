import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/animated_aura_card.dart';
import '../../../../shared/widgets/ghost_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';

/// Reusable auth form layout used by both Sign In and Sign Up.
///
/// Implements the Luminous Stratum design: atmospheric glow orbs behind a
/// [GlassCard] form container, gradient title heading, and an
/// [AnimatedAuraCard]-wrapped primary CTA.
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
      body: Stack(
        children: [
          // ── Atmospheric Orbs ────────────────────────────────────────────
          const _AuraOrb(
            top: -80,
            right: -80,
            size: 300,
            color: AppColors.primaryFixed,
            opacity: 0.10,
          ),
          const _AuraOrb(
            bottom: -100,
            left: -60,
            size: 250,
            color: AppColors.secondary,
            opacity: 0.08,
          ),
          const _AuraOrb(
            top: 220,
            left: 40,
            size: 160,
            color: AppColors.primaryFixed,
            opacity: 0.06,
          ),

          // ── Form Content ────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Brand (above glass card) ─────────────────────────────
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

                  // ── Glass Form Card ──────────────────────────────────────
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Gradient heading
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.primaryFixed, AppColors.secondary],
                            begin: Alignment(-0.7071, -0.7071),
                            end: Alignment(0.7071, 0.7071),
                          ).createShader(bounds),
                          child: Text(
                            title,
                            style: AppTextStyles.headingLarge.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Fields with filled input decoration theme + light text color
                        Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.copyWith(
                              bodyLarge: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: AppColors.surfaceContainerHigh,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryFixed,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                borderSide: const BorderSide(color: AppColors.error, width: 1.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                              ),
                              labelStyle: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              prefixIconColor: AppColors.onSurfaceVariant,
                              suffixIconColor: AppColors.onSurfaceVariant,
                            ),
                          ),
                          child: Column(
                            children: fields
                                .map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                    child: f,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Aura CTA
                        AnimatedAuraCard(
                          borderRadius: AppSpacing.radiusFull,
                          child: GradientButton(
                            label: submitLabel,
                            onPressed: isLoading ? null : onSubmit,
                            isLoading: isLoading,
                          ),
                        ),

                        if (footerLabel != null && onFooterTap != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          GhostButton(label: footerLabel!, onPressed: onFooterTap!),
                        ],

                        if (footer != null) ...[const SizedBox(height: AppSpacing.md), footer!],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Decorative radial-gradient glow orb positioned absolutely within a [Stack].
class _AuraOrb extends StatelessWidget {
  const _AuraOrb({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
