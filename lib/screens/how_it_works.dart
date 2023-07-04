import 'package:flutter/material.dart';

class HowitWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
        title: Text(
          'How It Works',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The app that rewards you for staying active and engaged!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Here\'s how it works:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              StepListItem(
                number: '1',
                text:
                    'Step Tracking: Download the StepNGet app and allow it to track your daily steps using your device\'s built-in pedometer.',
              ),
              StepListItem(
                number: '2',
                text:
                    'Earn Points: For every step you take, you\'ll earn points that can be redeemed for exciting rewards and incentives.',
              ),
              StepListItem(
                number: '3',
                text:
                    'Watch Ads: Explore the "Watch Ads" section (under Points) within the app and earn additional points by watching targeted advertisements.',
              ),
              StepListItem(
                number: '4',
                text:
                    'Redeem Rewards: Once you\'ve accumulated enough points, head over to the "Rewards" section to redeem them for a variety of offers, such as data, call airtime, gift cards, discounts, or exclusive merchandise.',
              ),
              StepListItem(
                number: '5',
                text:
                    'Stay Active and Engaged: Keep stepping, watching ads, and engaging with StepNGet to maximize your rewards and discover new opportunities.',
              ),
              SizedBox(height: 16),
              Text(
                'Start your journey with StepNGet today and let your steps turn into valuable rewards!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepListItem extends StatelessWidget {
  final String number;
  final String text;

  StepListItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
