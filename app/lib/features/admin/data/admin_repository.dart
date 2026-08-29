import 'package:saji/core/models/page.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/offers/domain/offer.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// The admin board's filter set (§9).
class AdminOrderFilters {
  const AdminOrderFilters({
    this.status,
    this.vendorId,
    this.agentId,
    this.from,
    this.to,
    this.payment,
    this.deliveryType,
    this.query,
  });

  final String? status;
  final String? vendorId;
  final String? agentId;
  final DateTime? from;
  final DateTime? to;
  final String? payment;
  final String? deliveryType;
  final String? query;

  AdminOrderFilters copyWith({
    String? status,
    String? vendorId,
    String? agentId,
    DateTime? from,
    DateTime? to,
    String? payment,
    String? deliveryType,
    String? query,
    bool clear = false,
  }) {
    if (clear) return const AdminOrderFilters();
    return AdminOrderFilters(
      status: status ?? this.status,
      vendorId: vendorId ?? this.vendorId,
      agentId: agentId ?? this.agentId,
      from: from ?? this.from,
      to: to ?? this.to,
      payment: payment ?? this.payment,
      deliveryType: deliveryType ?? this.deliveryType,
      query: query ?? this.query,
    );
  }

  Map<String, dynamic> toQuery({int page = 1, int limit = 30}) => {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (vendorId != null) 'vendor': vendorId,
        if (agentId != null) 'agent': agentId,
        if (from != null) 'from': from!.toUtc().toIso8601String(),
        if (to != null) 'to': to!.toUtc().toIso8601String(),
        if (payment != null) 'payment': payment,
        if (deliveryType != null) 'deliveryType': deliveryType,
        if (query != null && query!.isNotEmpty) 'q': query,
      };
}

class AdminRepository {
  AdminRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  // ── dashboard & orders ─────────────────────────────────────────────────

