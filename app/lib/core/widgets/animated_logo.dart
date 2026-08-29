import 'package:flutter/material.dart';
import 'package:saji/core/widgets/app_logo.dart';

/// The logo's entrance: a soft scale-and-fade in, then a slow breathing pulse
/// with a halo behind it while the app finishes loading.
///
/// Two controllers, driven in sequence: the entrance runs once, and hands off
/// to the breathing loop when it completes. Keeping them separate means the
/// pulse can be switched off without touching the entrance.
class AnimatedAppLogo extends StatefulWidget {
  const AnimatedAppLogo({
    super.key,
    this.size = 108,
    this.onWhiteCircle = true,
    this.full = false,
    this.pulse = true,
    this.haloColor = Colors.white,
  });

  final double size;
  final bool onWhiteCircle;

  /// Use the complete lockup rather than the roundel-and-wordmark mark.
  final bool full;

  /// Keep breathing after the entrance. Off for a one-shot reveal.
  final bool pulse;
  final Color haloColor;

  @override
  State<AnimatedAppLogo> createState() => _AnimatedAppLogoState();
}

class _AnimatedAppLogoState extends State<AnimatedAppLogo>
    with TickerProviderStateMixin {
  static const _entrance = Duration(milliseconds: 900);
  static const _breath = Duration(milliseconds: 2200);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _entrance,
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.55, curve: Curves.easeOut),
  );

  /// Overshoots slightly past 1 and settles — the logo lands rather than
  /// simply appearing at its final size.
  late final Animation<double> _scale = Tween<double>(begin: 0.72, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );

  late final Animation<double> _slide = Tween<double>(begin: 18, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _spin = Tween<double>(begin: -0.12, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );

  /// Drives the pulse once the entrance has finished.
  late final AnimationController _breathController = AnimationController(
    vsync: this,
    duration: _breath,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted && widget.pulse) _breathController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = widget.full
        ? AppLogo.full(size: widget.size, onWhiteCircle: widget.onWhiteCircle)
        : AppLogo.mark(size: widget.size, onWhiteCircle: widget.onWhiteCircle);

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _breathController]),
      builder: (context, child) {
        final breath = Curves.easeInOut.transform(_breathController.value);
        // The halo trails the logo slightly, so the two do not look welded.
        final haloScale = 1 + breath * 0.28;

        return Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: Transform.scale(
              scale: _scale.value * (1 + breath * 0.035),
              child: Transform.rotate(
                angle: _spin.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.pulse)
                      Opacity(
                        opacity: (1 - breath) * 0.18 * _fade.value,
                        child: Container(
                          width: widget.size * haloScale,
                          height: widget.size * haloScale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.haloColor,
                          ),
                        ),
                      ),
                    child!,
                  ],
                ),
              ),
            ),
          ),
        );
      },
      // Built once — the image itself never changes, only its transform.
      child: logo,
    );
  }
}
