// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuoteLine _$QuoteLineFromJson(Map<String, dynamic> json) => _QuoteLine(
  productId: json['productId'] as String,
  name: json['name'] as String,
  qty: (json['qty'] as num?)?.toInt() ?? 1,
  unitPriceCentimes: json['unitPriceCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['unitPriceCentimes']),
  lineTotalCentimes: json['lineTotalCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['lineTotalCentimes']),
);

Map<String, dynamic> _$QuoteLineToJson(_QuoteLine instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'qty': instance.qty,
      'unitPriceCentimes': const MoneyConverter().toJson(
        instance.unitPriceCentimes,
      ),
      'lineTotalCentimes': const MoneyConverter().toJson(
        instance.lineTotalCentimes,
      ),
    };

_OrderQuote _$OrderQuoteFromJson(Map<String, dynamic> json) => _OrderQuote(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => QuoteLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuoteLine>[],
  subtotalCentimes: json['subtotalCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['subtotalCentimes']),
  serviceFeeCentimes: json['serviceFeeCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['serviceFeeCentimes']),
  deliveryFeeCentimes: json['deliveryFeeCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['deliveryFeeCentimes']),
  discountCentimes: json['discountCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['discountCentimes']),
  voucherDiscountCentimes: json['voucherDiscountCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['voucherDiscountCentimes']),
  pointsDiscountCentimes: json['pointsDiscountCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['pointsDiscountCentimes']),
  totalCentimes: json['totalCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['totalCentimes']),
  pointsUsed: (json['pointsUsed'] as num?)?.toInt() ?? 0,
  pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
  voucherCode: json['voucherCode'] as String?,
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$OrderQuoteToJson(
  _OrderQuote instance,
) => <String, dynamic>{
  'items': instance.items,
  'subtotalCentimes': const MoneyConverter().toJson(instance.subtotalCentimes),
  'serviceFeeCentimes': const MoneyConverter().toJson(
    instance.serviceFeeCentimes,
  ),
  'deliveryFeeCentimes': const MoneyConverter().toJson(
    instance.deliveryFeeCentimes,
  ),
  'discountCentimes': const MoneyConverter().toJson(instance.discountCentimes),
  'voucherDiscountCentimes': const MoneyConverter().toJson(
    instance.voucherDiscountCentimes,
  ),
  'pointsDiscountCentimes': const MoneyConverter().toJson(
    instance.pointsDiscountCentimes,
  ),
  'totalCentimes': const MoneyConverter().toJson(instance.totalCentimes),
  'pointsUsed': instance.pointsUsed,
  'pointsEarned': instance.pointsEarned,
  'voucherCode': instance.voucherCode,
  'warnings': instance.warnings,
};
