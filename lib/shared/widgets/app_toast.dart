import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Top-anchored, animated notification banner for the Luminous Stratum design.
///
/// Usage (via [BuildContext] extensions in context_extensions.dart):
/// ```dart
/// context.showInfoToast('Message');
/// context.showErrorToast('Something went wrong');
/// context.showSuccessToast('Saved!');
/// ```
abstract final class AppToast {
  static OverlayEntry? _current;

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastBanner(
        message: message,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        icon: icon,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }

  static void info(BuildContext context, String message) => _show(
    context,
    message: message,
    backgroundColor: AppColors.surfaceContainerHigh,
    iconColor: AppColors.onSurfaceVariant,
    icon: Icons.info_outline_rounded,
  );

  static void error(BuildContext context, String message) => _show(
    context,
    message: message,
    backgroundColor: AppColors.errorContainer,
    iconColor: AppColors.error,
    icon: Icons.error_outline_rounded,
  );

  static void success(BuildContext context, String message) => _show(
    context,
    message: message,
    backgroundColor: AppColors.success.withValues(alpha: 0.15),
    iconColor: AppColors.success,
    icon: Icons.check_circle_outline_rounded,
    duration: const Duration(seconds: 4),
  );

  static void warning(BuildContext context, String message) => _show(
    context,
    message: message,
    backgroundColor: AppColors.warning.withValues(alpha: 0.15),
    iconColor: AppColors.warning,
    icon: Icons.warning_amber_rounded,
  );
}

class _ToastBanner extends StatefulWidget {
  const _ToastBanner({
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<_ToastBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + AppSpacing.xxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  boxShadow: AppColors.ambientShadow(),
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.iconColor, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
