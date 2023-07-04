import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid;
    void getCurrentUserUID() {
      User? user = auth.currentUser;
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User UID'),
      ),
      body: Center(
        child: Text(
          uid != null ? uid! : 'User UID not available',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
