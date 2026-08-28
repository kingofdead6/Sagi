import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saji/core/models/converters.dart';
import 'package:saji/core/models/image_ref.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

enum OfferType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed')
  fixed,
  @JsonValue('freeDelivery')
  freeDelivery,
  @JsonValue('bundle')
  bundle;

  String get wire => switch (this) {
        OfferType.percentage => 'percentage',
        OfferType.fixed => 'fixed',
        OfferType.freeDelivery => 'freeDelivery',
        OfferType.bundle => 'bundle',
      };
}

@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String title,
    String? subtitle,
    @JsonKey(fromJson: _vendorName) String? vendorName,
    @RefIdConverter() String? vendor,
    ImageRef? image,
    @Default(OfferType.percentage) OfferType type,
    @Default(0) num value,
    @Default(<String>[]) List<String> productIds,
    @NullableDateConverter() DateTime? startsAt,
    @NullableDateConverter() DateTime? endsAt,
    @Default(true) bool isActive,
    @Default(false) bool showOnHome,
    @Default(0) int sortOrder,
  }) = _Offer;

  const Offer._();

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  bool get isPlatformWide => vendor == null;
}

String? _vendorName(Object? json) => json is Map ? json['name'] as String? : null;
