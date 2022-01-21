import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';

class PlayerNotifier extends ChangeNotifier {
  late Sound sound;
  late Duration duration;
  bool isPlaying = false;

  void setDuration(int duration) {
    this.duration = Duration(minutes: duration);
    notifyListeners();
  }

  void setSound(Sound sound) {
    this.sound = sound;
    notifyListeners();
  }

  void startPlayer() {
    isPlaying = true;
    notifyListeners();
  }

  void stopPlayer() {
    isPlaying = false;
    notifyListeners();
  }
}
