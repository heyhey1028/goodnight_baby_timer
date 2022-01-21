import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/screens/home/widgets/image_card.dart';
import 'package:goodnight_baby_timer/screens/timer/timer_screen.dart';

class SoundList extends StatefulWidget {
  const SoundList({Key? key, required this.soundLists}) : super(key: key);
  final List<Sound> soundLists;

  @override
  State<SoundList> createState() => _SoundListState();
}

class _SoundListState extends State<SoundList>
    with SingleTickerProviderStateMixin {
  bool _onSlide = false;
  late final AnimationController _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);
  late final Animation<double> _fadeAnimation =
      Tween(begin: 1.0, end: 0.3).animate(CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeIn,
  ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          if (scroll is ScrollStartNotification) {
            setState(() {
              _onSlide = true;
              _fadeController.forward();
            });
          }
          if (scroll is ScrollEndNotification) {
            setState(() {
              _onSlide = false;
              _fadeController.reverse();
            });
          }
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.soundLists.length,
          itemBuilder: (BuildContext context, int index) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ImageCard(
                sound: widget.soundLists[index],
                onSlide: _onSlide,
                onTap: (Sound sound) =>
                    _onTapSoundCard(context, widget.soundLists[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTapSoundCard(BuildContext context, Sound sound) {
    Navigator.push(context, _createRoute(sound));
  }

  Route _createRoute(Sound sound) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TimerScreen(sound: sound),
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
