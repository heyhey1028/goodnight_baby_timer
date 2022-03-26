import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/notifiers/player_notifier.dart';
import 'package:goodnight_baby_timer/screens/playing/playing_screen.dart';
import 'package:goodnight_baby_timer/widgets/app_body.dart';
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
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> minutes = getIntervalTime();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 36,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBody(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.sound.title,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.sound.imageURL),
                      fit: BoxFit.cover,
                      colorFilter:
                          const ColorFilter.mode(Colors.grey, BlendMode.darken),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ListWheelScrollView(
                physics: const BouncingScrollPhysics(),
                itemExtent: 100,
                diameterRatio: 0.8,
                magnification: 1.0,
                onSelectedItemChanged: (int index) =>
                    setState(() => _currentIndex = index),
                children: <Widget>[
                  for (int num in minutes) ...<Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      title: Text(
                        num.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _onTapPlayButton(
                      context,
                      sound: widget.sound,
                      duration: minutes[_currentIndex],
                    );
                  },
                  label: const Text(
                    'START',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: const StadiumBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent,
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
      // transitionDuration: Duration.zero,
    );
  }
}
