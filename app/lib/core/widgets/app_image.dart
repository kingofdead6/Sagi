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
  });

  final ImageRef? image;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final IconData fallbackIcon;
  final int transformWidth;

  @override
  Widget build(BuildContext context) {
    final child = image == null
        ? _fallback()
        : CachedNetworkImage(
            imageUrl: image!.cardUrl(transformWidth),
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: AppDurations.fast,
            placeholder: (context, url) => _Placeholder(blurUrl: image!.blurUrl, fit: fit),
            errorWidget: (context, url, error) => _fallback(),
          );

    if (radius == 0) return child;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
  }

  Widget _fallback() => SizedBox(
        width: width,
        height: height,
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
