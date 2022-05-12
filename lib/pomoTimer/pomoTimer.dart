import 'package:flutter/material.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum PomoState { running, shortBreak, longBreak, stopped }

class PomoTimer extends ChangeNotifier {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: () async {
        var hasPermission = await QuickNotify.hasPermission();
        if (!hasPermission) await QuickNotify.requestPermission();
        QuickNotify.notify(
          title: 'Pomodoro',
          content: 'Pomodoro terminaldo',
        );
      });

  PomoState _state = PomoState.running;
  int workTime = 25;
  int shortBreakTime = 5;
  int longBreakTime = 5;
  int numberOfPomodoros = 0;
  int numberOfBreaks = 0;

  PomoState get state => _state;

  StopWatchTimer get stopWatchTimer => _stopWatchTimer;

  void start() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    if (numberOfBreaks == 4) numberOfBreaks = 0;
    if (numberOfPomodoros == 4) numberOfPomodoros = 0;
  }

  void stop() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  void reset() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.clearPresetTime();
    print(_state);
    switch (_state) {
      case PomoState.running:
        if (numberOfBreaks < 3) {
          _stopWatchTimer.setPresetMinuteTime(shortBreakTime);
          _state = PomoState.shortBreak;
        } else {
          _stopWatchTimer.setPresetMinuteTime(longBreakTime);
          _state = PomoState.longBreak;
        }
        numberOfPomodoros++;

        break;
      case PomoState.longBreak:
        _stopWatchTimer.setPresetMinuteTime(workTime);

        _state = PomoState.running;
        numberOfBreaks++;
        break;
      case PomoState.shortBreak:
        _stopWatchTimer.setPresetMinuteTime(workTime);
        _state = PomoState.running;
        numberOfBreaks++;
        break;
      case PomoState.stopped:
        break;
    }
    notifyListeners();
  }
}
