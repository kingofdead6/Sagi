import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/admin/data/admin_repository.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/orders/domain/order.dart';

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(client: ref.watch(apiClientProvider)),
);

/// Fires whenever a new order lands, so the board can play its alert.
final newOrderAlertProvider = StreamProvider<AppOrder>((ref) {
  return ref.watch(socketServiceProvider).onOrderNew.map(AppOrder.fromJson);
});

/// Fires when the sweeper flags an order as late.
final lateOrderAlertProvider = StreamProvider<Map<String, dynamic>>(
  (ref) => ref.watch(socketServiceProvider).onOrderLate,
);

/// Dashboard counters, refreshed on every realtime event — no refresh button.
final adminStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final socket = ref.watch(socketServiceProvider);
  final subscriptions = [
    socket.onOrderNew.listen((_) => ref.invalidateSelf()),
    socket.onOrderStatus.listen((_) => ref.invalidateSelf()),
    socket.onAgentStatus.listen((_) => ref.invalidateSelf()),
  ];
  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
  });

  final result = await ref.watch(adminRepositoryProvider).stats();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final adminOrderFiltersProvider =
    StateProvider<AdminOrderFilters>((ref) => const AdminOrderFilters());

/// The live orders board. Socket events invalidate it, so an order placed on a
/// phone appears here without anyone touching the page.
final adminOrdersProvider = FutureProvider.autoDispose<Paged<AppOrder>>((ref) async {
  final filters = ref.watch(adminOrderFiltersProvider);
  final socket = ref.watch(socketServiceProvider);

  final subscriptions = [
    socket.onOrderNew.listen((_) => ref.invalidateSelf()),
    socket.onOrderStatus.listen((_) => ref.invalidateSelf()),
  ];
  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
  });

  final result = await ref.watch(adminRepositoryProvider).orders(filters);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// The order currently open in the right-hand drawer.
final selectedOrderIdProvider = StateProvider<String?>((ref) => null);

final selectedOrderProvider = FutureProvider.autoDispose<AppOrder?>((ref) async {
  final id = ref.watch(selectedOrderIdProvider);
  if (id == null) return null;

  final socket = ref.watch(socketServiceProvider);
  final subscription = socket.onOrderStatus.listen((payload) {
    if (payload['orderId'] == id) ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);

  final result = await ref.watch(adminRepositoryProvider).order(id);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final availableAgentsProvider =
    FutureProvider.autoDispose.family<List<AvailableAgent>, String?>((ref, vendorId) async {
  final result = await ref.watch(adminRepositoryProvider).availableAgents(vendorId: vendorId);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// Live fleet positions, updated straight from `agent:location`.
final fleetProvider = FutureProvider.autoDispose<List<FleetAgent>>((ref) async {
  final socket = ref.watch(socketServiceProvider);
  Timer? debounce;

  final subscriptions = [
    socket.onAgentStatus.listen((_) => ref.invalidateSelf()),
    // Location events are frequent; refetch at most once a second.
    socket.onAgentLocation.listen((_) {
      debounce?.cancel();
      debounce = Timer(const Duration(seconds: 1), ref.invalidateSelf);
    }),
  ];

  ref.onDispose(() {
    debounce?.cancel();
    for (final s in subscriptions) {
      s.cancel();
    }
  });

  final result = await ref.watch(adminRepositoryProvider).fleet();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final adminSettingsProvider = FutureProvider.autoDispose<PlatformSettings>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).settings();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
