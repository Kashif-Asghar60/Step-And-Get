import 'package:flutter/material.dart';

class StepsScreen extends StatefulWidget {
  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final int targetSteps = 1000;
  // Target number of steps
  final int currentSteps = 500;
  // Current number of steps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Step Tracker',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
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
                    backgroundColor: Colors.grey,
                    value: currentSteps / targetSteps,
                    strokeWidth: 20,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  currentSteps.toString(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 26),
            Text(
              'Target Steps: $targetSteps',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 46),
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
    );
  }
}
