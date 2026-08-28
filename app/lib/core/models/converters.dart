import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/money.dart';

/// Money crosses the wire as an integer number of centimes.
class MoneyConverter implements JsonConverter<Money, Object?> {
  const MoneyConverter();

  @override
  Money fromJson(Object? json) => Money.fromJson(json);

  @override
  Object toJson(Money object) => object.centimes;
}

/// GeoJSON `{type: 'Point', coordinates: [lng, lat]}` <-> LatLng.
class GeoPointConverter implements JsonConverter<LatLng?, Object?> {
  const GeoPointConverter();

  @override
  LatLng? fromJson(Object? json) {
    if (json is Map) {
      final coords = json['coordinates'];
      if (coords is List && coords.length == 2) {
        final lng = (coords[0] as num).toDouble();
        final lat = (coords[1] as num).toDouble();
        return LatLng(lat, lng);
      }
      // The API also returns plain {lat, lng} on some agent endpoints.
      final lat = json['lat'];
      final lng = json['lng'];
      if (lat is num && lng is num) return LatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }

  @override
  Object? toJson(LatLng? object) => object == null
      ? null
      : {
          'type': 'Point',
          'coordinates': [object.longitude, object.latitude],
        };
}

/// Mongo documents arrive either as an id string or as a populated object.
class RefIdConverter implements JsonConverter<String?, Object?> {
  const RefIdConverter();

  @override
  String? fromJson(Object? json) {
    if (json is String) return json;
    if (json is Map) return json['id'] as String?;
    return null;
  }

  @override
  Object? toJson(String? object) => object;
}

/// Tolerates the API sending a date as null, a string, or already-parsed.
class NullableDateConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json is String && json.isNotEmpty) return DateTime.tryParse(json)?.toLocal();
    if (json is DateTime) return json;
    return null;
  }

  @override
  Object? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

class DateConverter implements JsonConverter<DateTime, Object?> {
  const DateConverter();

  @override
  DateTime fromJson(Object? json) =>
      const NullableDateConverter().fromJson(json) ?? DateTime.fromMillisecondsSinceEpoch(0);

  @override
  Object toJson(DateTime object) => object.toUtc().toIso8601String();
}
