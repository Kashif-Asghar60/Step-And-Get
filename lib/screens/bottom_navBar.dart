import 'package:flutter/material.dart';
import 'package:step_n_get/screens/points_screen.dart';
import 'package:step_n_get/screens/redeem_screen.dart';
import 'package:step_n_get/screens/setting.dart';

import 'steps_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StepsScreen(),
    PointsScreen(),
    RedeemScreen(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.redAccent,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/shoes.png",
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              label: 'Steps',
              backgroundColor: Colors.blue.shade800),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Points',
              backgroundColor: Colors.blue.shade800),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Redeem',
              backgroundColor: Colors.blue.shade800),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.blue.shade800),
        ],
      ),
    );
  }
}
