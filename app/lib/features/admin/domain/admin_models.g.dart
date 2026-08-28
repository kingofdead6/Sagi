// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      todayOrders: (json['todayOrders'] as num?)?.toInt() ?? 0,
      revenueCentimes: json['revenueCentimes'] == null
          ? const Money.zero()
          : const MoneyConverter().fromJson(json['revenueCentimes']),
      deliveredToday: (json['deliveredToday'] as num?)?.toInt() ?? 0,
      activeDeliveries: (json['activeDeliveries'] as num?)?.toInt() ?? 0,
      avgDeliveryMinutes: (json['avgDeliveryMinutes'] as num?)?.toInt() ?? 0,
      lateOrders: (json['lateOrders'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      onlineAgents: (json['onlineAgents'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardStatsToJson(
  _DashboardStats instance,
) => <String, dynamic>{
  'todayOrders': instance.todayOrders,
  'revenueCentimes': const MoneyConverter().toJson(instance.revenueCentimes),
  'deliveredToday': instance.deliveredToday,
  'activeDeliveries': instance.activeDeliveries,
  'avgDeliveryMinutes': instance.avgDeliveryMinutes,
  'lateOrders': instance.lateOrders,
  'pendingOrders': instance.pendingOrders,
  'onlineAgents': instance.onlineAgents,
};

_AvailableAgent _$AvailableAgentFromJson(Map<String, dynamic> json) =>
    _AvailableAgent(
      agentId: json['agentId'] as String,
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      currentOrder: json['currentOrder'] as String?,
      currentLoad: (json['currentLoad'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AvailableAgentToJson(_AvailableAgent instance) =>
    <String, dynamic>{
      'agentId': instance.agentId,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'isOnline': instance.isOnline,
      'currentOrder': instance.currentOrder,
      'currentLoad': instance.currentLoad,
      'distanceKm': instance.distanceKm,
    };

_FleetAgent _$FleetAgentFromJson(Map<String, dynamic> json) => _FleetAgent(
  agentId: json['agentId'] as String,
  fullName: json['fullName'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  location: const GeoPointConverter().fromJson(json['location']),
  lastSeenAt: const NullableDateConverter().fromJson(json['lastSeenAt']),
  state: json['state'] as String? ?? 'idle',
  currentOrder: _orderOrNull(json['currentOrder']),
);

Map<String, dynamic> _$FleetAgentToJson(_FleetAgent instance) =>
    <String, dynamic>{
      'agentId': instance.agentId,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'location': const GeoPointConverter().toJson(instance.location),
      'lastSeenAt': const NullableDateConverter().toJson(instance.lastSeenAt),
      'state': instance.state,
      'currentOrder': instance.currentOrder,
    };

_TimeSeriesPoint _$TimeSeriesPointFromJson(Map<String, dynamic> json) =>
    _TimeSeriesPoint(
      date: json['date'] as String,
      orders: (json['orders'] as num?)?.toInt() ?? 0,
      revenueCentimes: json['revenueCentimes'] == null
          ? const Money.zero()
          : const MoneyConverter().fromJson(json['revenueCentimes']),
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TimeSeriesPointToJson(
  _TimeSeriesPoint instance,
) => <String, dynamic>{
  'date': instance.date,
  'orders': instance.orders,
  'revenueCentimes': const MoneyConverter().toJson(instance.revenueCentimes),
  'cancelled': instance.cancelled,
};

_PlatformSettings _$PlatformSettingsFromJson(
  Map<String, dynamic> json,
) => _PlatformSettings(
  serviceFeeCentimes: (json['serviceFeeCentimes'] as num?)?.toInt() ?? 5000,
  vipSurchargeCentimes:
      (json['vipSurchargeCentimes'] as num?)?.toInt() ?? 10000,
  assignTimeoutSec: (json['assignTimeoutSec'] as num?)?.toInt() ?? 60,
  lateThresholdMin: (json['lateThresholdMin'] as num?)?.toInt() ?? 45,
  supportPhone: json['supportPhone'] as String? ?? '',
  deliveryRadiusKm: json['deliveryRadiusKm'] as num? ?? 15,
  pointsPerHundredDinars: json['pointsPerHundredDinars'] as num? ?? 1,
  pointValueCentimes: (json['pointValueCentimes'] as num?)?.toInt() ?? 100,
  maxPointsPercentOfSubtotal: json['maxPointsPercentOfSubtotal'] as num? ?? 50,
  electronicPaymentEnabled: json['electronicPaymentEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$PlatformSettingsToJson(_PlatformSettings instance) =>
    <String, dynamic>{
      'serviceFeeCentimes': instance.serviceFeeCentimes,
      'vipSurchargeCentimes': instance.vipSurchargeCentimes,
      'assignTimeoutSec': instance.assignTimeoutSec,
      'lateThresholdMin': instance.lateThresholdMin,
      'supportPhone': instance.supportPhone,
      'deliveryRadiusKm': instance.deliveryRadiusKm,
      'pointsPerHundredDinars': instance.pointsPerHundredDinars,
      'pointValueCentimes': instance.pointValueCentimes,
      'maxPointsPercentOfSubtotal': instance.maxPointsPercentOfSubtotal,
      'electronicPaymentEnabled': instance.electronicPaymentEnabled,
    };

_Voucher _$VoucherFromJson(Map<String, dynamic> json) => _Voucher(
  id: json['id'] as String,
  code: json['code'] as String,
  type: json['type'] as String? ?? 'percentage',
  value: json['value'] as num? ?? 0,
  minOrderCentimes: (json['minOrderCentimes'] as num?)?.toInt() ?? 0,
  maxUses: (json['maxUses'] as num?)?.toInt() ?? 0,
  usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
  perUserLimit: (json['perUserLimit'] as num?)?.toInt() ?? 1,
  startsAt: const NullableDateConverter().fromJson(json['startsAt']),
  endsAt: const NullableDateConverter().fromJson(json['endsAt']),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$VoucherToJson(_Voucher instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'type': instance.type,
  'value': instance.value,
  'minOrderCentimes': instance.minOrderCentimes,
  'maxUses': instance.maxUses,
  'usedCount': instance.usedCount,
  'perUserLimit': instance.perUserLimit,
  'startsAt': const NullableDateConverter().toJson(instance.startsAt),
  'endsAt': const NullableDateConverter().toJson(instance.endsAt),
  'isActive': instance.isActive,
};

_ManagedUser _$ManagedUserFromJson(Map<String, dynamic> json) => _ManagedUser(
  id: json['id'] as String,
  fullName: json['fullName'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  isActive: json['isActive'] as bool? ?? true,
  isBlocked: json['isBlocked'] as bool? ?? false,
  points: (json['points'] as num?)?.toInt() ?? 0,
  isOnline: json['isOnline'] as bool? ?? false,
  createdAt: const NullableDateConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ManagedUserToJson(_ManagedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'isBlocked': instance.isBlocked,
      'points': instance.points,
      'isOnline': instance.isOnline,
      'createdAt': const NullableDateConverter().toJson(instance.createdAt),
    };
