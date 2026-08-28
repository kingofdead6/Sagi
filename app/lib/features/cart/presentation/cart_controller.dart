import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/features/cart/domain/cart.dart';
import 'package:saji/features/catalog/domain/product.dart';

/// Owns the basket and persists it, so closing the app mid-order loses nothing.
class CartController extends StateNotifier<Cart> {
  CartController(this._cache) : super(Cart.empty) {
    _restore();
  }

  static const _cacheKey = 'cart.current';

  final LocalCache _cache;

  void _restore() {
    final raw = _cache.readJson(_cacheKey, ttl: const Duration(days: 3));
    if (raw is! Map) return;

    try {
      final lines = (raw['lines'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(
            (line) => CartLine(
              product: Product.fromJson(line['product'] as Map<String, dynamic>),
              qty: (line['qty'] as num).toInt(),
              selectedValueIds:
                  (line['selectedValueIds'] as List? ?? const []).cast<String>(),
            ),
          )
          .toList();
      if (lines.isEmpty) return;

      state = Cart(
        vendorId: raw['vendorId'] as String?,
        vendorName: raw['vendorName'] as String?,
        lines: lines,
      );
    } catch (_) {
      // A corrupt cache is not worth crashing over — start empty.
    }
  }

  Future<void> _persist() async {
    if (state.isEmpty) {
      await _cache.remove(_cacheKey);
      return;
    }
    await _cache.writeJson(_cacheKey, {
      'vendorId': state.vendorId,
      'vendorName': state.vendorName,
      'lines': state.lines
          .map(
            (line) => {
              'product': line.product.toJson(),
              'qty': line.qty,
              'selectedValueIds': line.selectedValueIds,
            },
          )
          .toList(),
    });
  }

  /// True when the product comes from a different vendor than the basket —
  /// the caller must ask the user before clearing.
  bool conflictsWith(String vendorId) => state.isNotEmpty && !state.belongsTo(vendorId);

  Future<void> add({
    required Product product,
    required String vendorId,
    required String vendorName,
    int qty = 1,
    List<String> selectedValueIds = const [],
  }) async {
    state = state.add(
      CartLine(product: product, qty: qty, selectedValueIds: selectedValueIds),
      forVendorId: vendorId,
      forVendorName: vendorName,
    );
    await _persist();
  }

  Future<void> setQty(String key, int qty) async {
    state = state.setQty(key, qty);
    await _persist();
  }

  Future<void> remove(String key) async {
    state = state.remove(key);
    await _persist();
  }

  Future<void> clear() async {
    state = Cart.empty;
    await _persist();
  }

  /// Replaces the basket wholesale — used by "reorder".
  Future<void> replaceWith(Cart cart) async {
    state = cart;
    await _persist();
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, Cart>(
  (ref) => CartController(ref.watch(localCacheProvider)),
);

final cartItemCountProvider = Provider<int>((ref) => ref.watch(cartControllerProvider).itemCount);
