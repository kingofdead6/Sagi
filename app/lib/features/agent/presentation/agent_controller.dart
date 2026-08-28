import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/agent/data/agent_repository.dart';
import 'package:saji/features/agent/data/location_tracker.dart';
import 'package:saji/features/agent/domain/agent_models.dart';
import 'package:saji/features/orders/domain/order.dart';

final agentRepositoryProvider = Provider<AgentRepository>(
  (ref) => AgentRepository(client: ref.watch(apiClientProvider)),
);

final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = LocationTracker(
    repository: ref.watch(agentRepositoryProvider),
    socket: ref.watch(socketServiceProvider),
  );
  ref.onDispose(tracker.dispose);
  return tracker;
});

@immutable
class AgentState {
  const AgentState({
    this.isOnline = false,
    this.isBusy = false,
    this.offers = const [],
    this.active,
    this.stats = const AgentStats(),
    this.position,
    this.locationDenied = false,
    this.failure,
  });

  final bool isOnline;
  final bool isBusy;
  final List<DeliveryOffer> offers;
  final ActiveDelivery? active;
  final AgentStats stats;
  final LatLng? position;
  final bool locationDenied;
  final Failure? failure;

  bool get hasActiveDelivery => active != null;

  AgentState copyWith({
    bool? isOnline,
    bool? isBusy,
    List<DeliveryOffer>? offers,
    ActiveDelivery? active,
    AgentStats? stats,
    LatLng? position,
    bool? locationDenied,
    Failure? failure,
    bool clearActive = false,
    bool clearFailure = false,
  }) {
    return AgentState(
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      offers: offers ?? this.offers,
      active: clearActive ? null : (active ?? this.active),
      stats: stats ?? this.stats,
      position: position ?? this.position,
      locationDenied: locationDenied ?? this.locationDenied,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

/// The courier's whole session: online toggle, incoming offers, the active
/// delivery, and the GPS stream that runs alongside them.
class AgentController extends StateNotifier<AgentState> {
  AgentController(this._ref) : super(const AgentState()) {
    _listen();
    unawaited(bootstrap());
  }

  final Ref _ref;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  AgentRepository get _repository => _ref.read(agentRepositoryProvider);
  LocationTracker get _tracker => _ref.read(locationTrackerProvider);

  void _listen() {
    final socket = _ref.read(socketServiceProvider);

    // A new offer arrives over the socket — no polling.
    _subscriptions.add(socket.onOrderAssigned.listen((_) => unawaited(refreshOffers())));

    _subscriptions.add(
      socket.onOrderStatus.listen((_) => unawaited(refreshActive())),
    );

    _subscriptions.add(
      _tracker.positions.listen((point) => state = state.copyWith(position: point)),
    );
  }

  Future<void> bootstrap() async {
    final status = await _repository.status();
    if (status case Ok(:final value)) {
      state = state.copyWith(isOnline: value.isOnline);
      if (value.isOnline) await _startTracking();
    }
    await Future.wait([refreshOffers(), refreshActive(), refreshStats()]);
  }

  Future<void> toggleOnline({required bool isOnline}) async {
    state = state.copyWith(isBusy: true, clearFailure: true);
    final result = await _repository.setOnline(isOnline: isOnline);

    switch (result) {
      case Ok(:final value):
        state = state.copyWith(isOnline: value.isOnline, isBusy: false);
        if (value.isOnline) {
          await _startTracking();
          await refreshOffers();
        } else {
          await _tracker.stop();
        }
      case Err(:final failure):
        state = state.copyWith(isBusy: false, failure: failure);
    }
  }

  Future<void> _startTracking() async {
    final started = await _tracker.start();
    state = state.copyWith(locationDenied: !started);
  }

  Future<void> refreshOffers() async {
    final result = await _repository.offers();
    if (result case Ok(:final value)) {
      // Expired offers are dropped client-side too, so the countdown never
      // shows a card the server has already returned to the pool.
      state = state.copyWith(offers: value.where((o) => !o.isExpired).toList());
    }
  }

  Future<void> refreshActive() async {
    final result = await _repository.active();
    switch (result) {
      case Ok(:final value):
        state = value == null
            ? state.copyWith(clearActive: true)
            : state.copyWith(active: value);
      case Err():
        break;
    }
  }

  Future<void> refreshStats() async {
    final result = await _repository.stats();
    if (result case Ok(:final value)) state = state.copyWith(stats: value);
  }

  Future<Result<AppOrder>> accept(String orderId) async {
    state = state.copyWith(isBusy: true);
    final result = await _repository.accept(orderId);
    state = state.copyWith(isBusy: false);
    await Future.wait([refreshOffers(), refreshActive()]);
    return result;
  }

  Future<Result<AppOrder>> reject(String orderId, String reason) async {
    state = state.copyWith(isBusy: true);
    final result = await _repository.reject(orderId, reason);
    state = state.copyWith(isBusy: false);
    await Future.wait([refreshOffers(), refreshActive()]);
    return result;
  }

  Future<Result<AppOrder>> advance(String orderId, String status, {bool? cashCollected}) async {
    state = state.copyWith(isBusy: true, clearFailure: true);
    final result = await _repository.updateStatus(
      orderId,
      status,
      cashCollected: cashCollected,
    );
    state = state.copyWith(isBusy: false);

    switch (result) {
      case Ok():
        await refreshActive();
        if (status == 'delivered') await refreshStats();
      case Err(:final failure):
        state = state.copyWith(failure: failure);
    }
    return result;
  }

  Future<Result<Paged<AppOrder>>> history({DateTime? from, DateTime? to, String? status}) =>
      _repository.history(from: from, to: to, status: status);

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

final agentControllerProvider = StateNotifierProvider<AgentController, AgentState>(
  AgentController.new,
);
