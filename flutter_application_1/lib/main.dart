import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerScreen(
        name: 'Dinda Rachma Ayu Mauliza',
        nim: '222410102056',
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  final String name;
  final String nim;

  TimerScreen({required this.name, required this.nim});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  double _seconds = 0;
  double _durationInMinutes = 0;
  bool _isActive = false;
  late Timer _timer;
  late int _remainingSeconds;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Timer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Name: ${widget.name}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'NIM: ${widget.nim}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ],
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget> [
                  Text(
                    _seconds > 0
                        ? '${(_seconds ~/ 60).toInt()} menit ${(_seconds % 60).toInt()} detik'
                        : _isActive
                            ? 'Times up!'
                            : 'Enter Time (minutes)',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Type Here!',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _durationInMinutes = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _isActive
                            ? _pauseTimer
                            : _seconds == 0
                                ? _startTimer
                                : _resumeTimer,
                        child: Text(
                          _isActive ? 'Pause' : _seconds == 0 ? 'Start' : 'Resume',
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _startTimer() {
    setState(() {
      _seconds = _durationInMinutes * 60;
      _isActive = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          _isActive = false;
        }
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      setState(() {
        _isActive = false;
        _remainingSeconds = _seconds.toInt();
      });
    }
  }

  void _stopTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      setState(() {
        _isActive = false;
      });
    }
  }

  void _resumeTimer() {
    if (_timer != null && !_timer.isActive) {
      setState(() {
        _isActive = true;
        _seconds = _remainingSeconds.toDouble();
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _timer.cancel();
            _isActive = false;
          }
        });
      });
    }
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {
      _seconds = 0;
      _isActive = false;
    });
  }

  String get _remainingTime {
    return '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';
  }
}
