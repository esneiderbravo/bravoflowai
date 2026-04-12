import 'package:equatable/equatable.dart';

enum AiInsightType { spending, saving, prediction, alert }

/// An AI-generated insight surfaced to the user.
///
/// [confidence] is a value between 0.0 and 1.0.
/// Rules-based insights have confidence = 1.0.
class AiInsight extends Equatable {
  const AiInsight({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.generatedAt,
    this.confidence = 1.0,
    this.relatedTransactionIds = const [],
  });

  final String id;
  final String userId;
  final AiInsightType type;
  final String title;
  final String body;

  /// Confidence score [0.0, 1.0]. Rules-based = 1.0, ML = varies.
  final double confidence;

  final DateTime generatedAt;
  final List<String> relatedTransactionIds;

  @override
  List<Object> get props => [
    id,
    userId,
    type,
    title,
    body,
    confidence,
    generatedAt,
    relatedTransactionIds,
  ];
}
