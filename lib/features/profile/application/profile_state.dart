import 'dart:typed_data';

import '../domain/entities/profile.dart';

class ProfileState {
  const ProfileState({
    required this.profile,
    required this.fullNameDraft,
    required this.selectedLanguageCode,
    required this.selectedThemeMode,
    this.pendingAvatarBytes,
    this.pendingAvatarExtension,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  final Profile profile;
  final String fullNameDraft;
  final String selectedLanguageCode;
  final String selectedThemeMode;
  final Uint8List? pendingAvatarBytes;
  final String? pendingAvatarExtension;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  ProfileState copyWith({
    Profile? profile,
    String? fullNameDraft,
    String? selectedLanguageCode,
    String? selectedThemeMode,
    Uint8List? pendingAvatarBytes,
    String? pendingAvatarExtension,
    bool clearPendingAvatar = false,
    bool? isSaving,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      fullNameDraft: fullNameDraft ?? this.fullNameDraft,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
      pendingAvatarBytes: clearPendingAvatar ? null : pendingAvatarBytes ?? this.pendingAvatarBytes,
      pendingAvatarExtension: clearPendingAvatar
          ? null
          : pendingAvatarExtension ?? this.pendingAvatarExtension,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage ? null : successMessage ?? this.successMessage,
    );
  }
}
