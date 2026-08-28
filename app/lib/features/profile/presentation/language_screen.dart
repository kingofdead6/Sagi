import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/profile/presentation/settings_controller.dart';

/// Language picker. Selecting a language rebuilds the whole app through
/// `MaterialApp.locale`, which also flips text direction — Arabic is RTL while
/// French and English are LTR.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(localeControllerProvider);
    final controller = ref.read(localeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.profileLanguage, style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          Text(l10n.languageHint, style: AppText.meta),
          Gap.md,
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardBorder,
              boxShadow: AppShadows.card,
            ),
            child: RadioGroup<String>(
              groupValue: current.languageCode,
              onChanged: (code) {
                if (code != null) controller.select(AppLanguage.fromCode(code));
              },
              child: Column(
                children: [
                  for (final language in AppLanguage.values)
                    RadioListTile<String>(
                      value: language.code,
                      activeColor: AppColors.primaryGreen,
                      title: Text(language.label, style: AppText.body),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
