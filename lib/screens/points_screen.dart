import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/pointsprovider.dart';
import '../provider/userauth.dart';

class PointsScreen extends StatefulWidget {
  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  int _points = 0;
  bool _isTimerRunning = false;
  Timer? _timer;
  int _timerDuration = 15 * 60; // 15 minutes in seconds
  RewardedAd? _rewardedAd;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';
  String? streamuserid;
  Map<String, int> _dailyPoints = {};
  int sumOfLastSixDays = 0;
  Stream<int>? totalPointsStream; // Changed to nullable to set it later
  List<DateTime> datesToDisplay = [];

  List<Stream<int>> dailyPointsStreams = [];

  @override
  void initState() {
    _createRewardedAd();
    super.initState();
    _fetchDailyPointsData();

    // Fetch the current user ID from UserProvider
    String? userId = context.read<UserProvider>().userId;
    streamuserid = userId; // Set streamuserid here

    // Initialize totalPointsStream if streamuserid is not null
    if (streamuserid != null) {
      totalPointsStream =
          context.read<PointsProvider>().streamTotalPoints(streamuserid!);

      // Call fetchPoints with the user ID
      context.read<PointsProvider>().fetchTotalPoints(userId!);

      // Create dailyPointsStreams for each date
      for (int i = 0; i < 6; i++) {
        DateTime date = DateTime.now().subtract(Duration(days: i));
        dailyPointsStreams.add(
            context.read<PointsProvider>().streamDailyPoints(streamuserid!, date));
        datesToDisplay.add(date);
      }
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> _fetchDailyPointsData() async {
    String? userId = context.read<UserProvider>().userId;
    for (int index = 0; index < 6; index++) {
      DateTime currentDate = DateTime.now().subtract(Duration(days: index + 1));
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Fetch daily points for the current date and store them in _dailyPoints
      int points = await context
          .read<PointsProvider>()
          .fetchDailyPoints(userId!, currentDate);

      setState(() {
        _dailyPoints[formattedDate] = points;
        sumOfLastSixDays += points;
      });
    }
  }

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

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd();
      });
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          final pointsProvider = context.read<PointsProvider>();
          String? userId = context.read<UserProvider>().userId;
          pointsProvider.updatePoints(userId!, 40);

          setState(() {
            _points += 40;
          });
        });
      _rewardedAd = null;
    }
  }

  String _formatDuration(int duration) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: const Center(
          child: Text(
            'Points',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          StreamBuilder<int>(
            stream: totalPointsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  '${snapshot.data}',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Last Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '$sumOfLastSixDays',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: datesToDisplay.length,
              itemBuilder: (context, index) {
                DateTime date = datesToDisplay[index];
                final pointsProvider = context.read<PointsProvider>();
                // Replace with the user's ID
                final dailyPointsStream = dailyPointsStreams[index];

                return StreamBuilder(
                  stream: dailyPointsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(DateFormat('yyyy-MM-dd').format(date)),
                        trailing: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text(DateFormat('yyyy-MM-dd').format(date)),
                        trailing: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      int points = snapshot.data ?? 0;
                      print("object .. \n ll $snapshot");
                      return ListTile(
                        title: Text(DateFormat('yyyy-MM-dd').format(date)),
                        trailing: Text('$points'),
                      );
                    }
                  },
                );
              },
            ),
          ),
          _isTimerRunning
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Wait until Times complete ${_formatDuration(_timerDuration)}')));
                  },
                  child:
                      Text('Next ad after: ${_formatDuration(_timerDuration)}'),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      _showRewardedAd();
                      _timerDuration = 15 * 60;
                      _startTimer();
                    });
                  },
                  child: Text('Get 40 Points - Watch Ad'),
                ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    // Implement your own date formatting logic here
    // Example: 'May 28, 2023'
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    // Implement a mapping from month number to month name
    // Example: 1 -> 'January', 2 -> 'February', etc.
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
