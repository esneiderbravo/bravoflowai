import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../domain/validation/profile_validation.dart';
import 'profile_providers.dart';
import 'profile_state.dart';

class ProfileController extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    final result = await ref.read(profileRepositoryProvider).getCurrentProfile();
    return result.match(
      (failure) => throw AppException(failure),
      (profile) => ProfileState(profile: profile, fullNameDraft: profile.fullName),
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
        .updateProfile(fullName: current.fullNameDraft.trim(), avatarUrl: uploadedAvatarUrl);

    state = updateResult.match(
      (failure) => AsyncData(current.copyWith(isSaving: false, errorMessage: failure.userMessage)),
      (profile) => AsyncData(
        ProfileState(
          profile: profile,
          fullNameDraft: profile.fullName,
          isSaving: false,
          successMessage: 'Profile saved successfully.',
        ),
      ),
    );
  }
}
