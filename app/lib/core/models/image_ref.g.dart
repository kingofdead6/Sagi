// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageRef _$ImageRefFromJson(Map<String, dynamic> json) => _ImageRef(
  url: json['url'] as String,
  publicId: json['publicId'] as String,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImageRefToJson(_ImageRef instance) => <String, dynamic>{
  'url': instance.url,
  'publicId': instance.publicId,
  'width': instance.width,
  'height': instance.height,
};
