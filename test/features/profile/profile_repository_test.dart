import 'package:bravoflowai/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileRepositoryImpl helpers', () {
    test('avatarObjectPath normalizes extension', () {
      final path = ProfileRepositoryImpl.avatarObjectPath('user-123', '.PNG');
      expect(path, 'user-123/avatar.png');
    });

    test('profileUpdatePayload maps full name, language, theme and optional avatar', () {
      final payload = ProfileRepositoryImpl.profileUpdatePayload(
        fullName: 'Jane Doe',
        avatarUrl: 'https://cdn/avatar.png',
        languageCode: 'en',
        themeMode: 'dark',
      );

      expect(payload['name'], 'Jane Doe');
      expect(payload['full_name'], 'Jane Doe');
      expect(payload['language_code'], 'en');
      expect(payload['theme_mode'], 'dark');
      expect(payload['avatar_url'], 'https://cdn/avatar.png');
    });

    test('profileUpdatePayload defaults when optional fields are absent', () {
      final payload = ProfileRepositoryImpl.profileUpdatePayload(fullName: 'Jane Doe');

      expect(payload['language_code'], 'es');
      expect(payload['theme_mode'], 'system');
      expect(payload.containsKey('avatar_url'), isFalse);
    });

    test('sanitizeLanguageCode falls back to Spanish for unsupported values', () {
      expect(ProfileRepositoryImpl.sanitizeLanguageCode('en'), 'en');
      expect(ProfileRepositoryImpl.sanitizeLanguageCode('pt'), 'es');
      expect(ProfileRepositoryImpl.sanitizeLanguageCode(null), 'es');
    });

    test('sanitizeThemeMode falls back to system for unsupported values', () {
      expect(ProfileRepositoryImpl.sanitizeThemeMode('dark'), 'dark');
      expect(ProfileRepositoryImpl.sanitizeThemeMode('light'), 'light');
      expect(ProfileRepositoryImpl.sanitizeThemeMode('auto'), 'system');
      expect(ProfileRepositoryImpl.sanitizeThemeMode(null), 'system');
    });
  });
}
