import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme parity source guards', () {
    const filesToCheck = <String>[
      'lib/shared/widgets/app_shell.dart',
      'lib/features/dashboard/dashboard_screen.dart',
      'lib/features/transactions/presentation/screens/transaction_list_screen.dart',
      'lib/features/transactions/presentation/screens/add_transaction_screen.dart',
      'lib/features/ai_insights/ai_insights_screen.dart',
      'lib/features/budget/presentation/screens/budget_screen.dart',
      'lib/features/auth/presentation/widgets/auth_form.dart',
    ];

    test('primary routes do not hardcode dark background token', () {
      for (final path in filesToCheck) {
        final content = File(path).readAsStringSync();
        expect(
          content.contains('backgroundColor: AppColors.backgroundDark'),
          isFalse,
          reason: 'Remove hardcoded dark background in $path',
        );
        expect(
          content.contains('AppColors.cardDark'),
          isFalse,
          reason: 'Remove hardcoded dark card usage in $path',
        );
        expect(
          content.contains('AppColors.surfaceDark'),
          isFalse,
          reason: 'Remove hardcoded dark surface usage in $path',
        );
      }
    });
  });
}
