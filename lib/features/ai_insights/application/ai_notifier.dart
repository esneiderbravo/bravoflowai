import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/services/app_providers.dart';
import '../../../../domain/entities/ai_insight.dart';
import '../../../../features/transactions/application/transaction_providers.dart';
import 'ai_providers.dart';

/// Manages the list of [AiInsight] entities.
///
/// Derives insights from the current transaction list via [AiRepository].
class AiNotifier extends AsyncNotifier<List<AiInsight>> {
  @override
  Future<List<AiInsight>> build() async {
    final userId = ref.read(supabaseClientProvider).auth.currentUser?.id ?? '';
    final result =
        await ref.read(aiRepositoryProvider).getInsights(userId);
    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

