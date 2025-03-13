import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class GospelScreen extends StatelessWidget {
  const GospelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'The Gospel'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            'God\'s Love',
            'For God so loved the world that He gave His only begotten Son, that whoever believes in Him should not perish but have everlasting life.',
            'John 3:16',
          ),
          _buildSection(
            'Our Need',
            'For all have sinned and fall short of the glory of God.',
            'Romans 3:23',
          ),
          _buildSection(
            'God\'s Gift',
            'For the wages of sin is death, but the gift of God is eternal life in Christ Jesus our Lord.',
            'Romans 6:23',
          ),
          _buildSection(
            'Our Response',
            'If you confess with your mouth the Lord Jesus and believe in your heart that God has raised Him from the dead, you will be saved.',
            'Romans 10:9',
          ),
          const SizedBox(height: 16),
          _buildPrayerCard(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String verse, String reference) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              verse,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              reference,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCard() {
    return Card(
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
            SizedBox(height: 16),
            Text(
              'Dear God,\n\n'
              'I believe that Jesus died for my sins and rose from the dead. '
              'I ask for Your forgiveness and invite Jesus to be my Lord and Savior. '
              'Thank You for saving me and making me Your child.\n\n'
              'In Jesus\' name,\nAmen',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
