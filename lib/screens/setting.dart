import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:step_n_get/account/register.dart';
import 'package:step_n_get/account/sign_in.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: [
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('How it works'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle "How it works" settings
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Social'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle "Social" settings
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle "Privacy Policy" settings
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Terms and Conditions'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle "Terms and Conditions" settings
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle "About" settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
