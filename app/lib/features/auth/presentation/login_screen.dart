import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/animated_logo.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/auth/presentation/auth_form_fields.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref.read(authControllerProvider.notifier).login(
          phone: Phone.normalize(_phone.text)!,
          password: _password.text,
        );

    if (!mounted || ok) return;
    final failure = ref.read(authControllerProvider).failure;
    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH,
              vertical: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      // Entrance only — this is not a loading state, so the
                      // logo settles and stays put.
                      child: AnimatedAppLogo(
                        size: 132,
                        onWhiteCircle: false,
                        pulse: false,
                      ),
                    ),
                    Gap.xl,
                    Text(l10n.welcomeTitle, style: AppText.sectionTitle, textAlign: TextAlign.center),
                    Gap.xs,
                    Text(
                      l10n.welcomeSubtitle,
                      style: AppText.meta,
                      textAlign: TextAlign.center,
                    ),
                    Gap.xxl,
                    PhoneField(controller: _phone, enabled: !auth.isSubmitting),
                    Gap.lg,
                    PasswordField(
                      controller: _password,
                      enabled: !auth.isSubmitting,
                      validateStrength: false,
                      onSubmitted: _submit,
                    ),
                    Gap.xl,
                    PrimaryButton(
                      label: l10n.authLogin,
                      isLoading: auth.isSubmitting,
                      onPressed: _submit,
                    ),
                    Gap.lg,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.authNoAccount, style: AppText.meta),
                        TextButton(
                          onPressed: auth.isSubmitting ? null : () => context.push(Routes.register),
                          child: Text(
                            l10n.authRegister,
                            style: AppText.metaStrong.copyWith(color: AppColors.primaryGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
