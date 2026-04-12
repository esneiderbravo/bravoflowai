import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/app_providers.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../data/repositories/transaction_repository_impl.dart';
import 'transaction_notifier.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

final transactionNotifierProvider = AsyncNotifierProvider<TransactionNotifier, List<Transaction>>(
  TransactionNotifier.new,
);
