import 'dart:async';
import 'package:sprintf/sprintf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

enum TimerStatus { running, paused, stopped, resting }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const WORK_SECONDS = 10;
  static const REST_SECONDS = 5;

  late TimerStatus _timerStatus;
  late int _timer;
  late int _pomodoroCount;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = WORK_SECONDS;
    _timerStatus = TimerStatus.stopped;
    _pomodoroCount = 0;
  }

  void run() {
    setState(() {
      _timerStatus = TimerStatus.running;
      runTimer();
    });
  }

  void pause() {
    setState(() {
      _timerStatus = TimerStatus.paused;
    });
  }

  void resume() {
    run();
  }

  void rest() {
    setState(() {
      _timerStatus = TimerStatus.resting;
      _timer = REST_SECONDS;
    });
  }

  void stop() {
    setState(() {
      _timerStatus = TimerStatus.stopped;
      _timer = WORK_SECONDS;
    });
  }

  void runTimer() async {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      switch (_timerStatus) {
        case TimerStatus.paused:
          t.cancel();
          break;
        case TimerStatus.stopped:
          t.cancel();
          break;
        case TimerStatus.running:
          if (_timer <= 0) {
            rest();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        case TimerStatus.resting:
          if (_timer <= 0) {
            setState(() {
              _pomodoroCount += 1;
              showToast("오늘 $_pomodoroCount개의 뽀모도로를 달성했습니다!");
            });

            t.cancel();
            stop();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        default:
          break;
      }
    });
  }

  String timerToString(int timer) {
    return sprintf("%02d:%02d", [_timer ~/ 60, _timer % 60]);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> runningButtons = [
      ElevatedButton(
        onPressed: _timerStatus == TimerStatus.paused ? resume : pause,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: Text(
          _timerStatus == TimerStatus.paused ? '계속하기' : '일시정지',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(
        onPressed: stop,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: const Text(
          '포기하기',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ];

    final List<Widget> stoppedButtons = [
      ElevatedButton(
        onPressed: run,
        style: ElevatedButton.styleFrom(
            backgroundColor: _timerStatus == TimerStatus.resting
                ? Colors.green
                : Colors.blue),
        child: const Text(
          '시작하기',
          style: TextStyle(fontSize: 16),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('뽀모도로 타이머 앱'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _timerStatus == TimerStatus.resting
                  ? Colors.green
                  : Colors.blue,
            ),
            child: Center(
              child: Text(timerToString(_timer),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _timerStatus == TimerStatus.resting
                ? const []
                : _timerStatus == TimerStatus.stopped
                    ? stoppedButtons
                    : runningButtons,
          )
        ],
      ),
    );
  }
}
