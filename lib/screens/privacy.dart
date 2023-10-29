import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String privacyPolicyLink = 'https://example.com/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Privacy Policy',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LAST UPDATED: Recently',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'At StepNGet, we take your privacy seriously. We are committed to protecting any personal information you provide to us. Please review our Privacy Policy to understand how we collect, use, disclose, and safeguard your data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _launchURL();
              },
              child: Text(
                'Read our Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://stepngetllc.com/privacy-policy/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
