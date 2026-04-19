import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// BravoFlow AI — Currency enum
enum Currency { usd, eur, gbp, brl }

/// Value object representing a monetary amount with a [Currency].
///
/// Immutable. Arithmetic operators enforce same-currency constraint.
class Money extends Equatable {
  const Money({required this.amount, this.currency = Currency.usd});

  final double amount;
  final Currency currency;

  bool get isPositive => amount > 0;
  bool get isNegative => amount < 0;
  bool get isZero => amount == 0;

  String get currencySymbol => switch (currency) {
    Currency.usd => '\$',
    Currency.eur => '€',
    Currency.gbp => '£',
    Currency.brl => 'R\$',
  };

  Money operator +(Money other) {
    assert(currency == other.currency, 'Cannot add different currencies');
    return Money(amount: amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    assert(currency == other.currency, 'Cannot subtract different currencies');
    return Money(amount: amount - other.amount, currency: currency);
  }

  Money operator *(double factor) => Money(amount: amount * factor, currency: currency);

  @override
  List<Object> get props => [amount, currency];

  @override
  String toString() {
    final fmt = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 2);
    return fmt.format(amount);
  }
}
