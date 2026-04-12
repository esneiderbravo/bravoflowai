import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getCurrentProfile();

  Future<Either<Failure, Profile>> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? languageCode,
  });

  Future<Either<Failure, String>> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  });
}
