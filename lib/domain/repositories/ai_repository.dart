import 'package:fpdart/fpdart.dart';
import '../entities/ai_insight.dart';
import '../../core/error/failure.dart';

/// Contract for AI insight retrieval and interaction.
///
/// Implementations are swappable (rules-based MVP → LLM Phase 2)
/// without touching the domain or presentation layers.
abstract interface class AiRepository {
  /// Returns AI-generated insights for [userId].
  ///
  /// MVP: returns rule-based insights derived from transactions.
  /// Phase 2: calls an external LLM API.
  Future<Either<Failure, List<AiInsight>>> getInsights(String userId);

  /// Sends a natural-language [prompt] to the AI engine.
  ///
  /// MVP: returns a canned response.
  /// Phase 2: proxied through a Supabase Edge Function.
  Future<Either<Failure, String>> chatQuery(
    String prompt, {
    String? userId,
  });
}

