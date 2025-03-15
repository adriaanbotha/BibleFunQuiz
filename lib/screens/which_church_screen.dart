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
            const Text(
              'We dream of a church full of love—here\'s what that looks like from the Book of Acts!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildMinistrySection(
              'Nancy Coen',
              'A global heart!',
              {
                'Website': 'https://www.globalascensionnetwork.net',
                'Facebook': 'https://www.facebook.com/nancy.coen.9',
                'YouTube': 'https://www.youtube.com/@NancyCoenGlobal',
              },
            ),
            _buildMinistrySection(
              'Justin Paul Abraham',
              'So inspiring!',
              {
                'Website': 'https://www.companyofburninghearts.com',
                'Facebook': 'https://www.facebook.com/justinabrahamCOBH',
                'Instagram': 'https://www.instagram.com/justinpaulabraham',
                'YouTube': 'https://www.youtube.com/@CompanyofBurningHearts',
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
                'Website': 'https://www.lizwrightministries.com',
                'Facebook': 'https://www.facebook.com/lizwrightministries',
                'Instagram': 'https://www.instagram.com/lizwrightministries',
                'YouTube': 'https://www.youtube.com/@LizWrightMinistries',
              },
            ),
            _buildMinistrySection(
              'Mike Parsons',
              'Freedom awaits!',
              {
                'Website': 'https://freedomarc.org',
                'Facebook': 'https://www.facebook.com/FreedomApostolicResources',
                'YouTube': 'https://www.youtube.com/@FreedomARC',
              },
            ),
          ],
        ),
      ),
    );
  }
} 