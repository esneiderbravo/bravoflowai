import '../../../../domain/entities/ai_insight.dart';

/// DTO mapping between Supabase `ai_insights` table rows and [AiInsight].
class AiInsightDto {
  const AiInsightDto({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.confidence,
    required this.generatedAt,
    required this.relatedTransactionIds,
  });

  factory AiInsightDto.fromJson(Map<String, dynamic> json) => AiInsightDto(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
        generatedAt: json['generated_at'] as String,
        relatedTransactionIds:
            (json['related_transaction_ids'] as List<dynamic>?)
                    ?.cast<String>() ??
                [],
      );

  factory AiInsightDto.fromDomain(AiInsight insight) => AiInsightDto(
        id: insight.id,
        userId: insight.userId,
        type: insight.type.name,
        title: insight.title,
        body: insight.body,
        confidence: insight.confidence,
        generatedAt: insight.generatedAt.toIso8601String(),
        relatedTransactionIds: insight.relatedTransactionIds,
      );

  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final double confidence;
  final String generatedAt;
  final List<String> relatedTransactionIds;

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'type': type,
        'title': title,
        'body': body,
        'confidence': confidence,
        'related_transaction_ids': relatedTransactionIds,
      };

  AiInsight toDomain() => AiInsight(
        id: id,
        userId: userId,
        type: _parseType(type),
        title: title,
        body: body,
        confidence: confidence,
        generatedAt: DateTime.parse(generatedAt),
        relatedTransactionIds: relatedTransactionIds,
      );

  static AiInsightType _parseType(String raw) => switch (raw) {
        'saving' => AiInsightType.saving,
        'prediction' => AiInsightType.prediction,
        'alert' => AiInsightType.alert,
        _ => AiInsightType.spending,
      };
}

