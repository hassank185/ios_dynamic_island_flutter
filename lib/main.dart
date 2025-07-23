import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer with Dynamic Island',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({super.key});

  @override
  State<TimerHomePage> createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  static const platform = MethodChannel('com.test.liveactivity/timer');

  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;

  void startTimer(int seconds) {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _start = seconds;
      _isRunning = true;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isRunning = false;
          });
          _stopLiveActivity();
        } else {
          setState(() {
            _start--;
          });
          _updateLiveActivity(_start);
        }
      },
    );
    _startLiveActivity(_start);
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
    });
    _stopLiveActivity();
  }

  Future<void> _startLiveActivity(int duration) async {
    try {
      await platform.invokeMethod('startLiveActivity', {"duration": duration});
    } on PlatformException catch (e) {
      print("Failed to start live activity: '${e.message}'.");
    }
  }

  Future<void> _updateLiveActivity(int remainingTime) async {
    try {
      await platform.invokeMethod('updateLiveActivity', {"remainingTime": remainingTime});
    } on PlatformException catch (e) {
      print("Failed to update live activity: '${e.message}'.");
    }
  }

  Future<void> _stopLiveActivity() async {
    try {
      await platform.invokeMethod('stopLiveActivity');
    } on PlatformException catch (e) {
      print("Failed to stop live activity: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Island Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : () => startTimer(120), // 2 minutes
                  child: const Text('Start Timer (2 min)'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? stopTimer : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Stop Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
