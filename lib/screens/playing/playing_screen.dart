import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/notifiers/player_notifier.dart';
import 'package:goodnight_baby_timer/screens/playing/widgets/time_slider.dart';
import 'package:provider/provider.dart';

class PlayingScreenController extends ChangeNotifier {
  PlayingScreenController({required this.duration});

  late final AnimationController sliderController;
  late final AnimationController fadeController;
  late final AnimationController playButtonController;
  late final AnimationController cancelButtonController;
  late final AnimationController refreshButtonController;
  late final AnimationController buttonFadeController;
  double playButtonScale = 1;
  double cancelButtonScale = 1;
  double refreshButtonScale = 1;
  final Duration duration;
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  late final Animation<double> fadeAnimation = CurvedAnimation(
    parent: fadeController,
    curve: Curves.easeIn,
  );

  Duration get currentDuration => duration * sliderController.value;

  void initialize(TickerProvider provider) {
    sliderController = AnimationController(vsync: provider, duration: duration);

    fadeController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 1000),
    )..forward().whenComplete(() => sliderController.forward());

    playButtonController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        playButtonScale = 1 - playButtonController.value;
        notifyListeners();
      });

    cancelButtonController = AnimationController(
        vsync: provider, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        cancelButtonScale = 1 - cancelButtonController.value;
        notifyListeners();
      });

    refreshButtonController = AnimationController(
        vsync: provider, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        refreshButtonScale = 1 - refreshButtonController.value;
        notifyListeners();
      });

    buttonFadeController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => notifyListeners());
  }

  void switchIsPaused() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void forwardPlayer() {
    sliderController.forward();
    buttonFadeController.reverse();
    _isPaused = false;
    notifyListeners();
  }

  void pausePlayer() {
    sliderController.stop();
    buttonFadeController.forward();
    _isPaused = true;
    notifyListeners();
  }

  void resetPlayer() {
    sliderController.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    sliderController.dispose();
    fadeController.dispose();
    playButtonController.dispose();
    cancelButtonController.dispose();
    refreshButtonController.dispose();
    buttonFadeController.dispose();
    super.dispose();
  }
}

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Duration duration = context.read<PlayerNotifier>().duration;

    return ChangeNotifierProvider(
      create: (_) => PlayingScreenController(duration: duration),
      child: const _PlayingScreen(),
    );
  }
}

class _PlayingScreen extends StatefulWidget {
  const _PlayingScreen({Key? key}) : super(key: key);

  @override
  _PlayingScreenState createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<_PlayingScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    context.read<PlayingScreenController>().initialize(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerNotifier player = context.read<PlayerNotifier>();
    final PlayingScreenController controller =
        context.watch<PlayingScreenController>();
    final Sound sound = player.sound;
    print('rebuild!');

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: FadeTransition(
          opacity: controller.fadeAnimation,
          child: IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            iconSize: 40,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: sound.title,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Image(
                colorBlendMode: BlendMode.overlay,
                color: Colors.grey.withOpacity(0.4),
                image: AssetImage(sound.imageURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FadeTransition(
            opacity: controller.fadeAnimation,
            child: const Align(
              alignment: Alignment.center,
              child: TimeSlider(),
            ),
          ),
          FadeTransition(
            opacity: controller.fadeAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: controller.buttonFadeController,
                      child: GestureDetector(
                        onTapUp: (_) =>
                            controller.cancelButtonController.reverse(),
                        onTapDown: (_) =>
                            controller.cancelButtonController.forward(),
                        onTap: () {
                          print('clear pressed');
                        },
                        child: Transform.scale(
                          scale: controller.cancelButtonScale,
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: !controller.isPaused
                          ? GestureDetector(
                              onTapUp: (_) =>
                                  controller.playButtonController.reverse(),
                              onTapDown: (_) =>
                                  controller.playButtonController.forward(),
                              onTap: () => controller.pausePlayer(),
                              child: Transform.scale(
                                scale: controller.playButtonScale,
                                child: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTapUp: (_) =>
                                  controller.playButtonController.reverse(),
                              onTapDown: (_) =>
                                  controller.playButtonController.forward(),
                              onTap: () => controller.forwardPlayer(),
                              child: Transform.scale(
                                scale: controller.playButtonScale,
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                            ),
                    ),
                    FadeTransition(
                      opacity: controller.buttonFadeController,
                      child: GestureDetector(
                        onTapUp: (_) =>
                            controller.refreshButtonController.reverse(),
                        onTapDown: (_) =>
                            controller.refreshButtonController.forward(),
                        onTap: () => controller.resetPlayer(),
                        child: Transform.scale(
                          scale: controller.refreshButtonScale,
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
