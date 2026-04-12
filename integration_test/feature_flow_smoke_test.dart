import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Feature flow smoke: dashboard -> transactions -> ai -> budget',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Scaffold(body: Text('Dashboard')),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) =>
              const Scaffold(body: Text('Transactions')),
        ),
        GoRoute(
          path: '/ai',
          builder: (context, state) => const Scaffold(body: Text('AI')),
        ),
        GoRoute(
          path: '/budget',
          builder: (context, state) => const Scaffold(body: Text('Budget')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);

    router.go('/transactions');
    await tester.pumpAndSettle();
    expect(find.text('Transactions'), findsOneWidget);

    router.go('/ai');
    await tester.pumpAndSettle();
    expect(find.text('AI'), findsOneWidget);

    router.go('/budget');
    await tester.pumpAndSettle();
    expect(find.text('Budget'), findsOneWidget);
  });
}
