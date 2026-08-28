import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/money.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String nameAr,
    required String nameFr,
    required String iconKey,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
abstract class OpeningHour with _$OpeningHour {
  const factory OpeningHour({
    required int day,
    required String from,
    required String to,
  }) = _OpeningHour;

  factory OpeningHour.fromJson(Map<String, dynamic> json) => _$OpeningHourFromJson(json);
}

@freezed
abstract class Vendor with _$Vendor {
  const factory Vendor({
    required String id,
    required String name,
    @Default('') String slug,
    String? description,
    @RefIdConverter() String? category,
    ImageRef? logo,
    ImageRef? cover,
    @Default('') String phone,
    @Default('') String addressText,
    @GeoPointConverter() LatLng? location,
    @Default(0) double rating,
    @Default(0) int ratingCount,
    @Default(15) int prepTimeMin,
    @Default(30) int prepTimeMax,
    @MoneyConverter() @Default(Money.zero()) Money deliveryFeeCentimes,
    @MoneyConverter() @Default(Money.zero()) Money minOrderCentimes,
    @Default(true) bool isOpen,
    @Default(<OpeningHour>[]) List<OpeningHour> openingHours,
    @Default(false) bool isFeatured,
    @Default(true) bool isActive,
    double? distanceKm,
    int? etaMinutes,
    bool? isOpenNow,
  }) = _Vendor;

  const Vendor._();

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  /// Falls back to the raw flag when the API did not compute opening hours.
  bool get openNow => isOpenNow ?? isOpen;

  int get eta => etaMinutes ?? prepTimeMin;

  bool get hasRating => ratingCount > 0;
}

@freezed
abstract class MenuSection with _$MenuSection {
  const factory MenuSection({
    required String id,
    required String name,
    @Default(0) int sortOrder,
  }) = _MenuSection;

  factory MenuSection.fromJson(Map<String, dynamic> json) => _$MenuSectionFromJson(json);
}
