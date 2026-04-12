import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dtos/profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, Profile>> getCurrentProfile() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('No authenticated user found.'));
      }

      final row = await client.from('profiles').select().eq('id', user.id).maybeSingle();

      if (row == null) {
        final fallbackName =
            (user.userMetadata?['full_name'] as String?) ??
            (user.userMetadata?['name'] as String?) ??
            (user.email?.split('@').first ?? 'User');

        final createPayload = <String, dynamic>{
          'id': user.id,
          'name': fallbackName,
          'full_name': fallbackName,
          'email': user.email,
          'language_code': 'es',
          'theme_mode': 'system',
          'currency': 'USD',
        };

        await client.from('profiles').upsert(createPayload);
        return Right(
          ProfileDto.fromJson(<String, dynamic>{
            ...createPayload,
            'created_at': DateTime.now().toIso8601String(),
          }).toDomain(),
        );
      }

      return Right(
        ProfileDto.fromJson(<String, dynamic>{
          ...row,
          'email': row['email'] ?? user.email,
          'language_code': sanitizeLanguageCode(row['language_code'] as String?),
          'theme_mode': sanitizeThemeMode(row['theme_mode'] as String?),
        }).toDomain(),
      );
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on sb.StorageException catch (e) {
      if (e.message.toLowerCase().contains('bucket not found')) {
        return const Left(
          ServerFailure('Avatar storage bucket is missing. Please run profile storage migration.'),
        );
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? languageCode,
    String? themeMode,
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('No authenticated user found.'));
      }

      final payload = profileUpdatePayload(
        fullName: fullName,
        avatarUrl: avatarUrl,
        languageCode: languageCode,
        themeMode: themeMode,
      );
      await client.from('profiles').update(payload).eq('id', user.id);
      return getCurrentProfile();
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on sb.PostgrestException catch (e) {
      if (_isAvatarUrlMissingFromSchemaCache(e.message)) {
        return const Left(
          ServerFailure(
            'Database schema is outdated: avatar_url is missing in profiles. '
            'Run the latest profile migration and reload schema cache.',
          ),
        );
      }
      return Left(ServerFailure(e.message));
    } on sb.StorageException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('No authenticated user found.'));
      }

      final objectPath = avatarObjectPath(user.id, fileExtension);
      await client.storage
          .from('avatars')
          .uploadBinary(
            objectPath,
            bytes,
            fileOptions: sb.FileOptions(upsert: true, contentType: _contentTypeFor(fileExtension)),
          );

      final publicUrl = client.storage.from('avatars').getPublicUrl(objectPath);
      final cacheBust = DateTime.now().millisecondsSinceEpoch;
      return Right('$publicUrl?v=$cacheBust');
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on sb.StorageException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  static String avatarObjectPath(String userId, String fileExtension) {
    final normalized = fileExtension.toLowerCase().replaceAll('.', '');
    return '$userId/avatar.$normalized';
  }

  static Map<String, dynamic> profileUpdatePayload({
    required String fullName,
    String? avatarUrl,
    String? languageCode,
    String? themeMode,
  }) {
    final payload = <String, dynamic>{
      'name': fullName,
      'full_name': fullName,
      'language_code': sanitizeLanguageCode(languageCode),
      'theme_mode': sanitizeThemeMode(themeMode),
    };
    if (avatarUrl != null) {
      payload['avatar_url'] = avatarUrl;
    }
    return payload;
  }

  static String sanitizeLanguageCode(String? languageCode) {
    return ProfileDto.sanitizeLanguageCode(languageCode);
  }

  static String sanitizeThemeMode(String? themeMode) {
    return ProfileDto.sanitizeThemeMode(themeMode);
  }

  String _contentTypeFor(String extension) {
    switch (extension.toLowerCase().replaceAll('.', '')) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  bool _isAvatarUrlMissingFromSchemaCache(String message) {
    final lower = message.toLowerCase();
    return lower.contains('avatar_url') &&
        lower.contains('profiles') &&
        (lower.contains('schema cache') || lower.contains('pgrst204'));
  }
}
