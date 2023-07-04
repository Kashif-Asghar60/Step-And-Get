import 'dart:async';

import 'package:flutter/material.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  int _points = 0;
  bool _isTimerRunning = false;
  Timer? _timer;
  int _timerDuration = 15 * 60; // 15 minutes in seconds

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    setState(() {
      _isTimerRunning = true;
      _timer = Timer.periodic(oneSec, (timer) {
        if (_timerDuration <= 0) {
          timer.cancel();
          _onTimerComplete();
        } else {
          setState(() {
            _timerDuration--;
          });
        }
      });
    });
  }

  void _onTimerComplete() {
    setState(() {
      _isTimerRunning = false;
      _timer?.cancel();
      _timer = null;
    });
  }

  void _watchAds() {
    setState(() {
      _points += 20;
      _timerDuration = 15 * 60; // Reset the timer duration
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int duration) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Points: $_points',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _isTimerRunning
                ? ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Wait until Times complete ${_formatDuration(_timerDuration)}')));
                    },
                    child: Text(
                        'Next ad after: ${_formatDuration(_timerDuration)}'),
                  )
                : ElevatedButton(
                    onPressed: _watchAds,
                    child: Text('Watch Ads'),
                  ),
          ],
        ),
      ),
    );
  }
}
