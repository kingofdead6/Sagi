// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentOnlineStatus _$AgentOnlineStatusFromJson(Map<String, dynamic> json) =>
    _AgentOnlineStatus(
      isOnline: json['isOnline'] as bool? ?? false,
      currentOrder: const RefIdConverter().fromJson(json['currentOrder']),
      lastSeenAt: const NullableDateConverter().fromJson(json['lastSeenAt']),
    );

Map<String, dynamic> _$AgentOnlineStatusToJson(_AgentOnlineStatus instance) =>
    <String, dynamic>{
      'isOnline': instance.isOnline,
      'currentOrder': const RefIdConverter().toJson(instance.currentOrder),
      'lastSeenAt': const NullableDateConverter().toJson(instance.lastSeenAt),
    };

_AgentStats _$AgentStatsFromJson(Map<String, dynamic> json) => _AgentStats(
  deliveries: (json['deliveries'] as num?)?.toInt() ?? 0,
  earningsCentimes: json['earningsCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['earningsCentimes']),
  avgMinutes: (json['avgMinutes'] as num?)?.toInt() ?? 0,
  todayDeliveries: (json['todayDeliveries'] as num?)?.toInt() ?? 0,
  rejectedOffers: (json['rejectedOffers'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AgentStatsToJson(
  _AgentStats instance,
) => <String, dynamic>{
  'deliveries': instance.deliveries,
  'earningsCentimes': const MoneyConverter().toJson(instance.earningsCentimes),
  'avgMinutes': instance.avgMinutes,
  'todayDeliveries': instance.todayDeliveries,
  'rejectedOffers': instance.rejectedOffers,
};
