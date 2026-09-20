import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/models/image_ref.dart';

/// Every remote image in the app: transformed Cloudinary URL, blur placeholder
/// while it loads, and a graceful fallback when there is no image at all.
class AppImage extends StatelessWidget {
  const AppImage({
    required this.image,
    super.key,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.storefront_rounded,
    this.transformWidth = 684,
    this.aspectRatio,
    this.applyAspectRatioToLayout = true,
  });

  final ImageRef? image;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final IconData fallbackIcon;
  final int transformWidth;

  /// Width / height. When set, the image is cropped by Cloudinary to exactly
  /// this shape, so a row or grid of them is uniform regardless of what was
  /// uploaded.
  final double? aspectRatio;

  /// Whether to also reserve a box of [aspectRatio] in the layout, so the
  /// slot holds its shape before the image loads and when there is none.
  ///
  /// Turn this off where the parent already dictates the size — a
  /// `StackFit.expand` stack or a fixed-height header — since sizing it here
  /// too would fight that parent.
  final bool applyAspectRatioToLayout;

  @override
  Widget build(BuildContext context) {
    final ratio = aspectRatio;

    final resolvedUrl = image == null
        ? null
        : ratio == null
            ? image!.cardUrl(transformWidth)
            : image!.uniformUrl(
                width: transformWidth,
                height: (transformWidth / ratio).round(),
              );

    var child = resolvedUrl == null
        ? _fallback()
        : _networkImage(resolvedUrl);

    if (radius != 0) {
      child = ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
    }

    // Hold the shape even while loading or when there is no image at all, so
    // an item without a photo still lines up with the ones that have one.
    if (ratio != null && height == null && applyAspectRatioToLayout) {
      child = AspectRatio(aspectRatio: ratio, child: child);
    }

    return child;
  }

  Widget _networkImage(String url) => CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: AppDurations.fast,
        placeholder: (context, _) => _Placeholder(blurUrl: image!.blurUrl, fit: fit),
        errorWidget: (context, _, error) => _fallback(),
      );

  Widget _fallback() => SizedBox(
        width: width,
        // When the AspectRatio wrapper is in play it sets the height; forcing
        // it here too would fight that and over-constrain the box.
        height: (aspectRatio != null && applyAspectRatioToLayout) ? null : height,
        child: ColoredBox(
          color: AppColors.searchFill,
          child: Center(
            child: Icon(fallbackIcon, color: AppColors.textMuted, size: 32),
          ),
        ),
      );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.blurUrl, required this.fit});

  final String blurUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.searchFill,
      child: CachedNetworkImage(
        imageUrl: blurUrl,
        fit: fit,
        errorWidget: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
