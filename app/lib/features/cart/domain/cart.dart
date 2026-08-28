import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:saji/core/money.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/orders/data/order_repository.dart';

/// One configured line in the basket. Two lines of the same product with
/// different options are distinct entries.
@immutable
class CartLine {
  const CartLine({
    required this.product,
    required this.qty,
    required this.selectedValueIds,
  });

  final Product product;
  final int qty;
  final List<String> selectedValueIds;

  /// Stable identity for a product + option combination.
  String get key => '${product.id}::${(List.of(selectedValueIds)..sort()).join(',')}';

  List<ProductOptionValue> get selectedValues => product.options
      .expand((option) => option.values)
      .where((value) => selectedValueIds.contains(value.id))
      .toList();

  String get optionsLabel => selectedValues.map((v) => v.name).join('، ');

  /// A local estimate for instant UI feedback only — the authoritative price
  /// always comes back from `POST /orders/quote`.
  Money get unitPrice => selectedValues.fold(
        product.priceCentimes,
        (sum, value) => sum + value.priceDeltaCentimes,
      );

  Money get lineTotal => unitPrice * qty;

  CartLine copyWith({int? qty}) => CartLine(
        product: product,
        qty: qty ?? this.qty,
        selectedValueIds: selectedValueIds,
      );

  QuoteRequestItem toRequestItem() => QuoteRequestItem(
        productId: product.id,
        qty: qty,
        optionValueIds: selectedValueIds,
      );

  @override
  bool operator ==(Object other) => other is CartLine && other.key == key && other.qty == qty;

  @override
  int get hashCode => Object.hash(key, qty);
}

/// The basket is **single-vendor**: adding from another vendor prompts the user
/// to clear it first (§9).
@immutable
class Cart {
  const Cart({this.vendorId, this.vendorName, this.lines = const []});

  final String? vendorId;
  final String? vendorName;
  final List<CartLine> lines;

  bool get isEmpty => lines.isEmpty;
  bool get isNotEmpty => lines.isNotEmpty;

  int get itemCount => lines.fold(0, (sum, line) => sum + line.qty);

  /// Local estimate only — see [CartLine.unitPrice].
  Money get estimatedSubtotal => lines.map((l) => l.lineTotal).sum();

  CartLine? lineFor(String key) => lines.firstWhereOrNull((l) => l.key == key);

  bool belongsTo(String otherVendorId) => vendorId == null || vendorId == otherVendorId;

  Cart add(CartLine line, {required String forVendorId, required String forVendorName}) {
    final existing = lineFor(line.key);
    final next = existing == null
        ? [...lines, line]
        : lines
            .map((l) => l.key == line.key ? l.copyWith(qty: l.qty + line.qty) : l)
            .toList();

    return Cart(vendorId: forVendorId, vendorName: forVendorName, lines: next);
  }

  Cart setQty(String key, int qty) {
    if (qty <= 0) return remove(key);
    return _withLines(lines.map((l) => l.key == key ? l.copyWith(qty: qty) : l).toList());
  }

  Cart remove(String key) => _withLines(lines.where((l) => l.key != key).toList());

  Cart _withLines(List<CartLine> next) => next.isEmpty
      ? Cart.empty
      : Cart(vendorId: vendorId, vendorName: vendorName, lines: next);

  List<QuoteRequestItem> toRequestItems() => lines.map((l) => l.toRequestItem()).toList();

  static const empty = Cart();
}
