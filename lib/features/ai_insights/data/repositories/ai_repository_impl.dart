import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/ai_insight.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/ai_repository.dart';
import '../dtos/ai_insight_dto.dart';

/// MVP rules-based AI repository.
///
/// Generates insights from a provided transaction list — no external API calls.
/// Phase 2 will swap this for an LLM-backed implementation.
class RulesBasedAiRepositoryImpl implements AiRepository {
  const RulesBasedAiRepositoryImpl({required this.transactions});

  final List<Transaction> transactions;

  @override
  Future<Either<Failure, List<AiInsight>>> getInsights(String userId) async {
    try {
      final insights = <AiInsight>[];
      final now = DateTime.now();
      var id = 0;

      String nextId() => 'local-${id++}';

      // ── Rule 1: High spending month ──────────────────────────────────────
      final thisMonthExpenses = transactions
          .where((t) =>
              t.isExpense &&
              t.date.year == now.year &&
              t.date.month == now.month)
          .fold(0.0, (sum, t) => sum + t.amount.amount);

      if (thisMonthExpenses > 1000) {
        insights.add(AiInsight(
          id: nextId(),
          userId: userId,
          type: AiInsightType.spending,
          title: 'High spending this month',
          body:
              'You\'ve spent \$${thisMonthExpenses.toStringAsFixed(0)} this month. '
              'Consider reviewing your discretionary expenses.',
          generatedAt: now,
        ));
      }

      // ── Rule 2: Income vs expense balance ────────────────────────────────
      final income = transactions
          .where((t) => t.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount.amount);
      final expenses = transactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount.amount);

      if (income > 0 && expenses / income > 0.9) {
        insights.add(AiInsight(
          id: nextId(),
          userId: userId,
          type: AiInsightType.alert,
          title: 'Spending close to income',
          body:
              'Your expenses are ${((expenses / income) * 100).toStringAsFixed(0)}% '
              'of your income. Try to keep this below 80%.',
          generatedAt: now,
        ));
      }

      // ── Rule 3: Saving opportunity ───────────────────────────────────────
      if (income > 0 && expenses / income < 0.6) {
        insights.add(AiInsight(
          id: nextId(),
          userId: userId,
          type: AiInsightType.saving,
          title: 'Great saving potential',
          body:
              'You\'re spending only ${((expenses / income) * 100).toStringAsFixed(0)}% '
              'of your income. Consider investing the surplus.',
          generatedAt: now,
        ));
      }

      // ── Default: no data yet ──────────────────────────────────────────────
      if (insights.isEmpty) {
        insights.add(AiInsight(
          id: nextId(),
          userId: userId,
          type: AiInsightType.prediction,
          title: 'Add more transactions',
          body:
              'Add your income and expenses to start receiving personalised AI insights.',
          generatedAt: now,
        ));
      }

      return Right(insights);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> chatQuery(
    String prompt, {
    String? userId,
  }) async {
    // Phase 2: proxy through Supabase Edge Function + LLM
    return const Right(
        'AI chat is coming in Phase 2. Add transactions to get started!');
  }
}

/// Convert a domain [AiInsight] to a DTO for storage. Used when persisting
/// rule-generated insights to the `ai_insights` Supabase table.
extension AiInsightPersistence on AiInsight {
  AiInsightDto toDto() => AiInsightDto.fromDomain(this);
}

