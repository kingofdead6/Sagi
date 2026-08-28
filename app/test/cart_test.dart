import 'package:flutter_test/flutter_test.dart';
import 'package:saji/core/money.dart';
import 'package:saji/features/cart/domain/cart.dart';
import 'package:saji/features/catalog/domain/product.dart';

/// Mirrors the server's pricing for instant UI feedback only — the real total
/// always comes back from POST /orders/quote.
void main() {
  const burger = Product(
    id: 'p1',
    vendor: 'v1',
    name: 'برجر كلاسيك',
    priceCentimes: Money(45000),
    options: [
      ProductOption(
        name: 'الحجم',
        isRequired: true,
        values: [
          ProductOptionValue(id: 'size-normal', name: 'عادي'),
          ProductOptionValue(id: 'size-double', name: 'مضاعف', priceDeltaCentimes: Money(15000)),
        ],
      ),
      ProductOption(
        name: 'إضافات',
        type: ProductOptionType.multi,
        values: [
          ProductOptionValue(id: 'cheese', name: 'جبن', priceDeltaCentimes: Money(5000)),
          ProductOptionValue(id: 'egg', name: 'بيض', priceDeltaCentimes: Money(4000)),
        ],
      ),
    ],
  );

  const fries = Product(
    id: 'p2',
    vendor: 'v1',
    name: 'بطاطا مقلية',
    priceCentimes: Money(15000),
  );

  CartLine line(Product product, {int qty = 1, List<String> options = const []}) =>
      CartLine(product: product, qty: qty, selectedValueIds: options);

  group('CartLine', () {
    test('adds option deltas to the unit price', () {
      final withDouble = line(burger, options: ['size-double']);
      expect(withDouble.unitPrice.centimes, 60000);
    });

    test('sums several multi-choice deltas', () {
      final loaded = line(burger, options: ['size-normal', 'cheese', 'egg']);
      expect(loaded.unitPrice.centimes, 54000);
    });

    test('multiplies the unit price across the quantity', () {
      final three = line(burger, qty: 3, options: ['size-double']);
      expect(three.lineTotal.centimes, 180000);
    });

    test('keys are stable regardless of option ordering', () {
      final a = line(burger, options: ['cheese', 'egg']);
      final b = line(burger, options: ['egg', 'cheese']);
      expect(a.key, b.key);
    });

    test('different options produce different keys', () {
      expect(line(burger, options: ['cheese']).key, isNot(line(burger, options: ['egg']).key));
    });

    test('labels the selected options', () {
      expect(line(burger, options: ['size-double', 'cheese']).optionsLabel, 'مضاعف، جبن');
    });
  });

  group('Cart', () {
    test('starts empty', () {
      expect(Cart.empty.isEmpty, isTrue);
      expect(Cart.empty.itemCount, 0);
      expect(Cart.empty.estimatedSubtotal, const Money.zero());
    });

    test('adds a line and records the vendor', () {
      final cart = Cart.empty.add(
        line(fries),
        forVendorId: 'v1',
        forVendorName: 'مطعم الاختبار',
      );
      expect(cart.vendorId, 'v1');
      expect(cart.itemCount, 1);
      expect(cart.estimatedSubtotal.centimes, 15000);
    });

    test('merges quantities for an identical configuration', () {
      var cart = Cart.empty.add(
        line(burger, options: ['size-normal']),
        forVendorId: 'v1',
        forVendorName: 'x',
      );
      cart = cart.add(
        line(burger, options: ['size-normal']),
        forVendorId: 'v1',
        forVendorName: 'x',
      );
      expect(cart.lines.length, 1);
      expect(cart.itemCount, 2);
    });

    test('keeps differently configured lines separate', () {
      var cart = Cart.empty
          .add(line(burger, options: ['size-normal']), forVendorId: 'v1', forVendorName: 'x');
      cart = cart.add(
        line(burger, options: ['size-double']),
        forVendorId: 'v1',
        forVendorName: 'x',
      );
      expect(cart.lines.length, 2);
    });

    test('sums the subtotal across lines', () {
      var cart = Cart.empty.add(
        line(burger, qty: 2, options: ['size-normal']),
        forVendorId: 'v1',
        forVendorName: 'x',
      );
      cart = cart.add(line(fries, qty: 3), forVendorId: 'v1', forVendorName: 'x');
      expect(cart.estimatedSubtotal.centimes, 45000 * 2 + 15000 * 3);
    });

    test('updates and removes by key', () {
      final entry = line(fries);
      var cart = Cart.empty.add(entry, forVendorId: 'v1', forVendorName: 'x');
      cart = cart.setQty(entry.key, 5);
      expect(cart.itemCount, 5);

      cart = cart.remove(entry.key);
      expect(cart.isEmpty, isTrue);
    });

    test('setting a quantity to zero removes the line', () {
      final entry = line(fries);
      final cart = Cart.empty
          .add(entry, forVendorId: 'v1', forVendorName: 'x')
          .setQty(entry.key, 0);
      expect(cart.isEmpty, isTrue);
    });

    test('the basket is single-vendor', () {
      final cart = Cart.empty.add(line(fries), forVendorId: 'v1', forVendorName: 'x');
      expect(cart.belongsTo('v1'), isTrue);
      expect(cart.belongsTo('v2'), isFalse);
      // An empty cart accepts any vendor.
      expect(Cart.empty.belongsTo('v2'), isTrue);
    });

    test('builds request items with ids and quantities only', () {
      final cart = Cart.empty.add(
        line(burger, qty: 2, options: ['size-double', 'cheese']),
        forVendorId: 'v1',
        forVendorName: 'x',
      );
      final items = cart.toRequestItems();

      expect(items.single.productId, 'p1');
      expect(items.single.qty, 2);
      expect(items.single.optionValueIds, containsAll(['size-double', 'cheese']));
      // Crucially, no price crosses the wire.
      expect(items.single.toJson().keys, ['productId', 'qty', 'optionValueIds']);
    });
  });
}
