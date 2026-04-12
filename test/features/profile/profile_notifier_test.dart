import 'dart:typed_data';

import 'package:bravoflowai/features/profile/application/profile_providers.dart';
import 'package:bravoflowai/features/profile/domain/entities/profile.dart';
import 'package:bravoflowai/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  final profile = Profile(
    id: 'u1',
    fullName: 'Jane Doe',
    email: 'jane@bravo.ai',
    avatarUrl: null,
    languageCode: 'es',
    createdAt: DateTime(2026, 4, 11),
  );

  test('ProfileController loads profile on build', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));

    final container = ProviderContainer(
      overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final state = await container.read(profileControllerProvider.future);
    expect(state.profile.fullName, 'Jane Doe');
    expect(state.fullNameDraft, 'Jane Doe');
  });

  test('saveProfile uploads avatar then persists profile', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.uploadAvatar(
        bytes: any(named: 'bytes'),
        fileExtension: any(named: 'fileExtension'),
      ),
    ).thenAnswer((_) async => const Right('https://cdn/avatar.png?v=1'));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer(
      (_) async => Right(
        Profile(
          id: 'u1',
          fullName: 'Jane Updated',
          email: 'jane@bravo.ai',
          avatarUrl: 'https://cdn/avatar.png?v=1',
          languageCode: 'es',
          createdAt: DateTime(2026, 4, 11),
        ),
      ),
    );

    final container = ProviderContainer(
      overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(profileControllerProvider.future);

    final notifier = container.read(profileControllerProvider.notifier);
    notifier.updateFullName('Jane Updated');
    notifier.setPendingAvatar(Uint8List.fromList(<int>[1, 2, 3]), 'png');
    await notifier.saveProfile();

    verify(
      () => repo.uploadAvatar(
        bytes: any(named: 'bytes'),
        fileExtension: any(named: 'fileExtension'),
      ),
    ).called(1);
    verify(
      () => repo.updateProfile(
        fullName: 'Jane Updated',
        avatarUrl: 'https://cdn/avatar.png?v=1',
        languageCode: any(named: 'languageCode'),
      ),
    ).called(1);

    final state = container.read(profileControllerProvider).value!;
    expect(state.successMessage, isNotNull);
    expect(state.profile.fullName, 'Jane Updated');
  });

  test('saveProfile validates full name', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));

    final container = ProviderContainer(
      overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(profileControllerProvider.future);

    final notifier = container.read(profileControllerProvider.notifier);
    notifier.updateFullName(' ');
    await notifier.saveProfile();

    final state = container.read(profileControllerProvider).value!;
    expect(state.errorMessage, 'Full name is required');
    verifyNever(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    );
  });

  test('saveProfile ignores duplicate submission while saving', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return Right(profile);
    });

    final container = ProviderContainer(
      overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(profileControllerProvider.future);
    final notifier = container.read(profileControllerProvider.notifier);

    await Future.wait(<Future<void>>[notifier.saveProfile(), notifier.saveProfile()]);

    verify(
      () => repo.updateProfile(
        fullName: 'Jane Doe',
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).called(1);
  });

  test('language draft is persisted only when saveProfile is executed', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer(
      (_) async => Right(
        Profile(
          id: 'u1',
          fullName: 'Jane Doe',
          email: 'jane@bravo.ai',
          avatarUrl: null,
          languageCode: 'en',
          createdAt: DateTime(2026, 4, 11),
        ),
      ),
    );

    final container = ProviderContainer(
      overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(profileControllerProvider.future);

    final notifier = container.read(profileControllerProvider.notifier);
    notifier.updateSelectedLanguageCode('en');

    verifyNever(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    );

    await notifier.saveProfile();

    verify(
      () => repo.updateProfile(
        fullName: 'Jane Doe',
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: 'en',
      ),
    ).called(1);
  });
}
