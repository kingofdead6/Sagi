import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/widgets/primary_button.dart';

/// The OTP screen is built but disabled at v1 (`OTP_ENABLED=false`): Algerian
/// SMS delivery is unreliable and the admin phones every customer anyway.
/// Enabling the server flag is all this screen needs to go live.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.phone});

  final String? phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.authOtpTitle, style: AppText.header),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.authOtpTitle, style: AppText.sectionTitle, textAlign: TextAlign.center),
                  Gap.sm,
                  Text(
                    l10n.authOtpSubtitle(Phone.pretty(widget.phone ?? '')),
                    style: AppText.meta,
                    textAlign: TextAlign.center,
                  ),
                  Gap.xl,
                  TextField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppText.sectionTitle.copyWith(letterSpacing: 12),
                    decoration: const InputDecoration(counterText: ''),
                  ),
                  Gap.lg,
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: AppRadius.mediumBorder,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.warning),
                        Gap.wMd,
                        Expanded(child: Text(l10n.authOtpDisabled, style: AppText.meta)),
                      ],
                    ),
                  ),
                  Gap.xl,
                  PrimaryButton(label: l10n.commonConfirm, onPressed: null),
                  Gap.md,
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.commonBack, style: AppText.metaStrong),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
