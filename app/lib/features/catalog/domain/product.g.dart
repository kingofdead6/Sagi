// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductOptionValue _$ProductOptionValueFromJson(Map<String, dynamic> json) =>
    _ProductOptionValue(
      id: json['id'] as String,
      name: json['name'] as String,
      priceDeltaCentimes: json['priceDeltaCentimes'] == null
          ? const Money.zero()
          : const MoneyConverter().fromJson(json['priceDeltaCentimes']),
    );

Map<String, dynamic> _$ProductOptionValueToJson(_ProductOptionValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceDeltaCentimes': const MoneyConverter().toJson(
        instance.priceDeltaCentimes,
      ),
    };

_ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) =>
    _ProductOption(
      name: json['name'] as String,
      type:
          $enumDecodeNullable(_$ProductOptionTypeEnumMap, json['type']) ??
          ProductOptionType.single,
      isRequired: json['isRequired'] as bool? ?? false,
      values:
          (json['values'] as List<dynamic>?)
              ?.map(
                (e) => ProductOptionValue.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ProductOptionValue>[],
    );

Map<String, dynamic> _$ProductOptionToJson(_ProductOption instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$ProductOptionTypeEnumMap[instance.type]!,
      'isRequired': instance.isRequired,
      'values': instance.values,
    };

const _$ProductOptionTypeEnumMap = {
  ProductOptionType.single: 'single',
  ProductOptionType.multi: 'multi',
};

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  vendor: const RefIdConverter().fromJson(json['vendor']),
  section: const RefIdConverter().fromJson(json['section']),
  description: json['description'] as String?,
  image: json['image'] == null
      ? null
      : ImageRef.fromJson(json['image'] as Map<String, dynamic>),
  priceCentimes: json['priceCentimes'] == null
      ? const Money.zero()
      : const MoneyConverter().fromJson(json['priceCentimes']),
  isAvailable: json['isAvailable'] as bool? ?? true,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductOption>[],
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'vendor': const RefIdConverter().toJson(instance.vendor),
  'section': const RefIdConverter().toJson(instance.section),
  'description': instance.description,
  'image': instance.image,
  'priceCentimes': const MoneyConverter().toJson(instance.priceCentimes),
  'isAvailable': instance.isAvailable,
  'sortOrder': instance.sortOrder,
  'options': instance.options,
};
