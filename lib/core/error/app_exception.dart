import 'failure.dart';

/// Wraps a [Failure] as an [Exception] when it must cross a throw/catch
/// boundary (e.g. inside a Riverpod [AsyncNotifier]).
class AppException implements Exception {
  const AppException(this.failure);

  final Failure failure;

  @override
  String toString() => 'AppException(${failure.runtimeType}): ${failure.message}';
}

