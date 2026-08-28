import 'package:flutter/foundation.dart';

/// Money value object. Amounts are **always** an integer number of centimes
/// (1 دج = 100 سنتيم) — the app never uses a double for money.
@immutable
class Money implements Comparable<Money> {
  const Money(this.centimes) : assert(centimes >= -1 << 52, 'centimes out of range');

  const Money.zero() : centimes = 0;

  /// Builds a Money from dinars — only for literals and user input.
  factory Money.fromDinars(num dinars) => Money((dinars * centimesPerDinar).round());

  factory Money.fromJson(Object? value) {
    if (value is int) return Money(value);
    if (value is num) return Money(value.round());
    if (value is String) return Money(int.tryParse(value) ?? 0);
    return const Money.zero();
  }

  static const centimesPerDinar = 100;

  /// The currency suffix, in the active language. [Money] is a domain object
  /// with no BuildContext, so the app sets this once when the locale changes
  /// rather than threading l10n through every price.
  static String symbol = 'د.ج';

  final int centimes;

  double get dinars => centimes / centimesPerDinar;

  bool get isZero => centimes == 0;
  bool get isPositive => centimes > 0;

  Money operator +(Money other) => Money(centimes + other.centimes);
  Money operator -(Money other) => Money(centimes - other.centimes);
  Money operator *(int factor) => Money(centimes * factor);

  bool operator >(Money other) => centimes > other.centimes;
  bool operator <(Money other) => centimes < other.centimes;
  bool operator >=(Money other) => centimes >= other.centimes;
  bool operator <=(Money other) => centimes <= other.centimes;

  Money clampToZero() => centimes < 0 ? const Money.zero() : this;

  /// Applies a percentage (0-100), rounding half-up to whole centimes.
  Money percent(num value) => Money((centimes * value / 100).round());

  /// "1350.0 د.ج" — one decimal, as the design specifies.
  String format() {
    final rounded = (dinars * 10).round() / 10;
    return '${rounded.toStringAsFixed(1)} $symbol';
  }

  /// The number alone, for places that render the currency separately.
  String formatAmount() => ((dinars * 10).round() / 10).toStringAsFixed(1);

  int toJson() => centimes;

  @override
  int compareTo(Money other) => centimes.compareTo(other.centimes);

  @override
  bool operator ==(Object other) => other is Money && other.centimes == centimes;

  @override
  int get hashCode => centimes.hashCode;

  @override
  String toString() => format();
}

extension MoneyIterable on Iterable<Money> {
  Money sum() => fold(const Money.zero(), (a, b) => a + b);
}
