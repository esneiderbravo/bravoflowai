import 'package:bravoflowai/features/auth/data/dtos/user_dto.dart';
import 'package:bravoflowai/features/profile/data/dtos/profile_dto.dart';
import 'package:bravoflowai/features/transactions/data/dtos/transaction_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DTO mappings', () {
    test('UserDto maps json to domain', () {
      final dto = UserDto.fromJson({
        'id': 'u1',
        'email': 'user@mail.com',
        'name': 'User',
        'currency': 'USD',
        'created_at': '2026-04-11T00:00:00.000Z',
      });

      final user = dto.toDomain();
      expect(user.id, 'u1');
      expect(user.email, 'user@mail.com');
      expect(dto.toJson()['name'], 'User');
    });

    test('TransactionDto maps json to domain', () {
      final dto = TransactionDto.fromJson({
        'id': 't1',
        'user_id': 'u1',
        'amount': 50.5,
        'category_id': 'c1',
        'description': 'Lunch',
        'date': '2026-04-11',
        'type': 'expense',
        'created_at': '2026-04-11T10:00:00.000Z',
        'categories': {'name': 'Food'},
      });

      final tx = dto.toDomain();
      expect(tx.description, 'Lunch');
      expect(tx.category.name, 'Food');
      expect(tx.amount.amount, 50.5);
    });

    test('ProfileDto maps json to domain', () {
      final dto = ProfileDto.fromJson({
        'id': 'u1',
        'full_name': 'Jane Doe',
        'email': 'jane@bravo.ai',
        'avatar_url': 'https://cdn/avatar.png',
        'language_code': 'en',
        'theme_mode': 'dark',
        'created_at': '2026-04-11T00:00:00.000Z',
      });

      final profile = dto.toDomain();
      expect(profile.id, 'u1');
      expect(profile.fullName, 'Jane Doe');
      expect(profile.email, 'jane@bravo.ai');
      expect(profile.avatarUrl, 'https://cdn/avatar.png');
      expect(profile.languageCode, 'en');
      expect(profile.themeMode, 'dark');
    });

    test('ProfileDto defaults language_code and theme_mode when absent', () {
      final dto = ProfileDto.fromJson({
        'id': 'u2',
        'full_name': 'Carlos',
        'email': 'carlos@bravo.ai',
        'avatar_url': null,
        'created_at': '2026-04-11T00:00:00.000Z',
      });
      expect(dto.toDomain().languageCode, 'es');
      expect(dto.toDomain().themeMode, 'system');
    });
  });
}
