import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/value_objects/money.dart';
import '../../transactions/application/transaction_providers.dart';
import 'account_providers.dart';
import 'transfer_providers.dart';

/// Computes the derived balance for a given account.
///
/// Balance = initialBalance + sum(income txns) - sum(expense txns)
///           + sum(incoming transfers) - sum(outgoing transfers)
final accountBalanceProvider = FutureProvider.family<Money, String>((ref, accountId) async {
  final accounts = await ref.watch(accountNotifierProvider.future);
  final account = accounts.firstWhere(
    (a) => a.id == accountId,
    orElse: () => throw StateError('Account $accountId not found'),
  );

  final allTransactions = await ref.watch(transactionNotifierProvider.future);
  final txns = allTransactions.where((t) => t.accountId == accountId).toList();

  final transfers = await ref.watch(transferNotifierProvider(accountId).future);

  double balance = account.initialBalance.amount;
  for (final t in txns) {
    if (t.isIncome) {
      balance += t.amount.amount;
    } else {
      balance -= t.amount.amount;
    }
  }
  for (final t in transfers) {
    if (t.toAccountId == accountId) {
      balance += t.amount.amount;
    } else {
      balance -= t.amount.amount;
    }
  }

  return Money(amount: balance);
});
