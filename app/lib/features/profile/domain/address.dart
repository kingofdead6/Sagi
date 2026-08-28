import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/converters.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    @Default('المنزل') String label,
    @Default('') String wilaya,
    @Default('') String commune,
    @Default('') String street,
    String? notes,
    @GeoPointConverter() LatLng? location,
    @Default(false) bool isDefault,
  }) = _Address;

  const Address._();

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  String get oneLine => [street, commune, wilaya].where((p) => p.isNotEmpty).join('، ');
}
