import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/animated_logo.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';

/// Restores the stored session before the router decides where to go.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.primaryGreenDeep,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimatedAppLogo(size: 108),
            Gap.xl,
            // The wordmark and tagline follow the logo in rather than landing
            // with it, so the eye reaches the name after the mark has settled.
            _FadeInUp(
              delay: const Duration(milliseconds: 450),
              child: Text(
                l10n.appName,
                style: AppText.sectionTitle.copyWith(color: Colors.white, fontSize: 34),
              ),
            ),
            Gap.xs,
            _FadeInUp(
              delay: const Duration(milliseconds: 650),
              child: Text(
                l10n.welcomeSubtitle,
                style: AppText.body.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            Gap.xxl,
            _FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fades a child in and lifts it a few pixels, after [delay]. Used to stagger
/// the splash contents behind the logo.
class _FadeInUp extends StatefulWidget {
  const _FadeInUp({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.35), end: Offset.zero).animate(curved),
        child: widget.child,
      ),
    );
  }
}
