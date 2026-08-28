import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// Swipe-to-confirm, used for every irreversible step of a delivery so a
/// pocket tap can never mark an order picked up or delivered.
class SwipeConfirm extends StatefulWidget {
  const SwipeConfirm({
    required this.label,
    required this.onConfirmed,
    super.key,
    this.color = AppColors.primaryGreen,
    this.enabled = true,
    this.isBusy = false,
  });

  final String label;
  final Future<void> Function() onConfirmed;
  final Color color;
  final bool enabled;
  final bool isBusy;

  @override
  State<SwipeConfirm> createState() => _SwipeConfirmState();
}

class _SwipeConfirmState extends State<SwipeConfirm> {
  static const _height = 60.0;
  static const _knob = 52.0;

  double _dragX = 0;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && !widget.isBusy;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - _knob - 8;
        final progress = maxDrag <= 0 ? 0.0 : (_dragX / maxDrag).clamp(0.0, 1.0);

        return Opacity(
          opacity: enabled ? 1 : 0.6,
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.stadium),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  widget.label,
                  style: AppText.bodyStrong.copyWith(
                    color: widget.color.withValues(alpha: 1 - progress * 0.6),
                  ),
                ),
                // RTL: the knob starts on the right and travels left.
                PositionedDirectional(
                  start: 4 + _dragX,
                  child: GestureDetector(
                    onHorizontalDragUpdate: enabled
                        ? (details) {
                            final direction =
                                Directionality.of(context) == TextDirection.rtl ? -1 : 1;
                            setState(() {
                              _dragX = (_dragX + details.delta.dx * direction)
                                  .clamp(0.0, maxDrag);
                            });
                          }
                        : null,
                    onHorizontalDragEnd: enabled
                        ? (_) async {
                            if (progress > 0.85) {
                              setState(() => _dragX = maxDrag);
                              await widget.onConfirmed();
                              if (mounted) setState(() => _dragX = 0);
                            } else {
                              setState(() => _dragX = 0);
                            }
                          }
                        : null,
                    child: Container(
                      width: _knob,
                      height: _knob,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.card,
                      ),
                      child: widget.isBusy
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.keyboard_double_arrow_left_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
