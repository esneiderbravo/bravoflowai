/// BravoFlow AI — AI Service (Placeholder)
///
/// This class will be expanded with AI provider integrations
/// (e.g., OpenAI, Gemini) in a future feature iteration.
abstract final class AiService {
  // TODO(feature): Implement AI insight generation.
  // TODO(feature): Implement natural-language spending analysis.
  // TODO(feature): Implement budget recommendation engine.

  /// Placeholder: Returns a static insight until the AI backend is wired up.
  static Future<String> getInsight(String context) async {
    await Future<void>.delayed(const Duration(milliseconds: 500)); // simulate latency
    return 'AI insights coming soon — stay tuned!';
  }
}
