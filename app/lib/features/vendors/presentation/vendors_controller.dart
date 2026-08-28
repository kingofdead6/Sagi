import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/home/presentation/home_controller.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';
import 'package:saji/features/vendors/data/catalog_repository.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// The filter bar's live state on the vendor list screen.
final vendorFiltersProvider =
    StateProvider.autoDispose<VendorFilters>((ref) => const VendorFilters());

final vendorListProvider =
    FutureProvider.autoDispose<Paged<Vendor>>((ref) async {
  final filters = ref.watch(vendorFiltersProvider);
  final address = ref.watch(defaultAddressProvider);

  final result = await ref.watch(catalogRepositoryProvider).vendors(
        filters: filters,
        lat: address?.location?.latitude,
        lng: address?.location?.longitude,
        limit: 30,
      );

  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final vendorDetailProvider =
    FutureProvider.autoDispose.family<Vendor, String>((ref, id) async {
  final address = ref.watch(defaultAddressProvider);
  final result = await ref.watch(catalogRepositoryProvider).vendor(
        id,
        lat: address?.location?.latitude,
        lng: address?.location?.longitude,
      );
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final vendorMenuProvider =
    FutureProvider.autoDispose.family<List<MenuGroup>, String>((ref, id) async {
  final result = await ref.watch(catalogRepositoryProvider).menu(id);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final productDetailProvider =
    FutureProvider.autoDispose.family<Product, String>((ref, id) async {
  final result = await ref.watch(catalogRepositoryProvider).product(id);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
