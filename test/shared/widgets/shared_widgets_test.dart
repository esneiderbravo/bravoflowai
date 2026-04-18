import 'package:bravoflowai/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoadingOverlay shows spinner', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingOverlay())));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
