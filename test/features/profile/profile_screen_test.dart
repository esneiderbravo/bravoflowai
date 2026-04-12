import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/features/profile/application/profile_providers.dart';
import 'package:bravoflowai/features/profile/domain/entities/profile.dart';
import 'package:bravoflowai/features/profile/domain/repositories/profile_repository.dart';
import 'package:bravoflowai/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  final profile = Profile(
    id: 'u1',
    fullName: 'Jane Doe',
    email: 'jane@bravo.ai',
    avatarUrl: null,
    languageCode: 'es',
    createdAt: DateTime(2026, 4, 11),
  );

  testWidgets('ProfileScreen renders and triggers save', (WidgetTester tester) async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer((_) async => Right(profile));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Guardar cambios'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Correo'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre completo'), 'Jane Updated');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    verify(
      () => repo.updateProfile(
        fullName: 'Jane Updated',
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    ).called(1);
  });

  testWidgets('ProfileScreen shows validation error for empty full name', (
    WidgetTester tester,
  ) async {
    final repo = MockProfileRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[profileRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre completo'), ' ');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsWidgets);
    verifyNever(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
      ),
    );
  });
}
