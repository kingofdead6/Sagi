import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/agent/domain/agent_models.dart';
import 'package:saji/features/orders/domain/order.dart';

/// One buffered GPS sample. Batched so a reconnecting phone can flush what it
/// captured while offline.
class LocationSample {
  const LocationSample({
    required this.point,
    required this.recordedAt,
    this.heading,
    this.speed,
    this.battery,
  });

  final LatLng point;
  final DateTime recordedAt;
  final double? heading;
  final double? speed;
  final int? battery;

  Map<String, dynamic> toJson() => {
        'lat': point.latitude,
        'lng': point.longitude,
        if (heading != null) 'heading': heading,
        if (speed != null) 'speed': speed,
        if (battery != null) 'battery': battery,
        'recordedAt': recordedAt.toUtc().toIso8601String(),
      };
}

class AgentRepository {
  AgentRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<Result<AgentOnlineStatus>> status() => _client.get<AgentOnlineStatus>(
        Api.agentMyStatus,
        parse: (data) => AgentOnlineStatus.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AgentOnlineStatus>> setOnline({required bool isOnline}) =>
      _client.patch<AgentOnlineStatus>(
        Api.agentStatus,
        body: {'isOnline': isOnline},
        parse: (data) => AgentOnlineStatus.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<List<DeliveryOffer>>> offers() => _client.get<List<DeliveryOffer>>(
        Api.agentOffers,
        parse: (data) => (data as List)
            .whereType<Map<String, dynamic>>()
            .map(DeliveryOffer.fromApi)
            .toList(),
      );

  Future<Result<AppOrder>> accept(String orderId) => _client.post<AppOrder>(
        Api.agentAccept(orderId),
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppOrder>> reject(String orderId, String reason) => _client.post<AppOrder>(
        Api.agentReject(orderId),
        body: {'reason': reason},
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<ActiveDelivery?>> active() => _client.get<ActiveDelivery?>(
        Api.agentActive,
        parse: (data) =>
            data is Map<String, dynamic> ? ActiveDelivery.fromApi(data) : null,
      );

  Future<Result<AppOrder>> updateStatus(
    String orderId,
    String status, {
    bool? cashCollected,
  }) =>
      _client.patch<AppOrder>(
        Api.agentOrderStatus(orderId),
        body: {
          'status': status,
          if (cashCollected != null) 'cashCollected': cashCollected,
        },
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Paged<AppOrder>>> history({
    DateTime? from,
    DateTime? to,
    String? status,
    int page = 1,
  }) =>
      _client.get<Paged<AppOrder>>(
        Api.agentHistory,
        query: {
          'page': page,
          'limit': 30,
          if (from != null) 'from': from.toUtc().toIso8601String(),
          if (to != null) 'to': to.toUtc().toIso8601String(),
          if (status != null) 'status': status,
        },
        parse: (data) => Paged.fromJson(data, AppOrder.fromJson),
      );

  Future<Result<AgentStats>> stats({DateTime? from, DateTime? to}) => _client.get<AgentStats>(
        Api.agentStats,
        query: {
          if (from != null) 'from': from.toUtc().toIso8601String(),
          if (to != null) 'to': to.toUtc().toIso8601String(),
        },
        parse: (data) => AgentStats.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> pushLocation(LocationSample sample) => _client.post<void>(
        Api.agentLocation,
        body: sample.toJson(),
        parse: (_) {},
      );

  /// Flushes a queue of samples captured while the connection was down.
  Future<Result<void>> pushLocationBatch(List<LocationSample> samples) => _client.post<void>(
        Api.agentLocationBatch,
        body: {'points': samples.map((s) => s.toJson()).toList()},
        parse: (_) {},
      );
}
