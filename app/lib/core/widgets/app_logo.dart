import 'package:flutter/material.dart';
import 'package:saji/app/theme/tokens.dart';

/// The Saji logo.
///
/// Two assets exist because the full lockup carries a tagline and a strip of
/// category icons that turn to mush below roughly 120px — [AppLogo.mark] uses
/// the roundel and wordmark alone, [AppLogo.full] the complete lockup.
class AppLogo extends StatelessWidget {
  const AppLogo.mark({super.key, this.size = 96, this.onWhiteCircle = false})
      : _asset = 'assets/images/logo_mark.png';

  const AppLogo.full({super.key, this.size = 220, this.onWhiteCircle = false})
      : _asset = 'assets/images/logo_full.png';

  final String _asset;
  final double size;

  /// The artwork is drawn on white, so on a coloured background it needs a
  /// white disc behind it rather than sitting on the colour directly.
  final bool onWhiteCircle;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      _asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      // A missing asset should not take the screen down with it.
      errorBuilder: (context, error, stack) => Icon(
        Icons.delivery_dining_rounded,
        size: size * 0.55,
        color: AppColors.primaryGreen,
      ),
    );

    if (!onWhiteCircle) return image;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.all(size * 0.06),
      child: image,
    );
  }
}
