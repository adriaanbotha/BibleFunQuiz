import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_app_bar.dart';

class WhichChurchScreen extends StatelessWidget {
  const WhichChurchScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMinistrySection(String name, String description, Map<String, String> links) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: links.entries.map((entry) {
                IconData icon = Icons.link;
                if (entry.key.toLowerCase().contains('facebook')) {
                  icon = Icons.facebook;
                } else if (entry.key.toLowerCase().contains('instagram')) {
                  icon = Icons.photo_camera;
                } else if (entry.key.toLowerCase().contains('youtube')) {
                  icon = Icons.video_library;
                }
                
                return TextButton.icon(
                  icon: Icon(icon, color: const Color(0xFFFF9800)),
                  label: Text(
                    entry.key,
                    style: const TextStyle(color: Color(0xFFFF9800)),
                  ),
                  onPressed: () => _launchURL(entry.value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Which Church?'),
        backgroundColor: const Color(0xFFFF9800),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer Card
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber[900], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Important Disclaimer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The author of this app has been following these ministries for several years and, through the guidance of the Holy Spirit, has become convinced that they represent the direction the church should be moving in today. While the author personally knows these ministries through their teachings and ministry, they do not know the author and are in no way associated with this Bible app. They may not even be aware of its existence. This list is shared with the strong conviction that the Holy Spirit has directed these steps and that these ministries embody the church\'s true direction in this season.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber[900],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The church described in the Book of Acts serves as our model for what the church should look like today. Through relationship and unity in the Father, Son, and Holy Spirit, a church should be alive, not religious, but free in Christ and moving in miracles, signs, and wonders. The fruit of this freedom should be evident in the church. Always seek such churches and stay free from the spirit of religion.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber[900],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'We dream of a church full of love—here\'s what that looks like from the Book of Acts!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildMinistrySection(
              'Nancy Coen',
              'A global heart!',
              {
                'Website': 'https://www.globalascensionnetwork.net',
                'YouTube': 'https://www.youtube.com/@globalsons',
              },
            ),
            _buildMinistrySection(
              'Justin Paul Abraham',
              'So inspiring!',
              {
                'Website': 'https://www.companyofburninghearts.com',
                'YouTube': 'https://www.youtube.com/@JustinPaulAbraham',
                'Patreon': 'https://www.patreon.com/c/justinpaulabraham',
              },
            ),
            _buildMinistrySection(
              'Ian Clayton',
              'Thunderous wisdom!',
              {
                'Website': 'https://www.sonofthunder.org',
                'Facebook': 'https://www.facebook.com/sonofthunderpublications',
                'YouTube': 'https://www.youtube.com/@SonofThunderPublications',
              },
            ),
            _buildMinistrySection(
              'Liz Wright',
              'Pure joy!',
              {
                'Website': 'https://imcmembers.com/',
                'Facebook': 'https://www.facebook.com/lizwrightministries',
                'Instagram': 'https://www.instagram.com/lizwrightministries',
                'YouTube': 'https://www.youtube.com/@LizWright',
              },
            ),
            _buildMinistrySection(
              'Mike Parsons',
              'Freedom awaits!',
              {
                'Website': 'https://freedomarc.org',
                'YouTube': 'https://www.youtube.com/@MikeParsonsFAM',
              },
            ),
          ],
        ),
      ),
    );
  }
} 