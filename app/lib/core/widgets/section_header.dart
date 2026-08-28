import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';

/// "الأكثر شعبية بالقرب منك" + "عرض الكل" — 24px ExtraBold, tracking -0.6.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.onSeeAll, this.padding});

  final String title;
  final VoidCallback? onSeeAll;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppText.sectionTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(context.l10n.commonSeeAll, style: AppText.metaStrong.copyWith(
                color: AppColors.primaryGreen,
              )),
            ),
        ],
      ),
    );
  }
}
