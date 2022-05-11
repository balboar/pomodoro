import 'package:flutter/material.dart';
import 'package:pomodoro/pomoTimer/pomoTimer.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PlayPauseButton extends StatefulWidget {
  final StopWatchTimer? timer;

  const PlayPauseButton(
    this.timer, {
    Key? key,
  }) : super(key: key);
  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  bool isRunning = false;
  late AnimationController _animationController;
  late Animation<Color?> _animateColor;
  late Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));

    widget.timer!.fetchEnded.listen((event) {
      if (event && isRunning) {
        stopTimer();
        isRunning = false;
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isRunning) {
      startTimer();
    } else {
      stopTimer();
    }
    isRunning = !isRunning;
  }

  void startTimer() {
    _animationController.forward();
    Provider.of<PomoTimer>(context, listen: false).start();
  }

  void stopTimer() {
    _animationController.reverse();
    Provider.of<PomoTimer>(context, listen: false).reset();
  }

  Widget toggle() {
    return FloatingActionButton.extended(
      backgroundColor: _animateColor.value,
      onPressed: animate,
      // label: Text('a'),
      label: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return toggle();
  }
}
