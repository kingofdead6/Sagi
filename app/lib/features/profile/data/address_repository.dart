import 'package:latlong2/latlong.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/features/profile/domain/address.dart';

class AddressRepository {
  AddressRepository({required ApiClient client, required LocalCache cache})
      : _client = client,
        _cache = cache;

  static const _key = 'addresses';

  final ApiClient _client;
  final LocalCache _cache;

  Future<Result<List<Address>>> list() async {
    final result = await _client.get<List<Address>>(
      Api.addresses,
      parse: (data) =>
          (data as List).whereType<Map<String, dynamic>>().map(Address.fromJson).toList(),
    );

    if (result case Ok(:final value)) {
      await _cache.writeJson(_key, value.map((a) => a.toJson()).toList());
      return result;
    }

    final cached = _cache.readList(_key);
    if (cached.isNotEmpty) return Result.ok(cached.map(Address.fromJson).toList());
    return result;
  }

  Future<Result<Address>> create({
    required String label,
    required String wilaya,
    required String commune,
    required String street,
    required LatLng location,
    String? notes,
    bool isDefault = false,
  }) =>
      _client.post<Address>(
        Api.addresses,
        body: {
          'label': label,
          'wilaya': wilaya,
          'commune': commune,
          'street': street,
          'lat': location.latitude,
          'lng': location.longitude,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'isDefault': isDefault,
        },
        parse: (data) => Address.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Address>> update(
    String id, {
    String? label,
    String? wilaya,
    String? commune,
    String? street,
    String? notes,
    LatLng? location,
    bool? isDefault,
  }) =>
      _client.patch<Address>(
        Api.address(id),
        body: {
          if (label != null) 'label': label,
          if (wilaya != null) 'wilaya': wilaya,
          if (commune != null) 'commune': commune,
          if (street != null) 'street': street,
          if (notes != null) 'notes': notes,
          if (location != null) 'lat': location.latitude,
          if (location != null) 'lng': location.longitude,
          if (isDefault != null) 'isDefault': isDefault,
        },
        parse: (data) => Address.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<Address>> setDefault(String id) => _client.patch<Address>(
        Api.addressDefault(id),
        parse: (data) => Address.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> remove(String id) => _client.delete<void>(
        Api.address(id),
        parse: (_) {},
      );
}
