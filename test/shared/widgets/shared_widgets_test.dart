import 'package:bravoflowai/shared/widgets/ai_insight_chip.dart';
import 'package:bravoflowai/shared/widgets/gradient_card.dart';
import 'package:bravoflowai/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GradientCard renders child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: GradientCard(child: Text('hello'))),
      ),
    );

    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('AiInsightChip renders label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AiInsightChip(icon: Icons.lightbulb_outline_rounded, label: 'Insight text'),
        ),
      ),
    );

    expect(find.text('Insight text'), findsOneWidget);
  });

  testWidgets('LoadingOverlay shows spinner', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingOverlay())));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
