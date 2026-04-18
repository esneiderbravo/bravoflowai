import 'package:bravoflowai/core/error/failure.dart';
import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/domain/repositories/auth_repository.dart';
import 'package:bravoflowai/features/auth/application/auth_providers.dart';
import 'package:bravoflowai/features/profile/application/profile_providers.dart';
import 'package:bravoflowai/features/profile/domain/entities/profile.dart';
import 'package:bravoflowai/features/profile/domain/repositories/profile_repository.dart';
import 'package:bravoflowai/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  final profile = Profile(
    id: 'u1',
    fullName: 'Jane Doe',
    email: 'jane@bravo.ai',
    avatarUrl: null,
    languageCode: 'es',
    themeMode: 'system',
    createdAt: DateTime(2026, 4, 11),
  );

  testWidgets('ProfileScreen renders and triggers save', (WidgetTester tester) async {
    final repo = MockProfileRepository();
    final authRepo = MockAuthRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(
      () => repo.updateProfile(
        fullName: any(named: 'fullName'),
        avatarUrl: any(named: 'avatarUrl'),
        languageCode: any(named: 'languageCode'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer((_) async => Right(profile));
    when(() => authRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          profileRepositoryProvider.overrideWithValue(repo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
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
        themeMode: any(named: 'themeMode'),
      ),
    ).called(1);
  });

  testWidgets('ProfileScreen shows validation error for empty full name', (
    WidgetTester tester,
  ) async {
    final repo = MockProfileRepository();
    final authRepo = MockAuthRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(() => authRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          profileRepositoryProvider.overrideWithValue(repo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
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
        themeMode: any(named: 'themeMode'),
      ),
    );
  });

  testWidgets('ProfileScreen asks confirmation before closing session and can cancel', (
    WidgetTester tester,
  ) async {
    final repo = MockProfileRepository();
    final authRepo = MockAuthRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(() => authRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          profileRepositoryProvider.overrideWithValue(repo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cerrar sesion'));
    await tester.pumpAndSettle();

    expect(find.text('Cerrar sesion?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    verifyNever(() => authRepo.signOut());
  });

  testWidgets('ProfileScreen shows localized error when close session fails', (
    WidgetTester tester,
  ) async {
    final repo = MockProfileRepository();
    final authRepo = MockAuthRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(() => authRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));
    when(() => authRepo.signOut()).thenAnswer((_) async => const Left(AuthFailure('network')));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          profileRepositoryProvider.overrideWithValue(repo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cerrar sesion'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesion'));
    await tester.pumpAndSettle();

    verify(() => authRepo.signOut()).called(1);
    expect(find.text('No se pudo cerrar la sesion. Intentalo de nuevo.'), findsOneWidget);
  });

  testWidgets('ProfileScreen redirects to login when close session succeeds', (
    WidgetTester tester,
  ) async {
    final repo = MockProfileRepository();
    final authRepo = MockAuthRepository();
    when(() => repo.getCurrentProfile()).thenAnswer((_) async => Right(profile));
    when(() => authRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));
    when(() => authRepo.signOut()).thenAnswer((_) async => const Right(unit));

    final router = GoRouter(
      initialLocation: '/profile',
      routes: <RouteBase>[
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        GoRoute(
          path: '/auth/sign-in',
          builder: (context, state) => const Scaffold(body: Text('login')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          profileRepositoryProvider.overrideWithValue(repo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cerrar sesion'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesion'));
    await tester.pumpAndSettle();

    expect(find.text('login'), findsOneWidget);
  });
}
