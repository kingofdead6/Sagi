import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/auth/presentation/auth_form_fields.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref.read(authControllerProvider.notifier).register(
          phone: Phone.normalize(_phone.text)!,
          password: _password.text,
          fullName: _name.text.trim(),
        );

    if (!mounted) return;
    if (ok) {
      // A new customer needs a delivery address before they can order.
      context.go('${Routes.locationSetup}?onboarding=1');
      return;
    }

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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.authRegisterTitle, style: AppText.header),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _name,
                      enabled: !auth.isSubmitting,
                      style: AppText.body,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value == null || value.trim().length < 2) ? l10n.authInvalidName : null,
                      decoration: InputDecoration(
                        labelText: l10n.authFullName,
                        hintText: l10n.authFullNameHint,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textPlaceholder,
                        ),
                      ),
                    ),
                    Gap.lg,
                    PhoneField(controller: _phone, enabled: !auth.isSubmitting),
                    Gap.lg,
                    PasswordField(
                      controller: _password,
                      enabled: !auth.isSubmitting,
                      onSubmitted: _submit,
                    ),
                    Gap.xl,
                    PrimaryButton(
                      label: l10n.authRegister,
                      isLoading: auth.isSubmitting,
                      onPressed: _submit,
                    ),
                    Gap.lg,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.authHaveAccount, style: AppText.meta),
                        TextButton(
                          onPressed: auth.isSubmitting ? null : () => context.pop(),
                          child: Text(
                            l10n.authLogin,
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
