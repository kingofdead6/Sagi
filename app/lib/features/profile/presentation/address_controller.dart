import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/profile/data/address_repository.dart';
import 'package:saji/features/profile/domain/address.dart';

final addressRepositoryProvider = Provider<AddressRepository>(
  (ref) => AddressRepository(
    client: ref.watch(apiClientProvider),
    cache: ref.watch(localCacheProvider),
  ),
);

/// The user's saved addresses. Everything that changes them goes through here
/// so the checkout screen always sees the current default.
class AddressesController extends StateNotifier<AsyncValue<List<Address>>> {
  AddressesController(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  AddressRepository get _repository => _ref.read(addressRepositoryProvider);

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repository.list();
    state = switch (result) {
      Ok(:final value) => AsyncValue.data(value),
      Err(:final failure) => AsyncValue.error(failure, StackTrace.current),
    };
  }

  Future<Result<Address>> create({
    required String label,
    required String wilaya,
    required String commune,
    required String street,
    required LatLng location,
    String? notes,
    bool isDefault = false,
  }) async {
    final result = await _repository.create(
      label: label,
      wilaya: wilaya,
      commune: commune,
      street: street,
      location: location,
      notes: notes,
      isDefault: isDefault,
    );
    if (result.isOk) await load();
    return result;
  }

  Future<Result<Address>> update(
    String id, {
    String? label,
    String? wilaya,
    String? commune,
    String? street,
    String? notes,
    LatLng? location,
    bool? isDefault,
  }) async {
    final result = await _repository.update(
      id,
      label: label,
      wilaya: wilaya,
      commune: commune,
      street: street,
      notes: notes,
      location: location,
      isDefault: isDefault,
    );
    if (result.isOk) await load();
    return result;
  }

  Future<void> setDefault(String id) async {
    final result = await _repository.setDefault(id);
    if (result.isOk) await load();
  }

  Future<Result<void>> remove(String id) async {
    final result = await _repository.remove(id);
    if (result.isOk) await load();
    return result;
  }
}

final addressesControllerProvider =
    StateNotifierProvider<AddressesController, AsyncValue<List<Address>>>(
  AddressesController.new,
);

/// The address orders are delivered to — the default, or the first saved one.
final defaultAddressProvider = Provider<Address?>((ref) {
  final addresses = ref.watch(addressesControllerProvider).valueOrNull ?? const [];
  if (addresses.isEmpty) return null;
  return addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
});
