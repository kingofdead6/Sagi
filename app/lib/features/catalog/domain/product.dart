import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/money.dart';

part 'product.freezed.dart';
part 'product.g.dart';

enum ProductOptionType {
  @JsonValue('single')
  single,
  @JsonValue('multi')
  multi;

  bool get isSingle => this == ProductOptionType.single;
}

@freezed
abstract class ProductOptionValue with _$ProductOptionValue {
  const factory ProductOptionValue({
    required String id,
    required String name,
    @MoneyConverter() @Default(Money.zero()) Money priceDeltaCentimes,
  }) = _ProductOptionValue;

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionValueFromJson(json);
}

@freezed
abstract class ProductOption with _$ProductOption {
  const factory ProductOption({
    required String name,
    @Default(ProductOptionType.single) ProductOptionType type,
    @Default(false) bool isRequired,
    @Default(<ProductOptionValue>[]) List<ProductOptionValue> values,
  }) = _ProductOption;

  factory ProductOption.fromJson(Map<String, dynamic> json) => _$ProductOptionFromJson(json);
}

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    @RefIdConverter() String? vendor,
    @RefIdConverter() String? section,
    String? description,
    ImageRef? image,
    @MoneyConverter() @Default(Money.zero()) Money priceCentimes,
    @Default(true) bool isAvailable,
    @Default(0) int sortOrder,
    @Default(<ProductOption>[]) List<ProductOption> options,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  bool get hasOptions => options.isNotEmpty;

  bool get hasRequiredOptions => options.any((o) => o.isRequired);
}

/// One `{section, products}` group from `GET /vendors/:id/menu`.
@freezed
abstract class MenuGroup with _$MenuGroup {
  const factory MenuGroup({
    required String sectionId,
    required String sectionName,
    required List<Product> products,
  }) = _MenuGroup;

  factory MenuGroup.fromApi(Map<String, dynamic> json) {
    final section = json['section'] as Map<String, dynamic>? ?? const {};
    return MenuGroup(
      sectionId: section['id']?.toString() ?? 'other',
      sectionName: section['name']?.toString() ?? 'أخرى',
      products: (json['products'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList(),
    );
  }
}
