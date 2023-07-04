import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String? email;
  String? dateOfBirth;
  String? firstName;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot<Map<String, dynamic>>? userSnapshot =
          await firestore.collection('users').doc(userId).get();
      final Map<String, dynamic>? userData = userSnapshot?.data();

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateTime? dob = userData?['dateOfBirth']
          ?.toDate(); // Convert DateTime object to DateTime
      final String formattedDob = dob != null ? formatter.format(dob) : 'N/A';

      setState(() {
        email = userData?['email'];
        dateOfBirth = formattedDob;
        firstName = userData?['name'];
        phoneNumber = userData?['phoneNumber'];
      });
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle the error as per your app's requirements
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Email'),
            subtitle: Text(email ?? 'N/A'),
          ),
          ListTile(
            title: Text('Date of Birth'),
            subtitle: Text(dateOfBirth ?? 'N/A'),
          ),
          ListTile(
            title: Text('Name'),
            subtitle: Text(firstName ?? 'N/A'),
          ),
          ListTile(
            title: Text('Phone Number'),
            subtitle: Text(phoneNumber ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
