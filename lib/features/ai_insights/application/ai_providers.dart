import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/ai_insight.dart';
import '../../../../domain/repositories/ai_repository.dart';
import '../../../../features/transactions/application/transaction_providers.dart';
import '../data/repositories/ai_repository_impl.dart';
import 'ai_notifier.dart';

/// Provides the [AiRepository] — rules-based for MVP, swappable for Phase 2.
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  // Derive insights from the current transaction list (rules engine)
  final transactions = ref.watch(transactionNotifierProvider).valueOrNull ?? [];
  return RulesBasedAiRepositoryImpl(transactions: transactions);
});

final aiNotifierProvider = AsyncNotifierProvider<AiNotifier, List<AiInsight>>(AiNotifier.new);
