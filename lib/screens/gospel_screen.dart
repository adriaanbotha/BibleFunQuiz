import 'package:flutter/material.dart';

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
              'Dear God,\n\n'
              'I know I am a sinner and need Your forgiveness. I believe that Jesus Christ died for my sins. '
              'I am willing to turn from my sins. I now invite Jesus Christ to come into my heart and life as my personal Savior. '
              'I am willing to follow and obey Christ as my Lord.\n\n'
              'In Jesus\' name,\nAmen',
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
          ],
        ),
      ),
    );
  }
}
