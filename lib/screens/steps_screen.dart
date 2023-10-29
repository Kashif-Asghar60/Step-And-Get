import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/pointsprovider.dart';
import '../provider/userauth.dart';

class StepsScreen extends StatefulWidget {
  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> with WidgetsBindingObserver {
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  int targetSteps = 10000;
  bool isTracking = false;

  final numberFormatter = NumberFormat('#,###');

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0';

  Timer? _resetStepsTimer;

  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  @override
  void dispose() {
    _textEditingController.dispose();
    _resetStepsTimer?.cancel();
    WidgetsBinding.instance!.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _setupResetStepsTimer();

    // Retrieve the tracking state from SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      bool savedTrackingState = prefs.getBool('isTracking') ?? false;
      // Retrieve the target steps from SharedPreferences and initialize _steps
      targetSteps = prefs.getInt('targetSteps') ?? 10000;
      _updateStepsFromSharedPrefs(prefs);
      setState(() {
        isTracking = savedTrackingState;
      });

      // Retrieve and set the step count from SharedPreferences
      int savedSteps = prefs.getInt('steps') ?? 0;
      setState(() {
        _steps = savedSteps.toString();
      });

      // Only update the UI when the tracking state is retrieved
      _updateUIFromTrackingState();
    });

    // Add an app lifecycle state observer
    WidgetsBinding.instance!.addObserver(this);
  }

  void _updateStepsFromSharedPrefs(SharedPreferences prefs) {
    int savedSteps = prefs.getInt('steps') ?? 0;
    setState(() {
      _steps = savedSteps.toString();
    });
  }

  void _updateUIFromTrackingState() {
    if (isTracking) {
      // If tracking is active, set the UI to "Stop Tracking"
      setState(() {});
    } else {
      // If tracking is not active, set the UI to "Start Tracking"
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has resumed from the background
      SharedPreferences.getInstance().then((prefs) {
        bool savedTrackingState = prefs.getBool('isTracking') ?? false;
        setState(() {
          isTracking = savedTrackingState;
          _updateUIFromTrackingState(); // Update the UI
        });
      });
    }
  }

  void _setupResetStepsTimer() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight =
        midnight.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

    _resetStepsTimer = Timer(Duration(milliseconds: timeUntilMidnight), () {
      setState(() {
        _steps = '0';
      });
      _setupResetStepsTimer();
    });
  }

  bool pointsAddedToday = false;

void onStepCount(StepCount event) {
  if (mounted) {
    setState(() {
      final stepsString = event.steps.toString(); // Convert to string
      final stepsWithoutCommas = stepsString.replaceAll(',', ''); // Remove commas
      _steps = stepsWithoutCommas;
    });

    // Save the step count to SharedPreferences
    saveStepCountToSharedPreferences(int.parse(_steps));

    // Check if points have already been added today
    if (pointsAddedToday) {
      return; // Points have already been added, no need to continue
    }

    // Check if the current steps are greater than or equal to the target steps
    if (int.parse(_steps) >= targetSteps) {
      // Add points to the user's total points
      final userId = context.read<UserProvider>().userId;
      if (userId != null) {
        context
            .read<PointsProvider>()
            .updatePoints(userId, 70); // Adjust the points as needed
        print("Adding 70 points.");
        pointsAddedToday =
            true; // Set the flag to prevent multiple additions in a day
      }
    }
  }
}

// Function to save the step count to SharedPreferences
  void saveStepCountToSharedPreferences(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', steps);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (mounted) {
      // Check if the widget is still mounted before calling setState
      print("stpppp $event");
      setState(() {
        _status = event.status;
      });
    }
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

