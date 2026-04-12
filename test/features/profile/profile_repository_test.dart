import 'package:bravoflowai/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileRepositoryImpl helpers', () {
    test('avatarObjectPath normalizes extension', () {
      final path = ProfileRepositoryImpl.avatarObjectPath('user-123', '.PNG');
      expect(path, 'user-123/avatar.png');
    });

    test('profileUpdatePayload maps full name and optional avatar', () {
      final payload = ProfileRepositoryImpl.profileUpdatePayload(
        fullName: 'Jane Doe',
        avatarUrl: 'https://cdn/avatar.png',
      );

      expect(payload['name'], 'Jane Doe');
      expect(payload['full_name'], 'Jane Doe');
      expect(payload['avatar_url'], 'https://cdn/avatar.png');
    });

    test('profileUpdatePayload omits avatar_url when null', () {
      final payload = ProfileRepositoryImpl.profileUpdatePayload(fullName: 'Jane Doe');

      expect(payload.containsKey('avatar_url'), isFalse);
    });
  });
}
