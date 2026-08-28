import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/phone.dart';

/// The phone field, shared by login and register: numeric keyboard, LTR digits
/// inside an RTL layout, and the one validator both screens use.
class PhoneField extends StatelessWidget {
  const PhoneField({required this.controller, super.key, this.enabled = true, this.onSubmitted});

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback? onSubmitted;

  static String? validate(BuildContext context, String? value) =>
      Phone.isValid(value) ? null : context.l10n.authInvalidPhone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d+\s]')),
        LengthLimitingTextInputFormatter(14),
      ],
      style: AppText.body,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      validator: (value) => validate(context, value),
      decoration: InputDecoration(
        labelText: l10n.authPhone,
        hintText: l10n.authPhoneHint,
        hintTextDirection: TextDirection.ltr,
        prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.textPlaceholder),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    super.key,
    this.label,
    this.enabled = true,
    this.validateStrength = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final bool enabled;
  final bool validateStrength;
  final VoidCallback? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscured,
      style: AppText.body,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n.authInvalidPassword;
        if (widget.validateStrength && value.length < 6) return l10n.authInvalidPassword;
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.label ?? l10n.authPassword,
        hintText: widget.validateStrength ? l10n.authPasswordHint : null,
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textPlaceholder),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscured = !_obscured),
          icon: Icon(
            _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textPlaceholder,
          ),
        ),
      ),
    );
  }
}
