import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/notifiers/player_notifier.dart';
import 'package:goodnight_baby_timer/screens/playing/playing_screen.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({
    Key? key,
    required this.sound,
  }) : super(key: key);

  final Sound sound;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _fadeController =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..forward();

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeIn,
  );

  late final AnimationController _buttonController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> minutes = getIntervalTime();
    double _scale = 1 - _buttonController.value;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: FadeTransition(
          opacity: _fadeAnimation,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 36,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.sound.title,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image(
                  colorBlendMode: BlendMode.overlay,
                  color: Colors.grey.withOpacity(0.4),
                  image: AssetImage(widget.sound.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 140,
                  backgroundColor: Colors.white60,
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ListWheelScrollView(
                  physics: const BouncingScrollPhysics(),
                  itemExtent: 100,
                  diameterRatio: 0.6,
                  useMagnifier: true,
                  magnification: 1.0,
                  overAndUnderCenterOpacity: 0.3,
                  onSelectedItemChanged: (int index) =>
                      setState(() => _currentIndex = index),
                  children: <Widget>[
                    for (int num in minutes) ...<Widget>[
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        title: Text(
                          num.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: GestureDetector(
                    onTapUp: (_) => _buttonController.reverse(),
                    onTapDown: (_) => _buttonController.forward(),
                    onTap: () {
                      _fadeController.reverse();
                      _onTapPlayButton(
                        context,
                        sound: widget.sound,
                        duration: minutes[_currentIndex],
                      );
                    },
                    child: Transform.scale(
                      scale: _scale,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> getIntervalTime() {
    return <int>[
      5,
      10,
      15,
      20,
      30,
      45,
      60,
      90,
      120,
      180,
      360,
    ];
  }

  void _onTapPlayButton(
    BuildContext context, {
    required Sound sound,
    required int duration,
  }) {
    context.read<PlayerNotifier>()
      ..setSound(sound)
      ..setDuration(duration);
    Navigator.push(context, _createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => const PlayingScreen(),
      transitionDuration: Duration.zero,
    );
  }
}
