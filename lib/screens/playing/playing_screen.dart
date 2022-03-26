import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/notifiers/player_notifier.dart';
import 'package:goodnight_baby_timer/screens/home/home_screen.dart';
import 'package:goodnight_baby_timer/screens/playing/widgets/time_slider.dart';
import 'package:goodnight_baby_timer/widgets/app_body.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AppBody(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: controller.fadeAnimation,
              child: const Padding(
                padding: EdgeInsets.only(top: 160.0),
                child: TimeSlider(),
              ),
            ),
            FadeTransition(
              opacity: controller.fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FadeTransition(
                        opacity: controller.buttonFadeController,
                        child: FloatingActionButton(
                          heroTag: 'refresh',
                          onPressed: () => controller.resetPlayer(),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 36,
                          ),
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 3000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: !controller.isPaused
                            ? FloatingActionButton(
                                heroTag: 'pause',
                                onPressed: () => controller.pausePlayer(),
                                child: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white),
                                ),
                                backgroundColor: Colors.transparent,
                              )
                            : FloatingActionButton(
                                heroTag: 'play',
                                onPressed: () => controller.forwardPlayer(),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                      ),
                      FadeTransition(
                        opacity: controller.buttonFadeController,
                        child: FloatingActionButton(
                          heroTag: 'stop',
                          onPressed: () =>
                              Navigator.of(context).push(_createRoute()),
                          child: const Icon(
                            Icons.stop,
                            color: Colors.white,
                            size: 36,
                          ),
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
