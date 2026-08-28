// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderPerson _$OrderPersonFromJson(Map<String, dynamic> json) => _OrderPerson(
  id: json['id'] as String,
  fullName: json['fullName'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
);

Map<String, dynamic> _$OrderPersonToJson(_OrderPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
    };

_OrderAddress _$OrderAddressFromJson(Map<String, dynamic> json) =>
    _OrderAddress(
      label: json['label'] as String? ?? '',
      wilaya: json['wilaya'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      street: json['street'] as String? ?? '',
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OrderAddressToJson(_OrderAddress instance) =>
    <String, dynamic>{
      'label': instance.label,
      'wilaya': instance.wilaya,
      'commune': instance.commune,
      'street': instance.street,
      'notes': instance.notes,
    };

_OrderSelectedOption _$OrderSelectedOptionFromJson(Map<String, dynamic> json) =>
    _OrderSelectedOption(
      name: json['name'] as String,
      value: json['value'] as String,
      priceDeltaCentimes: json['priceDeltaCentimes'] == null
          ? const Money.zero()
          : const MoneyConverter().fromJson(json['priceDeltaCentimes']),
    );

Map<String, dynamic> _$OrderSelectedOptionToJson(
  _OrderSelectedOption instance,
) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'priceDeltaCentimes': const MoneyConverter().toJson(
    instance.priceDeltaCentimes,
  ),
};

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  product: const RefIdConverter().fromJson(json['product']),
  nameSnapshot: json['nameSnapshot'] as String? ?? '',
  unitPriceCentimes: json['unitPriceCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['unitPriceCentimes']),
  qty: (json['qty'] as num?)?.toInt() ?? 1,
  selectedOptions:
      (json['selectedOptions'] as List<dynamic>?)
          ?.map((e) => OrderSelectedOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderSelectedOption>[],
  lineTotalCentimes: json['lineTotalCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['lineTotalCentimes']),
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'product': const RefIdConverter().toJson(instance.product),
      'nameSnapshot': instance.nameSnapshot,
      'unitPriceCentimes': const MoneyConverter().toJson(
        instance.unitPriceCentimes,
      ),
      'qty': instance.qty,
      'selectedOptions': instance.selectedOptions,
      'lineTotalCentimes': const MoneyConverter().toJson(
        instance.lineTotalCentimes,
      ),
    };

_OrderEvent _$OrderEventFromJson(Map<String, dynamic> json) => _OrderEvent(
  to: OrderStatus.parse(json['to']),
  at: const DateConverter().fromJson(json['at']),
  from: _statusOrNull(json['from']),
  actorRole: json['actorRole'] as String? ?? 'system',
  note: json['note'] as String?,
);

Map<String, dynamic> _$OrderEventToJson(_OrderEvent instance) =>
    <String, dynamic>{
      'to': _$OrderStatusEnumMap[instance.to]!,
      'at': const DateConverter().toJson(instance.at),
      'from': _$OrderStatusEnumMap[instance.from],
      'actorRole': instance.actorRole,
      'note': instance.note,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.sentToVendor: 'sent_to_vendor',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.assigned: 'assigned',
  OrderStatus.accepted: 'accepted',
  OrderStatus.pickedUp: 'picked_up',
  OrderStatus.onTheWay: 'on_the_way',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

_AppOrder _$AppOrderFromJson(Map<String, dynamic> json) => _AppOrder(
  id: json['id'] as String,
  code: json['code'] as String,
  createdAt: const DateConverter().fromJson(json['createdAt']),
  status: json['status'] == null
      ? OrderStatus.pending
      : OrderStatus.parse(json['status']),
  customer: _personOrNull(json['customer']),
  vendor: _vendorOrNull(json['vendor']),
  agent: _personOrNull(json['agent']),
  deliveryType:
      $enumDecodeNullable(_$DeliveryTypeEnumMap, json['deliveryType']) ??
      DeliveryType.normal,
  paymentMethod:
      $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
      PaymentMethod.cash,
  address: json['address'] == null
      ? const OrderAddress()
      : OrderAddress.fromJson(json['address'] as Map<String, dynamic>),
  deliveryLocation: const GeoPointConverter().fromJson(
    json['deliveryLocation'],
  ),
  customerNote: json['customerNote'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItem>[],
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
  totalCentimes: json['totalCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['totalCentimes']),
  pointsUsed: (json['pointsUsed'] as num?)?.toInt() ?? 0,
  pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => OrderEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderEvent>[],
  cancelledReason: json['cancelledReason'] as String?,
  confirmedAt: const NullableDateConverter().fromJson(json['confirmedAt']),
  assignedAt: const NullableDateConverter().fromJson(json['assignedAt']),
  acceptedAt: const NullableDateConverter().fromJson(json['acceptedAt']),
  pickedUpAt: const NullableDateConverter().fromJson(json['pickedUpAt']),
  deliveredAt: const NullableDateConverter().fromJson(json['deliveredAt']),
  isLate: json['isLate'] as bool? ?? false,
);

Map<String, dynamic> _$AppOrderToJson(_AppOrder instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'createdAt': const DateConverter().toJson(instance.createdAt),
  'status': _$OrderStatusEnumMap[instance.status]!,
  'customer': instance.customer,
  'vendor': instance.vendor,
  'agent': instance.agent,
  'deliveryType': _$DeliveryTypeEnumMap[instance.deliveryType]!,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'address': instance.address,
  'deliveryLocation': const GeoPointConverter().toJson(
    instance.deliveryLocation,
  ),
  'customerNote': instance.customerNote,
  'items': instance.items,
  'subtotalCentimes': const MoneyConverter().toJson(instance.subtotalCentimes),
  'serviceFeeCentimes': const MoneyConverter().toJson(
    instance.serviceFeeCentimes,
  ),
  'deliveryFeeCentimes': const MoneyConverter().toJson(
    instance.deliveryFeeCentimes,
  ),
  'discountCentimes': const MoneyConverter().toJson(instance.discountCentimes),
  'totalCentimes': const MoneyConverter().toJson(instance.totalCentimes),
  'pointsUsed': instance.pointsUsed,
  'pointsEarned': instance.pointsEarned,
  'events': instance.events,
  'cancelledReason': instance.cancelledReason,
  'confirmedAt': const NullableDateConverter().toJson(instance.confirmedAt),
  'assignedAt': const NullableDateConverter().toJson(instance.assignedAt),
  'acceptedAt': const NullableDateConverter().toJson(instance.acceptedAt),
  'pickedUpAt': const NullableDateConverter().toJson(instance.pickedUpAt),
  'deliveredAt': const NullableDateConverter().toJson(instance.deliveredAt),
  'isLate': instance.isLate,
};

const _$DeliveryTypeEnumMap = {
  DeliveryType.normal: 'normal',
  DeliveryType.vip: 'vip',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.electronic: 'electronic',
};
