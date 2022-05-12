import 'package:flutter/material.dart';
import 'package:pomodoro/pomoTimer/pomoTimer.dart';
import 'package:pomodoro/ui/dot.dart';

import 'package:pomodoro/ui/play_pause_button.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => PomoTimer(), child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StopWatchTimer? _stopWatchTimer;
  @override
  void initState() {
    _stopWatchTimer =
        Provider.of<PomoTimer>(context, listen: false).stopWatchTimer;
    _stopWatchTimer!.setPresetMinuteTime(25);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.settings_rounded),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      floatingActionButton: PlayPauseButton(_stopWatchTimer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: StreamBuilder<int>(
              stream: _stopWatchTimer!.rawTime,
              initialData: 0,
              builder: (context, snap) {
                final value = snap.data!;
                final displayTime = StopWatchTimer.getDisplayTime(
                  value,
                  hours: false,
                  milliSecond: false,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    displayTime,
                    style: TextStyle(
                        fontSize: 60,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Consumer<PomoTimer>(builder: ((context, model, child) {
            var pomodoros = model.numberOfPomodoros;
            var breaks = model.numberOfBreaks;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PomoDot(pomodoros > 0, false),
                PomoDot(breaks > 0, true),
                PomoDot(pomodoros > 1, false),
                PomoDot(breaks > 1, true),
                PomoDot(pomodoros > 2, false),
                PomoDot(breaks > 2, true),
                PomoDot(pomodoros > 3, false),
              ],
            );
          })),
        ],
      ),
    );
  }
}
