import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/money.dart';

/// Renders money consistently: "1350.0 د.ج", currency slightly de-emphasised.
class PriceText extends StatelessWidget {
  const PriceText(
    this.amount, {
    super.key,
    this.style,
    this.color,
    this.strikeThrough = false,
  });

  const PriceText.large(this.amount, {super.key, this.color})
      : style = null,
        strikeThrough = false;

  final Money amount;
  final TextStyle? style;
  final Color? color;
  final bool strikeThrough;

  @override
  Widget build(BuildContext context) {
    final base = (style ?? AppText.bodyStrong).copyWith(
      color: color ?? AppColors.textPrimary,
      decoration: strikeThrough ? TextDecoration.lineThrough : null,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: amount.formatAmount(), style: base),
          TextSpan(
            text: ' ${Money.symbol}',
            style: base.copyWith(
              fontSize: (base.fontSize ?? 16) * 0.75,
              fontWeight: FontWeight.w500,
              color: (color ?? AppColors.textPrimary).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
