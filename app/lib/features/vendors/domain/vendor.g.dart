// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameFr: json['nameFr'] as String,
  iconKey: json['iconKey'] as String,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameFr': instance.nameFr,
  'iconKey': instance.iconKey,
  'sortOrder': instance.sortOrder,
  'isActive': instance.isActive,
};

_OpeningHour _$OpeningHourFromJson(Map<String, dynamic> json) => _OpeningHour(
  day: (json['day'] as num).toInt(),
  from: json['from'] as String,
  to: json['to'] as String,
);

Map<String, dynamic> _$OpeningHourToJson(_OpeningHour instance) =>
    <String, dynamic>{
      'day': instance.day,
      'from': instance.from,
      'to': instance.to,
    };

_Vendor _$VendorFromJson(Map<String, dynamic> json) => _Vendor(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String? ?? '',
  description: json['description'] as String?,
  category: const RefIdConverter().fromJson(json['category']),
  logo: json['logo'] == null
      ? null
      : ImageRef.fromJson(json['logo'] as Map<String, dynamic>),
  cover: json['cover'] == null
      ? null
      : ImageRef.fromJson(json['cover'] as Map<String, dynamic>),
  phone: json['phone'] as String? ?? '',
  addressText: json['addressText'] as String? ?? '',
  location: const GeoPointConverter().fromJson(json['location']),
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  prepTimeMin: (json['prepTimeMin'] as num?)?.toInt() ?? 15,
  prepTimeMax: (json['prepTimeMax'] as num?)?.toInt() ?? 30,
  deliveryFeeCentimes: json['deliveryFeeCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['deliveryFeeCentimes']),
  minOrderCentimes: json['minOrderCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['minOrderCentimes']),
  isOpen: json['isOpen'] as bool? ?? true,
  openingHours:
      (json['openingHours'] as List<dynamic>?)
          ?.map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OpeningHour>[],
  isFeatured: json['isFeatured'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  etaMinutes: (json['etaMinutes'] as num?)?.toInt(),
  isOpenNow: json['isOpenNow'] as bool?,
);

Map<String, dynamic> _$VendorToJson(_Vendor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'category': const RefIdConverter().toJson(instance.category),
  'logo': instance.logo,
  'cover': instance.cover,
  'phone': instance.phone,
  'addressText': instance.addressText,
  'location': const GeoPointConverter().toJson(instance.location),
  'rating': instance.rating,
  'ratingCount': instance.ratingCount,
  'prepTimeMin': instance.prepTimeMin,
  'prepTimeMax': instance.prepTimeMax,
  'deliveryFeeCentimes': const MoneyConverter().toJson(
    instance.deliveryFeeCentimes,
  ),
  'minOrderCentimes': const MoneyConverter().toJson(instance.minOrderCentimes),
  'isOpen': instance.isOpen,
  'openingHours': instance.openingHours,
  'isFeatured': instance.isFeatured,
  'isActive': instance.isActive,
  'distanceKm': instance.distanceKm,
  'etaMinutes': instance.etaMinutes,
  'isOpenNow': instance.isOpenNow,
};

_MenuSection _$MenuSectionFromJson(Map<String, dynamic> json) => _MenuSection(
  id: json['id'] as String,
  name: json['name'] as String,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MenuSectionToJson(_MenuSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sortOrder': instance.sortOrder,
    };
