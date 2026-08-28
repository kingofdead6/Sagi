import 'package:saji/core/models/page.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/orders/domain/quote.dart';

/// One basket line as the API wants it: ids and quantities only. The client
/// never sends a price — the server re-prices everything.
class QuoteRequestItem {
  const QuoteRequestItem({
    required this.productId,
    required this.qty,
    this.optionValueIds = const [],
  });

  final String productId;
  final int qty;
  final List<String> optionValueIds;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'qty': qty,
        'optionValueIds': optionValueIds,
      };
}

class OrderRepository {
  OrderRepository({required ApiClient client, required LocalCache cache})
      : _client = client,
        _cache = cache;

  static const _myOrdersKey = 'orders.mine';

  final ApiClient _client;
  final LocalCache _cache;

  Map<String, dynamic> _quoteBody({
    required String vendorId,
    required List<QuoteRequestItem> items,
    required DeliveryType deliveryType,
    required PaymentMethod paymentMethod,
    String? voucherCode,
    int? pointsToUse,
  }) =>
      {
        'vendorId': vendorId,
        'items': items.map((i) => i.toJson()).toList(),
        'deliveryType': deliveryType.wire,
        'paymentMethod': paymentMethod.wire,
        if (voucherCode != null && voucherCode.isNotEmpty) 'voucherCode': voucherCode,
        if (pointsToUse != null && pointsToUse > 0) 'pointsToUse': pointsToUse,
      };

  Future<Result<OrderQuote>> quote({
    required String vendorId,
    required List<QuoteRequestItem> items,
    required DeliveryType deliveryType,
    required PaymentMethod paymentMethod,
    String? voucherCode,
    int? pointsToUse,
  }) =>
      _client.post<OrderQuote>(
        Api.orderQuote,
        body: _quoteBody(
          vendorId: vendorId,
          items: items,
          deliveryType: deliveryType,
          paymentMethod: paymentMethod,
          voucherCode: voucherCode,
          pointsToUse: pointsToUse,
        ),
        parse: (data) => OrderQuote.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppOrder>> create({
    required String vendorId,
    required List<QuoteRequestItem> items,
    required String addressId,
    required DeliveryType deliveryType,
    required PaymentMethod paymentMethod,
    String? voucherCode,
    int? pointsToUse,
    String? customerNote,
  }) =>
      _client.post<AppOrder>(
        Api.orders,
        body: {
          ..._quoteBody(
            vendorId: vendorId,
            items: items,
            deliveryType: deliveryType,
            paymentMethod: paymentMethod,
            voucherCode: voucherCode,
            pointsToUse: pointsToUse,
          ),
          'addressId': addressId,
          if (customerNote != null && customerNote.isNotEmpty) 'customerNote': customerNote,
        },
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Paged<AppOrder>>> myOrders({int page = 1, int limit = 20}) async {
    final result = await _client.get<Paged<AppOrder>>(
      Api.orders,
      query: {'page': page, 'limit': limit},
      parse: (data) => Paged.fromJson(data, AppOrder.fromJson),
    );

    if (result case Ok(:final value)) {
      if (page == 1) {
        await _cache.writeJson(_myOrdersKey, value.items.map((o) => o.toJson()).toList());
      }
      return result;
    }

    if (page == 1) {
      final cached = _cache.readList(_myOrdersKey);
      if (cached.isNotEmpty) {
        final items = cached.map(AppOrder.fromJson).toList();
        return Result.ok(
          Paged(items: items, page: 1, limit: items.length, total: items.length, hasMore: false),
        );
      }
    }
    return result;
  }

  Future<Result<AppOrder>> order(String id) => _client.get<AppOrder>(
        Api.order(id),
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppOrder>> cancel(String id, String reason) => _client.patch<AppOrder>(
        Api.orderCancel(id),
        body: {'reason': reason},
        parse: (data) => AppOrder.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> rate({
    required String orderId,
    required int vendorRating,
    int? agentRating,
    String? comment,
  }) =>
      _client.post<void>(
        Api.orderRating(orderId),
        body: {
          'vendorRating': vendorRating,
          if (agentRating != null) 'agentRating': agentRating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
        parse: (_) {},
      );

  /// Server-side voucher check for the checkout screen's apply button.
  Future<Result<Money>> validateVoucher({
    required String code,
    required Money subtotal,
    required Money deliveryFee,
  }) =>
      _client.post<Money>(
        Api.voucherValidate,
        body: {
          'code': code,
          'subtotalCentimes': subtotal.centimes,
          'deliveryFeeCentimes': deliveryFee.centimes,
        },
        parse: (data) => Money.fromJson((data as Map<String, dynamic>)['discountCentimes']),
      );
}
