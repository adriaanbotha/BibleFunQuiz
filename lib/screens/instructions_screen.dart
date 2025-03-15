import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
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
          children: const [
            Text(
              'How to Play',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Choose your difficulty level on the home screen:\n'
              '   • Beginner (10 points per correct answer)\n'
              '   • Intermediate (20 points per correct answer)\n'
              '   • Advanced (30 points per correct answer)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Game Rules:\n'
              '   • You start with 3 lives\n'
              '   • Each question has a 30-second time limit\n'
              '   • Incorrect answers or time-outs cost one life\n'
              '   • Game ends when you run out of lives',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Scoring:\n'
              '   • Points are awarded based on difficulty\n'
              '   • Bonus points for remaining lives\n'
              '   • Your high scores appear on the leaderboard',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Settings:\n'
              '   • Customize sound effects\n'
              '   • Toggle reference display\n'
              '   • Adjust lives system\n'
              '   • Change time per question',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Tips:\n'
              '• Read questions carefully\n'
              '• Watch your time\n'
              '• Start with beginner level to practice\n'
              '• Check your progress in the Profile screen',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
