import 'package:flutter/foundation.dart';

/// Every server path in one place. The base URL is configured at build time:
/// `flutter run --dart-define=SAJI_API_URL=http://10.0.2.2:4000`
abstract final class Api {
  static const _configured = String.fromEnvironment('SAJI_API_URL');

  /// Falls back to a sensible local default per platform: `localhost` for the
  /// admin dashboard in a browser, and the Android emulator's host alias for
  /// the mobile surfaces.
  static final baseUrl = _configured.isNotEmpty
      ? _configured
      : kIsWeb
          ? 'http://localhost:4000'
          : 'http://10.0.2.2:4000';

  static const prefix = '/api/v1';
  static String get socketUrl => baseUrl;

  // auth
  static const register = '$prefix/auth/register';
  static const login = '$prefix/auth/login';
  static const refresh = '$prefix/auth/refresh';
  static const logout = '$prefix/auth/logout';
  static const me = '$prefix/auth/me';
  static const changePassword = '$prefix/auth/change-password';
  static const fcmToken = '$prefix/auth/fcm-token';
  static const otpRequest = '$prefix/auth/otp/request';
  static const otpVerify = '$prefix/auth/otp/verify';

  // catalog
  static const categories = '$prefix/categories';
  static const vendors = '$prefix/vendors';
  static String vendor(String id) => '$prefix/vendors/$id';
  static String vendorMenu(String id) => '$prefix/vendors/$id/menu';
  static String product(String id) => '$prefix/products/$id';
  static const homeOffers = '$prefix/offers/home';

  // addresses
  static const addresses = '$prefix/addresses';
  static String address(String id) => '$prefix/addresses/$id';
  static String addressDefault(String id) => '$prefix/addresses/$id/default';

  // orders
  static const orders = '$prefix/orders';
  static const orderQuote = '$prefix/orders/quote';
  static const reorderable = '$prefix/orders/reorderable';
  static String order(String id) => '$prefix/orders/$id';
  static String orderCancel(String id) => '$prefix/orders/$id/cancel';
  static String orderRating(String id) => '$prefix/orders/$id/rating';
  static const voucherValidate = '$prefix/vouchers/validate';

  // agent
  static const agentStatus = '$prefix/agent/status';
  static const agentMyStatus = '$prefix/agent/me/status';
  static const agentOffers = '$prefix/agent/offers';
  static String agentAccept(String orderId) => '$prefix/agent/offers/$orderId/accept';
  static String agentReject(String orderId) => '$prefix/agent/offers/$orderId/reject';
  static const agentActive = '$prefix/agent/orders/active';
  static String agentOrderStatus(String id) => '$prefix/agent/orders/$id/status';
  static const agentHistory = '$prefix/agent/orders/history';
  static const agentStats = '$prefix/agent/stats';
  static const agentLocation = '$prefix/agent/location';
  static const agentLocationBatch = '$prefix/agent/location/batch';

  // admin
  static const adminStats = '$prefix/admin/stats';
  static const adminOrders = '$prefix/admin/orders';
  static const adminOrdersExport = '$prefix/admin/orders/export';
  static String adminOrder(String id) => '$prefix/admin/orders/$id';
  static String adminOrderStatus(String id) => '$prefix/admin/orders/$id/status';
  static String adminOrderAssign(String id) => '$prefix/admin/orders/$id/assign';
  static const adminAgentsAvailable = '$prefix/admin/agents/available';
  static const adminAgentsLocations = '$prefix/admin/agents/locations';
  static const adminCategories = '$prefix/admin/categories';
  static String adminCategory(String id) => '$prefix/admin/categories/$id';
  static const adminVendors = '$prefix/admin/vendors';
  static String adminVendor(String id) => '$prefix/admin/vendors/$id';
  static String adminVendorSections(String id) => '$prefix/admin/vendors/$id/sections';
  static String adminSection(String id) => '$prefix/admin/sections/$id';
  static const adminProducts = '$prefix/admin/products';
  static String adminProduct(String id) => '$prefix/admin/products/$id';
  static const adminProductsReorder = '$prefix/admin/products/reorder';
  static const adminProductsAvailability = '$prefix/admin/products/availability';
  static const adminOffers = '$prefix/admin/offers';
  static String adminOffer(String id) => '$prefix/admin/offers/$id';
  static const adminVouchers = '$prefix/admin/vouchers';
  static String adminVoucher(String id) => '$prefix/admin/vouchers/$id';
  static const adminAgents = '$prefix/admin/agents';
  static String adminAgent(String id) => '$prefix/admin/agents/$id';
  static String adminAgentStats(String id) => '$prefix/admin/agents/$id/stats';
  static const adminCustomers = '$prefix/admin/customers';
  static String adminCustomer(String id) => '$prefix/admin/customers/$id';
  static const adminSettings = '$prefix/admin/settings';
  static const adminAnalyticsOrders = '$prefix/admin/analytics/orders';
  static const adminAnalyticsTopVendors = '$prefix/admin/analytics/top-vendors';
  static const adminAnalyticsTopProducts = '$prefix/admin/analytics/top-products';
  static const adminAnalyticsAgents = '$prefix/admin/analytics/agents';
  static const adminAnalyticsCancellations = '$prefix/admin/analytics/cancellations';

  // uploads
  static const uploadImage = '$prefix/uploads/image';
}
