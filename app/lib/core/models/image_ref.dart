import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_ref.freezed.dart';
part 'image_ref.g.dart';

/// A Cloudinary asset. `publicId` is required so a replace can delete the old
/// file rather than leaking it.
@freezed
abstract class ImageRef with _$ImageRef {
  const factory ImageRef({
    required String url,
    required String publicId,
    int? width,
    int? height,
  }) = _ImageRef;

  const ImageRef._();

  factory ImageRef.fromJson(Map<String, dynamic> json) => _$ImageRefFromJson(json);

  /// Transformed delivery URL for cards — `f_auto,q_auto,w_684`.
  String cardUrl([int width = 684]) =>
      url.replaceFirst('/upload/', '/upload/f_auto,q_auto,w_$width/');

  /// A tiny blurred version shown while the real image loads.
  String get blurUrl => url.replaceFirst('/upload/', '/upload/e_blur:1000,f_auto,q_auto,w_24/');
}
