import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/checkout/presentation/checkout_controller.dart';
import 'package:saji/features/orders/domain/order.dart';

/// The customer's own orders, refreshed automatically whenever a socket status
/// event arrives — no pull-to-refresh required.
final myOrdersProvider = FutureProvider.autoDispose<Paged<AppOrder>>((ref) async {
  final socket = ref.watch(socketServiceProvider);
  final subscription = socket.onOrderStatus.listen((_) => ref.invalidateSelf());
  ref.onDispose(subscription.cancel);

  final result = await ref.watch(orderRepositoryProvider).myOrders(limit: 30);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// One order, live: joins its socket room and refetches on every status change.
final orderDetailProvider =
    FutureProvider.autoDispose.family<AppOrder, String>((ref, id) async {
  final socket = ref.watch(socketServiceProvider)..joinOrder(id);

  final subscription = socket.onOrderStatus.listen((payload) {
    if (payload['orderId'] == id) ref.invalidateSelf();
  });

  ref.onDispose(() {
    subscription.cancel();
    socket.leaveOrder(id);
  });

  final result = await ref.watch(orderRepositoryProvider).order(id);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// The courier's live position for one order, pushed while it is `on_the_way`.
class AgentTrackingNotifier extends StateNotifier<LatLng?> {
  AgentTrackingNotifier(this._ref, this.orderId) : super(null) {
    _subscription = _ref.read(socketServiceProvider).onAgentLocation.listen((payload) {
      if (payload['orderId'] != orderId) return;
      final lat = payload['lat'];
      final lng = payload['lng'];
      if (lat is num && lng is num) {
        state = LatLng(lat.toDouble(), lng.toDouble());
      }
    });
  }

  final Ref _ref;
  final String orderId;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final agentTrackingProvider =
    StateNotifierProvider.autoDispose.family<AgentTrackingNotifier, LatLng?, String>(
  AgentTrackingNotifier.new,
);
