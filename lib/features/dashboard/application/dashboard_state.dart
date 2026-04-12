import 'package:equatable/equatable.dart';

/// Presentation-layer state for the Dashboard screen.
///
/// Holds only what the UI needs — no domain entities exposed directly.
/// Phase 2 will populate these from [TransactionRepository].
/// Phase 3 will populate [aiInsightPreviews] from [AiRepository].
class DashboardState extends Equatable {
  const DashboardState({
    required this.userName,
    required this.totalBalance,
    required this.monthlyChangePct,
    required this.aiInsightPreviews,
  });

  /// Display name for the greeting.
  final String userName;

  /// Total account balance (mock until Phase 2).
  final double totalBalance;

  /// Month-over-month balance change in percent (mock until Phase 2).
  final double monthlyChangePct;

  /// Short AI insight strings shown on the dashboard (mock until Phase 3).
  final List<String> aiInsightPreviews;

  bool get isPositiveChange => monthlyChangePct >= 0;

  @override
  List<Object> get props => [userName, totalBalance, monthlyChangePct, aiInsightPreviews];
}
