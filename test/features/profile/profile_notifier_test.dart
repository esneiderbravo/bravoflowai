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
    themeMode: 'system',
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
    expect(state.selectedThemeMode, 'system');
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
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer(
      (_) async => Right(
        Profile(
          id: 'u1',
          fullName: 'Jane Updated',
          email: 'jane@bravo.ai',
          avatarUrl: 'https://cdn/avatar.png?v=1',
          languageCode: 'es',
          themeMode: 'dark',
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
    notifier.updateSelectedThemeMode('dark');
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
        themeMode: 'dark',
      ),
    ).called(1);

    final state = container.read(profileControllerProvider).value!;
    expect(state.successMessage, isNotNull);
    expect(state.profile.fullName, 'Jane Updated');
    expect(state.profile.themeMode, 'dark');
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
        themeMode: any(named: 'themeMode'),
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
        themeMode: any(named: 'themeMode'),
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
        themeMode: any(named: 'themeMode'),
      ),
    ).called(1);
  });

  test('language and theme drafts are persisted only when saveProfile is executed', () async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer(
      (_) async => Right(
        Profile(
          id: 'u1',
          fullName: 'Jane Doe',
          email: 'jane@bravo.ai',
          avatarUrl: null,
          languageCode: 'en',
          themeMode: 'dark',
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
    notifier.updateSelectedThemeMode('dark');

    verifyNever(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
        themeMode: any(named: 'themeMode'),
      ),
    );

    await notifier.saveProfile();

    verify(
      () => repo.updateProfile(
        fullName: 'Jane Doe',
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: 'en',
        themeMode: 'dark',
      ),
    ).called(1);
  });
}
