import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/result.dart';

/// A resolved place. `label` is null when reverse geocoding failed — Algerian
/// coverage is patchy, so every caller must survive that and let the user type
/// the address instead.
class PlaceLabel {
  const PlaceLabel({this.label, this.wilaya, this.commune, this.street});

  final String? label;
  final String? wilaya;
  final String? commune;
  final String? street;

  bool get isResolved => label != null && label!.isNotEmpty;
}

/// Geocoding lives behind this interface so the Nominatim implementation can be
/// swapped (or stubbed in tests) without touching any screen.
abstract interface class MapService {
  Future<Result<PlaceLabel>> reverseGeocode(LatLng point);

  Future<Result<List<({String label, LatLng point})>>> search(String query);

  /// Tile URL template for `flutter_map` — works on mobile and the web dashboard.
  String get tileUrlTemplate;

  String get attribution;
}

class NominatimMapService implements MapService {
  NominatimMapService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://nominatim.openstreetmap.org',
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
                // Nominatim requires an identifying User-Agent.
                headers: {'User-Agent': 'Saji/1.0 (delivery app; contact@saji.dz)'},
              ),
            );

  final Dio _dio;

  @override
  String get tileUrlTemplate => 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  String get attribution => '© OpenStreetMap';

  @override
  Future<Result<PlaceLabel>> reverseGeocode(LatLng point) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'jsonv2',
          'accept-language': 'ar',
          'zoom': 18,
        },
      );

      final data = response.data;
      final address = data?['address'] as Map<String, dynamic>?;
      if (address == null) return const Result.ok(PlaceLabel());

      return Result.ok(
        PlaceLabel(
          label: data?['display_name'] as String?,
          wilaya: (address['state'] ?? address['county']) as String?,
          commune: (address['city'] ?? address['town'] ?? address['village'] ?? address['suburb'])
              as String?,
          street: (address['road'] ?? address['neighbourhood']) as String?,
        ),
      );
    } on DioException {
      // Reverse geocoding failing is expected in Algeria — this is not an
      // error the user should see, they just type the address themselves.
      return const Result.ok(PlaceLabel());
    } catch (_) {
      return const Result.err(Failure(kind: FailureKind.unknown));
    }
  }

  @override
  Future<Result<List<({String label, LatLng point})>>> search(String query) async {
    if (query.trim().length < 3) return const Result.ok([]);
    try {
      final response = await _dio.get<List<dynamic>>(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'jsonv2',
          'accept-language': 'ar',
          'countrycodes': 'dz',
          'limit': 8,
        },
      );

      final results = (response.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((row) {
            final lat = double.tryParse('${row['lat']}');
            final lon = double.tryParse('${row['lon']}');
            if (lat == null || lon == null) return null;
            return (label: '${row['display_name']}', point: LatLng(lat, lon));
          })
          .whereType<({String label, LatLng point})>()
          .toList();

      return Result.ok(results);
    } on DioException {
      return const Result.err(Failure.network());
    }
  }
}
