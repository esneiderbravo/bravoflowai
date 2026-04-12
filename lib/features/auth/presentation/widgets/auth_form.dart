import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
    this.isLoading = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> fields;
  final String submitLabel;
  final VoidCallback onSubmit;
  final Widget? footer;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.spacingXxl),

              // ── Brand ───────────────────────────────────────────────────
              Text(
                AppConstants.appName,
                style: AppTextStyles.displayLarge.copyWith(color: AppColors.primaryBlue),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // ── Heading ─────────────────────────────────────────────────
              Text(title, style: AppTextStyles.headingLarge),
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Fields ──────────────────────────────────────────────────
              ...fields.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                  child: f,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),

              // ── Submit ───────────────────────────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(submitLabel),
                ),
              ),

              if (footer != null) ...[const SizedBox(height: AppConstants.spacingMd), footer!],
            ],
          ),
        ),
      ),
    );
  }
}
