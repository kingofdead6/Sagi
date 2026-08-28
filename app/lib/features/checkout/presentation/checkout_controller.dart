import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/cart/domain/cart.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';
import 'package:saji/features/orders/data/order_repository.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/orders/domain/quote.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(
    client: ref.watch(apiClientProvider),
    cache: ref.watch(localCacheProvider),
  ),
);

@immutable
class CheckoutState {
  const CheckoutState({
    this.deliveryType = DeliveryType.normal,
    this.paymentMethod = PaymentMethod.cash,
    this.voucherCode,
    this.pointsToUse = 0,
    this.note,
    this.quote,
    this.isQuoting = false,
    this.isSubmitting = false,
    this.failure,
  });

  final DeliveryType deliveryType;
  final PaymentMethod paymentMethod;
  final String? voucherCode;
  final int pointsToUse;
  final String? note;

  /// The authoritative breakdown from the server. Null until the first quote.
  final OrderQuote? quote;
  final bool isQuoting;
  final bool isSubmitting;
  final Failure? failure;

  bool get canSubmit => quote != null && !isQuoting && !isSubmitting;

  CheckoutState copyWith({
    DeliveryType? deliveryType,
    PaymentMethod? paymentMethod,
    String? voucherCode,
    int? pointsToUse,
    String? note,
    OrderQuote? quote,
    bool? isQuoting,
    bool? isSubmitting,
    Failure? failure,
    bool clearVoucher = false,
    bool clearFailure = false,
  }) {
    return CheckoutState(
      deliveryType: deliveryType ?? this.deliveryType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      voucherCode: clearVoucher ? null : (voucherCode ?? this.voucherCode),
      pointsToUse: pointsToUse ?? this.pointsToUse,
      note: note ?? this.note,
      quote: quote ?? this.quote,
      isQuoting: isQuoting ?? this.isQuoting,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

/// Drives checkout. Every price shown comes from `POST /orders/quote` — the
/// client never computes a total it then sends back.
class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController(this._ref) : super(const CheckoutState());

  final Ref _ref;

  OrderRepository get _repository => _ref.read(orderRepositoryProvider);
  Cart get _cart => _ref.read(cartControllerProvider);

  Future<void> refreshQuote() async {
    final cart = _cart;
    if (cart.isEmpty || cart.vendorId == null) return;

    state = state.copyWith(isQuoting: true, clearFailure: true);

    final result = await _repository.quote(
      vendorId: cart.vendorId!,
      items: cart.toRequestItems(),
      deliveryType: state.deliveryType,
      paymentMethod: state.paymentMethod,
      voucherCode: state.voucherCode,
      pointsToUse: state.pointsToUse,
    );

    state = switch (result) {
      Ok(:final value) => state.copyWith(quote: value, isQuoting: false),
      Err(:final failure) => state.copyWith(isQuoting: false, failure: failure),
    };
  }

  Future<void> setDeliveryType(DeliveryType type) async {
    if (type == state.deliveryType) return;
    state = state.copyWith(deliveryType: type);
    await refreshQuote();
  }

  void setPaymentMethod(PaymentMethod method) =>
      state = state.copyWith(paymentMethod: method);

  Future<void> applyVoucher(String code) async {
    state = state.copyWith(voucherCode: code.trim().toUpperCase());
    await refreshQuote();
  }

  Future<void> removeVoucher() async {
    state = state.copyWith(clearVoucher: true);
    await refreshQuote();
  }

  Future<void> setPoints(int points) async {
    if (points == state.pointsToUse) return;
    state = state.copyWith(pointsToUse: points < 0 ? 0 : points);
    await refreshQuote();
  }

  void setNote(String? note) => state = state.copyWith(note: note);

  Future<Result<AppOrder>> submit(String addressId) async {
    final cart = _cart;
    if (cart.isEmpty || cart.vendorId == null) {
      return const Result.err(Failure(kind: FailureKind.validation));
    }

    state = state.copyWith(isSubmitting: true, clearFailure: true);

    final result = await _repository.create(
      vendorId: cart.vendorId!,
      items: cart.toRequestItems(),
      addressId: addressId,
      deliveryType: state.deliveryType,
      paymentMethod: state.paymentMethod,
      voucherCode: state.voucherCode,
      pointsToUse: state.pointsToUse,
      customerNote: state.note,
    );

    switch (result) {
      case Ok():
        // The basket is only cleared once the server has the order.
        await _ref.read(cartControllerProvider.notifier).clear();
        state = const CheckoutState();
      case Err(:final failure):
        state = state.copyWith(isSubmitting: false, failure: failure);
    }

    return result;
  }

  void reset() => state = const CheckoutState();
}

final checkoutControllerProvider =
    StateNotifierProvider.autoDispose<CheckoutController, CheckoutState>(
  CheckoutController.new,
);
