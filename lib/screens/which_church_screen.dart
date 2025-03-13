import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_app_bar.dart';

class WhichChurchScreen extends StatelessWidget {
  const WhichChurchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Which Church'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildIntroSection(),
          const SizedBox(height: 16),
          _buildTeacherSection(
            'Justin Paul Abraham',
            'Company of Burning Hearts',
            'https://www.companyofburninghearts.com',
            'https://www.facebook.com/justinabrahamCOBH',
            'https://www.instagram.com/justinpaulabraham',
            'https://www.youtube.com/@CompanyofBurningHearts',
          ),
          _buildTeacherSection(
            'Nancy Coen',
            'Global Ascension Network',
            'https://www.globalascensionnetwork.net',
            'https://www.facebook.com/nancy.coen.9',
            null,
            'https://www.youtube.com/@NancyCoenGlobal',
          ),
          // Add other teachers similarly
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Our Vision of Church',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We dream of a church full of love—here\'s what that looks like from Acts!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherSection(
    String name,
    String ministry,
    String website,
    String facebook,
    String? instagram,
    String youtube,
  ) {
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
            Text(
              ministry,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSocialLink(Icons.language, 'Website', website),
            _buildSocialLink(Icons.facebook, 'Facebook', facebook),
            if (instagram != null)
              _buildSocialLink(Icons.camera_alt, 'Instagram', instagram),
            _buildSocialLink(Icons.play_circle_fill, 'YouTube', youtube),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLink(IconData icon, String platform, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF9800)),
            const SizedBox(width: 8),
            Text(platform),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
} 