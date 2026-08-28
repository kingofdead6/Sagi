import 'package:flutter_test/flutter_test.dart';
import 'package:saji/core/money.dart';

void main() {
  group('Money', () {
    test('stores centimes as integers', () {
      expect(Money.fromDinars(1350).centimes, 135000);
      expect(Money.fromDinars(13.5).centimes, 1350);
      expect(Money.fromDinars(0.005).centimes, isA<int>());
    });

    test('formats the way the design specifies', () {
      expect(const Money(135000).format(), '1350.0 د.ج');
      expect(const Money.zero().format(), '0.0 د.ج');
      expect(const Money(50).format(), '0.5 د.ج');
    });

    test('adds, subtracts and multiplies without drifting', () {
      const a = Money(45000);
      const b = Money(15000);
      expect((a + b).centimes, 60000);
      expect((a - b).centimes, 30000);
      expect((a * 3).centimes, 135000);
    });

    test('sums an iterable', () {
      expect([const Money(100), const Money(250), const Money(50)].sum().centimes, 400);
      expect(<Money>[].sum(), const Money.zero());
    });

    test('applies percentages with half-up rounding', () {
      expect(const Money(100000).percent(20).centimes, 20000);
      expect(const Money(33333).percent(10).centimes, 3333);
    });

    test('compares and clamps', () {
      expect(const Money(200) > const Money(100), isTrue);
      expect(const Money(100) <= const Money(100), isTrue);
      expect(const Money(-500).clampToZero(), const Money.zero());
    });

    test('round-trips through JSON as an integer', () {
      const money = Money(98765);
      expect(Money.fromJson(money.toJson()), money);
      expect(Money.fromJson(null), const Money.zero());
      expect(Money.fromJson('1234'), const Money(1234));
    });

    test('equality is by value', () {
      expect(const Money(500), const Money(500));
      expect(const Money(500).hashCode, const Money(500).hashCode);
      expect(const Money(500) == const Money(501), isFalse);
    });
  });
}
