import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_state.dart';

/// Manages the Dashboard screen's async state.
///
/// Phase 2: inject [TransactionRepository] and compute real balances.
/// Phase 3: inject [AiRepository] and populate [aiInsightPreviews].
class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    // TODO(phase-2): replace with TransactionRepository.getAll()
    // TODO(phase-3): replace aiInsightPreviews with AiRepository.getInsights()
    return const DashboardState(
      userName: 'User',
      totalBalance: 12_450.75,
      monthlyChangePct: 2.4,
      aiInsightPreviews: [
        'You could save \$320 by reducing dining out.',
        'Your spending increased 12% last week.',
      ],
    );
  }

  /// Triggers a manual refresh of the dashboard state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

