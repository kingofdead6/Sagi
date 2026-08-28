/// A voucher the signed-in customer can still redeem.
///
/// Deliberately not the admin `Voucher` model: this comes from
/// `GET /vouchers/mine`, which returns only what is still usable and omits the
/// quota bookkeeping the dashboard needs.
class CustomerVoucher {
  const CustomerVoucher({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.minOrderCentimes,
    this.endsAt,
  });

  factory CustomerVoucher.fromJson(Map<String, dynamic> json) => CustomerVoucher(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        type: CustomerVoucherType.fromWire(json['type'] as String?),
        value: (json['value'] as num?) ?? 0,
        minOrderCentimes: (json['minOrderCentimes'] as num?)?.toInt() ?? 0,
        endsAt: DateTime.tryParse(json['endsAt'] as String? ?? ''),
      );

  final String id;
  final String code;
  final CustomerVoucherType type;
  final num value;
  final int minOrderCentimes;
  final DateTime? endsAt;

  bool get hasMinimum => minOrderCentimes > 0;
}

enum CustomerVoucherType {
  percentage,
  fixed,
  freeDelivery;

  static CustomerVoucherType fromWire(String? wire) => switch (wire) {
        'fixed' => CustomerVoucherType.fixed,
        'freeDelivery' => CustomerVoucherType.freeDelivery,
        _ => CustomerVoucherType.percentage,
      };
}
