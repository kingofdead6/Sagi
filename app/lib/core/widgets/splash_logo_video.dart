import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// The splash entrance: the animated logo video, looping while the app
/// restores the session. Fades in once the first frame is ready so there is
/// no flash of an empty box while the video initializes.
class SplashLogoVideo extends StatefulWidget {
  const SplashLogoVideo({super.key, this.size = 160});

  final double size;

  @override
  State<SplashLogoVideo> createState() => _SplashLogoVideoState();
}

class _SplashLogoVideoState extends State<SplashLogoVideo> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/HomeLogo.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _controller.value.isInitialized;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedOpacity(
        opacity: ready ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: ready
            ? FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : null,
      ),
    );
  }
}
