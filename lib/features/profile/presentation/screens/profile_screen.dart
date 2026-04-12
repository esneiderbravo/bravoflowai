import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
      final l10n = context.l10n;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.photo_permission_required),
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

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ProfileState>>(profileControllerProvider, (prev, next) {
      final nextState = next.valueOrNull;
      final prevState = prev?.valueOrNull;

      if (nextState?.successMessage != null &&
          prevState?.successMessage != nextState?.successMessage) {
        // Wait one frame so l10n reads the new locale after language-save updates.
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

    return state.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) {
        final message = error is AppException ? error.failure.userMessage : error.toString();
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.profile_title)),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => ref.read(profileControllerProvider.notifier).reload(),
                    child: Text(context.l10n.retry_button),
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

        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.profile_title)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: _AvatarEditor(
                        currentAvatarUrl: data.profile.avatarUrl,
                        pendingAvatarBytes: data.pendingAvatarBytes,
                        onTap: _pickAvatar,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _fullNameController,
                      onChanged: ref.read(profileControllerProvider.notifier).updateFullName,
                      decoration: InputDecoration(
                        labelText: context.l10n.full_name_label,
                        errorText: data.errorMessage,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      initialValue: data.profile.email,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: context.l10n.email_label,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      initialValue: data.selectedLanguageCode,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: context.l10n.language_label,
                        prefixIcon: const Icon(Icons.language_outlined),
                      ),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'es',
                          child: Text(context.l10n.language_spanish),
                        ),
                        DropdownMenuItem<String>(
                          value: 'en',
                          child: Text(context.l10n.language_english),
                        ),
                      ],
                      onChanged: data.isSaving
                          ? null
                          : (value) {
                              if (value == null || value == data.selectedLanguageCode) return;
                              ref
                                  .read(profileControllerProvider.notifier)
                                  .updateSelectedLanguageCode(value);
                            },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: AppSpacing.xl + AppSpacing.lg,
                      child: ElevatedButton(
                        onPressed: data.isSaving
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? true) {
                                  ref.read(profileControllerProvider.notifier).saveProfile();
                                }
                              },
                        child: data.isSaving
                            ? const SizedBox(
                                width: AppSpacing.md + AppSpacing.xs,
                                height: AppSpacing.md + AppSpacing.xs,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : Text(context.l10n.save_changes_button),
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
          CircleAvatar(
            radius: AppSpacing.xl + AppSpacing.md,
            backgroundColor: AppColors.cardDark,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textSecondary,
                    size: AppSpacing.xl,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: AppSpacing.md,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
