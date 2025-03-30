import 'package:flutter/material.dart';
import 'which_church_screen.dart';

class GospelScreen extends StatelessWidget {
  const GospelScreen({Key? key}) : super(key: key);

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF9800),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard() {
    return Card(
      color: const Color(0xFFFFF3E0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Prayer of Salvation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Dear Lord,\n\n'
              'I acknowledge I am a sinner and in need of a Saviour and Your forgiveness. I believe that Jesus Christ died for my sins. '
              'I am willing to turn from my sins. I invite You Lord Jesus Christ to come into my heart and life as my personal Savior. '
              'I am willing to follow and obey You as my Lord.\n\n'
              'Lord, I now acknowledge that You are my Savior, My Deliverer, my Protection, my Provider, You are my All and in All!\n\n'
              'Direct my steps to a church that is like the book of Acts, Alive and showing the fruit of the Spirit and walking in Signs, Miracles and Wonders!\n\n'
              'Thank you for loving me first, while I was yet a sinner.\n\n'
              'Protect me from the spirit of Religion and help me to be Free, since when Christ sets you free you shall be free indeed.\n\n'
              'I pray this in your precious name Jesus Christ of Nazareth, Amen!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChurchSuggestion(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Finding Your Church Family',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'A vibrant, Spirit-filled church should be:\n\n'
                '• Grounded in Biblical teaching\n'
                '• Filled with genuine worship\n'
                '• Moving in the gifts of the Spirit\n'
                '• Demonstrating the love of Christ\n'
                '• Welcoming to all people\n'
                '• Supporting spiritual growth\n'
                '• Active in community outreach\n\n'
                'See the online churches as suggestion by clicking the button below\n',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WhichChurchScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Find a Church Near You',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Gospel'),
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
              'Meet Jesus\' love—it\'s a treasure we\'re thrilled to share with you!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'God\'s Love',
              'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life. - John 3:16',
            ),
            _buildSection(
              'Our Problem',
              'For all have sinned and fall short of the glory of God. - Romans 3:23',
            ),
            _buildSection(
              'God\'s Solution',
              'But God demonstrates his own love for us in this: While we were still sinners, Christ died for us. - Romans 5:8',
            ),
            _buildSection(
              'Our Response',
              'If you declare with your mouth, "Jesus is Lord," and believe in your heart that God raised him from the dead, you will be saved. - Romans 10:9',
            ),
            const SizedBox(height: 16),
            _buildPrayerCard(),
            const SizedBox(height: 24),
            _buildChurchSuggestion(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
