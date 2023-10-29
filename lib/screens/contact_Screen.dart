import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  _launchEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@stepngetllc.com',
    );
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  _launchWebsite() async {
    final Uri _websiteLaunchUri = Uri(
      scheme: 'https',
      host: 'stepngetllc.com',
    );
    if (await canLaunch(_websiteLaunchUri.toString())) {
      await launch(_websiteLaunchUri.toString());
    } else {
      throw 'Could not launch website';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contact'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Email:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _launchEmail,
              child: Text(
                'support@stepngetllc.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pinkAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Website:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _launchWebsite,
              child: Text(
                'stepngetllc.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pink,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
