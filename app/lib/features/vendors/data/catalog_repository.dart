import 'package:saji/core/models/page.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/offers/domain/offer.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

class VendorFilters {
  const VendorFilters({
    this.categoryId,
    this.search,
    this.sort = 'featured',
    this.openNow = false,
    this.hasOffer = false,
  });

  final String? categoryId;
  final String? search;
  final String sort;
  final bool openNow;
  final bool hasOffer;

  VendorFilters copyWith({
    String? categoryId,
    String? search,
    String? sort,
    bool? openNow,
    bool? hasOffer,
    bool clearCategory = false,
    bool clearSearch = false,
  }) {
    return VendorFilters(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      search: clearSearch ? null : (search ?? this.search),
      sort: sort ?? this.sort,
      openNow: openNow ?? this.openNow,
      hasOffer: hasOffer ?? this.hasOffer,
    );
  }

  bool get isDefault =>
      categoryId == null && (search == null || search!.isEmpty) && !openNow && !hasOffer;
}

/// Reads the catalog, writing every list through a local cache so a cold start
/// on a bad connection still shows the last known data instead of a blank page.
class CatalogRepository {
  CatalogRepository({required ApiClient client, required LocalCache cache})
      : _client = client,
        _cache = cache;

  final ApiClient _client;
  final LocalCache _cache;

  static const _categoriesKey = 'categories';
  static const _homeOffersKey = 'offers.home';
  static String _vendorsKey(String suffix) => 'vendors.$suffix';
  static String _menuKey(String vendorId) => 'menu.$vendorId';

  Future<Result<List<Category>>> categories() async {
    final result = await _client.get<List<Category>>(
      Api.categories,
      parse: (data) =>
          (data as List).whereType<Map<String, dynamic>>().map(Category.fromJson).toList(),
    );

    if (result case Ok(:final value)) {
      await _cache.writeJson(_categoriesKey, value.map((c) => c.toJson()).toList());
      return result;
    }

    final cached = _cache.readList(_categoriesKey);
    if (cached.isNotEmpty) return Result.ok(cached.map(Category.fromJson).toList());
    return result;
  }

  Future<Result<Paged<Vendor>>> vendors({
    VendorFilters filters = const VendorFilters(),
    double? lat,
    double? lng,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sort': filters.sort,
      if (filters.categoryId != null) 'category': filters.categoryId,
      if (filters.search != null && filters.search!.isNotEmpty) 'search': filters.search,
      if (filters.openNow) 'openNow': true,
      if (filters.hasOffer) 'hasOffer': true,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };

    final result = await _client.get<Paged<Vendor>>(
      Api.vendors,
      query: query,
      parse: (data) => Paged.fromJson(data, Vendor.fromJson),
    );

    final cacheKey = _vendorsKey('${filters.categoryId ?? 'all'}.${filters.sort}');

    if (result case Ok(:final value)) {
      if (page == 1 && filters.search == null) {
        await _cache.writeJson(cacheKey, value.items.map((v) => v.toJson()).toList());
      }
      return result;
    }

    if (page == 1) {
      final cached = _cache.readList(cacheKey);
      if (cached.isNotEmpty) {
        final items = cached.map(Vendor.fromJson).toList();
        return Result.ok(
          Paged(items: items, page: 1, limit: items.length, total: items.length, hasMore: false),
        );
      }
    }
    return result;
  }

  Future<Result<Vendor>> vendor(String id, {double? lat, double? lng}) => _client.get<Vendor>(
        Api.vendor(id),
        query: {if (lat != null) 'lat': lat, if (lng != null) 'lng': lng},
        parse: (data) => Vendor.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<List<MenuGroup>>> menu(String vendorId) async {
    final result = await _client.get<List<MenuGroup>>(
      Api.vendorMenu(vendorId),
      parse: (data) =>
          (data as List).whereType<Map<String, dynamic>>().map(MenuGroup.fromApi).toList(),
    );

    if (result case Ok(:final value)) {
      await _cache.writeJson(
        _menuKey(vendorId),
        value
            .map(
              (group) => {
                'section': {'id': group.sectionId, 'name': group.sectionName},
                'products': group.products.map((p) => p.toJson()).toList(),
              },
            )
            .toList(),
      );
      return result;
    }

    final cached = _cache.readList(_menuKey(vendorId));
    if (cached.isNotEmpty) return Result.ok(cached.map(MenuGroup.fromApi).toList());
    return result;
  }

  Future<Result<Product>> product(String id) => _client.get<Product>(
        Api.product(id),
        parse: (data) => Product.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<List<Offer>>> homeOffers() async {
    final result = await _client.get<List<Offer>>(
      Api.homeOffers,
      parse: (data) =>
          (data as List).whereType<Map<String, dynamic>>().map(Offer.fromJson).toList(),
    );

    if (result case Ok(:final value)) {
      await _cache.writeJson(_homeOffersKey, value.map((o) => o.toJson()).toList());
      return result;
    }

    final cached = _cache.readList(_homeOffersKey);
    if (cached.isNotEmpty) return Result.ok(cached.map(Offer.fromJson).toList());
    return result;
  }
}
