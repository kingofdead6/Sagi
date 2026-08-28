// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  vendorName: _vendorName(json['vendorName']),
  vendor: const RefIdConverter().fromJson(json['vendor']),
  image: json['image'] == null
      ? null
      : ImageRef.fromJson(json['image'] as Map<String, dynamic>),
  type:
      $enumDecodeNullable(_$OfferTypeEnumMap, json['type']) ??
      OfferType.percentage,
  value: json['value'] as num? ?? 0,
  productIds:
      (json['productIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  startsAt: const NullableDateConverter().fromJson(json['startsAt']),
  endsAt: const NullableDateConverter().fromJson(json['endsAt']),
  isActive: json['isActive'] as bool? ?? true,
  showOnHome: json['showOnHome'] as bool? ?? false,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'vendorName': instance.vendorName,
  'vendor': const RefIdConverter().toJson(instance.vendor),
  'image': instance.image,
  'type': _$OfferTypeEnumMap[instance.type]!,
  'value': instance.value,
  'productIds': instance.productIds,
  'startsAt': const NullableDateConverter().toJson(instance.startsAt),
  'endsAt': const NullableDateConverter().toJson(instance.endsAt),
  'isActive': instance.isActive,
  'showOnHome': instance.showOnHome,
  'sortOrder': instance.sortOrder,
};

const _$OfferTypeEnumMap = {
  OfferType.percentage: 'percentage',
  OfferType.fixed: 'fixed',
  OfferType.freeDelivery: 'freeDelivery',
  OfferType.bundle: 'bundle',
};
