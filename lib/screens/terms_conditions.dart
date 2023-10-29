import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditions extends StatelessWidget {
  final String privacyPolicyLink = 'https://example.com/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Terms & Conditions ',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'By using the StepNGet app, you agree to comply with our Terms and Conditions. These terms outline the rules and regulations for app usage, rewards, liability, and more. Please carefully read and understand our Terms and Conditions before using the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _launchURL();
              },
              child: Text(
                'Read Terms and Conditions',
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
    const url = 'https://stepngetllc.com/terms-conditions/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
