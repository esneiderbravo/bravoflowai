import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/application/auth_providers.dart';
import 'dashboard_state.dart';

/// Manages the Dashboard screen's async state.
///
/// Phase 2: inject [TransactionRepository] and compute real balances.
class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.valueOrNull;
    final userName = (user?.name.isNotEmpty == true) ? user!.name : (user?.email ?? 'User');

    // TODO(phase-2): replace with TransactionRepository.getAll()
    return DashboardState(userName: userName, totalBalance: 12_450.75, monthlyChangePct: 2.4);
  }

  /// Triggers a manual refresh of the dashboard state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
