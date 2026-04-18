import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../../auth/application/auth_providers.dart';
import '../../application/profile_providers.dart';
import '../../application/profile_state.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final ext = _extensionFromPath(file.path);
      ref.read(profileControllerProvider.notifier).setPendingAvatar(bytes, ext);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.photo_permission_required),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  String _extensionFromPath(String path) {
    final index = path.lastIndexOf('.');
    if (index == -1 || index == path.length - 1) return 'jpg';
    return path.substring(index + 1).toLowerCase();
  }

  Future<void> _closeSession() async {
    final l10n = context.l10n;
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.close_session_confirm_title),
        content: Text(l10n.close_session_confirm_body),
        actions: <Widget>[
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
    if (shouldClose != true) return;
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!mounted) return;
    final authState = ref.read(authNotifierProvider);
    if (!authState.hasError) context.go('/auth/sign-in');
  }

  Future<void> _showLanguagePicker(ProfileState data) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => _PickerSheet(
        title: l10n.language_label,
        items: [
          _PickerItem(value: 'es', label: l10n.language_spanish),
          _PickerItem(value: 'en', label: l10n.language_english),
        ],
        selected: data.selectedLanguageCode,
        onSelected: (value) {
          ref.read(profileControllerProvider.notifier).updateSelectedLanguageCode(value);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  Future<void> _showThemePicker(ProfileState data) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => _PickerSheet(
        title: l10n.theme_label,
        items: [
          _PickerItem(value: 'system', label: l10n.theme_system),
          _PickerItem(value: 'dark', label: l10n.theme_dark),
          _PickerItem(value: 'light', label: l10n.theme_light),
        ],
        selected: data.selectedThemeMode,
        onSelected: (value) {
          ref.read(profileControllerProvider.notifier).updateSelectedThemeMode(value);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.hasError && next.error is AppException) {
        final failure = (next.error! as AppException).failure;
        final message = failure.userMessage == 'close_session_failed'
            ? context.l10n.close_session_failed
            : failure.userMessage;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
      }
    });

    ref.listen<AsyncValue<ProfileState>>(profileControllerProvider, (prev, next) {
      final nextState = next.valueOrNull;
      final prevState = prev?.valueOrNull;

      if (nextState?.successMessage != null &&
          prevState?.successMessage != nextState?.successMessage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l10n = context.l10n;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  nextState!.successMessage == 'profile_saved_successfully'
                      ? l10n.profile_saved_successfully
                      : nextState.successMessage!,
                ),
                backgroundColor: AppColors.success,
              ),
            );
          ref.read(profileControllerProvider.notifier).clearFeedback();
        });
      }

      if (nextState?.errorMessage != null && prevState?.errorMessage != nextState?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(nextState!.errorMessage!), backgroundColor: AppColors.error),
          );
      }
    });

    final state = ref.watch(profileControllerProvider);
    final authState = ref.watch(authNotifierProvider);
    final isClosingSession = authState.isLoading;

    return state.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryFixed)),
      ),
      error: (error, _) {
        final message = error is AppException ? error.failure.userMessage : error.toString();
        return Scaffold(
          backgroundColor: AppColors.surface,
          extendBodyBehindAppBar: true,
          appBar: const _ProfileAppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                  const SizedBox(height: AppSpacing.md),
                  Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  GradientButton(
                    label: context.l10n.retry_button,
                    onPressed: () => ref.read(profileControllerProvider.notifier).reload(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      data: (data) {
        if (_fullNameController.text != data.fullNameDraft) {
          _fullNameController.value = TextEditingValue(
            text: data.fullNameDraft,
            selection: TextSelection.collapsed(offset: data.fullNameDraft.length),
          );
        }

        final l10n = context.l10n;

        final languageLabel = data.selectedLanguageCode == 'es'
            ? l10n.language_spanish
            : l10n.language_english;

        final themeLabel = switch (data.selectedThemeMode) {
          'dark' => l10n.theme_dark,
          'light' => l10n.theme_light,
          _ => l10n.theme_system,
        };

        return Scaffold(
          backgroundColor: AppColors.surface,
          extendBodyBehindAppBar: true,
          appBar: const _ProfileAppBar(),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: 100,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // ── Avatar ──────────────────────────────────────────────
                    Center(
                      child: _AvatarEditor(
                        currentAvatarUrl: data.profile.avatarUrl,
                        pendingAvatarBytes: data.pendingAvatarBytes,
                        onTap: _pickAvatar,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Personal Info ───────────────────────────────────────
                    _SectionLabel(l10n.profile_section_personal),
                    const SizedBox(height: AppSpacing.sm),
                    GlassCard(
                      borderRadius: AppSpacing.radiusLg,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _fullNameController,
                            onChanged: ref.read(profileControllerProvider.notifier).updateFullName,
                            decoration: InputDecoration(
                              labelText: l10n.full_name_label,
                              errorText: data.errorMessage,
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            initialValue: data.profile.email,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: l10n.email_label,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Preferences ─────────────────────────────────────────
                    _SectionLabel(l10n.more_preferences),
                    const SizedBox(height: AppSpacing.sm),
                    GlassCard(
                      borderRadius: AppSpacing.radiusLg,
                      child: Column(
                        children: <Widget>[
                          _PreferenceTile(
                            icon: Icons.language_outlined,
                            iconColor: AppColors.secondary,
                            label: l10n.language_label,
                            value: languageLabel,
                            enabled: !data.isSaving,
                            onTap: data.isSaving ? null : () => _showLanguagePicker(data),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Container(
                              height: 1,
                              color: AppColors.outlineVariant.withValues(alpha: 0.15),
                            ),
                          ),
                          _PreferenceTile(
                            icon: Icons.dark_mode_outlined,
                            iconColor: AppColors.tertiary,
                            label: l10n.theme_label,
                            value: themeLabel,
                            enabled: !data.isSaving,
                            onTap: data.isSaving ? null : () => _showThemePicker(data),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Save ────────────────────────────────────────────────
                    GradientButton(
                      label: l10n.save_changes_button,
                      isLoading: data.isSaving,
                      onPressed: data.isSaving
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? true) {
                                ref.read(profileControllerProvider.notifier).saveProfile();
                              }
                            },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Close Session ───────────────────────────────────────
                    GlassCard(
                      borderRadius: AppSpacing.radiusLg,
                      child: _PreferenceTile(
                        icon: Icons.logout_rounded,
                        iconColor: AppColors.error,
                        label: isClosingSession
                            ? l10n.close_session_signing_out
                            : l10n.close_session_action,
                        labelColor: AppColors.error,
                        enabled: !isClosingSession,
                        onTap: isClosingSession ? null : _closeSession,
                        trailing: isClosingSession
                            ? const SizedBox(
                                width: AppSpacing.md,
                                height: AppSpacing.md,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.error,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Glass App Bar ─────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

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
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => context.go('/more'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.primaryFixed, AppColors.secondary],
                    ).createShader(b),
                    child: Text(
                      context.l10n.profile_title,
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: Colors.white,
                      ),
                    ),
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

// ── Section Label ─────────────────────────────────────────────────────────────

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

// ── Preference Tile ───────────────────────────────────────────────────────────

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.value,
    this.labelColor,
    this.enabled = true,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final Color? labelColor;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(
          children: <Widget>[
            JeweledIcon(
              icon: icon,
              iconColor: iconColor,
              containerColor: iconColor.withValues(alpha: 0.12),
              size: 20,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? AppColors.onSurface,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null) ...<Widget>[
              Text(value!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryFixed)),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 18),
            ] else
              const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Sheet Picker ───────────────────────────────────────────────────────

class _PickerItem {
  const _PickerItem({required this.value, required this.label});
  final String value;
  final String label;
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<_PickerItem> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ...items.map(
            (item) => GestureDetector(
              onTap: () => onSelected(item.value),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: item.value == selected
                              ? AppColors.primaryFixed
                              : AppColors.onSurface,
                          fontWeight: item.value == selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (item.value == selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryFixed,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Avatar Editor ─────────────────────────────────────────────────────────────

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.currentAvatarUrl,
    required this.pendingAvatarBytes,
    required this.onTap,
  });

  final String? currentAvatarUrl;
  final Uint8List? pendingAvatarBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageProvider = pendingAvatarBytes != null
        ? MemoryImage(pendingAvatarBytes!) as ImageProvider
        : (currentAvatarUrl != null && currentAvatarUrl!.isNotEmpty)
        ? NetworkImage(currentAvatarUrl!)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: imageProvider == null
                  ? const LinearGradient(
                      colors: [AppColors.primaryFixed, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primaryFixed.withValues(alpha: 0.25),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: imageProvider != null
                ? ClipOval(
                    child: Image(image: imageProvider, width: 96, height: 96, fit: BoxFit.cover),
                  )
                : const Icon(Icons.person_rounded, color: AppColors.onPrimary, size: 44),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: const Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.primaryFixed),
          ),
        ],
      ),
    );
  }
}
