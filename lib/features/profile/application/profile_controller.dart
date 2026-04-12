import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/i18n/app_locale_controller.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../domain/validation/profile_validation.dart';
import 'profile_providers.dart';
import 'profile_state.dart';

class ProfileController extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    final result = await ref.read(profileRepositoryProvider).getCurrentProfile();
    return result.match(
      (failure) => throw AppException(failure),
      (profile) => ProfileState(
        profile: profile,
        fullNameDraft: profile.fullName,
        selectedLanguageCode: profile.languageCode,
        selectedThemeMode: profile.themeMode,
      ),
    );
  }

  void updateFullName(String value) {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;
    state = AsyncData(
      current.copyWith(fullNameDraft: value, clearErrorMessage: true, clearSuccessMessage: true),
    );
  }

  void setPendingAvatar(Uint8List bytes, String fileExtension) {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;
    state = AsyncData(
      current.copyWith(
        pendingAvatarBytes: bytes,
        pendingAvatarExtension: fileExtension,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  void clearFeedback() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(clearErrorMessage: true, clearSuccessMessage: true));
  }

  void updateSelectedLanguageCode(String languageCode) {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;

    final normalizedCode = languageCode.trim().toLowerCase() == 'en' ? 'en' : 'es';
    state = AsyncData(
      current.copyWith(
        selectedLanguageCode: normalizedCode,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  void updateSelectedThemeMode(String themeMode) {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;

    final normalized = _sanitizeThemeMode(themeMode);
    state = AsyncData(
      current.copyWith(
        selectedThemeMode: normalized,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> saveProfile() async {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;

    final validation = ProfileValidation.validateFullName(current.fullNameDraft);
    if (validation != null) {
      state = AsyncData(current.copyWith(errorMessage: validation, clearSuccessMessage: true));
      return;
    }

    state = AsyncData(
      current.copyWith(isSaving: true, clearErrorMessage: true, clearSuccessMessage: true),
    );

    String? uploadedAvatarUrl;
    if (current.pendingAvatarBytes != null && current.pendingAvatarExtension != null) {
      final uploadResult = await ref
          .read(profileRepositoryProvider)
          .uploadAvatar(
            bytes: current.pendingAvatarBytes!,
            fileExtension: current.pendingAvatarExtension!,
          );

      if (uploadResult.isLeft()) {
        final failure = uploadResult.swap().getOrElse((r) => const UnknownFailure());
        state = AsyncData(current.copyWith(isSaving: false, errorMessage: failure.userMessage));
        return;
      }

      uploadedAvatarUrl = uploadResult.getOrElse((r) => '');
    }

    final updateResult = await ref
        .read(profileRepositoryProvider)
        .updateProfile(
          fullName: current.fullNameDraft.trim(),
          avatarUrl: uploadedAvatarUrl,
          languageCode: current.selectedLanguageCode,
          themeMode: current.selectedThemeMode,
        );

    state = updateResult.match(
      (failure) => AsyncData(current.copyWith(isSaving: false, errorMessage: failure.userMessage)),
      (profile) {
        ref.read(appLocaleControllerProvider.notifier).setLanguageCode(profile.languageCode);
        ref.read(appThemeControllerProvider.notifier).setThemeModeCode(profile.themeMode);
        return AsyncData(
          ProfileState(
            profile: profile,
            fullNameDraft: profile.fullName,
            selectedLanguageCode: profile.languageCode,
            selectedThemeMode: profile.themeMode,
            isSaving: false,
            successMessage: 'profile_saved_successfully',
          ),
        );
      },
    );
  }

  String _sanitizeThemeMode(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'dark':
        return 'dark';
      case 'light':
        return 'light';
      case 'system':
      default:
        return 'system';
    }
  }
}
