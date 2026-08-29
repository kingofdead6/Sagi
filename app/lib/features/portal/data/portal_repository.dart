import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// Everything the shop owner's portal can do. The server scopes every call to
/// the signed-in owner's shop, so no vendor id is ever sent from here.
class PortalRepository {
  const PortalRepository(this._client);

  final ApiClient _client;

  Future<Result<Vendor>> me() => _client.get<Vendor>(
        Api.portalMe,
        parse: (data) => Vendor.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Vendor>> setOpen({required bool isOpen}) =>
      updateShop({'isOpen': isOpen});

  /// Patches the shop-level fields the owner controls. Only the keys present
  /// are changed, so callers send the one thing they edited.
  Future<Result<Vendor>> updateShop(Map<String, dynamic> body) => _client.patch<Vendor>(
        Api.portalMe,
        body: body,
        parse: (data) => Vendor.fromJson(data as Map<String, dynamic>),
      );

  /// The bounds the server checks the delivery fee against, so the form can
  /// label them and reject a bad value before the round trip.
  Future<Result<PortalLimits>> limits() => _client.get<PortalLimits>(
        Api.portalLimits,
        parse: (data) => PortalLimits.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<List<MenuSection>>> sections() => _client.get<List<MenuSection>>(
        Api.portalSections,
        parse: _parseSections,
      );

  Future<Result<MenuSection>> createSection(String name, int sortOrder) =>
      _client.post<MenuSection>(
        Api.portalSections,
        body: {'name': name, 'sortOrder': sortOrder},
        parse: (data) => MenuSection.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> deleteSection(String id) =>
      _client.delete<void>(Api.portalSection(id), parse: (_) {});

  Future<Result<List<Product>>> products() => _client.get<List<Product>>(
        Api.portalProducts,
        parse: _parseProducts,
      );

  Future<Result<Product>> saveProduct(Map<String, dynamic> body, {String? id}) => id == null
      ? _client.post<Product>(
          Api.portalProducts,
          body: body,
          parse: (data) => Product.fromJson(data as Map<String, dynamic>),
        )
      : _client.patch<Product>(
          Api.portalProduct(id),
          body: body,
          parse: (data) => Product.fromJson(data as Map<String, dynamic>),
        );

  Future<Result<void>> deleteProduct(String id) =>
      _client.delete<void>(Api.portalProduct(id), parse: (_) {});

  static List<MenuSection> _parseSections(dynamic data) =>
      (data as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(MenuSection.fromJson)
          .toList();

  static List<Product> _parseProducts(dynamic data) => (data as List<dynamic>? ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(Product.fromJson)
      .toList();
}

/// The platform-set floor and ceiling on a shop's own delivery fee.
class PortalLimits {
  const PortalLimits({required this.minDeliveryFee, required this.maxDeliveryFee});

  factory PortalLimits.fromJson(Map<String, dynamic> json) => PortalLimits(
        minDeliveryFee: Money.fromJson(json['minDeliveryFeeCentimes']),
        maxDeliveryFee: Money.fromJson(json['maxDeliveryFeeCentimes']),
      );

  final Money minDeliveryFee;
  final Money maxDeliveryFee;
}

final portalRepositoryProvider = Provider<PortalRepository>(
  (ref) => PortalRepository(ref.watch(apiClientProvider)),
);

final portalVendorProvider = FutureProvider.autoDispose<Vendor>((ref) async {
  final result = await ref.watch(portalRepositoryProvider).me();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final portalLimitsProvider = FutureProvider.autoDispose<PortalLimits>((ref) async {
  final result = await ref.watch(portalRepositoryProvider).limits();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final portalSectionsProvider = FutureProvider.autoDispose<List<MenuSection>>((ref) async {
  final result = await ref.watch(portalRepositoryProvider).sections();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final portalProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final result = await ref.watch(portalRepositoryProvider).products();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
