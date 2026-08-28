import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/money.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
abstract class QuoteLine with _$QuoteLine {
  const factory QuoteLine({
    required String productId,
    required String name,
    @Default(1) int qty,
    @MoneyConverter() @Default(Money.zero()) Money unitPriceCentimes,
    @MoneyConverter() @Default(Money.zero()) Money lineTotalCentimes,
  }) = _QuoteLine;

  factory QuoteLine.fromJson(Map<String, dynamic> json) => _$QuoteLineFromJson(json);
}

/// The authoritative price breakdown from `POST /orders/quote`. The client
/// never computes a total it then sends back.
@freezed
abstract class OrderQuote with _$OrderQuote {
  const factory OrderQuote({
    @Default(<QuoteLine>[]) List<QuoteLine> items,
    @MoneyConverter() @Default(Money.zero()) Money subtotalCentimes,
    @MoneyConverter() @Default(Money.zero()) Money serviceFeeCentimes,
    @MoneyConverter() @Default(Money.zero()) Money deliveryFeeCentimes,
    @MoneyConverter() @Default(Money.zero()) Money discountCentimes,
    @MoneyConverter() @Default(Money.zero()) Money voucherDiscountCentimes,
    @MoneyConverter() @Default(Money.zero()) Money pointsDiscountCentimes,
    @MoneyConverter() @Default(Money.zero()) Money totalCentimes,
    @Default(0) int pointsUsed,
    @Default(0) int pointsEarned,
    String? voucherCode,
    @Default(<String>[]) List<String> warnings,
  }) = _OrderQuote;

  const OrderQuote._();

  factory OrderQuote.fromJson(Map<String, dynamic> json) => _$OrderQuoteFromJson(json);

  bool get hasDiscount => discountCentimes.isPositive;
  bool get hasWarnings => warnings.isNotEmpty;
}
