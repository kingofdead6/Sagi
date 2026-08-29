import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/money.dart';
import 'package:saji/features/orders/domain/order.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0) int todayOrders,
    @MoneyConverter() @Default(Money.zero()) Money revenueCentimes,
    @Default(0) int deliveredToday,
    @Default(0) int activeDeliveries,
    @Default(0) int avgDeliveryMinutes,
    @Default(0) int lateOrders,
    @Default(0) int pendingOrders,
    @Default(0) int onlineAgents,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@freezed
abstract class AvailableAgent with _$AvailableAgent {
  const factory AvailableAgent({
    required String agentId,
    @Default('') String fullName,
    @Default('') String phone,
    @Default(false) bool isOnline,
    String? currentOrder,
    @Default(0) int currentLoad,
    double? distanceKm,
  }) = _AvailableAgent;

  factory AvailableAgent.fromJson(Map<String, dynamic> json) => _$AvailableAgentFromJson(json);
}

@freezed
abstract class FleetAgent with _$FleetAgent {
  const factory FleetAgent({
    required String agentId,
    @Default('') String fullName,
    @Default('') String phone,
    @GeoPointConverter() LatLng? location,
    @NullableDateConverter() DateTime? lastSeenAt,
    @Default('idle') String state,
    @JsonKey(fromJson: _orderOrNull) AppOrder? currentOrder,
  }) = _FleetAgent;

  const FleetAgent._();

  factory FleetAgent.fromJson(Map<String, dynamic> json) => _$FleetAgentFromJson(json);

  bool get isOnDelivery => state == 'on_delivery';
}

AppOrder? _orderOrNull(Object? json) =>
    json is Map<String, dynamic> ? AppOrder.fromJson(json) : null;

@freezed
abstract class TimeSeriesPoint with _$TimeSeriesPoint {
  const factory TimeSeriesPoint({
    required String date,
    @Default(0) int orders,
    @MoneyConverter() @Default(Money.zero()) Money revenueCentimes,
    @Default(0) int cancelled,
  }) = _TimeSeriesPoint;

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) => _$TimeSeriesPointFromJson(json);
}

@freezed
abstract class RankedRow with _$RankedRow {
  const factory RankedRow({
    @Default('') String name,
    @Default(0) int count,
    @MoneyConverter() @Default(Money.zero()) Money amount,
    String? subtitle,
  }) = _RankedRow;

  /// The analytics endpoints return differently shaped rows; this folds them
  /// into the one shape the leaderboard table renders.
  factory RankedRow.fromApi(Map<String, dynamic> json) => RankedRow(
        name: (json['name'] ?? json['fullName'] ?? json['reason'] ?? '—').toString(),
        count: ((json['orders'] ?? json['qty'] ?? json['deliveries'] ?? json['count'] ?? 0) as num)
            .toInt(),
        amount: Money.fromJson(json['revenueCentimes'] ?? json['earningsCentimes'] ?? 0),
        subtitle: json['phone'] as String?,
      );
}

@freezed
abstract class PlatformSettings with _$PlatformSettings {
  const factory PlatformSettings({
    @Default(5000) int serviceFeeCentimes,
    @Default(10000) int vipSurchargeCentimes,
    @Default(60) int assignTimeoutSec,
    @Default(45) int lateThresholdMin,
    @Default('') String supportPhone,
    @Default(15) num deliveryRadiusKm,
    @Default(1) num pointsPerHundredDinars,
    @Default(100) int pointValueCentimes,
    @Default(50) num maxPointsPercentOfSubtotal,
    @Default(false) bool electronicPaymentEnabled,
    // Bounds on the delivery fee a shop may set for itself, in centimes.
    @Default(60000) int maxVendorDeliveryFeeCentimes,
    @Default(5000) int minVendorDeliveryFeeCentimes,
  }) = _PlatformSettings;

  factory PlatformSettings.fromJson(Map<String, dynamic> json) => _$PlatformSettingsFromJson(json);
}

@freezed
abstract class Voucher with _$Voucher {
  const factory Voucher({
    required String id,
    required String code,
    @Default('percentage') String type,
    @Default(0) num value,
    @Default(0) int minOrderCentimes,
    @Default(0) int maxUses,
    @Default(0) int usedCount,
    @Default(1) int perUserLimit,
    @NullableDateConverter() DateTime? startsAt,
    @NullableDateConverter() DateTime? endsAt,
    @Default(true) bool isActive,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);
}

@freezed
abstract class ManagedUser with _$ManagedUser {
  const factory ManagedUser({
    required String id,
    @Default('') String fullName,
    @Default('') String phone,
    @Default(true) bool isActive,
    @Default(false) bool isBlocked,
    @Default(0) int points,
    @Default(false) bool isOnline,
    @NullableDateConverter() DateTime? createdAt,
  }) = _ManagedUser;

  factory ManagedUser.fromJson(Map<String, dynamic> json) => _$ManagedUserFromJson(json);
}
