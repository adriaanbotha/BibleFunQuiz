import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
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
              '🎮 Welcome to Bible Quest! 🎯',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '🌟 Choose Your Adventure!',
              'Get ready for an exciting biblical journey! Pick your perfect challenge:\n\n'
              '🎈 Children\'s Quest: A fun-filled adventure for young explorers! (5 points per correct answer)\n'
              '🌱 Beginner\'s Path: Start your journey with friendly questions! (10 points)\n'
              '⭐ Faith Explorer: Ready for bigger challenges? Try this! (20 points)\n'
              '🏆 Bible Master: For those seeking the ultimate challenge! (30 points)',
            ),
            _buildSection(
              '❤️ Your Quest Journey',
              'Every hero needs strength for their journey:\n\n'
              '🎯 Start with 5 precious hearts - these are your chances to explore and learn!\n'
              '⏰ Each question gives you 30 exciting seconds to ponder and answer\n'
              '💫 Wrong answers or time-outs cost one heart - but don\'t worry, that\'s how we learn!\n'
              '🌈 When your hearts run out, it\'s time for a new adventure!',
            ),
            _buildSection(
              '🏅 Earning Treasures',
              'Collect points and achievements on your quest:\n\n'
              '🎯 Score points based on your chosen difficulty level\n'
              '💝 Bonus points for keeping your hearts safe\n'
              '🏆 See your name shine on our global leaderboard\n'
              '⭐ Unlock special achievements as you grow in knowledge',
            ),
            _buildSection(
              '⚙️ Customize Your Quest',
              'Make the journey truly yours:\n\n'
              '🔊 Toggle fun sound effects for more excitement\n'
              '📖 Show or hide Bible references - your choice!\n'
              '❤️ Adjust your hearts to match your style\n'
              '⏱️ Set your own time limit for each question',
            ),
            _buildSection(
              '💡 Pro Tips for Success',
              'Secret strategies for your biblical adventure:\n\n'
              '🎯 Take your time to read each question carefully - the answer might be hiding in plain sight!\n'
              '⏰ Don\'t let the timer rush you - wisdom comes to those who think!\n'
              '🌱 New to the journey? Start with Children\'s or Beginner\'s quests\n'
              '📊 Check your Profile to see how you\'re growing\n'
              '🌟 Remember: Every question is a chance to learn something amazing!',
            ),
          ],
        ),
      ),
    );
  }
}
