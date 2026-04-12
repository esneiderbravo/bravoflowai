import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import 'profile_controller.dart';
import 'profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

final profileControllerProvider = AsyncNotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);
