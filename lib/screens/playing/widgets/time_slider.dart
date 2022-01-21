import 'package:flutter/material.dart';
import 'package:goodnight_baby_timer/screens/playing/playing_screen.dart';
import 'package:provider/provider.dart';

class TimeSlider extends StatefulWidget {
  const TimeSlider({
    Key? key,
  }) : super(key: key);

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  String startTime = '00:00:00';

  @override
  void initState() {
    context.read<PlayingScreenController>().sliderController.addListener(() {
      setState(() {
        startTime =
            context.read<PlayingScreenController>().currentDuration.hhmmss;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PlayingScreenController controller =
        context.read<PlayingScreenController>();
    final String endTime = controller.duration.hhmmss;

    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Slider.adaptive(
            label: 'LABEL',
            value:
                context.read<PlayingScreenController>().sliderController.value,
            onChanged: (double value) {
              controller.pausePlayer();
              controller.sliderController.value = value;
            },
          ),
          Row(
            children: <Widget>[
              Text(
                startTime,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Spacer(),
              Text(
                endTime,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension DurationEx on Duration {
  String get hhmmss => toString().split('.').first.padLeft(8, '0');
}
