import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhichChurchScreen extends StatelessWidget {
  const WhichChurchScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Which Church'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cross.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Which Church',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'In this hour, the Unity of the Church is vital. We long for all churches to come together as one body, united in prayer for the world. As Jesus prayed in John 17:21, "that they may all be one," we believe this unity can bring healing, hope, and transformation to the nations.\n\n'
                  'When searching for a church, seek one like the Book of Acts churches—where miracles, signs, and wonders are evident, and the Presence of the Holy Spirit is alive and active. These churches reflect the power and love of God as seen in Acts 2:43-47, with awe-inspiring works and a community devoted to prayer, teaching, and fellowship.\n\n'
                  'Below are online ministries exemplifying these qualities, led by individuals passionate about the supernatural and the Holy Spirit’s move today:',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                _buildMinistryLink(context, 'Justin Paul Abraham', {
                  'Instagram': 'https://www.instagram.com/justin_paul_abraham/',
                  'Facebook':
                      'https://www.facebook.com/officialjustinpaulabraham/',
                  'YouTube': 'https://www.youtube.com/@JustinPaulAbraham',
                }),
                _buildMinistryLink(context, 'Nancy Coen', {
                  'Website': 'https://globalascensionnetwork.net/',
                  'Facebook': 'https://www.facebook.com/nancy.coen.9',
                }),
                _buildMinistryLink(context, 'Ian Clayton', {
                  'Website': 'https://www.sonofthunder.org/',
                  'Facebook':
                      'https://www.facebook.com/ianclayton.sonofthunder/',
                }),
                _buildMinistryLink(context, 'Liz Wright', {
                  'Website':
                      'https://imcmembers.com', // Website for Liz Wright Ministries
                  'Instagram': 'https://www.instagram.com/lizmargaretwright/',
                  'Facebook': 'https://www.facebook.com/lizwrightministries/',
                  'YouTube': 'https://www.youtube.com/@LizWrightOfficial',
                }),
                _buildMinistryLink(context, 'Mike Parsons', {
                  'Website': 'https://freedomarc.org/',
                  'Facebook': 'https://www.facebook.com/FreedomARCMinistry/',
                  'YouTube': 'https://www.youtube.com/@MikeParsons13',
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinistryLink(
    BuildContext context,
    String name,
    Map<String, String> links,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          ...links.entries.map(
            (entry) => GestureDetector(
              onTap: () => _launchUrl(entry.value),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
