import '../../domain/entities/profile.dart';

class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.languageCode,
    required this.themeMode,
    required this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    final fallbackName = json['name'] as String? ?? '';
    final fullName = (json['full_name'] as String?)?.trim();
    return ProfileDto(
      id: json['id'] as String,
      fullName: (fullName == null || fullName.isEmpty) ? fallbackName : fullName,
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      languageCode: sanitizeLanguageCode(json['language_code'] as String?),
      themeMode: sanitizeThemeMode(json['theme_mode'] as String?),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String languageCode;
  final String themeMode;
  final String createdAt;

  Map<String, dynamic> toUpdateJson({
    required String updatedFullName,
    required String updatedLanguageCode,
    required String updatedThemeMode,
    String? updatedAvatarUrl,
  }) {
    final payload = <String, dynamic>{
      'full_name': updatedFullName,
      'name': updatedFullName,
      'language_code': sanitizeLanguageCode(updatedLanguageCode),
      'theme_mode': sanitizeThemeMode(updatedThemeMode),
    };
    if (updatedAvatarUrl != null) {
      payload['avatar_url'] = updatedAvatarUrl;
    }
    return payload;
  }

  Profile toDomain() {
    return Profile(
      id: id,
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      languageCode: languageCode,
      themeMode: themeMode,
      createdAt: DateTime.parse(createdAt),
    );
  }

  static String sanitizeLanguageCode(String? languageCode) {
    final code = languageCode?.trim().toLowerCase();
    return code == 'en' ? 'en' : 'es';
  }

  static String sanitizeThemeMode(String? themeMode) {
    final normalized = themeMode?.trim().toLowerCase();
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
