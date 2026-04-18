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
  });

  final String userName;
  final double totalBalance;
  final double monthlyChangePct;

  bool get isPositiveChange => monthlyChangePct >= 0;

  @override
  List<Object> get props => [userName, totalBalance, monthlyChangePct];
}
