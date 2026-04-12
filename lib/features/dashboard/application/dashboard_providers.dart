import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';

/// Provides the [DashboardNotifier] to the presentation layer.
final dashboardNotifierProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