  Future<Result<DashboardStats>> stats() => _client.get<DashboardStats>(
        Api.adminStats,
        parse: (data) => DashboardStats.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Paged<AppOrder>>> orders(AdminOrderFilters filters, {int page = 1}) =>
      _client.get<Paged<AppOrder>>(
        Api.adminOrders,
        query: filters.toQuery(page: page),
        parse: (data) => Paged.fromJson(data, AppOrder.fromJson),
      );

  /// The CSV export of the current filter set, fetched through the
  /// authenticated client so the browser never needs the token in a URL.
  Future<Result<String>> exportCsv(AdminOrderFilters filters) => _client.get<String>(
        Api.adminOrdersExport,
        query: filters.toQuery(limit: 5000),
        parse: (data) => data is String ? data : data.toString(),
      );

  Future<Result<AppOrder>> order(String id) => _client.get<AppOrder>(
        Api.adminOrder(id),
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppOrder>> setStatus(String id, String status, {String? note}) =>
      _client.patch<AppOrder>(
        Api.adminOrderStatus(id),
        body: {'status': status, if (note != null && note.isNotEmpty) 'note': note},
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppOrder>> assign(String orderId, String agentId) => _client.post<AppOrder>(
        Api.adminOrderAssign(orderId),
        body: {'agentId': agentId},
        parse: (data) =>
            AppOrder.fromJson((data as Map<String, dynamic>)['order'] as Map<String, dynamic>),
      );

  Future<Result<List<AvailableAgent>>> availableAgents({String? vendorId}) =>
      _client.get<List<AvailableAgent>>(
        Api.adminAgentsAvailable,
        query: {if (vendorId != null) 'vendorId': vendorId},
        parse: (data) => (data as List)
            .whereType<Map<String, dynamic>>()
            .map(AvailableAgent.fromJson)
            .toList(),
      );

  Future<Result<List<FleetAgent>>> fleet() => _client.get<List<FleetAgent>>(
        Api.adminAgentsLocations,
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(FleetAgent.fromJson).toList(),
      );

  // ── catalog CRUD ───────────────────────────────────────────────────────

  Future<Result<List<Category>>> categories() => _client.get<List<Category>>(
        Api.adminCategories,
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(Category.fromJson).toList(),
      );

  Future<Result<Paged<Vendor>>> vendors({String? query, int page = 1}) =>
      _client.get<Paged<Vendor>>(
        Api.adminVendors,
        query: {'page': page, 'limit': 30, if (query != null && query.isNotEmpty) 'q': query},
        parse: (data) => Paged.fromJson(data, Vendor.fromJson),
      );

  Future<Result<Vendor>> saveVendor(Map<String, dynamic> body, {String? id}) => id == null
      ? _client.post<Vendor>(
          Api.adminVendors,
          body: body,
          parse: (data) => Vendor.fromJson(data as Map<String, dynamic>),
        )
      : _client.patch<Vendor>(
          Api.adminVendor(id),
          body: body,
          parse: (data) => Vendor.fromJson(data as Map<String, dynamic>),
        );

  /// Gives a shop its own login. The owner can then manage their menu only.
  Future<Result<void>> createVendorAccount(
    String vendorId, {
    required String fullName,
    required String phone,
    required String password,
  }) =>
      _client.post<void>(
        Api.adminVendorAccount(vendorId),
        body: {'fullName': fullName, 'phone': phone, 'password': password},
        parse: (_) {},
      );

  Future<Result<void>> revokeVendorAccount(String vendorId) =>
      _client.delete<void>(Api.adminVendorAccount(vendorId), parse: (_) {});

  Future<Result<void>> deleteVendor(String id) =>
      _client.delete<void>(Api.adminVendor(id), parse: (_) {});

  Future<Result<List<MenuSection>>> sections(String vendorId) => _client.get<List<MenuSection>>(
        Api.adminVendorSections(vendorId),
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(MenuSection.fromJson).toList(),
      );

  Future<Result<MenuSection>> createSection(String vendorId, String name, int sortOrder) =>
      _client.post<MenuSection>(
        Api.adminVendorSections(vendorId),
        body: {'name': name, 'sortOrder': sortOrder},
        parse: (data) => MenuSection.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> deleteSection(String id) =>
      _client.delete<void>(Api.adminSection(id), parse: (_) {});

  Future<Result<Paged<Product>>> products({String? vendorId, String? query, int page = 1}) =>
      _client.get<Paged<Product>>(
        Api.adminProducts,
        query: {
          'page': page,
          'limit': 50,
          if (vendorId != null) 'vendor': vendorId,
          if (query != null && query.isNotEmpty) 'q': query,
        },
        parse: (data) => Paged.fromJson(data, Product.fromJson),
      );

  Future<Result<Product>> saveProduct(Map<String, dynamic> body, {String? id}) => id == null
      ? _client.post<Product>(
          Api.adminProducts,
          body: body,
          parse: (data) => Product.fromJson(data as Map<String, dynamic>),
        )
      : _client.patch<Product>(
          Api.adminProduct(id),
          body: body,
          parse: (data) => Product.fromJson(data as Map<String, dynamic>),
        );

  Future<Result<void>> deleteProduct(String id) =>
      _client.delete<void>(Api.adminProduct(id), parse: (_) {});

  Future<Result<void>> reorderProducts(List<({String id, int sortOrder})> items) =>
      _client.post<void>(
        Api.adminProductsReorder,
        body: {
          'items': items.map((i) => {'id': i.id, 'sortOrder': i.sortOrder}).toList(),
        },
        parse: (_) {},
      );

  Future<Result<void>> setAvailability(List<String> ids, {required bool isAvailable}) =>
      _client.post<void>(
        Api.adminProductsAvailability,
        body: {'ids': ids, 'isAvailable': isAvailable},
        parse: (_) {},
      );

  Future<Result<List<Offer>>> offers() => _client.get<List<Offer>>(
        Api.adminOffers,
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(Offer.fromJson).toList(),
      );

  Future<Result<Offer>> saveOffer(Map<String, dynamic> body, {String? id}) => id == null
      ? _client.post<Offer>(
          Api.adminOffers,
          body: body,
          parse: (data) => Offer.fromJson(data as Map<String, dynamic>),
        )
      : _client.patch<Offer>(
          Api.adminOffer(id),
          body: body,
          parse: (data) => Offer.fromJson(data as Map<String, dynamic>),
        );

  Future<Result<void>> deleteOffer(String id) =>
      _client.delete<void>(Api.adminOffer(id), parse: (_) {});

  Future<Result<List<Voucher>>> vouchers() => _client.get<List<Voucher>>(
        Api.adminVouchers,
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(Voucher.fromJson).toList(),
      );

  Future<Result<Voucher>> saveVoucher(Map<String, dynamic> body, {String? id}) => id == null
      ? _client.post<Voucher>(
          Api.adminVouchers,
          body: body,
          parse: (data) => Voucher.fromJson(data as Map<String, dynamic>),
        )
      : _client.patch<Voucher>(
          Api.adminVoucher(id),
          body: body,
          parse: (data) => Voucher.fromJson(data as Map<String, dynamic>),
        );

  Future<Result<void>> deleteVoucher(String id) =>
      _client.delete<void>(Api.adminVoucher(id), parse: (_) {});

  // ── people ─────────────────────────────────────────────────────────────

  Future<Result<Paged<ManagedUser>>> agents({String? query, int page = 1}) =>
      _client.get<Paged<ManagedUser>>(
        Api.adminAgents,
        query: {'page': page, 'limit': 30, if (query != null && query.isNotEmpty) 'q': query},
        parse: (data) => Paged.fromJson(data, ManagedUser.fromJson),
      );

  Future<Result<ManagedUser>> createAgent({
    required String fullName,
    required String phone,
    required String password,
  }) =>
      _client.post<ManagedUser>(
        Api.adminAgents,
        body: {'fullName': fullName, 'phone': phone, 'password': password},
        parse: (data) => ManagedUser.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<ManagedUser>> updateAgent(String id, Map<String, dynamic> body) =>
      _client.patch<ManagedUser>(
        Api.adminAgent(id),
        body: body,
        parse: (data) => ManagedUser.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Paged<ManagedUser>>> customers({String? query, int page = 1}) =>
      _client.get<Paged<ManagedUser>>(
        Api.adminCustomers,
        query: {'page': page, 'limit': 30, if (query != null && query.isNotEmpty) 'q': query},
        parse: (data) => Paged.fromJson(data, ManagedUser.fromJson),
      );

  Future<Result<ManagedUser>> updateCustomer(String id, Map<String, dynamic> body) =>
      _client.patch<ManagedUser>(
        Api.adminCustomer(id),
        body: body,
        parse: (data) => ManagedUser.fromJson(data as Map<String, dynamic>),
      );

  // ── analytics & settings ───────────────────────────────────────────────

  Future<Result<List<TimeSeriesPoint>>> ordersOverTime({DateTime? from, DateTime? to}) =>
      _client.get<List<TimeSeriesPoint>>(
        Api.adminAnalyticsOrders,
        query: _range(from, to),
        parse: (data) => (data as List)
            .whereType<Map<String, dynamic>>()
            .map(TimeSeriesPoint.fromJson)
            .toList(),
      );

  Future<Result<List<RankedRow>>> ranked(String path, {DateTime? from, DateTime? to}) =>
      _client.get<List<RankedRow>>(
        path,
        query: _range(from, to),
        parse: (data) =>
            (data as List).whereType<Map<String, dynamic>>().map(RankedRow.fromApi).toList(),
      );

  Map<String, dynamic> _range(DateTime? from, DateTime? to) => {
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
      };

  Future<Result<PlatformSettings>> settings() => _client.get<PlatformSettings>(
        Api.adminSettings,
        parse: (data) => PlatformSettings.fromJson(data as Map<String, dynamic>),
      );

  /// The same document as [settings], untyped.
  ///
  /// [PlatformSettings] is a freezed model, so every key it exposes costs a
  /// codegen round. Settings that are only ever read and written as a number —
  /// the vendor delivery-fee bounds — are read from here instead.
  Future<Result<Map<String, dynamic>>> settingsRaw() => _client.get<Map<String, dynamic>>(
        Api.adminSettings,
        parse: (data) => (data as Map<String, dynamic>?) ?? const {},
      );

  Future<Result<PlatformSettings>> updateSettings(Map<String, dynamic> patch) =>
      _client.patch<PlatformSettings>(
        Api.adminSettings,
        body: patch,
        parse: (data) => PlatformSettings.fromJson(data as Map<String, dynamic>),
      );
}
