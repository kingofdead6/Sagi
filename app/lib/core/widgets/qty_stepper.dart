import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// The − 1 + control used in the product sheet and the cart.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 1,
    this.max = 50,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 32.0 : 40.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.searchFill,
        borderRadius: BorderRadius.circular(AppRadius.stadium),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            size: size,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: compact ? 32 : 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: compact ? AppText.metaStrong : AppText.bodyStrong,
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            size: size,
            onTap: value < max ? () => onChanged(value + 1) : null,
            filled: true,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.size,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: filled && enabled ? AppColors.primaryGreen : AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.5,
            color: !enabled
                ? AppColors.textMuted
                : filled
                    ? Colors.white
                    : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
