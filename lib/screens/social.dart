import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialScreen extends StatelessWidget {
  final List<Map<String, String>> socialLinks = [
    {
      'icon': 'assets/facebook.png',
      'text': 'Facebook',
      'url': 'https://www.facebook.com/profile.php?id=100093392318665',
    },
    {
      'icon': 'assets/twitter.png',
      'text': 'Twitter',
      'url': 'https://twitter.com/stepnget',
    },
    {
      'icon': 'assets/instagram.png',
      'text': 'Instagram',
      'url': 'https://www.instagram.com/stepngetrewards/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stay connected and engaged with the StepNGet community!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Follow us on social media for the latest updates, contests, and exclusive offers:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: socialLinks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    socialLinks[index]['icon']!,
                    width: 32,
                    height: 32,
                  ),
                  title: Text(socialLinks[index]['text']!),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final url = socialLinks[index]['url']!;
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Join the conversation, share your achievements, and connect with like-minded individuals who are also stepping towards their goals!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
