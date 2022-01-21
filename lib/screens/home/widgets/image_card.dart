import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/models/sound.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.sound,
    required this.onSlide,
    required this.onTap,
  }) : super(key: key);
  final Sound sound;
  final bool onSlide;
  final Function(Sound) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(sound),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: sound.title,
                child: Image(
                  image: AssetImage(sound.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      sound.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
