import 'package:bravoflowai/domain/entities/category.dart';
import 'package:bravoflowai/domain/entities/transaction.dart';
import 'package:bravoflowai/domain/entities/user.dart';
import 'package:bravoflowai/domain/value_objects/date_range.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain entities and value objects', () {
    test('AppUser equality works', () {
      final now = DateTime(2026, 4, 11);
      final a = AppUser(id: 'u1', email: 'a@b.com', name: 'Ana', currency: 'USD', createdAt: now);
      final b = AppUser(id: 'u1', email: 'a@b.com', name: 'Ana', currency: 'USD', createdAt: now);
      expect(a, b);
    });

    test('Money arithmetic enforces currency and calculates correctly', () {
      const a = Money(amount: 20);
      const b = Money(amount: 5);
      expect((a + b).amount, 25);
      expect((a - b).amount, 15);
      expect((a * 2).amount, 40);
      expect(a.currencySymbol, '\$');
    });

    test('DateRange contains date', () {
      final range = DateRange(start: DateTime(2026, 4, 1), end: DateTime(2026, 4, 30));
      expect(range.contains(DateTime(2026, 4, 11)), isTrue);
      expect(range.contains(DateTime(2026, 5, 1)), isFalse);
    });

    test('Transaction income/expense helpers work', () {
      const category = Category(id: 'c1', userId: 'u1', name: 'Salary');
      final tx = Transaction(
        id: 't1',
        userId: 'u1',
        accountId: 'acc1',
        amount: const Money(amount: 1000),
        category: category,
        description: 'Monthly salary',
        date: DateTime(2026, 4, 1),
        type: TransactionType.income,
        createdAt: DateTime(2026, 4, 1),
      );
      expect(tx.isIncome, isTrue);
      expect(tx.isExpense, isFalse);
    });
  });
}
