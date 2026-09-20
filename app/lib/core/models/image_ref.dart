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
  ///
  /// Width-only: the height follows whatever the source happens to be, so two
  /// of these side by side are two different shapes. Use [uniformUrl] wherever
  /// images are shown together.
  String cardUrl([int width = 684]) =>
      url.replaceFirst('/upload/', '/upload/f_auto,q_auto,w_$width/');

  /// A delivery URL cropped to an exact [width] x [height] box.
  ///
  /// Cloudinary does the cropping, so every image arrives at the same size no
  /// matter what the shop uploaded — portrait photos, screenshots and wide
  /// shots all come back as one shape and line up in a grid.
  ///
  /// `c_fill` fills the box and trims the overflow rather than squashing the
  /// picture, and `g_auto` picks the crop window around whatever the subject
  /// is, so the food stays in frame instead of being cut down the middle.
  String uniformUrl({required int width, required int height}) => url.replaceFirst(
        '/upload/',
        '/upload/c_fill,g_auto,f_auto,q_auto,w_$width,h_$height/',
      );

  /// A tiny blurred version shown while the real image loads.
  String get blurUrl => url.replaceFirst('/upload/', '/upload/e_blur:1000,f_auto,q_auto,w_24/');
}
