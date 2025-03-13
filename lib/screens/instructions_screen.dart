import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Instructions'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInstructionCard(
            'Getting Started',
            'Welcome to Bible Quiz! Here\'s how to play:',
            [
              'Choose your difficulty level',
              'Select your preferred age group',
              'Answer questions within the time limit',
              'Earn points for correct answers',
              'Complete daily challenges for bonus points',
            ],
          ),
          _buildInstructionCard(
            'Game Modes',
            'Different ways to play:',
            [
              'Regular Quiz - Test your knowledge',
              'Daily Challenge - 5 special questions',
              'Kids Mode - Age-appropriate questions',
              'Multiplayer - Play with friends',
            ],
          ),
          _buildInstructionCard(
            'Scoring',
            'How points are calculated:',
            [
              'Correct Answer: +100 points',
              'Speed Bonus: Up to +50 points',
              'Daily Streak: +10 points per day',
              'Perfect Round: +200 bonus points',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(String title, String subtitle, List<String> points) {
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
              subtitle,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFFFF9800), size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(point)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
