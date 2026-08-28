import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/money.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

part 'order.freezed.dart';
part 'order.g.dart';

OrderStatus? _statusOrNull(Object? value) => value == null ? null : OrderStatus.parse(value);

OrderPerson? _personOrNull(Object? json) =>
    json is Map<String, dynamic> ? OrderPerson.fromJson(json) : null;

Vendor? _vendorOrNull(Object? json) => json is Map<String, dynamic> ? Vendor.fromJson(json) : null;

@freezed
abstract class OrderPerson with _$OrderPerson {
  const factory OrderPerson({
    required String id,
    @Default('') String fullName,
    @Default('') String phone,
  }) = _OrderPerson;

  factory OrderPerson.fromJson(Map<String, dynamic> json) => _$OrderPersonFromJson(json);
}

@freezed
abstract class OrderAddress with _$OrderAddress {
  const factory OrderAddress({
    @Default('') String label,
    @Default('') String wilaya,
    @Default('') String commune,
    @Default('') String street,
    String? notes,
  }) = _OrderAddress;

  const OrderAddress._();

  factory OrderAddress.fromJson(Map<String, dynamic> json) => _$OrderAddressFromJson(json);

  String get oneLine => [street, commune, wilaya].where((p) => p.isNotEmpty).join('، ');
}

@freezed
abstract class OrderSelectedOption with _$OrderSelectedOption {
  const factory OrderSelectedOption({
    required String name,
    required String value,
    @MoneyConverter() @Default(Money.zero()) Money priceDeltaCentimes,
  }) = _OrderSelectedOption;

  factory OrderSelectedOption.fromJson(Map<String, dynamic> json) =>
      _$OrderSelectedOptionFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    @RefIdConverter() String? product,
    @Default('') String nameSnapshot,
    @MoneyConverter() @Default(Money.zero()) Money unitPriceCentimes,
    @Default(1) int qty,
    @Default(<OrderSelectedOption>[]) List<OrderSelectedOption> selectedOptions,
    @MoneyConverter() @Default(Money.zero()) Money lineTotalCentimes,
  }) = _OrderItem;

  const OrderItem._();

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  String get optionsLabel => selectedOptions.map((o) => o.value).join('، ');
}

@freezed
abstract class OrderEvent with _$OrderEvent {
  const factory OrderEvent({
    @JsonKey(fromJson: OrderStatus.parse) required OrderStatus to,
    @DateConverter() required DateTime at,
    @JsonKey(fromJson: _statusOrNull) OrderStatus? from,
    @Default('system') String actorRole,
    String? note,
  }) = _OrderEvent;

  factory OrderEvent.fromJson(Map<String, dynamic> json) => _$OrderEventFromJson(json);
}

@freezed
abstract class AppOrder with _$AppOrder {
  const factory AppOrder({
    required String id,
    required String code,
    @DateConverter() required DateTime createdAt,
    @JsonKey(fromJson: OrderStatus.parse) @Default(OrderStatus.pending) OrderStatus status,
    @JsonKey(fromJson: _personOrNull) OrderPerson? customer,
    @JsonKey(fromJson: _vendorOrNull) Vendor? vendor,
    @JsonKey(fromJson: _personOrNull) OrderPerson? agent,
    @Default(DeliveryType.normal) DeliveryType deliveryType,
    @Default(PaymentMethod.cash) PaymentMethod paymentMethod,
    @Default(OrderAddress()) OrderAddress address,
    @GeoPointConverter() LatLng? deliveryLocation,
    String? customerNote,
    @Default(<OrderItem>[]) List<OrderItem> items,
    @MoneyConverter() @Default(Money.zero()) Money subtotalCentimes,
    @MoneyConverter() @Default(Money.zero()) Money serviceFeeCentimes,
    @MoneyConverter() @Default(Money.zero()) Money deliveryFeeCentimes,
    @MoneyConverter() @Default(Money.zero()) Money discountCentimes,
    @MoneyConverter() @Default(Money.zero()) Money totalCentimes,
    @Default(0) int pointsUsed,
    @Default(0) int pointsEarned,
    @Default(<OrderEvent>[]) List<OrderEvent> events,
    String? cancelledReason,
    @NullableDateConverter() DateTime? confirmedAt,
    @NullableDateConverter() DateTime? assignedAt,
    @NullableDateConverter() DateTime? acceptedAt,
    @NullableDateConverter() DateTime? pickedUpAt,
    @NullableDateConverter() DateTime? deliveredAt,
    @Default(false) bool isLate,
  }) = _AppOrder;

  const AppOrder._();

  factory AppOrder.fromJson(Map<String, dynamic> json) => _$AppOrderFromJson(json);

  int get itemCount => items.fold(0, (sum, item) => sum + item.qty);

  bool get hasAgent => agent != null;

  /// Events newest-first, which is how the tracking timeline reads.
  List<OrderEvent> get timeline => [...events]..sort((a, b) => b.at.compareTo(a.at));
}
