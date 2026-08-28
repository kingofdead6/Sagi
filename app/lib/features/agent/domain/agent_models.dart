import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/money.dart';
import 'package:saji/features/orders/domain/order.dart';

part 'agent_models.freezed.dart';
part 'agent_models.g.dart';

@freezed
abstract class AgentOnlineStatus with _$AgentOnlineStatus {
  const factory AgentOnlineStatus({
    @Default(false) bool isOnline,
    @RefIdConverter() String? currentOrder,
    @NullableDateConverter() DateTime? lastSeenAt,
  }) = _AgentOnlineStatus;

  factory AgentOnlineStatus.fromJson(Map<String, dynamic> json) =>
      _$AgentOnlineStatusFromJson(json);
}

/// A pickup or dropoff waypoint on the agent's map.
@freezed
abstract class Waypoint with _$Waypoint {
  const factory Waypoint({
    double? lat,
    double? lng,
    String? name,
    String? phone,
    String? address,
  }) = _Waypoint;

  const Waypoint._();

  factory Waypoint.fromApi(Map<String, dynamic>? json) {
    if (json == null) return const Waypoint();
    final address = json['address'];
    return Waypoint(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: address is String
          ? address
          : address is Map
              ? [address['street'], address['commune'], address['wilaya']]
                  .whereType<String>()
                  .where((p) => p.isNotEmpty)
                  .join('، ')
              : null,
    );
  }

  LatLng? get point => (lat != null && lng != null) ? LatLng(lat!, lng!) : null;
}

/// A delivery offered to the agent, with its countdown.
@freezed
abstract class DeliveryOffer with _$DeliveryOffer {
  const factory DeliveryOffer({
    required String assignmentId,
    required AppOrder order,
    required DateTime expiresAt,
    Waypoint? pickup,
    Waypoint? dropoff,
    double? distanceKm,
    @MoneyConverter() @Default(Money.zero()) Money payoutCentimes,
    @Default(60) int timeoutSec,
  }) = _DeliveryOffer;

  const DeliveryOffer._();

  factory DeliveryOffer.fromApi(Map<String, dynamic> json) => DeliveryOffer(
        assignmentId: json['assignmentId'] as String? ?? '',
        order: AppOrder.fromJson(json['order'] as Map<String, dynamic>),
        pickup: Waypoint.fromApi(json['pickup'] as Map<String, dynamic>?),
        dropoff: Waypoint.fromApi(json['dropoff'] as Map<String, dynamic>?),
        distanceKm: (json['distanceKm'] as num?)?.toDouble(),
        payoutCentimes: Money.fromJson(json['payoutCentimes']),
        expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '')?.toLocal() ??
            DateTime.now().add(const Duration(seconds: 60)),
        timeoutSec: (json['timeoutSec'] as num?)?.toInt() ?? 60,
      );

  Duration get remaining {
    final left = expiresAt.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  bool get isExpired => remaining == Duration.zero;
}

@freezed
abstract class ActiveDelivery with _$ActiveDelivery {
  const factory ActiveDelivery({
    required AppOrder order,
    Waypoint? pickup,
    Waypoint? dropoff,
  }) = _ActiveDelivery;

  factory ActiveDelivery.fromApi(Map<String, dynamic> json) => ActiveDelivery(
        order: AppOrder.fromJson(json['order'] as Map<String, dynamic>),
        pickup: Waypoint.fromApi(json['pickup'] as Map<String, dynamic>?),
        dropoff: Waypoint.fromApi(json['dropoff'] as Map<String, dynamic>?),
      );
}

@freezed
abstract class AgentStats with _$AgentStats {
  const factory AgentStats({
    @Default(0) int deliveries,
    @MoneyConverter() @Default(Money.zero()) Money earningsCentimes,
    @Default(0) int avgMinutes,
    @Default(0) int todayDeliveries,
    @Default(0) int rejectedOffers,
  }) = _AgentStats;

  factory AgentStats.fromJson(Map<String, dynamic> json) => _$AgentStatsFromJson(json);
}
