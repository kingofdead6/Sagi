import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/offers/domain/offer.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';
import 'package:saji/features/vendors/data/catalog_repository.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(
    client: ref.watch(apiClientProvider),
    cache: ref.watch(localCacheProvider),
  ),
);

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final result = await ref.watch(catalogRepositoryProvider).categories();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final homeOffersProvider = FutureProvider<List<Offer>>((ref) async {
  final result = await ref.watch(catalogRepositoryProvider).homeOffers();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// The category chip the home screen is filtered by (null = all).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Home vendors, sorted by distance from the default address when we have one.
final homeVendorsProvider = FutureProvider<Paged<Vendor>>((ref) async {
  final address = ref.watch(defaultAddressProvider);
  final categoryId = ref.watch(selectedCategoryProvider);

  final result = await ref.watch(catalogRepositoryProvider).vendors(
        filters: VendorFilters(
          categoryId: categoryId,
          sort: address?.location != null ? 'nearest' : 'featured',
        ),
        lat: address?.location?.latitude,
        lng: address?.location?.longitude,
        limit: 10,
      );

  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// Vendor ids that currently carry an offer, so cards can show the badge.
final offerVendorIdsProvider = Provider<Set<String>>((ref) {
  final offers = ref.watch(homeOffersProvider).valueOrNull ?? const <Offer>[];
  return offers.map((o) => o.vendor).whereType<String>().toSet();
});