/* 
  void initPlatformState() async {
    PermissionStatus status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {
      setState(() {
        _status = 'Permission denied';
        _steps = 'Permission denied';
      });
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    final formattedTargetSteps = numberFormatter.format(targetSteps);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Step Tracker',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TODAY'S STEPS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 26),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[100],
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.pinkAccent,
                      value: int.parse(_steps) / targetSteps,
                      strokeWidth: 20,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  Text(
                    _steps.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              Text('Daily Goal:'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' $formattedTargetSteps',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' Steps',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    onTap: () {
                      setState(() {
                        isEditing = true;
                        final numericValue =
                            numberFormatter.format(targetSteps);
                        _textEditingController.text = numericValue;
                      });
                      showEditDialog();
                    },
                  )
                ],
              ),
              SizedBox(height: 46),
              ElevatedButton(
                onPressed: () {
                  toggleTracking();
                },
                child: Text(
                  isTracking ? 'Stop Tracking' : 'Start Tracking',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isTracking ? Colors.red : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12, width: 2)),
                height: 150,
                child: Center(
                  child: Text(' AdMob Ad'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Target Steps'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                final numericValue = value.replaceAll(',', '');
                final formattedValue =
                    numberFormatter.format(int.tryParse(numericValue) ?? 0);

                if (_textEditingController.text != formattedValue) {
                  _textEditingController.value =
                      _textEditingController.value.copyWith(
                    text: formattedValue,
                    selection:
                        TextSelection.collapsed(offset: formattedValue.length),
                  );
                }
              },
              decoration: InputDecoration(
                labelText: 'Enter Steps',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value.';
                }
                final enteredSteps = int.tryParse(value.replaceAll(',', ''));
                if (enteredSteps != null &&
                    enteredSteps >= 10000 &&
                    enteredSteps <= 20000) {
                  return null;
                }
                return 'Targeted steps must be\nbetween 10,000 and 20,000.';
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    final numericValue =
                        _textEditingController.text.replaceAll(',', '');
                    targetSteps = int.parse(numericValue);
                    isEditing = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void toggleTracking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isTracking) {
      // Stop tracking
      BackgroundFetch.stop().then((status) {
        print('[BackgroundFetch] Stopped with status: $status');
        setState(() {
          isTracking = false; // Update the tracking state immediately
        });

        // Save the tracking state to SharedPreferences
        prefs.setBool('isTracking', isTracking);

        // Cancel the step count subscription
        _stepCountSubscription?.cancel();
        _stepCountSubscription = null; // Set it to null when canceled

        // Cancel the pedestrian status subscription
        _pedestrianStatusSubscription?.cancel();
        _pedestrianStatusSubscription = null; // Set it to null when canceled
      });
    } else {
      // Start tracking
      initPlatformState(); // Call initPlatformState to set up _stepCountStream
      BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
        ),
        (String taskId) async {
          print("[BackgroundFetch] Headless event received: $taskId");

          BackgroundFetch.finish(taskId);
        },
      ).then((status) {
        print('[BackgroundFetch] Started with status: $status');
        setState(() {
          isTracking = true; // Update the tracking state immediately
        });

        // Save the tracking state to SharedPreferences
        prefs.setBool('isTracking', isTracking);
      });
    }

    // Only update the UI when the tracking state changes
    _updateUIFromTrackingState();
  }

void initPlatformState() async {
  PermissionStatus status;

  // Check the platform and request the corresponding permission
  if (Platform.isIOS) {
    status = await Permission.sensors.request();
  } else if (Platform.isAndroid) {
    status = await Permission.activityRecognition.request();
  } else {
    // Handle other platforms if needed
    return;
  }

  if (status.isGranted) {
    print('Permission for step count data is granted.');

    // Initialize _stepCountStream only when starting tracking
    _stepCountStream = Pedometer.stepCountStream;

    _stepCountSubscription = _stepCountStream.listen((StepCount event) {
      if (isTracking) {
        onStepCount(event);
      }
    });

    _stepCountSubscription!.onError(onStepCountError);

    // Initialize _pedestrianStatusStream only when starting tracking
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _pedestrianStatusSubscription =
        _pedestrianStatusStream.listen((PedestrianStatus event) {
      if (isTracking) {
        onPedestrianStatusChanged(event);
      }
    });

    _pedestrianStatusSubscription!.onError(onPedestrianStatusError);
  } else {
    setState(() {
      _status = 'Permission denied';
      _steps = 'Permission denied';
    });
    print('Permission for step count data is denied.');
  }
}

}
