import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';
import 'package:goodnight_baby_timer/screens/home/widgets/sound_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD NIGHT BABY TIMER'),
      ),
      body: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage('assets/gifs/goodnight.gif'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          SoundList(soundLists: createSounds()),
        ],
      ),
    );
  }

  List<Sound> createSounds() {
    return [
      Sound(
          title: 'WHITE NOISE',
          imageURL: 'assets/images/whitenoise.jpeg',
          soundFile: ''),
      Sound(
          title: 'WOMB',
          imageURL: 'assets/images/womb.jpeg',
          soundFile: 'soundFile'),
      Sound(
          title: 'DRYER',
          imageURL: 'assets/images/dryer.jpeg',
          soundFile: 'soundFile'),
      Sound(
          title: 'CLASSIC',
          imageURL: 'assets/images/classic.jpeg',
          soundFile: 'soundFile'),
      Sound(
          title: 'MUSICBOX',
          imageURL: 'assets/images/musicbox.jpeg',
          soundFile: 'soundFile'),
      Sound(
          title: 'WAVES',
          imageURL: 'assets/images/waves.jpeg',
          soundFile: 'soundFile'),
    ];
  }
}
