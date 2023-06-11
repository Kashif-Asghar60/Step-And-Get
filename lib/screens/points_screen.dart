import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Center(
          child: Text(
            'Points',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.grade,
                color: Colors.orangeAccent,
                size: 40,
              ),
              SizedBox(width: 5),
              Text(
                '100', // Replace with the actual points value
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Last Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '300',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                DateTime currentDate =
                    DateTime.now().subtract(Duration(days: index + 1));
                String formattedDate = formatDate(
                    currentDate); // Implement your own date formatting logic

                return ListTile(
                  title: Text(formattedDate),
                  trailing: Text(
                      '50'), // Replace with the actual points earned for the specific date
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              // Handle the action for watching an ad
              // This is for Watch Ad x2 button
            },
            child: Text('x2 Daily Points - Watch Ad'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              // Handle the action for watching a rewarded ad
              // This is for Watch Rewarded Ad x3 button
            },
            child: Text('x3 Daily Points - Watch Ad'),
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
