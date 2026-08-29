import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';

/// One field in a [showTextInputDialog].
class TextInputSpec {
  const TextInputSpec({
    required this.name,
    required this.label,
    this.initialValue = '',
    this.hint,
    this.keyboardType,
    this.obscure = false,
    this.autofocus = false,
  });

  /// Key this field's text appears under in the returned map.
  final String name;
  final String label;
  final String initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final bool autofocus;
}

/// A dialog that collects one or more short text values.
///
/// The controllers live inside the dialog's own [State] and are disposed with
/// it, once the route is gone. Creating them in the caller and disposing them
/// as soon as `showDialog` returns is what trips framework's
/// `_dependents.isEmpty` assertion: the future completes when `pop` is called,
/// while the fields are still mounted for the duration of the exit animation
/// and still listening to the controller being disposed underneath them.
///
/// Returns the entered values keyed by [TextInputSpec.name], or null if the
/// dialog was dismissed.
Future<Map<String, String>?> showTextInputDialog({
  required BuildContext context,
  required String title,
  required List<TextInputSpec> fields,
  String? confirmLabel,
  bool danger = false,
  TextStyle? titleStyle,
  Color? backgroundColor,
  double? width,
}) {
  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => _TextInputDialog(
      title: title,
      fields: fields,
      confirmLabel: confirmLabel,
      danger: danger,
      titleStyle: titleStyle,
      backgroundColor: backgroundColor,
      width: width,
    ),
  );
}

/// Convenience wrapper for the common single-field case. Returns the trimmed
/// text, or null when dismissed (the empty string is possible and distinct).
Future<String?> showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  required String label,
  String initialValue = '',
  String? hint,
  String? confirmLabel,
  TextInputType? keyboardType,
  bool danger = false,
  TextStyle? titleStyle,
  Color? backgroundColor,
}) async {
  final values = await showTextInputDialog(
    context: context,
    title: title,
    confirmLabel: confirmLabel,
    danger: danger,
    titleStyle: titleStyle,
    backgroundColor: backgroundColor,
    fields: [
      TextInputSpec(
        name: 'value',
        label: label,
        initialValue: initialValue,
        hint: hint,
        keyboardType: keyboardType,
        autofocus: true,
      ),
    ],
  );
  return values?['value'];
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.fields,
    this.confirmLabel,
    this.danger = false,
    this.titleStyle,
    this.backgroundColor,
    this.width,
  });

  final String title;
  final List<TextInputSpec> fields;
  final String? confirmLabel;
  final bool danger;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final double? width;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final Map<String, TextEditingController> _controllers = {
    for (final field in widget.fields)
      field.name: TextEditingController(text: field.initialValue),
  };

  @override
  void dispose() {
    // Safe here, and only here: the route — and every field bound to these
    // controllers — is already gone by the time this runs.
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop({
      for (final entry in _controllers.entries) entry.key: entry.value.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final form = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final field in widget.fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: _controllers[field.name],
              autofocus: field.autofocus,
              obscureText: field.obscure,
              keyboardType: field.keyboardType,
              style: AppText.body,
              decoration: InputDecoration(labelText: field.label, hintText: field.hint),
              onSubmitted: widget.fields.length == 1 ? (_) => _submit() : null,
            ),
          ),
      ],
    );

    return AlertDialog(
      backgroundColor: widget.backgroundColor,
      title: Text(widget.title, style: widget.titleStyle ?? AppText.cardTitle),
      content: widget.width == null ? form : SizedBox(width: widget.width, child: form),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _submit,
          style: widget.danger
              ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
              : null,
          child: Text(widget.confirmLabel ?? l10n.commonSave),
        ),
      ],
    );
  }
}
