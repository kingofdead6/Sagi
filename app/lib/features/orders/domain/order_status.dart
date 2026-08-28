import 'package:json_annotation/json_annotation.dart';

/// Mirrors the server state machine for UI purposes only — the server is
/// always authoritative about what a status may become.
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('sent_to_vendor')
  sentToVendor,
  @JsonValue('preparing')
  preparing,
  @JsonValue('ready')
  ready,
  @JsonValue('assigned')
  assigned,
  @JsonValue('accepted')
  accepted,
  @JsonValue('picked_up')
  pickedUp,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled;

  static OrderStatus parse(Object? value) {
    return switch (value) {
      'pending' => OrderStatus.pending,
      'confirmed' => OrderStatus.confirmed,
      'sent_to_vendor' => OrderStatus.sentToVendor,
      'preparing' => OrderStatus.preparing,
      'ready' => OrderStatus.ready,
      'assigned' => OrderStatus.assigned,
      'accepted' => OrderStatus.accepted,
      'picked_up' => OrderStatus.pickedUp,
      'on_the_way' => OrderStatus.onTheWay,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };
  }

  String get wire => switch (this) {
        OrderStatus.pending => 'pending',
        OrderStatus.confirmed => 'confirmed',
        OrderStatus.sentToVendor => 'sent_to_vendor',
        OrderStatus.preparing => 'preparing',
        OrderStatus.ready => 'ready',
        OrderStatus.assigned => 'assigned',
        OrderStatus.accepted => 'accepted',
        OrderStatus.pickedUp => 'picked_up',
        OrderStatus.onTheWay => 'on_the_way',
        OrderStatus.delivered => 'delivered',
        OrderStatus.cancelled => 'cancelled',
      };

  bool get isTerminal => this == OrderStatus.delivered || this == OrderStatus.cancelled;

  bool get isActive => !isTerminal;

  /// True once a courier is carrying the order, which is when the customer
  /// starts seeing the live marker.
  bool get isOnRoad => this == OrderStatus.onTheWay;

  bool get canCustomerCancel => this == OrderStatus.pending;

  /// The five steps the customer tracking stepper renders.
  static const customerSteps = <OrderStatus>[
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.onTheWay,
    OrderStatus.delivered,
  ];

  /// Where this status sits on the customer stepper (-1 when off it).
  int get stepIndex {
    final mapped = switch (this) {
      OrderStatus.pending => OrderStatus.pending,
      OrderStatus.confirmed || OrderStatus.sentToVendor => OrderStatus.confirmed,
      OrderStatus.preparing || OrderStatus.ready => OrderStatus.preparing,
      OrderStatus.assigned ||
      OrderStatus.accepted ||
      OrderStatus.pickedUp ||
      OrderStatus.onTheWay =>
        OrderStatus.onTheWay,
      OrderStatus.delivered => OrderStatus.delivered,
      OrderStatus.cancelled => OrderStatus.cancelled,
    };
    return customerSteps.indexOf(mapped);
  }
}

enum DeliveryType {
  @JsonValue('normal')
  normal,
  @JsonValue('vip')
  vip;

  String get wire => this == DeliveryType.vip ? 'vip' : 'normal';
  bool get isVip => this == DeliveryType.vip;
}

enum PaymentMethod {
  @JsonValue('cash')
  cash,
  @JsonValue('electronic')
  electronic;

  String get wire => this == PaymentMethod.electronic ? 'electronic' : 'cash';
}
