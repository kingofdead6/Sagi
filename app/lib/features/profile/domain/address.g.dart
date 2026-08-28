// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String,
  label: json['label'] as String? ?? 'المنزل',
  wilaya: json['wilaya'] as String? ?? '',
  commune: json['commune'] as String? ?? '',
  street: json['street'] as String? ?? '',
  notes: json['notes'] as String?,
  location: const GeoPointConverter().fromJson(json['location']),
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'wilaya': instance.wilaya,
  'commune': instance.commune,
  'street': instance.street,
  'notes': instance.notes,
  'location': const GeoPointConverter().toJson(instance.location),
  'isDefault': instance.isDefault,
};
